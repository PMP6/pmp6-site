-- Verify pmp6-site:auth on sqlite

BEGIN;

SELECT id, username, email, password, is_superuser, is_staff, joined_time
    FROM auth_user
    WHERE 0;

SELECT id, hash, user, expiry_time
    FROM auth_password_token
    WHERE 0;

ROLLBACK;
