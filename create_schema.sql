CREATE DATABASE IF NOT EXISTS nldb CHARACTER SET utf8 COLLATE utf8_general_ci;

USE nldb;



CREATE TABLE IF NOT EXISTS users (

    id CHAR(36) PRIMARY KEY COMMENT 'uuid (8-4-4-12) generated at creation time',

    url VARCHAR(8192) NOT NULL COMMENT 'url pointing to a user page',

    display_name VARCHAR(64) NOT NULL,

    creation_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
        COMMENT 'populated only at creation time, never updated',

    modification_time TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
        COMMENT 'housekeeping field, populated at creation time and each update time'
);



CREATE TABLE IF NOT EXISTS polls (

    id VARCHAR(36) PRIMARY KEY COMMENT 'uuid (8-4-4-12) generated at creation time',

    title VARCHAR(64) NOT NULL,

    tags VARCHAR(65535) NULL  COMMENT "JSON array of tags",

    -- cryptographic parameters for this poll

    large_prime_p VARCHAR(65535) NOT NULL,

    generator_g  VARCHAR(65535) NOT NULL,

    private_key_s VARCHAR(65535) NOT NULL,


    -- creator
    creator_id  VARCHAR(36) NOT NULL COMMENT 'populated at creation time with users.id, never updated',


    -- operational parameters of this poll
    opening_ts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    closing_ts TIMESTAMP NOT NULL,

    -- housekeeping

    creation_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    last_modification_ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,


    poll_type ENUM(
              'simple',             -- one choice allowed, choice with maximum votes wins
              'multiple_choice',    -- select as many as yoo like,  choice with maximum votes wins
              'instant_runoff'      -- select as many as you like in priority order,  instant runoff
              ) NOT NULL
        COMMENT 'an interpreter required per type value to interpret the json in the choices field',

    poll_choices  VARCHAR(65535)
);

CREATE TABLE IF NOT EXISTS ballots (
    pollId VARCHAR(32) NOT NULL
        COMMENT 'reference to poll.id, populated only on creation, never updated',
    voterURL VARCHAR(255) NOT NULL
        COMMENT 'populated only on creation, never updated',
    value JSON  #string json( eg: array of (T, C, D) )
        COMMENT 'value validated by an interpretor based on poll.type, populated only on creation, never updated',
    creationTS TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        COMMENT 'populated only on creation, never updated'
);



CREATE TABLE IF NOT EXISTS disqualifications (
    pollId VARCHAR(32) NOT NULL
        COMMENT 'refersence to poll.id, populated on creation, never updated',
    voterId VARCHAR(255) NOT NULL,
    tsstart TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        COMMENT 'populated on creation, never updated',
    tsend TIMESTAMP NULL
        COMMENT 'updated only if NULL, not populated on creation',
    reasonstart VARCHAR(255)
        COMMENT 'populated only on creation, never updated',
        COMMENT 'updated only if NULL, not populated on creation'
);
