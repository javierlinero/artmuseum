import json
import random
import os
import flask
from flask import Flask, jsonify
import database as db
import recommender

app = Flask(__name__)

def get_random_file():
    while True:
        art_id = random.randint(279, 44450)  # Generate a random number between 166 and 141746
        artists = db.get_art_by_id(art_id)
        if len(artists) != 0:
            return artists

def get_json(file):
    f = open(file)
    data = json.load(f)
    return data

@app.route('/art_of_the_day', methods=['GET'])
def art_of_the_day():
    file = get_random_file()
    return jsonify(file)

@app.route('/tinder_for_art', methods=['GET'])
def tinder_for_art_get():
    userid = int(flask.request.args.get('userid'))
    num_suggestions = int(flask.request.args.get('numart'))
    print("Suggesting " + str(num_suggestions) + " images based on preferences of userid " + str(userid))

    # still images without url *************************

    return recommender.get_suggestions(userid, num_suggestions)

@app.route('/tinder_for_art', methods=['POST'])
def tinder_for_art_post():
    data = flask.request.form
    userid = int(data["userid"])
    artid = int(data["artid"])
    rating = float(data["rating"])

    print("Updating pref of userid" + str(userid) + " with (" + str(artid) + "," + str(rating) + ")")

    db.set_user_pref(userid, (artid, rating))

    return "SUCCESS\n"

#curl "http://172.31.46.224:10203/tinder_for_art?userid=1&numart=3"
#curl "http://172.31.46.224:10203/tinder_for_art" -F userid=1 -F artid=286 -F rating=-0.5
