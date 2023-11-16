import json
from flask import Flask, jsonify
import database as db

app = Flask(__name__)

@app.route('/search', method=['GET'])
def search(query):
    arts_id = db.get_art_by_search(query)
    if query.isdigit():
        date = int(query)
        if date <= 500:
            arts_id = arts_id.append(arts_id, db.get_art_by_date('A.D. 1-500'))
            arts_id = arts_id.append(arts_id, db.get_art_by_date('1000 B.C.-A.D. 1'))
        if date >= 500 and date <= 1000:
            arts_id = arts_id.append(arts_id, db.get_art_by_date('A.D. 500-1000'))
            arts_id = arts_id.append(arts_id, db.get_art_by_date('1000 B.C.-A.D. 1'))
        if date >= 1000 and date <= 2000:
            arts_id = arts_id.append(arts_id, db.get_art_by_date('2000-1000 B.C.'))
        if date >= 1500 and date <= 1600:
            arts_id = arts_id.append(arts_id, db.get_art_by_date('A.D. 1500-1600'))
        if date >= 1600 and date <= 1700:
            arts_id = arts_id.append(arts_id, db.get_art_by_date('A.D. 1600-1700'))
        if date >= 1700 and date <= 1800:
            arts_id = arts_id.append(arts_id, db.get_art_by_date('A.D. 1700-1800'))
        if date >= 1800 and date <= 1900:
            arts_id = arts_id.append(arts_id, db.get_art_by_date('A.D. 1800-1900'))
        if date >= 1900 and date <= 1945:
            arts_id = arts_id.append(arts_id, db.get_art_by_date('A.D. 1900-1945'))
        if date >= 1945:
            arts_id = arts_id.append(arts_id, db.get_art_by_date('A.D. 1945-present'))
        if date >= 2000:
            arts_id = arts_id.append(arts_id, db.get_art_by_date('15000-2000 B.C.'))

    arts = []
    for id in arts_id:
        arts = arts.append(db.get_art_by_id(id))
    return arts