--
-- File generated with SQLiteStudio v3.4.1 on Fri Aug 4 17:10:17 2023
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: link
CREATE TABLE IF NOT EXISTS link (
    id      INTEGER PRIMARY KEY AUTOINCREMENT
                    UNIQUE
                    NOT NULL,
    url     TEXT    NOT NULL
                    REFERENCES users (name) ON DELETE CASCADE
                                            ON UPDATE CASCADE
                    UNIQUE,
    active  INTEGER NOT NULL,
    user_id TEXT    REFERENCES users (id) ON DELETE CASCADE
);


-- Table: response
CREATE TABLE IF NOT EXISTS response (
    id        INTEGER PRIMARY KEY AUTOINCREMENT
                      NOT NULL,
    questions TEXT    NOT NULL,
    link_id   INTEGER REFERENCES link (id) ON DELETE CASCADE,
    done      INTEGER DEFAULT (0)
);


-- Table: token
CREATE TABLE IF NOT EXISTS token (
    user_id      REFERENCES users (id) ON DELETE CASCADE
                 UNIQUE,
    token   TEXT UNIQUE
                 NOT NULL
);


-- Table: users
CREATE TABLE IF NOT EXISTS users (
    id        TEXT PRIMARY KEY
                   NOT NULL
                   UNIQUE,
    name      TEXT UNIQUE,
    email     TEXT UNIQUE,
    image     TEXT,
    public_id TEXT
);


COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
