import codecs
import contextlib
import glob
import numpy as np
import os
import pickle
import psycopg2
import os
import random
import database as db

def similarity(user_ratings, img_features, target_img_features):
  sim = 0
  for i, rating in enumerate(user_ratings):
    if img_features[i] is not None:
      sim += rating[1] * np.dot(img_features[i], target_img_features)
  return sim

def id_to_feature(artid):
  file = open('features/' + str(artid), 'r')
  pickled = ''
  for line in file:
    pickled += line
  tensor = pickle.loads(codecs.decode(pickled.encode(), "base64"))
  return tensor

def already_suggested(similarities, art_id):
	for s in similarities:
		if s[0] == art_id:
			return True
	return False

def get_suggestions(userid, MAX_ART_SAMPLES):
    MAX_PREF_SAMPLES = 5
    with psycopg2.connect(database="init_db", user="puam", password=os.environ['PUAM_DB_PASSWORD'], 
                          host="puam-app-db.c81admmts5ij.us-east-2.rds.amazonaws.com", port="5432", 
                          sslmode="require") as connection:
        with contextlib.closing(connection.cursor()) as cursor: 
            img_features = []
            full_prefs = db.read_prefs(cursor, userid)
            '''full_prefs = [
                (279, 0.1),
                (280, 0.8),
                (282, 0.4),
            ]'''
            num_pref_samples = min(len(full_prefs), MAX_PREF_SAMPLES)
            user_ratings = random.sample(full_prefs, num_pref_samples)
            for rating in user_ratings:
                img_features.append(id_to_feature(rating[0]))

            similarities = []
            features_dir = glob.glob('features/*')
            num_art_samples = min(len(features_dir), MAX_ART_SAMPLES)
            while len(similarities) != num_art_samples:
                feature_file = random.choice(features_dir)
                feature_num = int(feature_file[feature_file.rindex('/'):])

                if not (db.already_rated(userid, feature_num) or already_suggested(similarities, feature_num)):
                    similarities.append((feature_num, similarity(user_ratings, img_features, id_to_feature(feature_num))))

            similarities = sorted(similarities, key=lambda s : s[1], reverse=True)
            return similarities


if __name__ == '__main__':
	for s in get_suggestions(1, 3):
		print(s)
