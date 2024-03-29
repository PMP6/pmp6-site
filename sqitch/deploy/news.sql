-- Deploy pmp6-site:news to sqlite

BEGIN;

CREATE TABLE news (
    id INTEGER NOT NULL PRIMARY KEY,
    short_title TEXT NOT NULL,
    title TEXT NOT NULL,
    pub_time INTEGER NOT NULL,
    content TEXT NOT NULL,
    author INTEGER NOT NULL,
    is_visible INTEGER NOT NULL,
    FOREIGN KEY(author) REFERENCES auth_user(id)
);

COMMIT;
