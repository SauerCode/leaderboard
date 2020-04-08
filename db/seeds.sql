

INSERT INTO athletes (id, name, gender)
VALUES (40, 'Ayana',  'F'),
	   (50, 'Hayden', 'M'),
	   (60, 'Jayla',  'F'),
	   (70, 'August', 'M'),
	   (80, 'Andrew', 'M'),
	   (90, 'Martin', 'M'),
	   (91, 'Kaleb',  'M'),
	   (92, 'Nancy',  'F'),
	   (93, 'Sammy',  'M');


INSERT INTO athletes (id,name,gender,email,birthdate)
VALUES (220, 'Labante','F','to@yahoo.com','1990-09-20'),
	   (221, 'Laurie', 'F', 'laure@yahoo.com','1999-08-22'),
	   (233, 'Amande',  'F', 'ama@gmail.com','1992-08-12'),
	   (390, 'Gunter', 'M',  'gunter@gmail.com','2001-08-12'),
	   (400, 'Saucer', 'M', 'su@gmail.com','2001-01-14'),
	   (112, 'Sarah', 'F', 'sarah@gmail.com','2001-02-24'),
	   (912, 'Cuomo',  'M', 'cuomo@gmail.com','1978-02-26');


INSERT INTO partners (id, company_name)
VALUES (1, 'Crossfit');


INSERT INTO competitions (id, partner_id, name, venue, start_date, end_date, max_num_reg, num_of_events)
VALUES (10, 1, 'The Open', 'CrossFit NCR', '2020-05-20', '2020-09-20', 200, 10),
	   (11, 1, 'US National', 'ATT center', '2021-09-20', '2021-11-29', 300, 6),
	   (12, 1, 'Athletic', 'Rogers center', '2020-06-12', '2020-07-12', 400, 3);



INSERT INTO simple_events (id, competition_id, name, main_score_mode, main_score_direction, tiebreak_score_mode, tiebreak_score_direction)
VALUES (20, 10, '20.1', 'TIME', 'ASC', 'TIME', 'ASC'),
	   (21, 10, '20.2', 'COUNT', 'DESC', 'N/A', 'N/A'),
	   (22, 10, '20.3', 'COUNT', 'ASC', 'N/A', 'N/A'),
	   (25, 11, '13.1', 'COUNT', 'ASC', 'N/A', 'N/A'),
	   (26, 12, '14.1', 'TIME', 'DESC', 'N/A', 'N/A');



INSERT INTO extended_events (id, competition_id, name, time_cap, main_tiebreak_score_mode, main_tiebreak_score_direction, secondary_score_mode, secondary_score_direction, secondary_tiebreak_score_mode, secondary_tiebreak_score_direction)
VALUES (30, 10, '20.4', '00:20:00', 'TIME', 'ASC', 'COUNT', 'DESC', 'TIME', 'ASC'),
	   (31, 10, '20.5', '00:10:00', 'TIME', 'DESC', 'COUNT', 'ASC', 'TIME', 'ASC');




INSERT INTO registrations (athlete_id,competition_id)
VALUES (40, 10),
	   (50, 10),
	   (60, 10),
	   (70, 10),
	   (80, 10),
	   (90, 10),
	   (91, 10),
	   (92, 10),
	   (93, 10),
       (220, 10),
	   (221, 10),
	   (233, 10),
	   (390, 10),
	   (400, 10),
	   (112, 10),
	   (912, 10),
	   (40, 11),
	   (50, 11),
	   (60, 11),
	   (70, 11),
	   (80, 11),
	   (90, 11),
	   (91, 11),
	   (92, 11),
	   (93, 11),
       (220, 11),
	   (221, 11),
	   (233, 11),
	   (390, 11),
	   (400, 11),
	   (112, 11),
	   (912, 11),
       (220, 12),
	   (221, 12),
	   (233, 12),
	   (390, 12),
	   (400, 12),
	   (112, 12),
	   (912, 12);



INSERT INTO simple_scores (athlete_id, event_id, main_count)
VALUES (40, 21, 80),
	   (50, 21, 72),
	   (60, 21, 72),
	   (70, 21, 58),
	   (80, 21, 25),
	   (90, 21, 180),
	   (91, 21, 272),
	   (390, 21, 12),
	   (400, 21, 44);



INSERT INTO simple_scores (athlete_id, event_id, main_time, tiebreak_time)
VALUES (40, 25, '00:02:45','00:01:59'),
	   (50, 25, '00:03:01','00:02:30'),
	   (70, 25, '00:03:02','00:02:20'),
	   (60, 25, '00:04:00','00:03:30'),
	   (80, 25, '00:04:00','00:03:31'),
       (400, 25, '00:02:45','00:01:59'),
	   (233, 25, '00:05:01','00:02:30'),
	   (91, 25, '00:03:02','00:02:22'),
	   (220, 25, '00:04:01','00:03:32'),
	   (90, 25, '00:04:30','00:03:31');



INSERT INTO extended_scores (athlete_id, event_id, main_time, main_tiebreak_time, secondary_count, secondary_tiebreak_time)
VALUES (40, 30, '00:18:59', '00:13:15', 240, '00:13:15'),
	   (50, 30, '00:18:59', '00:13:45', 240, '00:13:45'),
	   (60, 30, '00:20:00', '00:11:00', 201, '00:11:00'),
	   (70, 30, '00:20:00', '00:09:15', 200, '00:09:15'),
	   (80, 30, '00:20:00', '00:11:12', 200, '00:11:12'),
	   (93, 30, '00:18:59', '00:13:15', 200, '00:13:15'),
	   (90, 30, '00:16:59', '00:10:15', 200, '00:10:15'),
	   (112, 30, '00:20:00', '00:11:00', 201, '00:11:00'),
	   (233, 30, '00:20:00', '00:09:16', 199, '00:09:15'),
	   (912, 30, '00:20:00', '00:11:12', 200, '00:11:12'),
	   (220, 30, '00:18:59', '00:13:15', 200, '00:13:15'),
	   (91, 30, '00:16:59', '00:10:15', 200, '00:10:15');




