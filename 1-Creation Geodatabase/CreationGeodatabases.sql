/*
																	Water Resources Management using PostgreSQL and PgAdmin4
																				Area of Interest (South America)
															 					 Developed by MSc Carlos Mendez
																														 
MOST TABLES AND DATASETS USED:

1. South America Countries and Boundary 
2. HydroSHEDS (Conditioned DEM)
3. HydroBASINS (Level 1,2,3,4,5,6,7,8,9,10,11 and 12)
4. HydroRIVERS
5. HydroLAKES
6. Global Lakes and Wetlands Database (GLWD)
7. HydroWASTE
8. Global River Classification (GloRiC)
9. Lake TEMP
10. Global Power Plant Database (GPPD)
11. Firt Level Administrative Units (FLAU)
12. Second Level Administrative Units (SLAU)

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

Try to run the following scripts in the Terminal of Windows/macOS/Linux:

First, Open the shp2pgsql.exe in the local directory 
C:\Program Files\PostgreSQL\17\bin\shp2pgsql.exe

Second, run the script and replace the path folder and .shp files, folowing the structure 
(shp2pgsql -s <SRID> -I <path_to_shapefile.shp> <schema_name>.<table_name> > <output_file.sql>


																				HydroSHEDS_SA.shp


																				HydroBASINS_SA.shp


																				HydroRIVERS_SA.shp


																				HydroLAKES_SA.shp


																				GLWD_SA.shp


																				HydroWASTE_SA.shp


																				GloRiC_SA.shp


																				LakeTEMP_SA.shp



Example with HydroWASTE_SA.shp
shp2pgsql -s 4326 -I C:\Users\USUARIO\Desktop\Geodatabases_Water\HydroWASTE_SA.shp water_data.Hydrowaste > C:\Users\USUARIO\Documents\GitHub\GeoDatabases-And-Cloud-Computing-For-Water-Resources-Management\2-Import-files(shp2sql)\Hydrowaste.sql

Example with GloRiC.shp


Example with GloRiC.shp


Example with GloRiC.shp


Example with GloRiC.shp


EXAMPLE WITH LakeTEMP.shp
shp2pgsql -s 4326 -I C:\Users\USUARIO\Desktop\Geodatabases_Water\LakeTEMP_SA.shp water_data.LakeTEMP > C:\Users\USUARIO\Documents\GitHub\GeoDatabases-And-Cloud-Computing-For-Water-Resources-Management\2-Import-files(shp2sql)\LakeTEMP.sql

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



