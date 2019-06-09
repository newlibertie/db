CREATE DATABASE IF NOT EXISTS nldb CHARACTER SET utf8 COLLATE utf8_general_ci;

USE nldb;



CREATE TABLE IF NOT EXISTS users (

    id CHAR(36) PRIMARY KEY COMMENT 'uuid generated at creation time',

    url VARCHAR(8192) NOT NULL COMMENT 'url pointing to a user page',

    display_name VARCHAR(64) NOT NULL,

    creation_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
        COMMENT 'populated only at creation time, never updated',

    modification_time TIMESTAMP NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP
        COMMENT 'housekeeping field, populated at creation time and each update time'
);



CREATE TABLE IF NOT EXISTS polls (
	id VARCHAR(32) NOT NULL
		COMMENT 'auto generated at creation time only, never updated',
	tittle VARCHAR(64) NOT NULL
		COMMENT 'provided at the creation time and can be updated, never empty',
	tags JSON, #| array of tags
	#parameters	| h is computed, not stored
	largePrimeP VARCHAR(1024) NOT NULL
		COMMENT 'populated at the creation time only, never updated',
	generatorG VARCHAR(1024) NOT NULL
		COMMENT 'populated at the creation time only, never updated',
	privateKeyS VARCHAR(1024) NOT NULL
		COMMENT 'populated at the creation time only, never updated',
	#creator
	creatorId VARCHAR(32) NOT NULL
		COMMENT 'populated at creation time with users.id, never updated',
	creatorURL VARCHAR(255) NOT NULL
		COMMENT 'populated at creation time with users.url, never updated',

	#scope
	openingTS TIMESTAMP NULL
		COMMENT 'user provided input and smaller than closingTS if present, can be updated as long as status allows',
	closingTS TIMESTAMP NULL
		COMMENT 'user provided input and bigger than openingTS if present, can be updated as long as status allows',

	#houseKeeping
	creationTS TIMESTAMP DEFAULT CURRENT_TIMESTAMP
		COMMENT 'housekeeping field, populated only at creation time, never updated',
	lastModificationTS TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
		COMMENT 'housekeeping field, populated at creation time and each update time',

	#state fields
	publishedTS TIMESTAMP NULL
		COMMENT 'can be updated only if it was NULL before and its value is not more than openingTS',
	openTS TIMESTAMP NULL
		COMMENT 'can be updated only if it was NULL before and its value is not less than publishedTS',
	closedTS TIMESTAMP NULL
		COMMENT 'can be updated only if it was NULL before and its value is not less than openTS',

	status ENUM('created', 'published', 'open', 'closed') NOT NULL,
	type ENUM('simple', 'priority', 'order', 'ranking', 'weights') NOT NULL
		COMMENT 'an interpreter required per type value to interpret the json',
	choices JSON
		COMMENT 'can be updated as long as status allows and content has to be validated by an interpretor corresponding to type',

	#estimate fields
	likely BIGINT
		COMMENT 'a vote count estimate, can be updated as allowed by status',
	maximum BIGINT
		COMMENT 'a vote count estimate, can be updated as allowed by status'
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
