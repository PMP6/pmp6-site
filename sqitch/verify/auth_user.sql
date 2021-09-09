-- Verify pmp6-site:auth on sqlite

BEGIN;

SELECT id, username, email, password, is_superuser, is_staff, joined_time
    FROM auth_user
    WHERE 0;

ROLLBACK;
