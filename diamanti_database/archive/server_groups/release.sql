/*

-- Database: release_ga-2.3.0

-- DROP DATABASE "release_ga-2.3.0";

CREATE DATABASE "release_ga-2.3.0"
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_IN'
    LC_CTYPE = 'en_IN'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
*/
create or replace function comment_on(p_type text, p_object text, p_comment text)
  returns text
as
$$
declare 
  l_sql     text;
  l_comment text;
begin
  l_comment := replace(p_comment, '${created}', 'created at '||to_char(current_date, 'yyyy-mm-dd'));
  l_sql := 'comment on '||p_type||' '||p_object||' is '||quote_literal(l_comment);
  execute l_sql;
  return l_comment;
end;
$$
language plpgsql;
select comment_on('database', cast((SELECT current_database()) as text), '${created}');

-- CREATE OR REPLACE FUNCTION documentation() RETURNS void AS $$
-- DECLARE 
-- current_db name;
-- BEGIN
-- SELECT current_database() INTO current_db;
-- COMMENT ON DATABASE current_db IS 'Database of QA on given Release';
-- END;
-- $$ LANGUAGE PLPGSQL;

-- SELECT documentation();
select description from pg_shdescription
join pg_database on objoid = pg_database.oid
where datname = 'release_ga_2_3_0';
-- SELECT current_database()
-- CgOMMENT ON DATABASE master IS 'Master Database of entire Diamanti application suite'
-- COMMENT ON DATABASE name =(SELECT current_database()) IS 'Database of Qualititative Aspects on given named Release'

/*
CREATE SCHEMA encoding;
CREATE SCHEMA metadata;

CREATE TABLE metadata.master(
	features VARCHAR(500), --features specific to setup and release eg: features of setup:'boston', release:'ga-2.3.0'
	setup VARCHAR(500) --references to db:master.release.setup.master['name']
);
CREATE TABLE encoding.master(
	name VARCHAR(100) PRIMARY KEY
);

*/
