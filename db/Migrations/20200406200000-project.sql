
CREATE TABLE contacts ( 

	id           INTEGER,
	phone_number VARCHAR(30),
	email 		 VARCHAR(255),
	name         VARCHAR(255),

	UNIQUE(email),
	PRIMARY KEY (id)
);

CREATE TABLE partners ( 

	id 				  INTEGER,
	contact_person_id INTEGER,
	company_name 	  VARCHAR(255),
	address 		  VARCHAR(1000),

	FOREIGN KEY (contact_person_id) REFERENCES contacts(id) ON DELETE SET NULL, 
	PRIMARY KEY (id)
);

CREATE TABLE athletes (

	id 			INTEGER,
	name 		VARCHAR(255),
	email 		VARCHAR(255),
	gender 		VARCHAR(255) check (gender in ('F','M')),
	birthdate   DATE,

	UNIQUE(email),
	PRIMARY KEY (id)
);


CREATE TABLE competitions ( 

	id 					INTEGER,
	partner_id 			INTEGER NOT NULL,
	contact_person_id   INTEGER,
	name 				VARCHAR(255),
	venue 				VARCHAR(255),
	start_date 			DATE,
	end_date 			DATE,
	max_num_reg 		INTEGER,
	num_of_events 		INTEGER, 
	 
	FOREIGN KEY (partner_id) REFERENCES partners(id) ON DELETE CASCADE, 
	FOREIGN KEY (contact_person_id) REFERENCES contacts(id) ON DELETE SET NULL, 
	PRIMARY KEY (id)
);

CREATE TABLE registrations ( 

	athlete_id     INTEGER,
	competition_id INTEGER,

	PRIMARY KEY (athlete_id, competition_id),
	FOREIGN KEY (athlete_id) REFERENCES athletes(id) ON DELETE CASCADE,
	FOREIGN KEY (competition_id) REFERENCES competitions(id) ON DELETE CASCADE
);


CREATE TABLE simple_events (

	id             INTEGER,
	competition_id INTEGER,
	name           VARCHAR(255),

	main_score_mode          VARCHAR(255) NOT NULL check (main_score_mode in ('TIME','COUNT')),
	main_score_direction     VARCHAR(255) NOT NULL check (main_score_direction in ('ASC','DESC')),
	
	tiebreak_score_mode      VARCHAR(255) NOT NULL check (tiebreak_score_mode in ('TIME','COUNT','N/A')),
	tiebreak_score_direction VARCHAR(255) NOT NULL check (tiebreak_score_direction in ('ASC','DESC','N/A')),
	
	FOREIGN KEY (competition_id) REFERENCES competitions(id) ON DELETE CASCADE,
	PRIMARY KEY (id)
);


CREATE TABLE extended_events (

	id             INTEGER,
	competition_id INTEGER,
	name           VARCHAR(255),
    
    -- MAIN SCORE IS BY DEFAULT : TIME -- ASC
    -- TIME CAP MUST BE PROVIDED
    
    time_cap TIME NOT NULL,
	
	main_tiebreak_score_mode           VARCHAR(255) NOT NULL check (main_tiebreak_score_mode in ('TIME','COUNT','N/A')),
	main_tiebreak_score_direction 	   VARCHAR(255) NOT NULL check (main_tiebreak_score_direction in ('ASC','DESC','N/A')),

	secondary_score_mode 			   VARCHAR(255) NOT NULL check (secondary_score_mode in ('TIME','COUNT')),
	secondary_score_direction 		   VARCHAR(255) NOT NULL check (secondary_score_direction in ('ASC','DESC')),

	secondary_tiebreak_score_mode 	   VARCHAR(255) NOT NULL check (secondary_tiebreak_score_mode in ('TIME','COUNT','N/A')),
	secondary_tiebreak_score_direction VARCHAR(255) NOT NULL check (secondary_tiebreak_score_direction in ('ASC','DESC','N/A')),	
	
	FOREIGN KEY (competition_id) REFERENCES competitions(id) ON DELETE CASCADE,
	PRIMARY KEY (id)
);


CREATE TABLE simple_scores (

	athlete_id     INTEGER,
	event_id       INTEGER,

	main_time      TIME,
	main_count     INTEGER,
	
	tiebreak_time  TIME,
	tiebreak_count INTEGER,

	PRIMARY KEY (athlete_id, event_id),
	FOREIGN KEY (event_id) REFERENCES simple_events(id) ON DELETE CASCADE,
	FOREIGN KEY (athlete_id) REFERENCES athletes(id) ON DELETE CASCADE,

	CONSTRAINT positive_count CHECK (main_count >= 0 AND tiebreak_count >=0)
);

CREATE TABLE extended_scores (

	athlete_id 				 INTEGER,
	event_id 				 INTEGER,

	main_time 				 TIME,
	main_tiebreak_time 		 TIME,
	main_tiebreak_count 	 INTEGER,
	
	secondary_time 			 TIME, 
	secondary_count 		 INTEGER,
	secondary_tiebreak_time  TIME,
	secondary_tiebreak_count INTEGER,

	PRIMARY KEY (athlete_id, event_id),
	FOREIGN KEY (event_id) REFERENCES extended_events(id) ON DELETE CASCADE,
	FOREIGN KEY (athlete_id) REFERENCES athletes(id) ON DELETE CASCADE,

	CONSTRAINT positive_count CHECK (main_tiebreak_count >=0 AND secondary_count >= 0 AND secondary_tiebreak_count >=0)
		   
);


CREATE VIEW all_competitions as
SELECT id, name, venue
FROM   competitions;



CREATE VIEW male_athletes as
SELECT id, name
FROM   athletes
WHERE  athletes.gender = 'M';
















