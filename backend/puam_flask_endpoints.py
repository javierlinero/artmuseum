import json
import random
import os
import flask
from flask import Flask, jsonify
import database as db

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
    userid = flask.request.args.get('userid')
    pref = db.get_user_pref(userid)
    print("Suggesting images based on preferences of userid " + str(userid) + " with preferences:")
    print(pref)

    file = get_random_file()
    data = get_json(file)
    # still images without url *************************
    url = data["primaryimage"][0]

    return url

@app.route('/tinder_for_art', methods=['POST'])
def tinder_for_art_post():
    data = flask.request.form
    userid = int(data["userid"])
    artobj = data["artobj"]
    rating = int(data["rating"])

    print("Updating pref of userid" + str(userid) + " with (" + artobj + "," + str(rating) + ")")

    db.set_user_pref(userid, (artobj, int(rating)))

    return "SUCCESS\n"

#curl "http://172.18.65.52:10203/tinder_for_art?userid=1" -F userid=1 -F artobj='artobject_4863.json' -F rating=-1
