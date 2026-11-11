
-- =====================================================
-- ACADEMIA PLATFORM
-- Migration 001: Identity and access management
-- PostgreSQL 17
-- =====================================================

BEGIN;

-- 1. USERS
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password_hash TEXT NOT NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT users_first_name_not_blank
        CHECK (LENGTH(TRIM(first_name)) > 0),

    CONSTRAINT users_last_name_not_blank
        CHECK (LENGTH(TRIM(last_name)) > 0),

    CONSTRAINT users_email_not_blank
        CHECK (LENGTH(TRIM(email)) > 0)
);

-- Unique emails regardless of letter case
CREATE UNIQUE INDEX users_email_unique_lower
ON users (LOWER(email));

-- 2. ROLES
CREATE TABLE roles (
    id SMALLINT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

-- 3. USER ROLES
CREATE TABLE user_roles (
    user_id UUID NOT NULL,
    role_id SMALLINT NOT NULL,

    assigned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    PRIMARY KEY (user_id, role_id),

    CONSTRAINT fk_user_roles_user
        FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_user_roles_role
        FOREIGN KEY (role_id)
        REFERENCES roles(id)
        ON DELETE RESTRICT
);

-- 4. DEFAULT ROLES
INSERT INTO roles (id, name, description)
VALUES
    (1, 'admin', 'Platform administrator'),
    (2, 'teacher', 'Academic instructor'),
    (3, 'student', 'Enrolled student'),
    (4, 'guardian', 'Parent or authorized guardian');

-- 5. AUTOMATIC UPDATED_AT
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

COMMIT;
