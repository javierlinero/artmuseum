#db script by Javier Linero

def drop_table():
    return """
    DROP TABLE IF EXISTS link;
    DROP TABLE IF EXISTS artworks CASCADE;
    DROP TABLE IF EXISTS artists;
    """

def create_table():
    return """
    CREATE TABLE artists (
        artist_id INTEGER PRIMARY KEY,
        displayname TEXT,
        displaydate TEXT,
        datebegin INTEGER,
        dateend INTEGER,
        prefix TEXT,
        suffix TEXT,
        role TEXT
    );
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
        daterange TEXT
    );
    CREATE TABLE link (
        artwork_id INTEGER,
        artist_id INTEGER,
        PRIMARY KEY (artwork_id, artist_id),
        FOREIGN KEY (artwork_id) REFERENCES artworks(artwork_id),
        FOREIGN KEY (artist_id) REFERENCES artists(artist_id)
    );
    """