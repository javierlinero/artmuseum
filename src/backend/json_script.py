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

def main():
    try:
        with psycopg2.connect(dbname="init_db",
                              user="puam",
                              password=pswd,
                              host=host,
                              port="5432",
                              sslmode="require") as conn:
            with closing(conn.cursor()) as cursor:
                # this allows for whenever it may potentially crash
                # a user can go back in and modify this to the file that
                # didnt get appended.
                resume_from_filename = "artobject_10000.json"
                resume_processing = False
                for filename in sorted(os.listdir(json_dir)):
                    if filename.endswith(".json"):
                        if resume_processing or filename == resume_from_filename:
                            resume_processing = True
                            print(f"Processing {filename}...")
                            # changed to utf-8 encoding for all chars needed
                            with open(os.path.join(json_dir, filename), "r", encoding="utf-8") as file:
                                artwork_data = json.load(file)

                                terms = artwork_data.get("terms", [])
                                types = [term["term"] for term in terms if term.get("termtype", "") == "Classification" and "termtype" in term]
                                cultures = [term["term"] for term in terms if term.get("termtype", "") == "Culture" and "termtype" in term]
                                subjects = [term["term"] for term in terms if term.get("termtype", "") == "Subject" and "termtype" in term]

                                # Collect terms without termtype in the 'other_terms' list
                                other_terms = [term["term"] for term in terms if "termtype" not in term]

                                periods_arr = artwork_data.get("periods", [])
                                periods = [period["period"] for period in periods_arr]

                                cursor.execute(
                                    """
                                    INSERT INTO artworks (artwork_id, title, imageUrl, year, materials, size, description, types, cultures, subjects, periods, daterange, other_terms)
                                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                                    RETURNING artwork_id;
                                    """,
                                    (artwork_data.get("objectid"),
                                    artwork_data.get("displaytitle"),
                                    artwork_data.get("media", [{}])[0].get("uri", ""),
                                    artwork_data.get("displaydate"),
                                    artwork_data.get("medium"),
                                    artwork_data.get("dimensions"),
                                    artwork_data.get("caption"),
                                    types,
                                    cultures,
                                    subjects, 
                                    periods,
                                    artwork_data.get("daterange"),
                                    other_terms),
                                )
                                conn.commit()
                                artwork_id = cursor.fetchone()[0]

                                # handles all potential artists that have contributed to a piece of art
                                processed_artist_ids = set()

                                for maker in artwork_data.get("makers", []):
                                    artist_id = maker.get("id") or maker.get("makerid")

                                    # Check if artist_id has already been processed
                                    if artist_id in processed_artist_ids:
                                        print(f"Artist with artist_id={artist_id} already processed. Skipping insertion.")
                                    else:
                                        with conn.cursor() as artist_cursor:
                                            artist_cursor.execute(
                                                """
                                                SELECT artist_id FROM artists WHERE artist_id = %s;
                                                """,
                                                (artist_id,)
                                            )
                                            existing_artist = artist_cursor.fetchone()

                                            if existing_artist:
                                                artist_id = existing_artist[0]
                                                print(f"Artist with artist_id={artist_id} already exists. Skipping insertion.")
                                            else:
                                                artist_cursor.execute(
                                                    """
                                                    INSERT INTO artists (artist_id, displayname, displaydate, datebegin, dateend, prefix, suffix, role)
                                                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
                                                    RETURNING artist_id;
                                                    """,
                                                    (maker.get("id"),
                                                    maker.get("displayname"),
                                                    maker.get("displaydate"),
                                                    maker.get("datebegin"),
                                                    maker.get("dateend"),
                                                    maker.get("prefix"),
                                                    maker.get("suffix"), 
                                                    maker.get("role")),
                                                )
                                                artist_id = artist_cursor.fetchone()[0]
                                            
                                            # Add the artist_id to the set of processed artist_ids
                                            processed_artist_ids.add(artist_id)

                                    # Check if the link already exists before inserting
                                    cursor.execute(
                                        """
                                        SELECT 1 FROM link WHERE artwork_id = %s AND artist_id = %s;
                                        """,
                                        (artwork_id, artist_id),
                                    )
                                    existing_link = cursor.fetchone()

                                    if not existing_link:
                                        # Link the existing or newly inserted artist to the artwork
                                        cursor.execute(
                                            """
                                            INSERT INTO link (artwork_id, artist_id)
                                            VALUES (%s, %s);
                                            """,
                                            (artwork_id, artist_id),
                                        )
                                    else:
                                        print(f"Link with artwork_id={artwork_id} and artist_id={artist_id} already exists. Skipping insertion.")


                            print(f"Processed {filename} successfully.")
                        else:
                            print(f"Skipped {filename} (not a JSON file).")
                else:
                    print("Finished processing all files.")
    except Exception as ex:
        conn.rollback()
        print(f"An error occurred: {ex}")

if __name__ == "__main__":
    main()