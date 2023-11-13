import contextlib
import os
import codecs
import pickle
import psycopg2
import bisect

def get_art_by_id(art_id):
    with psycopg2.connect(database="init_db", 
                          user="puam", password=os.environ['PUAM_DB_PASSWORD'],
                          host="puam-app-db.c81admmts5ij.us-east-2.rds.amazonaws.com",
                          port="5432", sslmode="require") as connection:
        with contextlib.closing(connection.cursor()) as cursor:

            query_str = 'SELECT artworks.title, artworks.imageurl, artworks.year, artworks.materials, artworks.size, artworks.description FROM artworks WHERE artwork_id=%s'
            cursor.execute(query_str, (str(art_id),))
            artwork_table = cursor.fetchall()

            artists = []
            query_str = 'SELECT artists.displayname FROM artists, link, artworks WHERE artworks.artwork_id=%s AND link.artwork_id=artworks.artwork_id AND artists.artist_id=link.artist_id'
            cursor.execute(query_str, (str(art_id),))
            artist_table = cursor.fetchall()
            if artist_table:
                for row in artist_table:
                    artists.append(row[0])

            if len(artwork_table) != 0:
               return {
                  "title": artwork_table[0][0],
                  "imageurl": artwork_table[0][1],
                  "year": artwork_table[0][2],
                  "materials": artwork_table[0][3],
                  "size": artwork_table[0][4],
                  "description": artwork_table[0][5],
                  "artists": artists
               }

def initDB(cursor):
  query_str = 'CREATE TABLE user_preferences2(user_id int PRIMARY KEY, pref_str VARCHAR(1000))'
  cursor.execute(query_str, [])

def write_prefs(cursor, user_id, user_ratings):
  if len(read_prefs(cursor, user_id)) == 0:
    query_str = 'INSERT INTO user_preferences2 VALUES (%s, %s)'
    cursor.execute(query_str, (user_id, codecs.encode(pickle.dumps(user_ratings), "base64").decode()))
  else:
    query_str = 'UPDATE user_preferences2 SET pref_str=%s WHERE user_id=%s'
    cursor.execute(query_str, (codecs.encode(pickle.dumps(user_ratings), "base64").decode(), user_id))

def read_prefs(cursor, user_id):
  query_str = 'SELECT pref_str FROM user_preferences2 WHERE user_id=%s' % (user_id)
  cursor.execute(query_str, [])
  table = cursor.fetchall()
  if len(table) == 0:
    return table
  else:
    pref = table[0][0].encode()
    return pickle.loads(codecs.decode(pref, "base64"))

def drop_prefs(cursor):
  query_str = 'DELETE FROM user_preferences2'
  cursor.execute(query_str, [])

def get_user_pref(user_id):
    with psycopg2.connect(database="init_db", 
                          user="puam", password=os.environ['PUAM_DB_PASSWORD'],
                          host="puam-app-db.c81admmts5ij.us-east-2.rds.amazonaws.com",
                          port="5432") as connection:
        with contextlib.closing(connection.cursor()) as cursor:
            pref = read_prefs(cursor, user_id)
            return pref

class RatingComparator(object):
    def __init__(self, val):
        self.val = val
    def __lt__(self, other):
        print(self.val[0], other[0])
        return self.val[0] < other[0]
    

def set_user_pref(user_id, new_rating):
    '''with psycopg2.connect(database="init_db", 
                          user="puam", password=os.environ['PUAM_DB_PASSWORD'],
                          host="puam-app-db.c81admmts5ij.us-east-2.rds.amazonaws.com",
                          port='5432') as connection:
        with connection.cursor() as cursor:
            pref = read_prefs(cursor, user_id)
            pref.append(new_rating)
            write_prefs(cursor, user_id, pref)'''
    pref = [
        (279, 0.1),
        (280, 0.8),
        (282, 0.4),
    ]

    new_pref = (281, 0.3)

    pref.insert(bisect.bisect_right(pref, RatingComparator(new_pref)), new_pref)
    print(pref)

def already_rated(user_id, art_id):
    '''with psycopg2.connect(database="init_db", 
                        user="puam", password=os.environ['PUAM_DB_PASSWORD'],
                        host="puam-app-db.c81admmts5ij.us-east-2.rds.amazonaws.com",
                        port='5432') as connection:
        with connection.cursor() as cursor:
            pref = read_prefs(cursor, user_id)
            if pref[bisect.bisect_right(pref, RatingComparator((art_id, None)))-1][0] == art_id:
               return True
            return False'''
    pref = [
        (279, 0.1),
        (280, 0.8),
        (282, 0.4),
    ]
    if pref[bisect.bisect_right(pref, RatingComparator((art_id, None)))-1][0] == art_id:
        return True
    return False

def write_dummy_pref(cursor):
    pref = [
        (279, 0.1),
        (280, 0.8),
        (281, 0.3),
    ]

    write_prefs(cursor, 1, pref)

if __name__ == '__main__':
    '''with psycopg2.connect(database="init_db", 
                          user="puam", password=os.environ['PUAM_DB_PASSWORD'],
                          host="puam-app-db.c81admmts5ij.us-east-2.rds.amazonaws.com",
                          port="5432", sslmode="require") as connection:
        with contextlib.closing(connection.cursor()) as cursor:
            print('SUCCESS')
            #initDB(cursor)
            #write_dummy_pref(cursor)
            print(read_prefs(cursor, 1))
            #drop_prefs(cursor)'''
    set_user_pref(None, None)
