/*
											Water Resources Managemen using PostgreSQL and PgAdmin4
															Area of Interest (South America)
															 Developed by MSc Carlos Mendez
																														 
MOST TABLES AND DATASETS USED:

HydroSHEDS
https://www.hydrosheds.org/

1. HydroSHEDS
2. HydroBASINS
3. HydroRIVERS
4. HydroLAKES
5. Global Lakes and Wetlands Database (GLWD)
6. HydroWASTE
7. Global River Classification (GloRiC)
8. Lake TEMP

World Resources Institute
https://www.wri.org/

9. Global Power Plant Database

Global Administrative Unit Layers (GAUL) 

10. Global Country boundaries
11. Firt Level Administrative Units
12. Second Level Administrative Units

*/

--- General Steps

--- Register a new SERVER, for example 'Water_Server'

--- Create a new DATABASE, for example 'master_gdb' 
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

--- Create an user with permissions, for example 'support'
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

--- Change the administrator and set 'Support'
ALTER DATABASE master_gdb OWNER TO support;

--- create the extension PostGIS 
create EXTENSION postgis;


/* 
Connect GIS data using PostGIS and import shapefiles (.shp) using the function shp2pgsql

Try to run the following script in the Terminal of Windows/macOS/Linux:

First, Open the shp2pgsql.exe in the local directory 
C:\Program Files\PostgreSQL\17\bin\shp2pgsql.exe

Second, run the script and replace the path folder and .shp files, folowing the structure 
(shp2pgsql -s <SRID> -I <path_to_shapefile.shp> <schema_name>.<table_name> > <output_file.sql>

EXAMPLE WITH HydroWASTE.shp

shp2pgsql -s 4326 -I C:\Users\USUARIO\Desktop\Geodatabases_Water\HydroWASTE_SA.shp water_data.Hydrowaste > C:\Users\USUARIO\Desktop\Geodatabases_Water\Hydrowaste.sql
*/



SELECT * FROM public.water_categories
ORDER BY hybas_id ASC;



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


--- Insert data and rows into water_categories
INSERT INTO water_categories(hybas_id,water_description) VALUES(123456,'Main Basin');
INSERT INTO water_categories(hybas_id,water_description) VALUES(7890,'Basin2');

--- Update data
UPDATE water_categories SET water_description = 'Basin' WHERE hybas_id = 123456;

--- Delete ROWS
DELETE FROM water_categories WHERE hybas_id = 123456;
DELETE FROM water_categories WHERE hybas_id = 7890;


CREATE SCHEMA water_data
    AUTHORIZATION postgres;


--- Delete DATABASE
drop DATABASE master_gdb;	

--- delete user with permissions 
drop ROLE SUPPORT;



