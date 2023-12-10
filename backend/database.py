import bisect
from datetime import date
import os
import codecs
import numpy as np
import pickle
from psycopg2 import pool
import bisect
import boto3
import json
import recommender
from urllib.parse import urlparse
from botocore.exceptions import ClientError

def get_secret():
    client = boto3.client('secretsmanager')
    try:
        response = client.get_secret_value(SecretId=os.environ['SEC_KEY'])
    except ClientError as e:
        raise e
    
    secret = json.loads(response['SecretString'])
    
    dbname = secret['dbname']
    user = secret['username']
    password = secret['password']
    host = secret['host']
    port = secret['port']
    ssl = "require"
    return dbname, user, password, host, port, ssl

def urlparser():
    url = os.environ['DB_URL']
    if url is None:
        print('error: Missing DB url, cant connect to DB!')
    url_components = urlparse(url)

    # extract any ssl_params
    ssl_params = dict(param.split("=") for param in url_components.query.split("&"))

    dbname = url_components[1:]
    user = url_components.username
    password = url_components.password
    host = url_components.hostname
    port = url_components.port
    return dbname, user, password, host, port, ssl_params

_connection_pool = None

def create_connection_pool():
    global _connection_pool
    if _connection_pool is None:
        try:
            dbname, user, password, host, port, ssl = get_secret()
        except Exception:
            print('Trying with non-AWS DB url...')
            dbname, user, password, host, port, ssl = urlparser()
        _connection_pool = pool.ThreadedConnectionPool(
            minconn=1,
            maxconn=10,
            database=dbname,
            user=user,
            password=password,
            host=host,
            port=port,
            sslmode=ssl
        )

def get_db_conn():
    if _connection_pool is None:
        create_connection_pool()
    return _connection_pool.getconn()

def return_db_conn(conn):
    _connection_pool.putconn(conn)

def get_art_by_id(art_id):
    connection = get_db_conn()
    try:
        with connection.cursor() as cursor:
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
    finally:
        return_db_conn(connection)


def initDB(cursor):
    drop_str = 'DROP TABLE IF EXISTS link'
    cursor.execute(drop_str, [])
    drop_str = 'DROP TABLE IF EXISTS artworks CASCADE'
    cursor.execute(drop_str, [])
    drop_str = 'DROP TABLE IF EXISTS artists'
    cursor.execute(drop_str, [])
    query_str = '''
    CREATE TABLE artists (
        artist_id INTEGER PRIMARY KEY,
        displayname TEXT,
        displaydate TEXT,
        datebegin INTEGER,
        dateend INTEGER,
        prefix TEXT,
        suffix TEXT,
        role TEXT
    )
    '''
    cursor.execute(query_str, [])
    query_str = '''
    CREATE TABLE artworks (
        artwork_id INTEGER PRIMARY KEY,
        title TEXT,
        imageUrl TEXT,
        year TEXT,
        materials TEXT,
        size TEXT,
        description TEXT,
        types TEXT[],
        cultures TEXT[],
        subjects TEXT[],
        periods TEXT[],
        daterange TEXT,
        other_terms VARCHAR[]
    )
    '''
    cursor.execute(query_str, [])
    query_str = '''
    CREATE TABLE link (
        artwork_id INTEGER,
        artist_id INTEGER,
        PRIMARY KEY (artwork_id, artist_id),
        FOREIGN KEY (artwork_id) REFERENCES artworks(artwork_id),
        FOREIGN KEY (artist_id) REFERENCES artists(artist_id)
    )
    '''
    cursor.execute(query_str, [])
    drop_str = 'DROP TABLE IF EXISTS users'
    cursor.execute(drop_str, [])
    query_str = '''
    CREATE TABLE users (
        UserID VARCHAR(255) PRIMARY KEY,
        Email VARCHAR(255) UNIQUE NOT NULL,
        DisplayName VARCHAR(255)
    )
    '''
    cursor.execute(query_str, [])

    drop_str = 'DROP TABLE IF EXISTS user_preferences'
    cursor.execute(drop_str, [])
    query_str = '''
    CREATE TABLE user_preferences (
        user_id VARCHAR(255) PRIMARY KEY,
        pref_str VARCHAR(20000),
        rated_str VARCHAR(63000),
        FOREIGN KEY (user_id) REFERENCES users(UserID) ON DELETE CASCADE
    )
    '''
    cursor.execute(query_str, [])

    drop_str = 'DROP TABLE IF EXISTS favorites'
    cursor.execute(drop_str, [])
    query_str = '''
    CREATE TABLE favorites (
        user_id VARCHAR(255),
        artwork_id INTEGER,
        PRIMARY KEY (user_id, artwork_id),
        FOREIGN KEY (user_id) REFERENCES users(UserID) ON DELETE CASCADE,
        FOREIGN KEY (artwork_id) REFERENCES artworks(artwork_id) ON DELETE CASCADE
    )
    '''
    cursor.execute(query_str, [])

    drop_str = 'DROP TABLE IF EXISTS aotd'
    cursor.execute(drop_str, [])
    query_str = '''
    CREATE TABLE aotd (
        user_id VARCHAR(255),
        artwork_id INTEGER,
        date VARCHAR(12),
        PRIMARY KEY (user_id),
        FOREIGN KEY (user_id) REFERENCES users(UserID) ON DELETE CASCADE
    )
    '''
    cursor.execute(query_str, [])

