-- Revert pmp6-site:auth from sqlite

BEGIN;

DROP TABLE auth_user;

COMMIT;
