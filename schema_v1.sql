-- ============================================================
-- schema_v1.sql
-- Digital Media & Creator Management System for YouTube
-- 3NF Normalized Schema — Initial DDL
--
-- Team: Sidharth Gupta, Aditya Koul, Ahshan Khan,
--       Aradhya Sharma, Daksh
-- Mid-Semester Report Deadline: 25 October 2025
--
-- Usage:
--   mysql -u <user> -p < schema_v1.sql
--   OR import into MySQL Workbench via:
--   Server → Data Import → Import from Self-Contained File
--   Then use Database → Reverse Engineer to auto-generate EER.
-- ============================================================

CREATE DATABASE IF NOT EXISTS youtube_creator_management
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE youtube_creator_management;

-- ────────────────────────────────────────────────────────────
-- 1. CREATOR
--    A person who produces content (may own multiple channels).
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Creator (
    creator_id      INT             NOT NULL AUTO_INCREMENT,
    full_name       VARCHAR(150)    NOT NULL,
    email           VARCHAR(255)    NOT NULL UNIQUE,
    country         VARCHAR(100)    NOT NULL DEFAULT 'Unknown',
    joined_date     DATE            NOT NULL,
    PRIMARY KEY (creator_id)
) ENGINE=InnoDB;

-- ────────────────────────────────────────────────────────────
-- 2. CHANNEL
--    A YouTube channel owned by exactly one Creator.
--    One Creator can own many Channels (1-to-many).
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Channel (
    channel_id          INT             NOT NULL AUTO_INCREMENT,
    creator_id          INT             NOT NULL,
    channel_name        VARCHAR(255)    NOT NULL,
    youtube_channel_id  VARCHAR(100)    NOT NULL UNIQUE,   -- e.g. UCxxxxxx
    category            VARCHAR(100)    NOT NULL,
    subscriber_count    BIGINT          NOT NULL DEFAULT 0,
    created_date        DATE            NOT NULL,
    PRIMARY KEY (channel_id),
    CONSTRAINT fk_channel_creator
        FOREIGN KEY (creator_id)
        REFERENCES Creator(creator_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ────────────────────────────────────────────────────────────
-- 3. VIDEO
--    A video uploaded to a Channel.
--    Belongs to exactly one Channel (many-to-one).
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Video (
    video_id            INT             NOT NULL AUTO_INCREMENT,
    channel_id          INT             NOT NULL,
    title               VARCHAR(500)    NOT NULL,
    youtube_video_id    VARCHAR(20)     NOT NULL UNIQUE,   -- e.g. dQw4w9WgXcQ
    published_at        DATETIME        NOT NULL,
    duration_seconds    INT             NOT NULL DEFAULT 0,
    status              ENUM('public','private','unlisted','deleted')
                                        NOT NULL DEFAULT 'public',
    PRIMARY KEY (video_id),
    CONSTRAINT fk_video_channel
        FOREIGN KEY (channel_id)
        REFERENCES Channel(channel_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- ────────────────────────────────────────────────────────────
-- 4. ANALYTICS
--    Performance metrics for a Video (one row per video).
--    Separated from Video to keep Video in 3NF — metrics
--    change frequently and are fetched independently.
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Analytics (
    analytics_id    INT             NOT NULL AUTO_INCREMENT,
    video_id        INT             NOT NULL UNIQUE,       -- 1-to-1 with Video
    view_count      BIGINT          NOT NULL DEFAULT 0,
    like_count      BIGINT          NOT NULL DEFAULT 0,
    comment_count   BIGINT          NOT NULL DEFAULT 0,
    watch_time_hrs  DECIMAL(12, 2)  NOT NULL DEFAULT 0.00,
    avg_view_pct    DECIMAL(5, 2)   NOT NULL DEFAULT 0.00, -- 0-100 %
    last_updated    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
                                    ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (analytics_id),
    CONSTRAINT fk_analytics_video
        FOREIGN KEY (video_id)
        REFERENCES Video(video_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;

-- ────────────────────────────────────────────────────────────
-- 5. BRAND
--    A company / advertiser that sponsors creators.
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Brand (
    brand_id        INT             NOT NULL AUTO_INCREMENT,
    brand_name      VARCHAR(255)    NOT NULL,
    industry        VARCHAR(150)    NOT NULL,
    website_url     VARCHAR(500)    NULL,
    contact_email   VARCHAR(255)    NULL,
    PRIMARY KEY (brand_id)
) ENGINE=InnoDB;

-- ────────────────────────────────────────────────────────────
-- 6. SPONSORSHIP
--    Resolves the many-to-many relationship between Brand and
--    Creator. A brand can sponsor many creators; a creator can
--    have multiple brand deals.
--
--    Optionally linked to a specific Video where the deal is
--    executed (nullable — some deals are channel-level).
-- ────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS Sponsorship (
    sponsorship_id      INT             NOT NULL AUTO_INCREMENT,
    brand_id            INT             NOT NULL,
    creator_id          INT             NOT NULL,
    video_id            INT             NULL,              -- nullable (channel deal)
    deal_value_usd      DECIMAL(12, 2)  NOT NULL DEFAULT 0.00,
    start_date          DATE            NOT NULL,
    end_date            DATE            NULL,
    deal_type           ENUM('one-time','recurring','affiliate')
                                        NOT NULL DEFAULT 'one-time',
    status              ENUM('active','completed','cancelled')
                                        NOT NULL DEFAULT 'active',
    PRIMARY KEY (sponsorship_id),
    CONSTRAINT fk_sponsorship_brand
        FOREIGN KEY (brand_id)
        REFERENCES Brand(brand_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_sponsorship_creator
        FOREIGN KEY (creator_id)
        REFERENCES Creator(creator_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_sponsorship_video
        FOREIGN KEY (video_id)
        REFERENCES Video(video_id)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE=InnoDB;

-- ============================================================
-- End of schema_v1.sql
-- ============================================================