def get_art_of_the_day(user_id):
    connection = get_db_conn()
    try:
        with connection.cursor() as cursor:
            query_str = "SELECT * FROM aotd WHERE user_id=%s"
            cursor.execute(query_str, [user_id])
            table = cursor.fetchall()

            if len(table) == 0:
                artid = recommender.get_suggestions(user_id, 1, False)[0]
                query_str = "INSERT INTO aotd VALUES (%s, %s, %s)"
                cursor.execute(query_str, (user_id, str(artid), str(date.today())))
                connection.commit()
                return get_art_by_id(artid)
            elif table[0][2] != str(date.today()):
                artid = recommender.get_suggestions(user_id, 1, False)[0]
                query_str = "UPDATE aotd SET artwork_id=%s, date=%s WHERE user_id=%s"
                cursor.execute(query_str, (str(artid), str(date.today()), user_id))
                connection.commit()
                return get_art_by_id(artid)
            else:
                return get_art_by_id(table[0][1])
    finally:
        return_db_conn(connection)

def create_user(uid, email, display_name):
    insert_query = 'INSERT INTO users (userid, email, displayname) VALUES (%s, %s, %s);'
    connection = get_db_conn()
    try:
        with connection.cursor() as cursor:
            cursor.execute(insert_query, (uid, email, display_name))
            connection.commit()
    except Exception as e:
        connection.rollback()
        raise e
    finally:
        return_db_conn(connection)

def update_user(uid, email=None, display_name=None):
    update_query = """
    UPDATE users 
    SET email = COALESCE(%s, email), 
        displayname = COALESCE(%s, displayname)
    WHERE userid = %s;
    """
    connection = get_db_conn()
    try:
        with connection.cursor() as cursor:
            cursor.execute(update_query, (email, display_name, uid))
            connection.commit()
    except Exception as e:
        connection.rollback()
        raise e
    finally:
        return_db_conn(connection)


def get_user_favorites(userid, limit=50):
    connection = get_db_conn()
    try:
        with connection.cursor() as cursor:
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
    finally:
        return_db_conn(connection)

def insert_user_favorites(userid, artworkid):
    connection = get_db_conn()
    try:
        with connection.cursor() as cursor:
            query_str='''
            INSERT INTO favorites (user_id, artwork_id) VALUES (%s, %s)
            '''
            cursor.execute(query_str, (userid, artworkid))
            connection.commit()
    except Exception as ex:
        connection.rollback()
        raise ex
    finally:
        return_db_conn(connection)

def write_prefs(cursor, user_id, user_ratings, rated):
  query_str = 'SELECT user_id FROM user_preferences WHERE user_id=%s'
  cursor.execute(query_str, [user_id])
  table = cursor.fetchall()
  if len(table) == 0:
    query_str = 'INSERT INTO user_preferences VALUES (%s, %s, %s)'
    cursor.execute(query_str,
        (user_id, codecs.encode(pickle.dumps(user_ratings), "base64").decode(),
                  codecs.encode(pickle.dumps(rated), "base64").decode()))
  else:
    query_str = 'UPDATE user_preferences SET pref_str=%s, rated_str=%s WHERE user_id=%s'
    cursor.execute(query_str, (codecs.encode(pickle.dumps(user_ratings), "base64").decode(),
                               codecs.encode(pickle.dumps(rated), "base64").decode(), user_id))

