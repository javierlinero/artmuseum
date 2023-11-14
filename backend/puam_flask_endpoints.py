import json
import random
import os
import flask
from apscheduler.schedulers.background import BackgroundScheduler
from flask import Flask, jsonify
import database as db
import recommender
from functools import wraps
import firebase_admin.auth as auth

app = Flask(__name__)

scheduler = BackgroundScheduler()
scheduler.start()

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
    while True:
        art_id = random.randint(279, 44450)  # Generate a random number between 166 and 141746
        artwork = db.get_art_by_id(art_id)
        if artwork is not None:
            return artwork

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

    if current_art is None:
        current_art = get_random_art()

    return jsonify(current_art)


@app.route('/tinder_for_art', methods=['GET'])
@require_auth
def tinder_for_art_get():
    userid = int(flask.request.args.get('userid'))
    num_suggestions = int(flask.request.args.get('numart'))
    print("Suggesting " + str(num_suggestions) + " images based on preferences of userid " + str(userid))

    # still images without url *************************
    suggestions = recommender.get_suggestions(userid, num_suggestions)
    return jsonify(suggestions), 200

@app.route('/tinder_for_art', methods=['POST'])
@require_auth
def tinder_for_art_post():
    data = flask.request.form
    userid = int(data["userid"])
    artid = int(data["artid"])
    rating = float(data["rating"])

    print("Updating pref of userid" + str(userid) + " with (" + str(artid) + "," + str(rating) + ")")

    db.set_user_pref(userid, (artid, rating))

    return jsonify({"message": "Preference updated successfully"}), 200

#curl "http://172.31.46.224:10203/tinder_for_art?userid=1&numart=3"
#curl "http://172.31.46.224:10203/tinder_for_art" -F userid=1 -F artid=286 -F rating=-0.5
