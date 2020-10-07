-- Revert pmp6-site:news from sqlite

BEGIN;

DROP TABLE news;

COMMIT;