def read_prefs(cursor, user_id):
  query_str = "SELECT pref_str FROM user_preferences WHERE user_id='%s'" % (user_id)
  cursor.execute(query_str, [])
  table = cursor.fetchall()
  if len(table) == 0:
    uniform_v = ([0.0] * 1000)
    return uniform_v
  else:
    pref = table[0][0].encode()
    return pickle.loads(codecs.decode(pref, "base64"))

def read_rated(cursor, user_id):
  query_str = "SELECT rated_str FROM user_preferences WHERE user_id='%s'" % (user_id)
  cursor.execute(query_str, [])
  table = cursor.fetchall()
  if len(table) == 0:
    return [False] * 46000
  else:
    rated = table[0][0].encode()
    return pickle.loads(codecs.decode(rated, "base64"))

def drop_prefs(cursor):
    query_str = 'DELETE FROM user_preferences'
    cursor.execute(query_str, [])

def get_user_pref(user_id):
    connection = get_db_conn()
    try:
        with connection.cursor() as cursor:
            pref = read_prefs(cursor, user_id)
            return pref
    finally:
        return_db_conn(connection)

def set_user_pref(user_id, new_rating):
    connection = get_db_conn()
    try:
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
            connection.commit()
    except Exception as ex:
        print(f"Exception: {ex}")
    finally:
        return_db_conn(connection)

def get_art_by_date(query, limit=100):
    connection = get_db_conn()
    try:
        with connection.cursor() as cursor:
            query_str = 'SELECT artwork_id FROM artworks WHERE artworks.daterange ILIKE %s LIMIT %s'
            cursor.execute(query_str, ('%' + query + '%', limit))
            date_table = cursor.fetchall()
            return date_table
    finally:
        return_db_conn(connection)


def get_art_by_search(query, limit=100, offset=0):
    q = '%' + query + '%'
    query_str = '''
        SELECT artwork_id, imageurl
        FROM (
            SELECT artworks.artwork_id, artworks.imageurl
            FROM artworks
            WHERE artworks.title ILIKE %s OR
            artworks.year ILIKE %s OR
            artworks.materials ILIKE %s
            UNION
            SELECT link.artwork_id, artworks.imageurl
            FROM artists
            JOIN link ON artists.artist_id=link.artist_id
            JOIN artworks ON link.artwork_id = artworks.artwork_id
            WHERE artists.displayname ILIKE %s
            UNION
            SELECT artworks.artwork_id, artworks.imageurl
            FROM artworks
            WHERE EXISTS (
                SELECT 1
                FROM unnest(cultures) as culture
                WHERE culture ILIKE %s
            )
            UNION
            SELECT artworks.artwork_id, artworks.imageurl
            FROM artworks
            WHERE EXISTS (
                SELECT 1
                FROM unnest(periods) as period
                WHERE period ILIKE %s
            )
            UNION
            SELECT artworks.artwork_id, artworks.imageurl
            FROM artworks
            WHERE EXISTS (
                SELECT 1
                FROM unnest(types) as type
                WHERE type ILIKE %s
            )
        ) AS combined_results
        LIMIT %s OFFSET %s
    '''
    connection = get_db_conn()
    try:
        with connection.cursor() as cursor:
            cursor.execute(query_str, (q, q, q, q, q, q, q, limit, offset))
            query_result = cursor.fetchall()
            return [(artwork_id, image_url) for artwork_id, image_url in query_result]
    except Exception as ex:
        print(ex)
    finally:
        return_db_conn(connection)

def get_artwork_by_artist(artistid):
    connection = get_db_conn()
    try:
        if isinstance(artistid, int):
            query='''
            SELECT link.artwork_id FROM link WHERE artist_id=%s
            '''
            with connection.cursor() as cursor:
                cursor.execute(query, (artistid))
                query_result = cursor.fetchall()
                return [artwork_id[0] for artwork_id in query_result]
        else:
            raise Exception("Artistid is not an integer")
    finally:
        return_db_conn(connection)

if __name__ == '__main__':
    connection = get_db_conn()
    try:
        with connection.cursor() as cursor:
            initDB(cursor)
            connection.commit()
    finally:
        return_db_conn(connection)
