import bisect
import contextlib
import os
import codecs
import numpy as np
import pickle
import psycopg2
import recommender

# import queue

# _connection_pool = queue.Queue()

# connection pool for efficiency with DB
# def _get_conn():
#    try:
#        conn = _connection_pool.get(block=False)
#    except queue.Empty:
#        conn = psycopg2.connect(database="init_db",
#                                user="puam", password=os.environ['PUAM_DB_PASSWORD'],
#                                host="puam-app-db.c81admmts5ij.us-east-2.rds.amazonaws.com",
#                                port="5432", sslmode="require")
#    return conn
#
# def _put_conn(conn):
#    _connection_pool.put(conn)

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
            else:
                return None


def initDB(cursor):
    drop_str = 'DROP TABLE IF EXISTS users'
    #cursor.execute(drop_str, [])
    query_str = '''
    CREATE TABLE users2 (
        UserID VARCHAR(255) PRIMARY KEY,
        Email VARCHAR(255) UNIQUE NOT NULL,
        DisplayName VARCHAR(255)
    )
    '''
    #cursor.execute(query_str, [])

    drop_str = 'DROP TABLE IF EXISTS user_preferences2'
    cursor.execute(drop_str, [])
    query_str = '''
    CREATE TABLE user_preferences2 (
        user_id VARCHAR(255) PRIMARY KEY,
        pref_str VARCHAR(20000),
        rated_str VARCHAR(63000),
        FOREIGN KEY (user_id) REFERENCES users(UserID) ON DELETE CASCADE
    )
    '''
    cursor.execute(query_str, [])

    drop_str = 'DROP TABLE IF EXISTS favorites'
    #cursor.execute(drop_str, [])
    query_str = '''
    CREATE TABLE favorites (
        user_id VARCHAR(255),
        artwork_id INTEGER,
        PRIMARY KEY (user_id, artwork_id),
        FOREIGN KEY (user_id) REFERENCES users(UserID) ON DELETE CASCADE,
        FOREIGN KEY (artwork_id) REFERENCES artworks(artwork_id) ON DELETE CASCADE
    )
    '''
    #cursor.execute(query_str, [])

def create_user(uid, email, display_name):
    insert_query = 'INSERT INTO users (userid, email, displayname) VALUES (%s, %s, %s);'
    with psycopg2.connect(database="init_db",
                          user="puam", password=os.environ['PUAM_DB_PASSWORD'],
                          host="puam-app-db.c81admmts5ij.us-east-2.rds.amazonaws.com",
                          port='5432') as connection:
        with connection.cursor() as cursor:
            try:
                cursor.execute(insert_query, (uid, email, display_name))
                connection.commit()
            except Exception as e:
                connection.rollback()
                raise e

def update_user(uid, email=None, display_name=None):
    update_query = """
    UPDATE users 
    SET email = COALESCE(%s, email), 
        displayname = COALESCE(%s, displayname)
    WHERE userid = %s;
    """
    with psycopg2.connect(database="init_db",
                          user="puam", password=os.environ['PUAM_DB_PASSWORD'],
                          host="puam-app-db.c81admmts5ij.us-east-2.rds.amazonaws.com",
                          port='5432') as connection:
        with connection.cursor() as cursor:
            try:
                cursor.execute(update_query, (email, display_name, uid))
                connection.commit()
            except Exception as e:
                connection.rollback()
                raise e


def get_user_favorites(userid, limit=50):
    with psycopg2.connect(database="init_db",
                          user="puam", password=os.environ['PUAM_DB_PASSWORD'],
                          host="puam-app-db.c81admmts5ij.us-east-2.rds.amazonaws.com",
                          port='5432') as connection:
        with contextlib.closing(connection.cursor()) as cursor:
            try:
                query_str = '''
                SELECT a.artwork_id, a.imageurl FROM artworks a
                JOIN favorites uf ON a.artwork_id = uf.artwork_id
                WHERE uf.user_id= %s
                LIMIT %s
                '''
                cursor.execute(query_str, (userid, limit))
                table = cursor.fetchall()

                return table
            except Exception as ex:
                print(ex)

