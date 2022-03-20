-- Verify pmp6-site:news on sqlite

BEGIN;

SELECT id, short_title, title, pub_time, content, author, is_visible
    FROM news
    WHERE 0;

ROLLBACK;
