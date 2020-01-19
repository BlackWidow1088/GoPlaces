/*
-- constant across all releases
CREATE TABLE usr (
	email VARCHAR(100) PRIMARY KEY,
	name VARCHAR(50),
	role VARCHAR(50), -- role='admin', 'emp'
	password VARCHAR(50)
);

CREATE TABLE domain_def (
	abr VARCHAR(10) PRIMARY KEY,
	name VARCHAR(50)
);

-- different tables for different releases
CREATE TABLE GA2_3_0_Encoding (
	encoding VARCHAR(100) PRIMARY KEY
);

CREATE TABLE GA2_3_0_TC (
	tc_id SERIAL PRIMARY KEY,
	encoding VARCHAR(100) REFERENCES GA2_3_0_Encoding(encoding) ON UPDATE CASCADE,
	setup VARCHAR(50) NOT NULL, --'common', 'boston', 'nynj', -- setup on which the test case is implemented for
	tc_name VARCHAR(100) NOT NULL,
	category VARCHAR(100),
	description VARCHAR(500),
	expected_behavior VARCHAR(500),
	detailed VARCHAR(500),
	
	auto_tc_name VARCHAR(100),
	type VARCHAR(50), -- 'sanity', 'daily', 'weekly'
	bugno VARCHAR(50),
	priority INTEGER, -- 1,2,3
	email VARCHAR(50) REFERENCES usr(email) ON DELETE RESTRICT ON UPDATE CASCADE --owner of the test case
);

CREATE TABLE GA2_3_0_TC_RUN (
	id SERIAL PRIMARY KEY,
	tc_id INTEGER REFERENCES GA2_3_0_TC(tc_id) ON DELETE CASCADE ON UPDATE CASCADE,
	setup VARCHAR(50) NOT NULL, --'boston', 'nynj', 'common' -- setup on which the test case is carried out,
	datetime ,
	result VARCHAR(20),
	buildno VARCHAR(50),
	email VARCHAR(50) REFERENCES usr(email) ON DELETE RESTRICT ON UPDATE CASCADE --user responsible for the event 
);

CREATE TABLE GA2_3_0_TC_STATE (
	tc_id INTEGER REFERENCES GA2_3_0_TC(tc_id) ON DELETE CASCADE ON UPDATE CASCADE,
	setup VARCHAR(50) NOT NULL, --'boston', 'nynj', 'common' -- setup on which the test case is carried out,
	datetime timestamptz, --latest timestamp for activity on the the test case
	result VARCHAR(20),
	buildno VARCHAR(50),
	email VARCHAR(50) REFERENCES usr(email) ON DELETE RESTRICT ON UPDATE CASCADE, --user responsible for the eve
	PRIMARY KEY (tc_id, setup)
);
*/
/*
INSERT INTO ga2_3_0_encoding VALUES('STR_REM_SS');
INSERT INTO ga2_3_0_encoding VALUES('STR_REM_SL');
INSERT INTO ga2_3_0_encoding VALUES('STR_REM_NS');
INSERT INTO ga2_3_0_encoding VALUES('STR_REM_SIM');

INSERT INTO domain_def VALUES('SL', 'Stress & Limit');
INSERT INTO domain_def VALUES('NS', 'Negative Scenarios');
INSERT INTO domain_def VALUES('SIM', 'Simulation');

INSERT INTO usr values('jenkins@diamanti.com', 'Jenkins', 'emp', 'a')
INSERT INTO usr values('achavan@diamanti.com', 'Abhijeet', 'emp', 'a')
INSERT INTO usr values('bchavan@diamanti.com', 'Bbhijeet', 'emp', 'a')
INSERT INTO usr values('deepak@diamanti.com', 'Deepak', 'admin', 'a')

INSERT INTO ga2_3_0_tc
(encoding, setup, tc_name, category, description, expected_behavior, detailed, auto_tc_name, type, bugno, email) 
VALUES
('STR_REM_SS', 'boston', 'RS_Basic-1.1', 'Remote Volume Basic', 'node 1 and attach', '', '', 'RemoteStorage.Basic', 'Sanity', 'bugno1', 'achavan@diamanti.com' );

INSERT INTO ga2_3_0_tc
(encoding, setup, tc_name, category, description, expected_behavior, detailed, auto_tc_name, type, bugno, email) 
VALUES
('STR_REM_SS', 'boston', 'RS_Verify-1.0', 'Remote Storage IO Verification', 'IO with various...', '', '', 'RemoteStorage.Basic', 'Sanity', 'bugno1', 'achavan@diamanti.com' );

INSERT INTO ga2_3_0_tc
(encoding, setup, tc_name, category, description, expected_behavior, detailed, auto_tc_name, type, bugno, email) 
VALUES
('STR_REM_SS', 'boston', 'RS_Verify-1.2', 'Remote Storage IO Verification', 'node 1 and attach', '', '', 'AndNon4KIOs', 'Sanity', 'bugno1', 'achavan@diamanti.com' );

INSERT INTO ga2_3_0_tc
(encoding, setup, tc_name, category, description, expected_behavior, detailed, auto_tc_name, type, bugno, email) 
VALUES
('STR_REM_SL', 'boston', 'RS_Stress-1.0', 'Config Stress', '32 remote volumes', '', '', 'RemoteStorage.ConfigStress', 'Daily', 'bugno2', 'achavan@diamanti.com' );

INSERT INTO ga2_3_0_tc
(encoding, setup, tc_name, category, description, expected_behavior, detailed, auto_tc_name, type, bugno, email) 
VALUES
('STR_REM_SL', 'boston', 'RS_Stress-1.1', 'Limit Testing', '8 remote volumes ...', '', '', 'RemoteStorage.Basic', 'Weekly', 'bugno1', 'achavan@diamanti.com' );

INSERT INTO ga2_3_0_tc
(encoding, setup, tc_name, category, description, expected_behavior, detailed, auto_tc_name, type, bugno, email) 
VALUES
('STR_REM_SL', 'boston', 'RS_Stress-1.2', 'Limit Testing', '8 remote volumes ...', '', '', 'RemoteStorage.Basic', 'Sanity', 'bugno1', 'achavan@diamanti.com');

INSERT INTO ga2_3_0_tc
(encoding, setup, tc_name, category, description, expected_behavior, detailed, auto_tc_name, type, bugno, email) 
VALUES
('STR_REM_NS', 'boston', 'RS_Negative-1.0', 'Remote Volume Negative Tests', 'Delete volume ...', '', '', 'RemoteVolume.NegativeTests', 'Daily', 'bugno3', 'bchavan@diamanti.com');
-- select * from ga2_3_0_tc

INSERT INTO ga2_3_0_tc_state
(tc_id, setup, datetime, result, buildno, email) 
VALUES
(2, 'boston', now(), 'Pass', '2.3.0-48', 'achavan@diamanti.com' );

INSERT INTO ga2_3_0_tc_state
(tc_id, setup, datetime, result, buildno, email) 
VALUES
(3, 'boston', now(), 'Pass', '2.3.0-48', 'achavan@diamanti.com' );

INSERT INTO ga2_3_0_tc_state
(tc_id, setup, datetime, result, buildno, email) 
VALUES
(4, 'boston', now(), 'Pass', '2.3.0-48', 'achavan@diamanti.com' );

INSERT INTO ga2_3_0_tc_state
(tc_id, setup, datetime, result, buildno, email) 
VALUES
(5, 'boston', now(), 'Pass', '2.3.0-14', 'achavan@diamanti.com' );

INSERT INTO ga2_3_0_tc_state
(tc_id, setup, datetime, result, buildno, email) 
VALUES
(6, 'boston', now(), 'Pass', '2.3.0-48', 'achavan@diamanti.com' );

INSERT INTO ga2_3_0_tc_state
(tc_id, setup, datetime, result, buildno, email) 
VALUES
(7, 'boston', now(), 'Pass', '2.3.0-48', 'achavan@diamanti.com' );

INSERT INTO ga2_3_0_tc_state
(tc_id, setup, datetime, result, buildno, email) 
VALUES
(8, 'boston', now(), 'Pass', '9.9.1-161', 'achavan@diamanti.com' );


INSERT INTO ga2_3_0_tc_run
(tc_id, setup, datetime, result, buildno, email) 
VALUES
(2, 'boston', timestamp with time zone '2019-11-25 01:05:00 +05:30', 'Fail', '2.3.0-47', 'achavan@diamanti.com' );
*/


-- a) latest status of all test cases
SELECT
a.tc_id test_case_id, a.priority priority, a.encoding domain_definition, a.setup test_designed_for, b.setup test_carried_on, a.tc_name test_name, a.auto_tc_name auto_test_name,
b.buildno build_no, b.result result, a.email test_owner, b.email latest_activity_by
FROM ga2_3_0_tc a
LEFT JOIN ga2_3_0_tc_state b ON a.tc_id = b.tc_id;










