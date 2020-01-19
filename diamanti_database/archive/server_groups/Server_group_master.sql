/*


-- 1) delete will always be soft delete.
-- 2) During system maintainence, if master db PK value is not found in any slave db name, schema name, table name or field
--    name, then only delete the entry from master db
-- 3) subordintate fields in usr.master can be moved seperate user db if the current system extends to multitenant architecture

-- the server_group will be hosted on seperate instance and will have its own IP address.
-- this database belongs to 
-- Cluster-Owner: Diamanti, 
-- Server_Group: master
-- Db_name: master

-- Database: MASTER_SERVER_GROUP_master_master

-- DROP DATABASE "MASTER_SERVER_GROUP_master_master";

CREATE DATABASE "MASTER_SERVER_GROUP_master_master"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_IN'
    LC_CTYPE = 'en_IN'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
	
*/
CREATE SCHEMA release;
CREATE SCHEMA usr;
CREATE SCHEMA setup;

CREATE TABLE release.master (
	name VARCHAR(50) PRIMARY KEY
);
CREATE TABLE release.qa_domain_abbreviation (
	abr VARCHAR(10) PRIMARY KEY,
	name VARCHAR(50)
);

CREATE TABLE usr.master(
	email VARCHAR(100) PRIMARY KEY,
	name VARCHAR(50),
	role VARCHAR(50), -- role='admin', 'emp'
	password VARCHAR(50),
	
	-- subordinate fields
	current_work VARCHAR(50)
);

CREATE TABLE setup.master(
	name VARCHAR(50) PRIMARY KEY,
	inventory_file_url VARCHAR(50)
);
CREATE TABLE setup.cluster(
	name VARCHAR(50) PRIMARY KEY,
	setup VARCHAR(50) REFERENCES setup.master(name) ON DELETE CASCADE ON UPDATE CASCADE,
	info VARCHAR(100)
);

CREATE TABLE setup.qa_state(
	cluster_name VARCHAR(50) REFERENCES setup.cluster(name) ON DELETE CASCADE ON UPDATE CASCADE, --eg: cluster_name: bos-serv1, name: 'boston'
	owner VARCHAR(50) REFERENCES usr.master(email) ON DELETE CASCADE ON UPDATE CASCADE,
	status VARCHAR(50) --'fail', 'normal'
	PRIMARY KEY(cluster_name)
);

INSERT INTO release.master(name) VALUES ('release_ga.2.3.0');












