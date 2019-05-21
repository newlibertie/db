CREATE DATABASE db CHARACTER SET utf8 COLLATE utf8_general_ci;

USE db

CREATE TABLE pet (name VARCHAR(20), owner VARCHAR(20),
       species VARCHAR(20), sex CHAR(1), birth DATE, death DATE);

CREATE TABLE Users (
	id VARCHAR(32),
	url VARCHAR(255),
	name VARCHAR(64),
	#houseKeeping
		creationTS TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
		lastModificationTS TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	isActive BOOL /*,
        audit,
	payment,
	abuse,
	others (may be in another table), */
        );

CREATE TABLE Polls (
	id VARCHAR(32),
	tittle VARCHAR(64),
	tags JSON, #| array of tags
	#parameters	| h is computed, not stored
		largePrimeP VARCHAR(1024),
		generatorG VARCHAR(1024),
		privateKeyS VARCHAR(1024),
	#creator
		creatorId VARCHAR(32),
		creatorURL VARCHAR(255),
	#scope
		/*geography
			inclusion
			exclusion*/
		timeRange
			openingTS TIMESTAMP NULL,
			closingTS TIMESTAMP NULL,
		/*affiliations :
			inclusion
			exclusion*/
	#houseKeeping
		creationTS TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
		lastModificationTS TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		publishedTS TIMESTAMP NULL,
		openTS TIMESTAMP NULL,
		closedTS TIMESTAMP NULL,
	status ENUM('created', 'published', 'open', 'closed'),
	type ENUM('simple', 'priority', 'order', 'ranking', 'weights'),  /* interpreter to interpret the json */
	choices JSON,
	#voteCount
	        /* perhaps currentCountEstimate */
		likely BIGINT,
		maximum BIGINT);

CREATE TABLE Ballots (
	pollId VARCHAR(32),
	voterURL VARCHAR(255),
	value JSON,  #string json( eg: array of (T, C, D) )
	creationTS TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

CREATE TABLE VoterDisqualification (
	pollId VARCHAR(32),
	voterId VARCHAR(255),
	tsstart TIMESTAMP CURENT_TIMESTAMP,
	tsend TIMESTAMP NULL,
	reasonstart VARCHAR(255),
	reasonend VARCHAR(255));
