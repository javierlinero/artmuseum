#!/usr/bin/env python
# ----------------------------------------------------------------------
# json_script.py
# Author: Javier Linero 
# ----------------------------------------------------------------------

import os
import json
import psycopg2
from contextlib import closing

json_dir = "json_files"
# password will be set to the given environ var
pswd = os.environ['PUAM_DB_PASSWORD']
host = "puam-app-db.c81admmts5ij.us-east-2.rds.amazonaws.com"

def create_table(conn):
    del_query = """
    DROP TABLE IF EXISTS link;
    DROP TABLE IF EXISTS artworks;
    DROP TABLE IF EXISTS artists;
    """
    conn.cursor.execute(del_query)
    conn.commit()

    table_query = """
    CREATE TABLE artists (
        artist_id SERIAL PRIMARY KEY,
        displayname TEXT,
        displaydate TEXT,
        datebegin INTEGER,
        dateend INTEGER,
        prefix TEXT,
        suffix TEXT,
        role TEXT
    );
    CREATE TABLE artworks (
        artwork_id SERIAL PRIMARY KEY,
        title TEXT,
        imageUrl TEXT,
        year TEXT,
        materials TEXT,
        size TEXT,
        description TEXT
    );
    CREATE TABLE link (
        artwork_id INTEGER,
        artist_id INTEGER,
        PRIMARY KEY (artwork_id, artist_id),
        FOREIGN KEY (artwork_id) REFERENCES artworks(artwork_id),
        FOREIGN KEY (artist_id) REFERENCES artists(artist_id)
    );
    """
    conn.cursor.execute(table_query)
    conn.commit()

def main():
    try:
        with psycopg2.connect(dbname="init_db",
                              user="puam",
                              password=pswd,
                              host=host,
                              port="5432",
                              sslmode="require") as conn:
            with closing(conn.cursor()) as cursor:
                # drop all prev tables w/ records & sets them up
                create_table()
                for filename in sorted(os.listdir(json_dir)):
                    if filename.endswith(".json"):
                        print(f"Processing {filename}...")
                        # changed to utf-8 encoding for all chars needed
                        with open(os.path.join(json_dir, filename), "r", encoding="utf-8") as file:
                            artwork_data = json.load(file)

                            # year formatting
                            year = artwork_data.get("accessionyear")
                            if year:
                                year = year.split("-")[0]
                            else:
                                year = None

                            cursor.execute(
                                """
                                INSERT INTO artworks (title, imageUrl, year, materials, size, description)
                                VALUES (%s, %s, %s, %s, %s, %s)
                                RETURNING artwork_id;
                                """,
                                (artwork_data.get("displaytitle"),
                                 artwork_data.get("media", [{}])[0].get("uri", ""),
                                 year,
                                 artwork_data.get("medium"),
                                 artwork_data.get("dimensions"),
                                 artwork_data.get("caption")),
                            )
                            conn.commit()
                            artwork_id = cursor.fetchone()[0]

                            # handles all potential artists that have contributed to a piece of art
                            for maker in artwork_data.get("makers", []):
                                with conn.cursor() as artist_cursor:
                                    artist_cursor.execute(
                                        """
                                        INSERT INTO artists (displayname, displaydate, datebegin, dateend, prefix, suffix, role)
                                        VALUES (%s, %s, %s, %s, %s, %s, %s)
                                        RETURNING artist_id;
                                        """,
                                        (maker.get("displayname"),
                                         maker.get("displaydate"),
                                         maker.get("datebegin"),
                                         maker.get("dateend"),
                                         maker.get("prefix"),
                                         maker.get("suffix"), 
                                         maker.get("role")),
                                    )
                                    artist_id = artist_cursor.fetchone()[0]
                                # links it so we can access artworks
                                # and their given artists connected by
                                # artwork_id
                                cursor.execute(
                                    """
                                    INSERT INTO link (artwork_id, artist_id)
                                    VALUES (%s, %s);
                                    """,
                                    (artwork_id, artist_id),
                                )

                        print(f"Processed {filename} successfully.")
                    else:
                        print(f"Skipped {filename} (not a JSON file).")
                print("Finished processing all files.")
    except Exception as ex:
        conn.rollback()
        print(f"An error occurred: {ex}")

if __name__ == "__main__":
    main()
