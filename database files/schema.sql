create database campus_lost_found;
go

USE campus_lost_found;
GO

CREATE TABLE users (
    user_id             INT IDENTITY(1,1) PRIMARY KEY,
    full_name           NVARCHAR(100) NOT NULL,
    email               NVARCHAR(100) NOT NULL UNIQUE,
    password_hash       NVARCHAR(255) NOT NULL,
    phone_number        NVARCHAR(20) NULL,
    registration_number NVARCHAR(20) NULL,
    user_type           NVARCHAR(20) NOT NULL DEFAULT 'user'
                        CHECK (user_type IN ('user', 'admin')),
    is_active           BIT DEFAULT 1,
    password_reset_token NVARCHAR(255) NULL,
    reset_token_expiry  DATETIME NULL,
    created_at          DATETIME DEFAULT GETDATE(),
    updated_at          DATETIME DEFAULT GETDATE()
);

-- enforcing only one admin in the system
CREATE UNIQUE INDEX uq_single_admin
    ON users (user_type)
    WHERE user_type = 'admin';

ALTER TABLE users ADD CONSTRAINT chk_email_domain
    CHECK (email LIKE '%@lhr.nu.edu.pk' AND email NOT LIKE '% %');

GO

CREATE TABLE categories (
    category_id   INT IDENTITY(1,1) PRIMARY KEY,
    category_name NVARCHAR(50) NOT NULL UNIQUE,
    description   NVARCHAR(255) NULL
);

GO

CREATE TABLE items (
    item_id              INT IDENTITY(1,1) PRIMARY KEY,
    user_id              INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    category_id          INT NOT NULL REFERENCES categories(category_id),
    item_type            NVARCHAR(5) NOT NULL CHECK (item_type IN ('lost', 'found')),
    item_name            NVARCHAR(100) NOT NULL,
    description          NVARCHAR(500) NOT NULL,
    location             NVARCHAR(200) NOT NULL,
    item_date            DATE NOT NULL,           -- lost_date or found_date
    reported_date        DATETIME DEFAULT GETDATE(),
    -- status: lost=(pending,matched,recovered,closed), found=(available,claimed,returned)
    status               NVARCHAR(20) NOT NULL DEFAULT 'pending'
                         CHECK (status IN ('pending','matched','recovered','closed','available','claimed','returned')),
    -- Lost-item fields (NULL for found items)
    security_question    NVARCHAR(255) NULL,
    security_answer_hash NVARCHAR(255) NULL,
    -- for admin moderation
    is_active            BIT DEFAULT 1,
    is_flagged           BIT DEFAULT 0,          -- flagged as inappropriate/spam
    flag_reason          NVARCHAR(255) NULL,
    is_duplicate         BIT DEFAULT 0,          -- suggested duplicate by system
    duplicate_of_item_id INT NULL REFERENCES items(item_id),
    image_path           NVARCHAR(500) NULL
);

GO

CREATE TABLE claims (
    claim_id                  INT IDENTITY(1,1) PRIMARY KEY,
    item_id                   INT NOT NULL REFERENCES items(item_id),   -- found item being claimed
    lost_item_id              INT NULL REFERENCES items(item_id),       -- optional: claimant's lost item
    claimant_user_id          INT NOT NULL REFERENCES users(user_id),
    claim_date                DATETIME DEFAULT GETDATE(),
    status                    NVARCHAR(20) DEFAULT 'pending'
                              CHECK (status IN ('pending','approved','rejected','verified')),
    security_answer_provided  NVARCHAR(255) NOT NULL,
    admin_notes               NVARCHAR(500) NULL,
    reviewed_by               INT NULL REFERENCES users(user_id),
    reviewed_date             DATETIME NULL,
    collection_code           VARCHAR(8) NULL,
    CONSTRAINT uq_claim_unique UNIQUE (item_id, claimant_user_id)
);

GO

CREATE TABLE messages (
    message_id   INT IDENTITY(1,1) PRIMARY KEY,
    item_id      INT NOT NULL REFERENCES items(item_id),
    sender_id    INT NOT NULL REFERENCES users(user_id),
    receiver_id  INT NOT NULL REFERENCES users(user_id),
    message_text NVARCHAR(1000) NOT NULL,
    is_read      BIT DEFAULT 0,
    sent_at      DATETIME DEFAULT GETDATE()
);

GO

CREATE TABLE notifications (
    notification_id     INT IDENTITY(1,1) PRIMARY KEY,
    user_id             INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    title               NVARCHAR(100) NOT NULL,
    message             NVARCHAR(500) NOT NULL,
    notification_type   NVARCHAR(50) NOT NULL,
    is_read             BIT DEFAULT 0,
    related_entity_type NVARCHAR(50) NULL,
    related_entity_id   INT NULL,
    created_at          DATETIME DEFAULT GETDATE()
);

GO

-- for admin monitoring
CREATE TABLE activity_logs (
    log_id      INT IDENTITY(1,1) PRIMARY KEY,
    user_id     INT NOT NULL REFERENCES users(user_id),
    action      NVARCHAR(100) NOT NULL,
    entity_type NVARCHAR(50) NOT NULL,
    entity_id   INT NOT NULL,
    details     NVARCHAR(MAX) NULL,
    ip_address  NVARCHAR(45) NULL,
    created_at  DATETIME DEFAULT GETDATE()
);

GO

-- Seed default categories
INSERT INTO categories (category_name) VALUES
('Electronics'), ('Books & Stationery'), ('Clothing & Accessories'),
('Keys'), ('Bags & Wallets'), ('ID & Cards'), ('Sports Equipment'), ('Other');

-- Seed the single admin account (password: Admin@123)
-- SHA256 of 'Admin@123' = precomputed hash below
INSERT INTO users (full_name, email, password_hash, user_type)
VALUES ('Administrator', 'admin@lhr.nu.edu.pk',
        'c3a2ded0a0e3b53a31e9b74e5c2143fd5e4cd399c35af7e15d36d5428dfd0e7d', 'admin');
GO

-- optimizations:
-- active item searches and matching algorithms
CREATE NONCLUSTERED INDEX ix_items_active_search 
ON items (item_type, status, is_active, is_flagged)
INCLUDE (item_name, location, item_date, category_id, user_id);

-- claim lookups and status evaluations
CREATE NONCLUSTERED INDEX ix_claims_lookup 
ON claims (item_id, claimant_user_id, status)
INCLUDE (collection_code);

-- messaging history and notifications queries
CREATE NONCLUSTERED INDEX ix_messages_stream 
ON messages (item_id, sender_id, receiver_id)
INCLUDE (sent_at, is_read);

CREATE NONCLUSTERED INDEX ix_notifications_user 
ON notifications (user_id, is_read)
INCLUDE (created_at);
GO