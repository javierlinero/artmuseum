import json
import random
import os
from flask import Flask, jsonify

app = Flask(__name__)

def get_random_file():
    while True:
        file_num = random.randint(166, 141746)  # Generate a random number between 166 and 141746
        object_name = 'HASIMAGES/artobject_' + str(file_num) + '.json'
        json_file = os.path.join(os.path.dirname(os.path.dirname(__file__)), object_name)
        if os.path.exists(json_file):
            return json_file

def get_json(file):
    f = open(file)
    data = json.load(f)
    return data

@app.route('/art_of_the_day', methods=['GET'])
def art_of_the_day():
    file = get_random_file()
    data = get_json(file)

    title = data["displaytitle"]
    artist = data["makers"]["displayname"]
    imageUrl = data["primaryimage"]
    year = data["daterange"]
    materials = data["medium"]
    size = data["dimensions"]
    description = ""

    json_data = {
        "title": title,
        "artist": artist,
        "imageUrl": imageUrl,
        "year": year,
        "materials": materials,
        "size": size,
        "description": description
    }

    return jsonify(json_data)
