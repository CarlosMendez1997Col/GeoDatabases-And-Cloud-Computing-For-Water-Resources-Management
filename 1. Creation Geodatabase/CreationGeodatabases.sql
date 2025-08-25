--- Water Resources Management using PostgreSQL and PgAdmin4
--- create by MSc Carlos Mendez

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

--- Change the administrator and owner of DATABASE

ALTER DATABASE master_gdb OWNER TO support;








