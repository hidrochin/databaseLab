DROP DATABASE if exists footballdb;
-- create database
CREATE DATABASE footballdb;
\c footballdb

-- TABLE DEFINITION
-- coach (coach_id, coach_name, DOB, role, phone, club_id, nation_id)
-- referee (referee_id, referee_name, role, DOB, nation_id)
-- nation (nation_id, nation_name)
-- club (club_id, club_name, address)
-- stadium (stadium_id, stadium_name, capacity, address, club_id)
-- player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id)
-- match (match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, time, roundname, stadium_id)
-- round (roundname)
-- participation (match_id, club_id1, club_id2)
-- control (match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3)
-- finaltable (roundname, club_id, match_played, win, lose, draw, yellow_card, red_card, goad_difference, point)

-- =======================================================================================
-- coach (coach_id, coach_name, DOB, role, phone, club_id, nation_id)
CREATE TABLE coach (
	coach_id CHAR(8) NOT NULL,
	coach_name VARCHAR(30) NOT NULL,
	DOB DATE NOT NULL,
	role VARCHAR(20) NOT NULL,
	phone CHAR(11),
	club_id CHAR(8),
	nation_id CHAR(8),
	CONSTRAINT coach_pk PRIMARY KEY (coach_id)
);

-- referee (referee_id, referee_name, role, DOB, nation_id)
CREATE TABLE referee (
	referee_id CHAR(8) NOT NULL,
	referee_name VARCHAR(30) NOT NULL,
	DOB DATE NOT NULL,
	role CHAR(20) NOT NULL,
	
	nation_id CHAR(8),
	CONSTRAINT referee_pk PRIMARY KEY (referee_id)
);

-- nation (nation_id, nation_name)
CREATE TABLE nation (
	nation_id CHAR(8) NOT NULL,
	nation_name VARCHAR(20) NOT NULL,
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

-- player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id)
CREATE TABLE player (
	player_id CHAR(8) NOT NULL,
	player_name VARCHAR(30) NOT NULL,
	DOB DATE NOT NULL,
	shirt_number SMALLINT NOT NULL,
	role VARCHAR(20),
	phone CHAR(15),
	club_id CHAR(8),
	nation_id CHAR(8),
	CONSTRAINT player_pk PRIMARY KEY (player_id),
	CONSTRAINT player_fk_club FOREIGN KEY (club_id) REFERENCES club(club_id),
	CONSTRAINT player_fk_nation FOREIGN KEY (nation_id) REFERENCES nation(nation_id)
);

-- matches (match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, time, roundname, stadium_id)
CREATE TABLE matches (
	match_id CHAR(8) NOT NULL,
	time DATE NOT NULL,
	roundname VARCHAR(20),
	stadium_id CHAR(8),
	goal_1 SMALLINT NOT NULL,
	goal_2 SMALLINT NOT NULL,
	yellow_card1 SMALLINT NOT NULL,
	yellow_card2 SMALLINT NOT NULL,
	red_card1 SMALLINT NOT NULL,
	red_card2 SMALLINT NOT NULL,

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
	CONSTRAINT participation_fk_match FOREIGN KEY (match_id) REFERENCES matches(match_id),
	CONSTRAINT participation_fk_club1 FOREIGN KEY (club_id1) REFERENCES club(club_id),
	CONSTRAINT participation_fk_club2 FOREIGN KEY (club_id2) REFERENCES club(club_id)
);

