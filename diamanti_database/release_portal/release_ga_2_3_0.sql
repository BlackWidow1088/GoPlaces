/*
-- Database: release_ga_2_3_0

-- DROP DATABASE "release_ga_2_3_0";

CREATE DATABASE "release_ga_2_3_0"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_IN'
    LC_CTYPE = 'en_IN'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
*/

CREATE OR REPLACE FUNCTION comment_on(p_type text, p_object text, p_comment text)
RETURNS text AS $$
DECLARE
  l_sql     text;
  l_comment text;
BEGIN
  l_comment := REPLACE(p_comment, '${created}', 'created at '||to_char(current_date, 'yyyy-mm-dd'));
  l_sql := 'comment on '||p_type||' '||p_object||' is '||quote_literal(l_comment);
  EXECUTE l_sql;
  RETURN l_comment;
END; $$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION show_comments(p_type text)
RETURNS text AS $$
BEGIN
RETURN (SELECT description FROM pg_shdescription
JOIN pg_database ON objoid=pg_database.oid
WHERE datname=p_type);
END; $$
LANGUAGE plpgsql;

-- ADDED DESCRIPTION
SELECT comment_on('database', CAST((SELECT current_database()) as text), 
				  '${created}: Consists of particular release database related to Qualititative Analysis Aspects');

-- SCHEMAS
CREATE SCHEMA master;
CREATE SCHEMA TC; -- test cases

-- TABLES

-- ONLY db admin can update master schema.
-- ONLY db admin can ADD, DELETE OR UPDATE fields in this schema
-- ONLY WHEN system is kept blocked from taking requests

-- for microservice archi: <sg:QA>.<db:master>.<schema:master>.<table:domain_hierarychy>
CREATE TABLE master.domain_hierarchy(
	leaf_node VARCHAR(200) PRIMARY KEY 
	-- leaf nodes composes of <db:master>.<schema:master>.<table:domain_definition>.<field: abbr>
	-- seperated by '_'
	-- for eg: available leaf nodes are: 
	-- storage->remote->standard_scenario and storage->snapshot->standard_scenario
	-- leaf nodes: STR_REM_STDSCE and STR_SNP_STDSCE
	-- purpose: this will be used by middle-ware or front end to know the hierarchy 
	-- 			specific for the release.
);


-- EXTRA can be removed
-- test runnner types: sanity_auto_runner, manual_runner.
-- manual means the test case is currently manually tested.
-- the user will tell the id in case manual from UI.
CREATE TABLE TC.test_runner(
	id VARCHAR(100) PRIMARY KEY,
	tag VARCHAR(50), -- for sanity_test_runner: 'daily', 'weekly', 'sanity'; for manual_Test_Runner: null
	log_url VARCHAR(100),
	date_time TIMESTAMPTZ DEFAULT now(),
	build VARCHAR(100) NOT NULL,
	test_runner_result VARCHAR(50) NOT NULL
);

-- for microservice archi: <sg:QA>.<db:{{release_version}}>.<schema:TC>.<table:master>
CREATE TABLE TC.master(
	id VARCHAR(100) PRIMARY KEY,
	name VARCHAR(100),
	
	scenario VARCHAR(200), 
	-- represents the leaf_node of master.domain_hierarchy
	-- but not a FK because entries in master.domain_hierarchy can be deleted.
	-- UPDATING scenario of TC.master can only be carried out by db admin
	-- ONLY WHEN system is kept blocked from taking requests
	
	designed_for_setup_list VARCHAR(100), 
	-- comma seperated values of setup names where this test is designed for
	--available  'boston', 'nynj', for all setups specified in 
	--available  'boston', 'nynj', for all setups specified in master.setup: value=null
	
	category VARCHAR(100),
	description VARCHAR(500),
	expected_behavior VARCHAR(500),
	detailed VARCHAR(500),
	review_id VARCHAR(100),
	
	tag VARCHAR(100) -- for sanity_auto_Test_runnner: 'sanity', 'daily', 'weekly'
);
CREATE TABLE TC.auto_tc(
	tc_id VARCHAR(100) PRIMARY KEY REFERENCES TC.master(id) ON DELETE CASCADE ON UPDATE CASCADE,
	auto_tc_name VARCHAR(100), --confirm whether uniqure required or not 
	UNIQUE(tc_id, auto_tc_name)
);

