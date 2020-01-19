
-- Database: master
/*
-- 1) delete will always be soft delete.
-- 2) During system maintainence, if master db PK value is not found in any slave db name, schema name, table name or field
--    name, then only delete the entry from master db
-- 3) subordintate fields in usr.master can be moved seperate user db if the current system extends to multitenant architecture

-- the server_group will be hosted on seperate instance and will have its own IP address.
-- this database belongs to 
-- Cluster-Owner: Diamanti, 
-- Server_Group: master

DROP DATABASE master;

CREATE DATABASE master
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
				  '${created}: Master database acts as master to other slave databases. it is the primary point of contact for communication. has soft delete for everyone except db admin');

-- SCHEMAS
CREATE SCHEMA master;
CREATE SCHEMA usr;
CREATE SCHEMA release_version;
CREATE SCHEMA setup;

-- master schema will consists of tables having information
-- about the entire suit of applications. 
-- in future, it will be broken down into seperate 'master' db
-- when this current 'master' is splitted as another server.


-- list of all different types of hardware universe 
-- across all releases.
CREATE TABLE setup.master(
	name VARCHAR(50) PRIMARY KEY,
	inventory_file_url VARCHAR(50)
);

CREATE TABLE setup.cluster(
	name VARCHAR(50) PRIMARY KEY,
	setup VARCHAR(50) REFERENCES setup.master(name) ON DELETE CASCADE ON UPDATE CASCADE,
	info VARCHAR(100)
);

CREATE TABLE setup.state(
	cluster_name VARCHAR(50) REFERENCES setup.cluster(name) ON DELETE CASCADE ON UPDATE CASCADE, --eg: cluster_name: bos-serv1, name: 'boston'
	status VARCHAR(50), --'fail', 'normal',
	date_time TIMESTAMPTZ default now(),
	PRIMARY KEY(cluster_name)
);




CREATE TABLE usr.master(
	email VARCHAR(100) PRIMARY KEY,
	name VARCHAR(100),
	role VARCHAR(50), -- role='admin', 'emp'
	password VARCHAR(50)
);

-- for microservice archi: <sg:Usr>.<db:{{usr_email}}>.<schema:qualitative_analysis>.<table:state>
-- 'cluster_name' wont be FK in microservice archi
CREATE TABLE usr.qualitative_analysis(
	email VARCHAR(100) REFERENCES usr.master(email) ON DELETE RESTRICT ON UPDATE CASCADE,
	auto_tc_list VARCHAR(100), -- composes of <db:{{release_version}}>.<schema:TC>.<table:master>.<field:auto_tc_name>
	manual_tc_list VARCHAR(100), -- composes of <db:{{release_version}}>.<schema:TC>.<table:master>.<field:manual_tc_name>
	cluster_name_list VARCHAR(50), --composes of setup.cluster.name
	PRIMARY KEY(email)
);

CREATE TABLE usr.qualitative_analysis_auto_tc(
	email VARCHAR(50) REFERENCES usr.master(email) ON DELETE CASCADE ON UPDATE CASCADE,
	auto_tc_name VARCHAR(100) NOT NULL, --<db:{{release_version}}>.<schema:TC>.<table:auto_tc>.<field:auto_tc>
	PRIMARY KEY(email, auto_tc_name)
);

CREATE TABLE usr.qualitative_analysis_manual_tc(
	email VARCHAR(50) REFERENCES usr.master(email) ON DELETE CASCADE ON UPDATE CASCADE,
	tc_id VARCHAR(100) NOT NULL,
	PRIMARY KEY(email, tc_id)
);

CREATE TABLE usr.qualitative_analysis_cluster(
	email VARCHAR(50) REFERENCES usr.master(email) ON DELETE CASCADE ON UPDATE CASCADE,
	cluster_name VARCHAR(50) REFERENCES setup.cluster(name) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE release_version.master(
	name VARCHAR(100) PRIMARY KEY
);

CREATE TABLE release_version.domain_definition (
	abr VARCHAR(10) PRIMARY KEY,
	name VARCHAR(100)
);

INSERT INTO release_version.master
(name) VALUES 
('master'), ('release_ga-2.3.0');

INSERT INTO release_version.domain_definition 
VALUES
('STR', 'Storage'),
('REM', 'Remote'),
('SNP', 'Snapshot'),
('STDSCE', 'Standard Scenarios'),
('SL', 'Stress & Limit'),
('NS', 'Negative Scenarios'),
('SIM', 'Simulation');

INSERT INTO usr.master 
VALUES
('jenkins@diamanti.com', 'Jenkins', 'emp', '123'),
('achavan@diamanti.com', 'Abhijeet', 'emp', '123'),
('sbhile@diamanti.com', 'Sushil', 'emp', '123'),
('yatish@diamanti.com', 'Yatish', 'admin', '123'),
('deepak@diamanti.com', 'Deepak', 'admin', '123');

INSERT INTO setup.master 
(name) VALUES 
('boston'),('nynj'),('san-diego'),('san-fransisco');

INSERT INTO setup.cluster
(name, setup) VALUES 
('bos-serv1', 'boston'), 
('bos-serv2', 'boston'), 
('appserv1', 'nynj'), 
('appserv2', 'nynj'), 
('appserv3', 'nynj'),
('san-diego1', 'san-diego'),
('san-fransisco1', 'san-fransisco');

INSERT INTO usr.qualitative_analysis_cluster(
	email,
	cluster_name
) VALUES 
('yatish@diamanti.com', 'bos-serv1'), 
('yatish@diamanti.com', 'san-diego1'), 
('sbhile@diamanti.com', 'appserv1'),
('sbhile@diamanti.com', 'appserv2');


INSERT INTO usr.qualitative_analysis_auto_tc(
	email,
	auto_tc_name
) VALUES
('yatish@diamanti.com', 'RemoteStorage.Basic'),
('sbhile@diamanti.com', 'RemoteStorage.ConfigStress');

INSERT INTO usr.qualitative_analysis_manual_tc(
	email,
	tc_id
) VALUES
('yatish@diamanti.com', 'manually_tested_only0'),
('sbhile@diamanti.com', 'manually_tested_only1');