-- controls (match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3)
CREATE TABLE controls (
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

-- finaltable (roundname, club_id, match_played, win, lose, draw, yellow_card, red_card, goal_difference, point)
CREATE TABLE finaltable (
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
	CONSTRAINT finaltable_pk PRIMARY KEY (roundname, club_id),
	CONSTRAINT finaltable_fk_round FOREIGN KEY (roundname) REFERENCES round(roundname),
	CONSTRAINT finalltable_fk_club FOREIGN KEY (club_id) REFERENCES club(club_id)
);

-- Foreign key constraints
ALTER TABLE coach ADD CONSTRAINT coach_fk_club FOREIGN KEY (club_id) REFERENCES club(club_id);
ALTER TABLE coach ADD CONSTRAINT coach_fk_nation FOREIGN KEY (nation_id) REFERENCES nation(nation_id);
ALTER TABLE referee ADD CONSTRAINT referee_fk_nation FOREIGN KEY (nation_id) REFERENCES nation(nation_id);
ALTER TABLE matches ADD CONSTRAINT match_fk_round FOREIGN KEY (roundname) REFERENCES round(roundname);

--Data

-- nation (nation_id, nation_name)
INSERT INTO nation(nation_id, nation_name) VALUES ('GER', 'Germany');
INSERT INTO nation(nation_id, nation_name) VALUES ('POR', 'Portugal');
INSERT INTO nation(nation_id, nation_name) VALUES ('ENG', 'England');
INSERT INTO nation(nation_id, nation_name) VALUES ('ARG', 'Argentina');
INSERT INTO nation(nation_id, nation_name) VALUES ('FRA', 'France');
INSERT INTO nation(nation_id, nation_name) VALUES ('BRA', 'Brazil');
INSERT INTO nation(nation_id, nation_name) VALUES ('ITA', 'Italia');
INSERT INTO nation(nation_id, nation_name) VALUES ('SPA', 'Spain');
INSERT INTO nation(nation_id, nation_name) VALUES ('NET', 'Netherlands');
INSERT INTO nation(nation_id, nation_name) VALUES ('URG', 'Uruguay');
INSERT INTO nation(nation_id, nation_name) VALUES ('BEL', 'Belgium');
INSERT INTO nation(nation_id, nation_name) VALUES ('NOR', 'Norway');
INSERT INTO nation(nation_id, nation_name) VALUES ('CRO', 'Croatia');
INSERT INTO nation(nation_id, nation_name) VALUES ('VIE', 'VIETNAM');




-- club (club_id, club_name, address)
INSERT INTO club(club_id, club_name, address) VALUES ('MNU', 'Manchester United', 'Manchester, England');
INSERT INTO club(club_id, club_name, address) VALUES ('LIV', 'Liverpool', 'Liverpool, England');
INSERT INTO club(club_id, club_name, address) VALUES ('MNC', 'Manchester City', 'Manchester, England');
INSERT INTO club(club_id, club_name, address) VALUES ('CHE', 'Chelsea', 'London, England');
INSERT INTO club(club_id, club_name, address) VALUES ('ARS', 'Arsenal', 'London, England');
INSERT INTO club(club_id, club_name, address) VALUES ('RMA', 'Real Madrid', 'Madrid, Spain');
INSERT INTO club(club_id, club_name, address) VALUES ('FCB', 'Barcelona', 'Barcelona, Spain');
INSERT INTO club(club_id, club_name, address) VALUES ('PSG', 'Paris Saint German', 'Paris, France');


-- coach (coach_id, coach_name, DOB, role, phone, club_id, nation_id)
INSERT INTO coach(coach_id, coach_name, DOB, role, phone, club_id, nation_id) VALUES ('1001','Erik Ten Hag','1970-02-02','Head Coach','09111970', 'MNU', 'NET');
INSERT INTO coach(coach_id, coach_name, DOB, role, phone, club_id, nation_id) VALUES ('1002','Jack','1980-01-20','Fitness Coach','09111980', 'MNU', 'ENG');
INSERT INTO coach(coach_id, coach_name, DOB, role, phone, club_id, nation_id) VALUES ('1003','Tony','1981-05-18','Tactical Coach','09111981', 'MNU', 'ENG');
INSERT INTO coach(coach_id, coach_name, DOB, role, phone, club_id, nation_id) VALUES ('2001','Jurgen Klopp','1967-06-16','Head Coach','09121967', 'LIV', 'GER');
INSERT INTO coach(coach_id, coach_name, DOB, role, phone, club_id, nation_id) VALUES ('2002','Chris','1972-09-21','Fitness Coach','09121972', 'LIV', 'BRA');
INSERT INTO coach(coach_id, coach_name, DOB, role, phone, club_id, nation_id) VALUES ('2003','Denis','1971-06-10','Tactical Coach','09121971', 'LIV', 'BEL');
INSERT INTO coach(coach_id, coach_name, DOB, role, phone, club_id, nation_id) VALUES ('3001','Pep Guardiola','1971-01-18','Head Coach','09131971', 'MNC', 'SPA');
INSERT INTO coach(coach_id, coach_name, DOB, role, phone, club_id, nation_id) VALUES ('3002','Paul','1961-10-28','Fitness Coach','09131961', 'MNC', 'ITA');
INSERT INTO coach(coach_id, coach_name, DOB, role, phone, club_id, nation_id) VALUES ('3003','Tom','1969-09-16','Tactical Coach','09131969', 'MNC', 'ENG');
INSERT INTO coach(coach_id, coach_name, DOB, role, phone, club_id, nation_id) VALUES ('4001','Thomas Tuchel','1973-08-29','Head Coach','09141973', 'CHE', 'GER');
INSERT INTO coach(coach_id, coach_name, DOB, role, phone, club_id, nation_id) VALUES ('4002','Mason','1975-10-28','Fitness Coach','09141975', 'CHE', 'CRO');
INSERT INTO coach(coach_id, coach_name, DOB, role, phone, club_id, nation_id) VALUES ('4003','Antonio','1974-07-25','Tactical Coach','09141974', 'CHE', 'FRA');
INSERT INTO coach(coach_id, coach_name, DOB, role, phone, club_id, nation_id) VALUES ('5001','Mikel Arteta','1982-03-26','Head Coach','09151982', 'ARS', 'SPA');
INSERT INTO coach(coach_id, coach_name, DOB, role, phone, club_id, nation_id) VALUES ('5002','Jonny','1985-02-20','Fitness Coach','09151985', 'ARS', 'ENG');
INSERT INTO coach(coach_id, coach_name, DOB, role, phone, club_id, nation_id) VALUES ('5003','Mike','1965-01-02','Tactical Coach','09151965', 'ARS', 'SPA');
INSERT INTO coach(coach_id, coach_name, DOB, role, phone, club_id, nation_id) VALUES ('6001','Carlo Ancelotti','1959-06-10','Head Coach','09161959', 'RMA', 'ITA');
INSERT INTO coach(coach_id, coach_name, DOB, role, phone, club_id, nation_id) VALUES ('6002','Hoang','1960-05-12','Fitness Coach','09161960', 'RMA', 'VIE');
INSERT INTO coach(coach_id, coach_name, DOB, role, phone, club_id, nation_id) VALUES ('6003','Quang','1990-03-21','Tactical Coach','09161990', 'RMA', 'VIE');
INSERT INTO coach(coach_id, coach_name, DOB, role, phone, club_id, nation_id) VALUES ('7001','Xavi','1980-01-25','Head Coach','09171980', 'FCB', 'SPA');
INSERT INTO coach(coach_id, coach_name, DOB, role, phone, club_id, nation_id) VALUES ('7002','Cuong','1963-08-07','Fitness Coach','09171963', 'FCB', 'VIE');
INSERT INTO coach(coach_id, coach_name, DOB, role, phone, club_id, nation_id) VALUES ('7003','John','1971-10-14','Tactical Coach','09171971', 'FCB', 'ENG');
INSERT INTO coach(coach_id, coach_name, DOB, role, phone, club_id, nation_id) VALUES ('8001','Mauricio Pochettino','1972-03-02','Head Coach','09181972', 'PSG', 'ARG');
INSERT INTO coach(coach_id, coach_name, DOB, role, phone, club_id, nation_id) VALUES ('8002','Kai','1983-10-14','Fitness Coach','09181983', 'PSG', 'GER');
INSERT INTO coach(coach_id, coach_name, DOB, role, phone, club_id, nation_id) VALUES ('8003','Steve','1979-01-26','Tactical Coach','09181979', 'PSG', 'POR');


-- round (roundname)
INSERT INTO round (roundname) VALUES('Round 1');
INSERT INTO round (roundname) VALUES('Round 2');
INSERT INTO round (roundname) VALUES('Round 3');
INSERT INTO round (roundname) VALUES('Round 4');
INSERT INTO round (roundname) VALUES('Round 5');
INSERT INTO round (roundname) VALUES('Round 6');
INSERT INTO round (roundname) VALUES('Round 7');
INSERT INTO round (roundname) VALUES('Round 8');


-- stadium (stadium_id, stadium_name, capacity, address, club_id)
INSERT INTO stadium(stadium_id, stadium_name, capacity, address, club_id) VALUES ('OTF', 'Old Trafford', '74140', 'Manchester, England', 'MNU');
INSERT INTO stadium(stadium_id, stadium_name, capacity, address, club_id) VALUES ('ANF', 'Anfield', '53394', 'Liverpool, England', 'LIV');
INSERT INTO stadium(stadium_id, stadium_name, capacity, address, club_id) VALUES ('ETI', 'Etihad', '55017', 'Manchester, England', 'MNC');
INSERT INTO stadium(stadium_id, stadium_name, capacity, address, club_id) VALUES ('STB', 'Stamford Bridge', '41837', 'London, England', 'CHE');
INSERT INTO stadium(stadium_id, stadium_name, capacity, address, club_id) VALUES ('EMR', 'Emirates', '60260', 'London, England', 'ARS');
INSERT INTO stadium(stadium_id, stadium_name, capacity, address, club_id) VALUES ('BER', 'Santiago Bernabeu', '81044', 'Madrid, Spain', 'RMA');
INSERT INTO stadium(stadium_id, stadium_name, capacity, address, club_id) VALUES ('CAN', 'Camp Nou', '99354', 'Barcelona, Spain', 'FCB');
INSERT INTO stadium(stadium_id, stadium_name, capacity, address, club_id) VALUES ('PDP', 'Parc de Princes', '47929', 'Paris, France', 'PSG');

-- referee (referee_id, referee_name, role, DOB, nation_id)
INSERT INTO referee(referee_id, referee_name, role, DOB, nation_id) VALUES ('A1', 'Anthony Taylor', 'Main Referee', '1978-10-20', 'ENG');
INSERT INTO referee(referee_id, referee_name, role, DOB, nation_id) VALUES ('B1', 'Pierluigi Collina', 'Main Referee', '1960-02-13', 'ITA');
INSERT INTO referee(referee_id, referee_name, role, DOB, nation_id) VALUES ('C1', 'Micheal Oliver', 'Main Referee', '1985-02-20', 'ENG');
INSERT INTO referee(referee_id, referee_name, role, DOB, nation_id) VALUES ('D1', 'Clement Turpin', 'Main Referee', '1982-05-16', 'FRA');
INSERT INTO referee(referee_id, referee_name, role, DOB, nation_id) VALUES ('E1', 'Antonio Mateu Lahoz', 'Main Referee', '1977-03-12', 'SPA');
INSERT INTO referee(referee_id, referee_name, role, DOB, nation_id) VALUES ('A2', 'Mateo', 'Linesman', '1975-05-14', 'GER');
INSERT INTO referee(referee_id, referee_name, role, DOB, nation_id) VALUES ('B2', 'Chris', 'Linesman', '1981-01-22', 'BEL');
INSERT INTO referee(referee_id, referee_name, role, DOB, nation_id) VALUES ('C2', 'Andreas', 'Linesman', '1980-11-12', 'BRA');
INSERT INTO referee(referee_id, referee_name, role, DOB, nation_id) VALUES ('D2', 'Junior', 'Linesman', '1974-12-21', 'BRA');
INSERT INTO referee(referee_id, referee_name, role, DOB, nation_id) VALUES ('E2', 'Elizabeth', 'Linesman', '1990-07-20', 'ENG');
INSERT INTO referee(referee_id, referee_name, role, DOB, nation_id) VALUES ('F2', 'Kellie', 'Linesman', '1977-03-15', 'SPA');
INSERT INTO referee(referee_id, referee_name, role, DOB, nation_id) VALUES ('G2', 'Strange', 'Linesman', '1980-08-22', 'GER');
INSERT INTO referee(referee_id, referee_name, role, DOB, nation_id) VALUES ('H2', 'Denis', 'Linesman', '1985-04-01', 'BEL');
INSERT INTO referee(referee_id, referee_name, role, DOB, nation_id) VALUES ('I2', 'Harry', 'Linesman', '1981-11-10', 'ENG');
INSERT INTO referee(referee_id, referee_name, role, DOB, nation_id) VALUES ('J2', 'Nicolas', 'Linesman', '1986-12-12', 'ARG');

-- player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id)
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('DA1', 'David De Gea', '1990-11-07', '01', 'Goalkeeper', '0107111990', 'MNU', 'SPA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('D20', 'Diogo Dalot', '1999-03-18', '20', 'Defender', '2018031999', 'MNU', 'POR');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('MA5', 'Harry Maguire', '1993-03-05', '05', 'Defender', '0505031993', 'MNU', 'ENG');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('R19', 'Raphael Varane', '1993-04-25', '19', 'Defender', '1925041993', 'MNU', 'FRA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('S23', 'Luke Shaw', '1995-07-12', '23', 'Defender', '2312071995', 'MNU', 'ENG');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('A29', 'Arron Wan-Bissaka', '1997-11-26', '29', 'Defender', '2926111997', 'MNU', 'ENG');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('B18', 'Bruno Fernandes', '1994-09-08', '18', 'Midfielder', '1808091994', 'MNU', 'POR');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('F21', 'Frankie De Jong', '1997-05-12', '27', 'Midfielder', '2712051997', 'MNU', 'NET');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('F17', 'Fred', '1993-03-05', '17', 'Midfielder', '1705031993', 'MNU', 'BRA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('CR7', 'Cristiano Ronaldo', '1985-02-05', '07', 'Attacker', '0705021985', 'MNU', 'POR');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('S25', 'Jadon Sancho', '2000-03-25', '25', 'Attacker', '2525032000', 'MNU', 'ENG');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('R10', 'Marcus Rashford', '1997-10-31', '10', 'Attacker', '1031101997', 'MNU', 'ENG');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('A01', 'Alisson', '1992-10-02', '01', 'Goalkeeper', '0102101992', 'LIV', 'BRA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('T66', 'Trent Alexander-Arnold', '1998-10-07', '66', 'Defender', '6607101998', 'LIV', 'ENG');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('D04', 'Virgil Van Dijk', '1991-07-08', '04', 'Defender', '0408071991', 'LIV', 'NET');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('K05', 'Ibrahima Konate', '1999-05-25', '05', 'Defender', '0525051999', 'LIV', 'FRA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('R26', 'Andrew Robertson', '1994-03-11', '26', 'Defender', '2611031994', 'LIV', 'ENG');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('T06', 'Thiago', '1991-04-11', '06', 'Midfielder', '0611041991', 'LIV', 'SPA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('F03', 'Fabinho', '1993-10-23', '03', 'Midfielder', '0323101993', 'LIV', 'BRA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('H14', 'Jordan Henderson', '1990-06-17', '14', 'Midfielder', '1417061990', 'LIV', 'ENG');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('M07', 'James Milner', '1986-01-04', '07', 'Midfielder', '0704011986', 'LIV', 'ENG');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('J20', 'Diogo Jota', '1996-12-04', '20', 'Attacker', '2004121996', 'LIV', 'SPA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('F10', 'Roberto Firmino', '1991-10-02', '10', 'Attacker', '1002101991', 'LIV', 'BRA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('N09', 'Darwin Nunez', '1999-06-24', '09', 'Attacker', '0924061999', 'LIV', 'URG');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('E31', 'Ederson', '1993-08-17', '31', 'Goalkeeper', '3117081993', 'MNC', 'BRA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('C27', 'Joao Cancelo', '1994-05-27', '27', 'Defender', '2727051994', 'MNC', 'POR');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('RD3', 'Ruben Dias', '1997-05-14', '03', 'Defender', '0314051997', 'MNC', 'POR');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('JS5', 'John Stones', '1994-05-28', '05', 'Defender', '0528051994', 'MNC', 'ENG');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('KW2', 'Kyle Walker', '1990-05-28', '02', 'Defender', '0228051990', 'MNC', 'ENG');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('B17', 'Kevin De Bruyne', '1991-06-28', '17', 'Midfielder', '1728061991', 'MNC', 'BEL');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('R16', 'Rodri', '1996-06-22', '16', 'Midfielder', '1622061996', 'MNC', 'SPA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('IG8', 'Gundogan', '1990-10-24', '08', 'Midfielder', '0824101990', 'MNC', 'GER');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('S20', 'Bernardo Silva', '1994-08-10', '20', 'Midfielder', '2010081994', 'MNC', 'POR');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('F47', 'Phil Foden', '2000-05-28', '47', 'Attacker', '4728052000', 'MNC', 'ENG');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('RS7', 'Raheem Sterling', '1994-12-08', '07', 'Attacker', '0708121994', 'MNC', 'ENG');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('EH9', 'Erling Haaland', '2000-07-21', '09', 'Attacker', '0921072000', 'MNC', 'NOR');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('KA1', 'Kepa Arrizabalaga', '1994-10-03', '01', 'Goalkeeper', '0103101994', 'CHE', 'SPA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('TS6', 'Thiago Silva', '1984-09-22', '06', 'Defender', '0622091984', 'CHE', 'BRA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('J24', 'Reece James', '1999-12-08', '24', 'Defender', '2408121999', 'CHE', 'ENG');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('C21', 'Ben Chilwell', '1996-12-21', '21', 'Defender', '2121121996', 'CHE', 'ENG');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('AR2', 'Antonio Rudiger', '1993-03-03', '02', 'Defender', '0203031993', 'CHE', 'GER');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('M19', 'Mason Mount', '1999-01-10', '19', 'Midfielder', '1910011999', 'CHE', 'ENG');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('NK7', 'Kante', '1991-03-29', '07', 'Midfielder', '0729031991', 'CHE', 'FRA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('J05', 'Jorginho', '1991-12-20', '05', 'Midfielder', '0520121991', 'CHE', 'ITA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('C12', 'Ruben Loftus-Cheek', '1996-01-23', '12', 'Midfielder', '1223011996', 'CHE', 'ENG');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('W11', 'Timo Werner', '1996-03-06', '11', 'Attacker', '1106031996', 'CHE', 'GER');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('K29', 'Kai Havertz', '1999-06-11', '29', 'Attacker', '2911061999', 'CHE', 'GER');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('RL9', 'Romelu Lukaku', '1993-05-13', '09', 'Attacker', '0913051993', 'CHE', 'BEL');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('R32', 'Aaron Ramsdale', '1998-05-14', '32', 'Goalkeeper', '3214051998', 'ARS', 'ENG');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('BW4', 'Ben White', '1997-10-18', '04', 'Defender', '0418101997', 'ARS', 'ENG');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('GM6', 'Gabriel Magalhaes', '1997-12-19', '06', 'Defender', '0619121997', 'ARS', 'BRA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('T20', 'Nuno Tavares', '2000-01-26', '20', 'Defender', '2026012000', 'ARS', 'POR');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('S17', 'Cedric Soares', '1991-08-31', '17', 'Defender', '1731081991', 'ARS', 'POR');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('MO8', 'Martin Odegaard', '1998-12-17', '08', 'Midfielder', '0817121998', 'ARS', 'NOR');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('L23', 'Lokonga', '1999-10-22', '23', 'Midfielder', '2322101999', 'ARS', 'BEL');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('BS7', 'Bukayo Saka', '2001-09-05', '07', 'Midfielder', '0705092001', 'ARS', 'ENG');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('E10', 'Smith Rowe', '2000-07-28', '10', 'Midfielder', '1028072000', 'ARS', 'ENG');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('J09', 'Gabriel Jesus', '1997-04-03', '09', 'Attacker', '0903041997', 'ARS', 'BRA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('M11', 'Gabriel Martinelli', '2001-06-18', '11', 'Attacker', '1118062001', 'ARS', 'BRA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('P19', 'Nicolas Pepe', '1995-05-29', '19', 'Attacker', '1929051995', 'ARS', 'FRA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('TC1', 'Thibaut Courtois', '1992-05-11', '01', 'Goalkeeper', '0111051992', 'RMA', 'BEL');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('DC2', 'Dani Carvajal', '1992-01-11', '02', 'Defender', '0211011992', 'RMA', 'SPA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('EM3', 'Eder Militao', '1998-01-18', '03', 'Defender', '0318011998', 'RMA', 'BRA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('SR4', 'Sergio Ramos', '1989-03-30', '04', 'Defender', '0430031989', 'RMA', 'SPA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('M23', 'Ferland Mendy', '1995-06-08', '23', 'Defender', '2308061995', 'RMA', 'FRA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('TK8', 'Toni Kroos', '1990-01-04', '08', 'Midfielder', '0804011990', 'RMA', 'GER');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('L10', 'Luka Modric', '1985-09-09', '10', 'Midfielder', '10090919854', 'RMA', 'CRO');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('C14', 'Casemiro', '1992-02-23', '14', 'Midfielder', '1423021992', 'RMA', 'BRA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('KB9', 'Karim Benzema', '1987-12-19', '09', 'Attacker', '0919121987', 'RMA', 'FRA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('V20', 'Vinicius', '2000-07-12', '20', 'Attacker', '2012072000', 'RMA', 'BRA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('H10', 'Eden Hazard', '1991-01-07', '10', 'Attacker', '1007011991', 'RMA', 'BEL');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('A11', 'Marco Asensio', '1996-01-21', '11', 'Attacker', '1121011996', 'RMA', 'SPA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('TS1', 'Marc-Andre Ter Stegen', '1992-04-30', '01', 'Goalkeeper', '0130041992', 'FCB', 'GER');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('DA8', 'Dani Alves', '1983-05-06', '08', 'Defender', '0806051983', 'FCB', 'BRA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('GP3', 'Gerard Pique', '1987-02-02', '03', 'Defender', '0302021987', 'FCB', 'SPA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('RA4', 'Ronald Araujo', '1999-03-07', '04', 'Defender', '0407031999', 'FCB', 'URG');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('G24', 'Eric Garcia', '2001-01-09', '24', 'Defender', '2409012001', 'FCB', 'SPA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('A18', 'Jordi Alba', '1989-03-21', '18', 'Defender', '1821031989', 'FCB', 'SPA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('G30', 'Gavi', '2004-08-05', '30', 'Midfielder', '3005082004', 'FCB', 'SPA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('P16', 'Pedri', '2002-11-25', '16', 'Midfielder', '1625112002', 'FCB', 'SPA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('SB5', 'Sergio Busquets', '1988-07-16', '05', 'Midfielder', '0516071988', 'FCB', 'SPA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('T19', 'Ferran Torres', '2000-02-29', '19', 'Attacker', '19022000', 'FCB', 'SPA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('MD9', 'Memphis Depay', '1994-02-13', '09', 'Attacker', '0913021994', 'FCB', 'NET');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('A10', 'Ansu Fati', '2002-10-31', '10', 'Attacker', '1031102002', 'FCB', 'SPA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('D99', 'Gianluigi Donnarumma', '1999-02-25', '99', 'Goalkeeper', '9925021999', 'PSG', 'ITA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('M05', 'Marquinhos', '1994-05-14', '05', 'Defender', '0514051994', 'PSG', 'BRA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('K03', 'Kimpembe', '1995-08-13', '03', 'Defender', '0313081995', 'PSG', 'FRA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('N25', 'Nuno Mendes', '2002-06-19', '25', 'Defender', '2519062002', 'PSG', 'POR');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('MV6', 'Marco Verratti', '1992-11-05', '06', 'Midfielder', '0605111992', 'PSG', 'ITA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('GW8', 'Georginio Wijnaldum', '1990-11-11', '08', 'Midfielder', '0811111990', 'PSG', 'NET');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('H21', 'Ander Herrera', '1989-08-14', '21', 'Midfielder', '2114081989', 'PSG', 'SPA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('D23', 'Julian Draxler', '1993-09-20', '23', 'Midfielder', '2320091993', 'PSG', 'GER');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('M30', 'Lionel Messi', '1987-06-24', '30', 'Attacker', '3024061987', 'PSG', 'ARG');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('N10', 'Neymar', '1992-02-05', '10', 'Attacker', '1005021992', 'PSG', 'BRA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('KM7', 'Kylian Mbappe', '1998-12-20', '07', 'Attacker', '0720121998', 'PSG', 'FRA');
INSERT INTO player (player_id, player_name, DOB, shirt_number, role, phone, club_id, nation_id) VALUES ('I18', 'Mauro Icardi', '1993-02-19', '18', 'Attacker', '1819021993', 'PSG', 'ARG');

-----insert match---------
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('11', '2022-06-01', 'Round 1', 'EMR', '1', '0', '2', '3', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('12', '2022-06-04', 'Round 1', 'EMR', '2', '3', '1', '3', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('13', '2022-06-07', 'Round 1', 'EMR', '3', '3', '1', '1', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('14', '2022-06-10', 'Round 1', 'EMR', '2', '0', '0', '1', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('15', '2022-06-13', 'Round 1', 'EMR', '1', '0', '1', '0', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('16', '2022-06-16', 'Round 1', 'EMR', '2', '1', '2', '2', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('17', '2022-06-19', 'Round 1', 'EMR', '1', '1', '2', '1', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('21', '2022-06-22', 'Round 2', 'STB', '2', '0', '0', '3', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('22', '2022-06-25', 'Round 2', 'STB', '2', '1', '1', '1', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('23', '2022-06-28', 'Round 2', 'STB', '1', '0', '2', '1', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('24', '2022-07-01', 'Round 2', 'STB', '1', '1', '2', '3', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('25', '2022-07-04', 'Round 2', 'STB', '2', '2', '3', '3', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('26', '2022-07-07', 'Round 2', 'STB', '2', '3', '1', '1', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('27', '2022-07-10', 'Round 2', 'STB', '0', '0', '3', '1', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('31', '2022-07-13', 'Round 3', 'CAN', '2', '1', '1', '1', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('32', '2022-07-16', 'Round 3', 'CAN', '2', '3', '2', '3', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('33', '2022-07-15', 'Round 3', 'CAN', '0', '0', '2', '1', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('34', '2022-07-19', 'Round 3', 'CAN', '1', '1', '2', '1', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('35', '2022-07-22', 'Round 3', 'CAN', '1', '1', '2', '2', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('36', '2022-07-25', 'Round 3', 'CAN', '1', '2', '1', '1', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('37', '2022-07-28', 'Round 3', 'CAN', '2', '1', '1', '1', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('41', '2022-07-31', 'Round 4', 'ANF', '1', '1', '1', '1', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('42', '2022-06-02', 'Round 4', 'ANF', '2', '1', '2', '2', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('43', '2022-06-05', 'Round 4', 'ANF', '3', '3', '1', '2', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('44', '2022-06-08', 'Round 4', 'ANF', '1', '0', '1', '3', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('45', '2022-06-11', 'Round 4', 'ANF', '0', '0', '2', '1', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('46', '2022-06-14', 'Round 4', 'ANF', '2', '1', '3', '4', '0', '0');
INSERT INTO matches(match_id, time, roundname, stadium_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2) VALUES ('47', '2022-06-17', 'Round 4', 'ANF', '0', '1', '3', '3', '0', '0');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('51', '3', '0', '2', '3', '0', '0', 'ETI', '2022-06-20', 'Round 5');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('52', '1', '1', '1', '1', '0', '0', 'ETI', '2022-06-23', 'Round 5');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('53', '0', '1', '0', '1', '0', '0', 'ETI', '2022-06-26', 'Round 5');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('54', '2', '2', '3', '5', '0', '1', 'ETI', '2022-06-29', 'Round 5');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('55', '4', '0', '0', '4', '0', '0', 'ETI', '2022-07-02', 'Round 5');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('56', '2', '1', '3', '1', '0', '0', 'ETI', '2022-07-05', 'Round 5');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('57', '5', '0', '0', '1', '0', '0', 'ETI', '2022-07-08', 'Round 5');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('61', '1', '2', '3', '1', '0', '0', 'OTF', '2022-07-11', 'Round 6');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('62', '0', '1', '0', '0', '0', '0', 'OTF', '2022-07-14', 'Round 6');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('63', '0', '3', '2', '1', '0', '0', 'OTF', '2022-07-17', 'Round 6');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('64', '0', '5', '4', '1', '0', '0', 'OTF', '2022-07-20', 'Round 6');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('65', '0', '3', '0', '2', '0', '0', 'OTF', '2022-07-23', 'Round 6');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('66', '1', '3', '4', '5', '0', '0', 'OTF', '2022-07-26', 'Round 6');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('67', '2', '0', '3', '1', '0', '0', 'OTF', '2022-07-29', 'Round 6');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('71', '2', '1', '2', '2', '1', '0', 'PDP', '2022-06-03', 'Round 7');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('72', '0', '0', '1', '1', '0', '0', 'PDP', '2022-06-06', 'Round 7');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('73', '1', '3', '0', '0', '0', '0', 'PDP', '2022-06-09', 'Round 7');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('74', '0', '2', '3', '1', '0', '0', 'PDP', '2022-06-12', 'Round 7');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('75', '0', '3', '3', '2', '0', '0', 'PDP', '2022-06-15', 'Round 7');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('76', '2', '1', '0', '2', '0', '0', 'PDP', '2022-06-18', 'Round 7');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('77', '3', '0', '1', '3', '0', '1', 'PDP', '2022-06-21', 'Round 7');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('81', '1', '1', '2', '3', '0', '0', 'BER', '2022-06-24', 'Round 8');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('82', '1', '2', '0', '1', '0', '0', 'BER', '2022-06-27', 'Round 8');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('83', '0', '4', '3', '1', '0', '0', 'BER', '2022-06-30', 'Round 8');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('84', '0', '3', '0', '1', '0', '0', 'BER', '2022-07-03', 'Round 8');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('85', '1', '4', '2', '0', '0', '0', 'BER', '2022-07-06', 'Round 8');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('86', '2', '1', '2', '1', '1', '0', 'BER', '2022-07-09', 'Round 8');
INSERT INTO matches(match_id, goal_1, goal_2, yellow_card1, yellow_card2, red_card1, red_card2, stadium_id, time, roundname) VALUES ('87', '3', '1', '2', '3', '0', '0', 'BER', '2022-07-12', 'Round 8');

-- thu tu cac doi bong: ars, che, fcb, liv, mnc, mnu, psg, rma. INSERT participation--
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('11', 'ARS', 'CHE');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('12', 'ARS', 'FCB');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('13', 'ARS', 'LIV');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('14', 'ARS', 'MNC');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('15', 'ARS', 'MNU');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('16', 'ARS', 'PSG');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('17', 'ARS', 'RMA');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('21', 'CHE', 'ARS');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('22', 'CHE', 'FCB');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('23', 'CHE', 'LIV');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('24', 'CHE', 'MNC');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('25', 'CHE', 'MNU');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('26', 'CHE', 'PSG');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('27', 'CHE', 'RMA');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('31', 'FCB', 'ARS');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('32', 'FCB', 'CHE');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('33', 'FCB', 'LIV');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('34', 'FCB', 'MNC');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('35', 'FCB', 'MNU');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('36', 'FCB', 'PSG');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('37', 'FCB', 'RMA');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('41', 'LIV', 'ARS');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('42', 'LIV', 'CHE');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('43', 'LIV', 'FCB');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('44', 'LIV', 'MNC');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('45', 'LIV', 'MNU');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('46', 'LIV', 'PSG');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('47', 'LIV', 'RMA');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('51', 'MNC', 'ARS');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('52', 'MNC', 'CHE');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('53', 'MNC', 'FCB');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('54', 'MNC', 'LIV');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('55', 'MNC', 'MNU');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('56', 'MNC', 'PSG');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('57', 'MNC', 'RMA');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('61', 'MNU', 'ARS');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('62', 'MNU', 'CHE');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('63', 'MNU', 'FCB');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('64', 'MNU', 'LIV');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('65', 'MNU', 'MNC');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('66', 'MNU', 'PSG');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('67', 'MNU', 'RMA');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('71', 'PSG', 'ARS');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('72', 'PSG', 'CHE');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('73', 'PSG', 'FCB');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('74', 'PSG', 'LIV');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('75', 'PSG', 'MNC');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('76', 'PSG', 'MNU');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('77', 'PSG', 'RMA');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('81', 'RMA', 'ARS');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('82', 'RMA', 'CHE');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('83', 'RMA', 'FCB');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('84', 'RMA', 'LIV');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('85', 'RMA', 'MNC');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('86', 'RMA', 'MNU');
INSERT INTO participation(match_id, club_id1, club_id2) VALUES ('87', 'RMA', 'PSG');

--insert control--
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('11', 'A1', 'A2', 'F2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('12', 'B1', 'B2', 'G2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('13', 'C1', 'C2', 'H2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('14', 'D1', 'D2', 'I2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('15', 'E1', 'E2', 'J2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('16', 'A1', 'A2', 'F2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('17', 'B1', 'B2', 'G2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('21', 'C1', 'C2', 'H2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('22', 'D1', 'D2', 'I2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('23', 'E1', 'E2', 'J2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('24', 'A1', 'A2', 'F2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('25', 'B1', 'B2', 'G2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('26', 'C1', 'C2', 'H2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('27', 'D1', 'D2', 'I2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('31', 'E1', 'E2', 'J2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('32', 'A1', 'A2', 'F2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('33', 'B1', 'B2', 'G2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('34', 'C1', 'C2', 'H2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('35', 'D1', 'D2', 'I2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('36', 'E1', 'E2', 'J2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('37', 'A1', 'A2', 'F2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('41', 'B1', 'B2', 'G2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('42', 'C1', 'C2', 'H2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('43', 'D1', 'D2', 'I2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('44', 'E1', 'E2', 'J2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('45', 'A1', 'A2', 'F2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('46', 'B1', 'B2', 'G2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('47', 'C1', 'C2', 'H2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('51', 'D1', 'D2', 'I2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('52', 'E1', 'E2', 'J2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('53', 'A1', 'A2', 'F2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('54', 'B1', 'B2', 'G2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('55', 'C1', 'C2', 'H2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('56', 'D1', 'D2', 'I2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('57', 'E1', 'E2', 'J2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('61', 'A1', 'A2', 'F2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('62', 'B1', 'B2', 'G2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('63', 'C1', 'C2', 'H2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('64', 'D1', 'D2', 'I2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('65', 'E1', 'E2', 'J2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('66', 'A1', 'A2', 'F2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('67', 'B1', 'B2', 'G2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('71', 'C1', 'C2', 'H2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('72', 'D1', 'D2', 'I2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('73', 'E1', 'E2', 'J2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('74', 'A1', 'A2', 'F2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('75', 'B1', 'B2', 'G2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('76', 'C1', 'C2', 'H2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('77', 'D1', 'D2', 'I2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('81', 'E1', 'E2', 'J2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('82', 'A1', 'A2', 'F2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('83', 'B1', 'B2', 'G2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('84', 'C1', 'C2', 'H2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('85', 'D1', 'D2', 'I2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('86', 'E1', 'E2', 'J2', 'Main Referee', 'Linesman', 'Linesman');
INSERT INTO controls(match_id, referee_id1, referee_id2, referee_id3, role1, role2, role3) VALUES ('87', 'A1', 'A2', 'F2', 'Main Referee', 'Linesman', 'Linesman');

--insert finaltable--
INSERT INTO finaltable(roundname, club_id, match_played, win, lose, draw, yellow_card, red_card, goal_difference, point) VALUES ('Round 8', 'FCB', '14', '7', '3', '4', '21', '0', '9', '25');
INSERT INTO finaltable(roundname, club_id, match_played, win, lose, draw, yellow_card, red_card, goal_difference, point) VALUES ('Round 8', 'PSG', '14', '6', '7', '1', '27', '1', '-3', '19');
INSERT INTO finaltable(roundname, club_id, match_played, win, lose, draw, yellow_card, red_card, goal_difference, point) VALUES ('Round 8', 'ARS', '14', '5', '5', '4', '23', '0', '-6', '19');
INSERT INTO finaltable(roundname, club_id, match_played, win, lose, draw, yellow_card, red_card, goal_difference, point) VALUES ('Round 8', 'CHE', '14', '6', '3', '5', '23', '0', '3', '23');
INSERT INTO finaltable(roundname, club_id, match_played, win, lose, draw, yellow_card, red_card, goal_difference, point) VALUES ('Round 8', 'MNU', '14', '1', '10', '3', '29', '0', '-20', '6');
INSERT INTO finaltable(roundname, club_id, match_played, win, lose, draw, yellow_card, red_card, goal_difference, point) VALUES ('Round 8', 'RMA', '14', '3', '8', '3', '22', '2', '-18', '12');
INSERT INTO finaltable(roundname, club_id, match_played, win, lose, draw, yellow_card, red_card, goal_difference, point) VALUES ('Round 8', 'LIV', '14', '6', '2', '6', '21', '0', '13', '24');
INSERT INTO finaltable(roundname, club_id, match_played, win, lose, draw, yellow_card, red_card, goal_difference, point) VALUES ('Round 8', 'MNC', '14', '7', '3', '4', '21', '0', '18', '25');