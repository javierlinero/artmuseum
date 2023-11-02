import codecs
import contextlib
import numpy as np
import pickle
import psycopg2
import sys
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

def get_suggestions(userid, MAX_ART_SAMPLES):
	MAX_PREF_SAMPLES = 5
	with psycopg2.connect(database="init_db",
												user="puam", password=os.environ['PUAM_DB_PASSWORD'],
												host="puam-app-db.c81admmts5ij.us-east-2.rds.amazonaws.com",
												port="5432", sslmode="require") as connection:
		with contextlib.closing(connection.cursor()) as cursor:

			img_features = []
			full_prefs = read_prefs(cursor, userid)
			num_pref_samples = min(len(full_prefs), MAX_PREF_SAMPLES)
			user_ratings = random.sample(full_prefs, num_pref_samples)
			for rating in user_ratings:
				img_features.append(id_to_feature(rating[0]))

			similarities = []
			features_dir = glob.glob('features/*')
			num_art_samples = min(len(features_dir), MAX_ART_SAMPLES)
			art_obj_features = random.sample(features_dir, num_art_samples)

			# hardcode to guarantee hits
			art_obj_features = ['features/279', 'features/280', 'features/281']

			art_obj_features = [os.path.basename(f) for f in art_obj_features]
			for f in art_obj_features:  # subset of glob
				with open('features/' + f) as fp:
					similarities.append((f, similarity(user_ratings, img_features, id_to_feature(int(f)))))

			similarities = sorted(similarities, key=lambda s : s[1], reverse=True)
			return similarities


if __name__ == '__main__':
	for s in get_suggestions(1, 5):
		print(s)