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

def similarity(prefs, target_img_features):
    return np.dot(prefs, target_img_features)

def id_to_feature(artid):
    file = open('../recommender/features/' + str(artid), 'r')
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
    SAMPLE_POOL_SIZE = 3
    swap_new_img_prob = 0.2
    with psycopg2.connect(database="init_db", user="puam", password=os.environ['PUAM_DB_PASSWORD'], 
                          host="puam-app-db.c81admmts5ij.us-east-2.rds.amazonaws.com", port="5432", 
                          sslmode="require") as connection:
        with contextlib.closing(connection.cursor()) as cursor:
            prefs = db.read_prefs(cursor, userid)

            similarities = []
            features_dir = glob.glob('../recommender/features/*')
            num_art_samples = min(len(features_dir), SAMPLE_POOL_SIZE)
            while len(similarities) != num_art_samples:
                feature_file = random.choice(features_dir)
                feature_num = int(feature_file[feature_file.rindex('/')+1:])

                if not (db.already_rated(userid, feature_num) or already_suggested(similarities, feature_num)):
                    similarities.append((feature_num, similarity(prefs, id_to_feature(feature_num))))

            similarities = sorted(similarities, key=lambda s : s[1], reverse=True)

            # Swap high similarity image with low similarity with probability swap_new_img_prob
            for i in range(MAX_ART_SAMPLES):
                if MAX_ART_SAMPLES < num_art_samples and random.random() < swap_new_img_prob:
                    high_sim_ind = int(random.random() * MAX_ART_SAMPLES)
                    low_sim_ind = int(random.random() * (len(similarities) - MAX_ART_SAMPLES) + MAX_ART_SAMPLES)
                    tmp = similarities[high_sim_ind]
                    similarities[high_sim_ind] = similarities[low_sim_ind]
                    similarities[low_sim_ind] = tmp

            urls = []
            for i in range(MAX_ART_SAMPLES):
                urls.append(db.get_art_by_id(similarities[i][0])['imageurl'])
            
            return urls


if __name__ == '__main__':
	for s in get_suggestions(1, 2):
		print(s)
