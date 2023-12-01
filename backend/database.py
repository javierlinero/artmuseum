import os
import codecs
import pickle
from psycopg2 import pool
import bisect
import boto3
import json
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

_connection_pool = None

def create_connection_pool():
    global _connection_pool
    if _connection_pool is None:
        dbname, user, password, host, port, ssl = get_secret()
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
        pref_str VARCHAR(1000),
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


def write_prefs(cursor, user_id, user_ratings):
    if len(read_prefs(cursor, user_id)) == 0:
        query_str = 'INSERT INTO user_preferences VALUES (%s, %s)'
        cursor.execute(query_str, (user_id, codecs.encode(
            pickle.dumps(user_ratings), "base64").decode()))
    else:
        query_str = "UPDATE user_preferences SET pref_str=%s WHERE user_id=%s"
        cursor.execute(query_str, (codecs.encode(
            pickle.dumps(user_ratings), "base64").decode(), user_id))


def read_prefs(cursor, user_id):
    query_str = "SELECT pref_str FROM user_preferences WHERE user_id='%s'" % (
        user_id)
    cursor.execute(query_str, [])
    table = cursor.fetchall()
    if len(table) == 0:
        return table
    else:
        pref = table[0][0].encode()
        return pickle.loads(codecs.decode(pref, "base64"))


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


def insert_pref(pref, new_rating):
    pref.insert(bisect.bisect_right(pref, new_rating), new_rating)


class RatingComparator(object):
    def __init__(self, val):
        self.val = val

    def __lt__(self, other):
        return self.val[0] < other[0]


def set_user_pref(user_id, new_rating):
    connection = get_db_conn()
    try:
        with connection.cursor() as cursor:
            pref = read_prefs(cursor, user_id)
            insert_pref(pref, new_rating)  # preserve sorted by art_id
            write_prefs(cursor, user_id, pref)
    finally:
        return_db_conn(connection)


def already_rated(user_id, art_id):
    connection = get_db_conn()
    try:
        with connection.cursor() as cursor:
            pref = read_prefs(cursor, user_id)
            if len(pref) != 0 and pref[bisect.bisect_right(pref, RatingComparator((art_id, None)))-1][0] == art_id:
                return True
            return False
    finally:
        return_db_conn(connection)


def write_dummy_pref(cursor):
    pref = [
        (279, 0.1),
        (280, 0.8),
        (281, 0.3),
    ]

    write_prefs(cursor, 1, pref)

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


def get_art_by_search(query, limit=100):
    q = '%' + query + '%'
    query_str = '''
        SELECT artwork_id
        FROM (
            SELECT artworks.artwork_id
            FROM artworks
            WHERE artworks.title ILIKE %s OR
            artworks.year ILIKE %s OR
            artworks.materials ILIKE %s
            UNION
            SELECT link.artwork_id
            FROM artists
            JOIN link ON artists.artist_id=link.artist_id 
            WHERE artists.displayname ILIKE %s
            UNION
            SELECT artworks.artwork_id
            FROM artworks
            WHERE EXISTS (
                SELECT 1
                FROM unnest(cultures) as culture
                WHERE culture ILIKE %s
            )
            UNION
            SELECT artworks.artwork_id
            FROM artworks
            WHERE EXISTS (
                SELECT 1
                FROM unnest(periods) as period
                WHERE period ILIKE %s
            )
            UNION
            SELECT artworks.artwork_id
            FROM artworks
            WHERE EXISTS (
                SELECT 1
                FROM unnest(types) as type
                WHERE type ILIKE %s
            )
        ) AS combined_results
        LIMIT %s
    '''
    connection = get_db_conn()
    try:
        with connection.cursor() as cursor:
            cursor.execute(query_str, (q, q, q, q, q, q, q, limit))
            query_result = cursor.fetchall()
            return [artwork_id[0] for artwork_id in query_result]
    except Exception as ex:
        print(ex)
    finally:
        return_db_conn(connection)

if __name__ == '__main__':
    connection = get_db_conn()
    try:
        with connection.cursor() as cursor:
            drop_prefs(cursor)
            write_dummy_pref(cursor)
    finally:
        return_db_conn(connection)
