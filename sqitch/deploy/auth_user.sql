-- Deploy pmp6-site:auth to sqlite

BEGIN;

CREATE TABLE auth_user (
    id INTEGER NOT NULL PRIMARY KEY,
    username TEXT NOT NULL UNIQUE COLLATE NOCASE,
    email TEXT NOT NULL UNIQUE COLLATE NOCASE,
    password TEXT NOT NULL,
    is_superuser INTEGER NOT NULL,
    is_staff INTEGER NOT NULL,
    joined_time INTEGER NOT NULL
);

COMMIT;
