import json
import random
import os
from apscheduler.schedulers.background import BackgroundScheduler
import flask
from flask import Flask, jsonify, request
import database as db
import recommender
from functools import wraps
import firebase_admin.auth as auth
from firebase_admin import credentials
import firebase_admin

app = Flask(__name__)

scheduler = BackgroundScheduler()
scheduler.start()

cred = credentials.Certificate("./firebase.json")
firebase_admin.initialize_app(cred)

current_art = None

# Decorator to require authentication in order to use
def require_auth(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        token = request.headers.get('Authorization')
        if not token:
            return jsonify({"error": "Authorization token is missing"}), 401

        try:
            # Strip the "Bearer " word from the header to get the token
            token = token.split(" ")[1]
            decoded_token = auth.verify_id_token(token)
            request.user = decoded_token  # Add token data to request context
            return f(*args, **kwargs)
        except Exception as e:
            return jsonify({"error": str(e)}), 403
    return decorated_function

def get_random_file():
    while True:
        file_num = random.randint(166, 141746)  # Generate a random number between 166 and 141746
        object_name = 'HASIMAGES/artobject_' + str(file_num) + '.json'
        json_file = os.path.join(os.path.dirname(os.path.dirname(__file__)), object_name)
        if os.path.exists(json_file):
            return json_file

def get_random_art():
    #while True:
    #    art_id = random.randint(166, 141746)  # Generate a random number between 166 and 141746
    #    artwork = db.get_art_by_id(art_id)
    #    print(artwork)
    #    if artwork is not None:
    #        return artwork
    return db.get_art_by_id(random.choice(recommender.features_dir))

def change_aotd():
    global current_art
    current_art = get_random_art()

#sets up a scheduler in cron expression to change art of the day 
scheduler.add_job(change_aotd, 'cron', hour=0, minute=0, second=0,
                  timezone='US/Eastern')

def get_json(file):
    f = open(file)
    data = json.load(f)
    return data

@app.route('/art_of_the_day', methods=['GET'])
def art_of_the_day():
    global current_art
    token = request.headers.get('Authorization')
    if not token:
        userid = "-1"
    else:
        try:
            token = token.split(" ")[1]
            decoded_token = auth.verify_id_token(token)
            request.user = decoded_token
            user_info = request.user
            userid = user_info['uid']
        except Exception as e:
            return jsonify({"error": str(e)}), 403

    if userid != "-1":
        return jsonify(db.get_art_of_the_day(userid))
    else:
        print("random")
        if current_art is None:
            current_art = get_random_art()
        return jsonify(current_art)


@app.route('/tinder_for_art', methods=['GET'])
@require_auth
def tinder_for_art_get():
    user_info = request.user
    userid = user_info['uid']
    #userid = flask.request.args.get('uid')
    num_suggestions = int(flask.request.args.get('numart'))
    print("Suggesting " + str(num_suggestions) + " images based on preferences of userid " + str(userid))

    suggestions = recommender.get_suggestions(userid, num_suggestions, True)
    return jsonify(suggestions), 200

@app.route('/tinder_for_art', methods=['POST'])
@require_auth
def tinder_for_art_post():
    data = request.form
    user_info = request.user
    userid = user_info['uid']
    #userid = data["userid"]
    artid = int(data["artid"])
    rating = float(data["rating"])

    print("Updating pref of userid" + str(userid) + " with (" + str(artid) + "," + str(rating) + ")")

    db.set_user_pref(userid, (artid, rating))
    #sending over favorite artwork into DB
    if rating == 1:
        db.insert_user_favorites(str(userid), artid)

    return jsonify({"message": "Preference updated successfully"}), 200

@app.route('/user_profile', methods=['GET'])
@require_auth
def user_profile_get():
    try:
        user_info = request.user
        uid = user_info['uid']

        user_record = auth.get_user(uid)

        email = user_record.email
        display_name = user_record.display_name

        return jsonify({'email': email, 'displayName': display_name}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/user_profile', methods=['POST'])
@require_auth
def user_profile_post():
    try:
        data = request.json

        user_info = request.user_agent
        uid = user_info['uid']

        update_data = {}
        if 'email' in data:
            update_data['email'] = data['email']
        if 'display_name' in data:
            update_data['display_name'] = data['display_name']
        
        auth.update_user(uid, **update_data)

        db.update_user(uid, data.get('email'), data.get('display_name'))

        return jsonify({"message": "User profile updated successfully"}), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/create_user', methods=['POST'])
@require_auth
def create_user():
    try:
        uid = request.user['uid']
        email = request.json.get('email')
        display_name = request.json.get('display_name')

        if not email or not display_name:
            return jsonify({'error': 'Email or display name is missing in the request'}), 400

        db.create_user(uid, email, display_name)

        update_data = {'display_name': display_name}

        auth.update_user(uid, **update_data)

        return jsonify({'message': 'User created successfully'}), 201

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/user_favorites', methods=['GET'])
@require_auth
def user_favorites_endpoint():
    try:
        user_info = request.user
        uid = user_info['uid']

        # Get the limit from query parameters (optional)
        limit = request.args.get('limit', default=50, type=int)

        # Call the function with the user ID and limit
        favorites = db.get_user_favorites(uid, limit)

        return jsonify(favorites), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/search', methods=['GET'])
def search():
    try:
        year = request.json.get('year')
        query = request.json.get('query')
        limit = request.json.get('limit')
        offset = request.json.get('offset')
        if query is None:
            query= ''
        if year is None and query is not None:
            if limit is None:
                result = db.get_art_by_search(query=query, offset=offset)
            else:
                result = db.get_art_by_search(query=query, limit=limit, offset=offset)
        else:
            if limit is None:
                result = db.get_art_by_date(year)
            else:
                result = db.get_art_by_date(year, limit)
        return jsonify(result), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/art_info', methods=['GET'])
def art_information():
    try:
        data = request.args.get('artid')
        artwork = db.get_art_by_id(data)
        return jsonify(artwork)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

#curl "http://172.31.46.224:10203/tinder_for_art?userid=1&numart=3"
#curl "http://172.31.46.224:10203/tinder_for_art" -F userid=1 -F artid=286 -F rating=-0.5
