-- Verify pmp6-site:news on sqlite

BEGIN;

SELECT id, short_title, title, pub_time, content
    FROM news
    WHERE 0;

ROLLBACK;