CREATE TABLE TC.event (
	id SERIAL PRIMARY KEY,
	tc_id VARCHAR(100) REFERENCES TC.master(id) ON DELETE CASCADE ON UPDATE CASCADE,
	date_time TIMESTAMPTZ DEFAULT now(),
	
	carried_on_setup VARCHAR(50) NOT NULL, -- refers to <db:master>.<schema:setup>.<table:master>.<field: name>
	-- must be non null value
	
	test_runner_id VARCHAR(100) REFERENCES TC.test_runner(id) ON DELETE CASCADE ON UPDATE CASCADE,
	test_result VARCHAR(50) NOT NULL 
);

-- represents the latest state of the test cases
CREATE TABLE TC.state(
	tc_id VARCHAR(100) REFERENCES TC.master(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	date_time TIMESTAMPTZ DEFAULT now(),
	
	carried_on_setup VARCHAR(50) NOT NULL,  -- refers to <db:master>.<schema:setup>.<table:master>.<field: name>
	-- must be non null value
	test_runner_id VARCHAR(100) REFERENCES TC.test_runner(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	
	test_result VARCHAR(50) NOT NULL, 
	-- individual test may have passed even if the test runner failed
	-- if test_runner passes, then this TC must have passed. if test_runner fails, this TC may have passed
	
	PRIMARY KEY(tc_id, carried_on_setup)
);

CREATE OR REPLACE FUNCTION updateTcStateForTcEvent() RETURNS TRIGGER AS $$
BEGIN
INSERT INTO TC.state AS t
	(
	tc_id,
	date_time,
	carried_on_setup, 
	-- must be non null value
	test_runner_id,
	test_result
	) VALUES 
(NEW.tc_id, NEW.date_time, NEW.carried_on_setup, NEW.test_runner_id, NEW.test_result)
ON CONFLICT (tc_id, carried_on_setup) 
DO UPDATE SET date_time=NEW.date_time, carried_on_setup=NEW.carried_on_setup, test_runner_id=NEW.test_runner_id, test_result=NEW.test_result
WHERE t.tc_id=NEW.tc_id AND t.carried_on_setup=NEW.carried_on_setup;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER on_tcEvent_updateTcState AFTER INSERT OR UPDATE ON TC.event
FOR EACH ROW EXECUTE FUNCTION updateTcStateForTcEvent();
-- EXECUTE PROCEDURE auditlogfunc();

CREATE TABLE TC.bug(
	jira_id VARCHAR(50) PRIMARY KEY,
	jira_url VARCHAR(50) NOT NULL,
	tc_id VARCHAR(100) REFERENCES TC.master(id) ON DELETE CASCADE ON UPDATE CASCADE,
	build VARCHAR(100),
	priority INTEGER, -- 1=high, 2=medium, 3=low
	date_time TIMESTAMPTZ DEFAULT now(),
	resolved BOOLEAN DEFAULT FALSE
);

INSERT INTO master.domain_hierarchy
VALUES
('STR_REM_STDSCE'),
('STR_REM_SL'),
('STR_REM_NS'),
('STR_SNP_STDSCE');


INSERT INTO TC.master
(id, name, scenario, designed_for_setup_list, category, description, expected_behavior, detailed, review_id, tag) 
VALUES
('boston_rs_basic_1.1', 'RS_Basic-1.1', 'STR_REM_STDSCE', 'boston, nynj', 'Remote Volume Basic', 'node 1 and attach', '', '', '', 'sanity'),
('boston_rs_verify_1.0', 'RS_Verify-1.0', 'STR_REM_STDSCE', 'boston, nynj', 'Remote Volume Basic', 'node 1 and attach', '', '', '', 'sanity'),
('boston_rs_verify_1.2', 'RS_Verify-1.2', 'STR_REM_STDSCE', 'boston', 'Remote Storage IO Verification', 'node 1 and attach', '', '', '', 'sanity'),
('boston_rs_stress_1.0', 'RS_Stress-1.0', 'STR_REM_SL', 'boston', 'Config Stress', '32 remote volumes', '', '', '', 'daily'),
('boston_rs_stress_1.1', 'RS_Stress-1.1', 'STR_REM_SL', 'boston', 'Limit Testing', '8 remote volumes...', '', '', '', 'weekly'),
('boston_rs_stress_1.2', 'RS_Stress-1.2', 'STR_REM_SL', 'boston', 'Limit Testing', '8 remote volumes...', '', '', '', 'sanity'),
('boston_rs_negative_1.0', 'RS_Negative-1.0', 'STR_REM_NS', 'boston', 'Remote Volume Negative Tests', 'Delete volumes...', '', '', '', 'daily'),
('boston_nynj_sandiego_only', 'DUMMY', 'STR_REM_NS', 'boston, nynj, san-diego', 'Dummy Tests', 'conducted on 3/4 setups across all releases', '', '', '', 'daily'),
('boston_passed_else_failed_1.0', 'DUMMY', 'STR_REM_NS', 'boston, nynj, san-diego', 'Dummy Tests', 'conducted on 3/4 setups across all releases', '', '', '', 'weekly'),
('boston_passed_else_failed_1.1', 'DUMMY', 'STR_REM_NS', 'boston, nynj, san-diego', 'Dummy Tests', 'conducted on 3/4 setups across all releases', '', '', '', 'weekly'),
('manually_tested_only0', 'DUMMY', 'STR_REM_NS', 'boston, nynj, san-diego', 'Dummy Tests', 'conducted on 3/4 setups across all releases', '', '', '', 'weekly'),
('manually_tested_only1', 'DUMMY', 'STR_REM_NS', 'boston, nynj, san-diego', 'Dummy Tests', 'conducted on 3/4 setups across all releases', '', '', '', 'weekly');

INSERT INTO TC.auto_tc
(tc_id, auto_tc_name)
VALUES
('boston_rs_basic_1.1', 'RemoteStorage.Basic'),
('boston_rs_verify_1.0', 'RemoteStorage.Basic'),
('boston_rs_verify_1.2', 'AndNon4KIOs'),
('boston_rs_stress_1.0', 'RemoteStorage.ConfigStress'),
('boston_rs_stress_1.1', 'RemoteStorage.ConfigStress'),
('boston_rs_stress_1.2', 'RemoteStorage.ConfigStress'),
('boston_rs_negative_1.0', 'RemoteStorage.NegativeTests'),
('boston_nynj_sandiego_only', 'RemoteStorage.NegativeTests'),
('boston_passed_else_failed_1.0', 'RemoteStorage.NegativeTests'),
('boston_passed_else_failed_1.1', 'RemoteStorage.NegativeTests');



INSERT INTO TC.test_runner
(
	id,
	tag, --'daily', 'weekly', 'sanity','manual'
	log_url,
	build,
	test_runner_result,
	date_time
) VALUES 
('SR1_OLD', 'weekly', 'http://localhost:8080/', '2.3.0-10', 'pass', timestamp with time zone '2019-11-25 01:05:00 +05:30');

INSERT INTO TC.test_runner
(
	id,
	tag, --for auto_tc_runner: 'daily', 'weekly', 'sanity', for manual auto_tc_runnner: null
	log_url,
	build,
	test_runner_result
) VALUES 
('SR0', 'daily', 'http://localhost:8080/', '2.3.0-14', 'pass'),
('SR1', 'weekly', 'http://localhost:8080/', '2.3.0-15', 'fail'),
('SR2', 'sanity', 'http://localhost:8080/', '2.3.0-16', 'pass'),
('SR1_OLD_MANUAL',null, 'http://localhost:8080/', '2.3.0-17', 'pass');


INSERT INTO TC.event
(
	tc_id,
	carried_on_setup,
	test_runner_id,
	test_result,
	date_time
) VALUES
('boston_rs_stress_1.1', 'boston', 'SR1_OLD', 'pass', timestamp with time zone '2019-11-25 01:05:00 +05:30'),
('boston_passed_else_failed_1.0', 'boston', 'SR1_OLD', 'pass', timestamp with time zone '2019-11-25 01:05:00 +05:30'),
('boston_passed_else_failed_1.0', 'nynj', 'SR1_OLD', 'fail', timestamp with time zone '2019-11-25 01:05:00 +05:30'),
('boston_passed_else_failed_1.0', 'san-diego', 'SR1_OLD', 'fail', timestamp with time zone '2019-11-25 01:05:00 +05:30'),
('boston_passed_else_failed_1.1', 'boston', 'SR1_OLD', 'pass', timestamp with time zone '2019-11-25 01:05:00 +05:30'),
('boston_passed_else_failed_1.1', 'nynj', 'SR1_OLD', 'fail', timestamp with time zone '2019-11-25 01:05:00 +05:30'),
('boston_passed_else_failed_1.1', 'san-diego', 'SR1_OLD', 'fail', timestamp with time zone '2019-11-25 01:05:00 +05:30'),

('manually_tested_only0', 'san-diego', 'SR1_OLD_MANUAL', 'pass', timestamp with time zone '2019-11-25 01:05:00 +05:30'),
('manually_tested_only0', 'boston', 'SR1_OLD_MANUAL', 'fail', timestamp with time zone '2019-11-25 01:05:00 +05:30'),
('manually_tested_only1', 'boston', 'SR1_OLD_MANUAL', 'pass', timestamp with time zone '2019-11-25 01:05:00 +05:30'),
('manually_tested_only1', 'san-diego', 'SR1_OLD_MANUAL', 'pass', timestamp with time zone '2019-11-25 01:05:00 +05:30');

INSERT INTO TC.event
(
	tc_id,
	carried_on_setup,
	test_runner_id,
	test_result
) VALUES
('boston_rs_stress_1.0', 'boston', 'SR0', 'pass'),
('boston_rs_negative_1.0', 'boston', 'SR0', 'pass'),
('boston_nynj_sandiego_only', 'boston', 'SR0', 'pass'),
('boston_nynj_sandiego_only', 'nynj', 'SR0', 'pass'),
('boston_nynj_sandiego_only', 'san-diego', 'SR0', 'pass'),

('boston_rs_stress_1.1', 'boston', 'SR1', 'fail'),
('boston_passed_else_failed_1.0', 'boston', 'SR1', 'pass'),
('boston_passed_else_failed_1.0', 'nynj', 'SR1', 'fail'),
('boston_passed_else_failed_1.0', 'san-diego', 'SR1', 'fail'),
('boston_passed_else_failed_1.1', 'boston', 'SR1', 'pass'),
('boston_passed_else_failed_1.1', 'nynj', 'SR1', 'fail'),
('boston_passed_else_failed_1.1', 'san-diego', 'SR1', 'fail'),

('boston_rs_basic_1.1', 'boston', 'SR2', 'pass'),
('boston_rs_verify_1.0', 'boston', 'SR2', 'pass'),
('boston_rs_verify_1.2', 'boston', 'SR2', 'pass'),
('boston_rs_stress_1.2', 'boston', 'SR2', 'pass');

-- TRIGGER INSERTS INTO TC.state 

INSERT INTO TC.bug(
	jira_id,
	jira_url,
	tc_id,
	build,
	priority
) VALUES 
('1', 'JIRA_SITE','boston_rs_stress_1.1', '2.3.0-15', '1'),
('2','JIRA_SITE', 'boston_passed_else_failed_1.0', '2.3.0-15', '1'),
('3', 'JIRA_SITE', 'boston_passed_else_failed_1.1', '2.3.0-15', '1');









