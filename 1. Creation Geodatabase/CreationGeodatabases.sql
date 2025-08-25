--- Water Resources Management using PostgreSQL and PgAdmin4
--- Developed by MSc Carlos Mendez

--- Create DATABASE
CREATE DATABASE master_gdb
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Spanish_Spain.1252'
    LC_CTYPE = 'Spanish_Spain.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

--- Delete DATABASE
drop DATABASE master_gdb;	

--- Create an user with permissions
CREATE ROLE support WITH
	LOGIN
	SUPERUSER
	CREATEDB
	CREATEROLE
	INHERIT
	NOREPLICATION
	BYPASSRLS
	CONNECTION LIMIT -1
	PASSWORD 'xxxxxx';
COMMENT ON ROLE support IS 'support data';

--- delete user with permissions 
drop ROLE SUPPORT;

--- Change the administrator and owner of DATABASE
ALTER DATABASE master_gdb OWNER TO support;

--- Create a table with fields
CREATE TABLE water_categories(Hybas_ID int, water_description varchar(30));

--- Modify users and fields
ALTER TABLE IF EXISTS public.water_categories
    ALTER COLUMN hybas_id SET NOT NULL;
ALTER TABLE IF EXISTS public.water_categories
    ALTER COLUMN water_description SET NOT NULL;
ALTER TABLE IF EXISTS public.water_categories
    ADD PRIMARY KEY (hybas_id);

--- Delete table with fields
DROP TABLE water_categories;

