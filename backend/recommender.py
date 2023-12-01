import bisect
import codecs
import contextlib
import glob
import numpy as np
import os
import pickle
import psycopg2
import os
import random
import time
import database as db

#features_dir = glob.glob('features/*')
features_dir = glob.glob('/home/ubuntu/artmuseum/backend/features/*')
features_dir.sort()
for i in range(len(features_dir)):
    file = features_dir[i]
    features_dir[i] = int(file[file.rindex('/')+1:])

def similarity(prefs, target_img_features):
    return np.dot(prefs, target_img_features)

def id_to_feature(artid):
    #file = open('features/' + str(artid), 'r')
    file = open('/home/ubuntu/artmuseum/backend/features/' + str(artid), 'r')
    pickled = ''
    for line in file:
        pickled += line
    tensor = pickle.loads(codecs.decode(pickled.encode(), "base64"))
    return tensor

def already_rated(rated, art_id):
    return rated[bisect.bisect_left(features_dir, art_id)]

class KeyWrapper:
    def __init__(self, iterable, key):
        self.it = iterable
        self.key = key

    def __getitem__(self, i):
        return self.key(self.it[i])

    def __len__(self):
        return len(self.it)

def insert_sim(similarities, feature_num, sim):
    if len(similarities) == 0:
        similarities.append((feature_num, sim))
    else:
        similarities.insert(bisect.bisect_left(KeyWrapper(similarities, key=lambda c: c[0]), feature_num),  (feature_num, sim))

def already_suggested(similarities, art_id):
    if len(similarities) == 0:
        return False
    if len(similarities) == bisect.bisect_left(KeyWrapper(similarities, key=lambda c: c[0]), art_id):
        return False
    return similarities[bisect.bisect_left(KeyWrapper(similarities, key=lambda c: c[0]), art_id)][0] == art_id

def get_suggestions(userid, MAX_ART_SAMPLES, urls):
    SAMPLE_POOL_SIZE = 5000
    swap_new_img_prob = 0.2
    with psycopg2.connect(database="init_db", user="puam", password=os.environ['PUAM_DB_PASSWORD'], 
                          host="puam-app-db.c81admmts5ij.us-east-2.rds.amazonaws.com", port="5432", 
                          sslmode="require") as connection:
        with contextlib.closing(connection.cursor()) as cursor:
            print("Reading prefs")
            prefs = db.read_prefs(cursor, userid)
            print("Finished reading prefs")
            print("Reading rated")
            rated = db.read_rated(cursor, userid)
            print("Finished reading rated")

            similarities = []
            num_art_samples = min(len(features_dir), SAMPLE_POOL_SIZE)
            print("sampling art")
            while len(similarities) != num_art_samples:
                feature_num = random.choice(features_dir)

                # speedup already_rated/already_suggested?
                time_init = time.time()
                a = already_rated(rated, feature_num)
                #a = False
                time_a = time.time()
                b = already_suggested(similarities, feature_num)
                time_b = time.time()

                #if not (db.already_rated(userid, feature_num) or already_suggested(similarities, feature_num)):
                if not (a or b):
                    s = similarity(prefs, id_to_feature(feature_num))
                    time_s = time.time()
                    insert_sim(similarities, feature_num, s)
                    #similarities.append((feature_num, s))
                    time_app = time.time()
                    total_time = time_app - time_init
                    '''print("feature num: " + str(feature_num) + \
                            "\talready_rated: " + str("{:.2f}".format((time_a - time_init) / total_time)) + \
                            "\talready_suggested: " + str("{:.2f}".format((time_b - time_a) / total_time)) + \
                            "\tsimilarity: " + str("{:.2f}".format((time_s - time_b)  / total_time)) + \
                            "\tappend: " + str("{:.2f}".format((time_app - time_s) / total_time)))'''
                    

            print("sorting art")
            similarities = sorted(similarities, key=lambda s : s[1], reverse=True)
            print("finished sorting art")

            # Swap high similarity image with low similarity with probability swap_new_img_prob
            print("begin random sampling")
            for i in range(MAX_ART_SAMPLES):
                if MAX_ART_SAMPLES < num_art_samples and random.random() < swap_new_img_prob:
                    high_sim_ind = int(random.random() * MAX_ART_SAMPLES)
                    low_sim_ind = int(random.random() * (len(similarities) - MAX_ART_SAMPLES) + MAX_ART_SAMPLES)
                    tmp = similarities[high_sim_ind]
                    similarities[high_sim_ind] = similarities[low_sim_ind]
                    similarities[low_sim_ind] = tmp
            print("end random sampling")

            ret = []
            for i in range(MAX_ART_SAMPLES):
                artwork_id = similarities[i][0]
                if urls:
                    image_url = db.get_art_by_id(artwork_id)['imageurl']
                    ret.append((artwork_id, image_url))
                else:
                    ret.append(artwork_id)

            return ret


if __name__ == '__main__':
	for s in get_suggestions("asdf", 3, True):
		print(s)
