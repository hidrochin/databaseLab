DROP DATABASE if exists footballdb;
-- create database
CREATE DATABASE footballdb;
\c footballdb

-- TABLE DEFINITION
-- coach (coach_id, coach_name, dob, role, phone, club_id, nation_id)
-- referee (referee_id, referee_name, role, dob, nation_id)
-- nation (nation_id, nation_name)
-- club (club_id, club_name, address)
-- stadium (stadium_id, stadium_name, capacity, address, club_id)
-- player (player_id, player_name, dob, number, role, phone, club_id, nation_id)
-- match (match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, time, roundname, stadium_id)
-- round (roundname)
-- participation (match_id, club_id1, club_id2)
-- control (match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3)
-- rankingtable (roundname, club_id, match_played, win, lose, draw, yellow_card, red_card, goad_difference, point, rank)

-- =======================================================================================
-- coach (coach_id, coach_name, dob, role, phone, club_id, nation_id)
CREATE TABLE coach (
	coach_id CHAR(8) NOT NULL,
	coach_name VARCHAR(30) NOT NULL,
	dob DATE NOT NULL,
	role VARCHAR(20) NOT NULL,
	phone CHAR(11),
	club_id CHAR(8),
	nation_id CHAR(8),
	CONSTRAINT coach_pk PRIMARY KEY (coach_id)
);

-- referee (referee_id, referee_name, role, dob, nation_id)
CREATE TABLE referee (
	referee_id CHAR(8) NOT NULL,
	referee_name VARCHAR(30) NOT NULL,
	role CHAR(10) NOT NULL,
	dob DATE NOT NULL,
	nation_id CHAR(8),
	CONSTRAINT referee_pk PRIMARY KEY (referee_id)
);

-- nation (nation_id, nation_name)
CREATE TABLE nation (
	nation_id CHAR(8) NOT NULL,
	natione_name VARCHAR(10) NOT NULL,
	CONSTRAINT nation_pk PRIMARY KEY (nation_id)
);

-- club (club_id, club_name, address)
CREATE TABLE club (
	club_id CHAR(8) NOT NULL,
	club_name VARCHAR(30) NOT NULL,
	address VARCHAR (30),
	CONSTRAINT club_pk PRIMARY KEY (club_id)
);

-- stadium (stadium_id, stadium_name, capacity, address, club_id)
CREATE TABLE stadium (
	stadium_id CHAR(8) NOT NULL,
	stadium_name VARCHAR(30) NOT NULL,
	capacity INT NOT NULL, 
	address VARCHAR(30) NOT NULL,
	club_id CHAR(8),
	CONSTRAINT stadium_pk PRIMARY KEY (stadium_id),
	CONSTRAINT stadium_fk_club FOREIGN KEY (club_id) REFERENCES club(club_id)
);

-- player (player_id, player_name, dob, number, role, phone, club_id, nation_id)
CREATE TABLE player (
	player_id CHAR(8) NOT NULL,
	player_name VARCHAR(30) NOT NULL,
	dob DATE NOT NULL,
	number SMALLINT NOT NULL,
	role VARCHAR(20),
	phone CHAR(11),
	club_id CHAR(8),
	nation_id CHAR(8),
	CONSTRAINT player_pk PRIMARY KEY (player_id),
	CONSTRAINT player_fk_club FOREIGN KEY (club_id) REFERENCES club(club_id),
	CONSTRAINT player_fk_nation FOREIGN KEY (nation_id) REFERENCES nation(nation_id)
);

-- match (match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, time, roundname, stadium_id)
CREATE TABLE match (
	match_id CHAR(8) NOT NULL,
	goal_1 SMALLINT NOT NULL,
	goal_2 SMALLINT NOT NULL,
	yellow_card1 SMALLINT NOT NULL,
	yellow_card2 SMALLINT NOT NULL,
	red_card1 SMALLINT NOT NULL,
	red_Card2 SMALLINT NOT NULL,
	time DATE NOT NULL,
	roundname VARCHAR(20),
	stadium_id CHAR(8),
	CONSTRAINT match_pk PRIMARY KEY (match_id),
	CONSTRAINT match_fk_stadium FOREIGN KEY (stadium_id) REFERENCES stadium(stadium_id)
);

-- round (roundname)
CREATE TABLE round (
	roundname VARCHAR(20) NOT NULL,
	CONSTRAINT round_pk PRIMARY KEY (roundname)
);

-- participation (match_id, club_id1, club_id2)
CREATE TABLE participation (
	match_id CHAR(8) NOT NULL,
	club_id1 CHAR(8) NOT NULL,
	club_id2 CHAR(8) NOT NULL,
	CONSTRAINT participation_pk PRIMARY KEY (match_id, club_id1, club_id2),
	CONSTRAINT participation_fk_match FOREIGN KEY (match_id) REFERENCES match(match_id),
	CONSTRAINT participation_fk_club1 FOREIGN KEY (club_id1) REFERENCES club(club_id),
	CONSTRAINT participation_fk_club2 FOREIGN KEY (club_id2) REFERENCES club(club_id)
);

-- control (match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3)
CREATE TABLE control (
	match_id CHAR(8) NOT NULL,
	referee_id1 CHAR(8) NOT NULL,
	referee_id2 CHAR(8) NOT NULL,
	referee_id3 CHAR(8) NOT NULL,
	role1 VARCHAR(20) NOT NULL,
	role2 VARCHAR(20) NOT NULL,
	role3 VARCHAR(20) NOT NULL,
	CONSTRAINT control_pk PRIMARY KEY (match_id, referee_id1, referee_id2, referee_id3),
	CONSTRAINT control_fk_referee1 FOREIGN KEY (referee_id1) REFERENCES referee(referee_id),
	CONSTRAINT control_fk_referee2 FOREIGN KEY (referee_id2) REFERENCES referee(referee_id),
	CONSTRAINT control_fk_referee3 FOREIGN KEY (referee_id3) REFERENCES referee(referee_id)
);

-- rankingtable (roundname, club_id, match_played, win, lose, draw, yellow_card, red_card, goad_difference, point, rank)
CREATE TABLE rankingtable (
	roundname VARCHAR(20) NOT NULL,
	club_id CHAR(8) NOT NULL,
	match_played SMALLINT NOT NULL,
	win SMALLINT NOT NULL,
	lose SMALLINT NOT NULL,
	draw SMALLINT NOT NULL,
	yellow_card SMALLINT NOT NULL,
	red_card SMALLINT NOT NULL,
	goal_difference INT,
	point INT, 
	rank SMALLINT,
	CONSTRAINT rankingtable_pk PRIMARY KEY (roundname, club_id),
	CONSTRAINT rankingtable_fk_round FOREIGN KEY (roundname) REFERENCES round(roundname),
	CONSTRAINT rankingtable_fk_club FOREIGN KEY (club_id) REFERENCES club(club_id)
);

-- Foreign key constraints
ALTER TABLE coach ADD CONSTRAINT coach_fk_club FOREIGN KEY (club_id) REFERENCES club(club_id);
ALTER TABLE coach ADD CONSTRAINT coach_fk_nation FOREIGN KEY (nation_id) REFERENCES nation(nation_id);
ALTER TABLE referee ADD CONSTRAINT referee_fk_nation FOREIGN KEY (nation_id) REFERENCES nation(nation_id);
ALTER TABLE match ADD CONSTRAINT match_fk_round FOREIGN KEY (roundname) REFERENCES round(roundname);