def write_prefs(cursor, user_id, user_ratings, rated):
  query_str = 'SELECT user_id FROM user_preferences2 WHERE user_id=%s'
  cursor.execute(query_str, [user_id])
  table = cursor.fetchall()
  if len(table) == 0:
    query_str = 'INSERT INTO user_preferences2 VALUES (%s, %s, %s)'
    cursor.execute(query_str,
        (user_id, codecs.encode(pickle.dumps(user_ratings), "base64").decode(),
                  codecs.encode(pickle.dumps(rated), "base64").decode()))
  else:
    query_str = 'UPDATE user_preferences2 SET pref_str=%s, rated_str=%s WHERE user_id=%s'
    cursor.execute(query_str, (codecs.encode(pickle.dumps(user_ratings), "base64").decode(),
                               codecs.encode(pickle.dumps(rated), "base64").decode(), user_id))

def read_prefs(cursor, user_id):
  query_str = "SELECT pref_str FROM user_preferences2 WHERE user_id='%s'" % (user_id)
  cursor.execute(query_str, [])
  table = cursor.fetchall()
  if len(table) == 0:
    uniform_v = ([0.0] * 1000)
    return uniform_v
  else:
    pref = table[0][0].encode()
    return pickle.loads(codecs.decode(pref, "base64"))

def read_rated(cursor, user_id):
  query_str = "SELECT rated_str FROM user_preferences2 WHERE user_id='%s'" % (user_id)
  cursor.execute(query_str, [])
  table = cursor.fetchall()
  if len(table) == 0:
    return [False] * 46000
  else:
    rated = table[0][0].encode()
    return pickle.loads(codecs.decode(rated, "base64"))

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

def set_user_pref(user_id, new_rating):
    with psycopg2.connect(database="init_db",
                          user="puam", password=os.environ['PUAM_DB_PASSWORD'],
                          host="puam-app-db.c81admmts5ij.us-east-2.rds.amazonaws.com",
                          port='5432') as connection:
        with connection.cursor() as cursor:
            pref = read_prefs(cursor, user_id)
            pref += new_rating[1] * recommender.id_to_feature(new_rating[0])
            pref /= np.linalg.norm(pref)
            print()
            print("===================")
            print()
            print("Feature: " + str(recommender.id_to_feature(new_rating[0])[0:10]))
            print("New pref: " + str(pref[0:10]))

            rated = read_rated(cursor, user_id)
            rated[bisect.bisect_left(recommender.features_dir, new_rating[0])] = True
            print("Set rated[" + str(bisect.bisect_left(recommender.features_dir, new_rating[0])) + "]=True for artid " + str(new_rating[0]))
            write_prefs(cursor, user_id, pref, rated)


if __name__ == '__main__':
    with psycopg2.connect(database="init_db",
                          user="puam", password=os.environ['PUAM_DB_PASSWORD'],
                          host="puam-app-db.c81admmts5ij.us-east-2.rds.amazonaws.com",
                          port="5432", sslmode="require") as connection:
        with contextlib.closing(connection.cursor()) as cursor:
            initDB(cursor)
            #write_dummy_pref(cursor)

            #drop_prefs(cursor)

            '''pref = read_prefs(cursor, 2)
            rated = read_rated(cursor, 2)

            print("Pref: " + str(pref[0:10]) + " ...")
            print("Rated: " + str(rated[0:10]))

            set_user_pref(2, (2770, 0.8))
            set_user_pref(2, (2771, -0.1))
            pref = read_prefs(cursor, 1)
            rated = read_rated(cursor, 1)

            print()
            print("===================")
            print()

            print("Pref: " + str(pref[0:10]) + " ...")
            print("Rated: " + str(rated))'''
