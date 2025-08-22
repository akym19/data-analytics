/*
	Script Purpose:
		Creates the "UberDA" database and 3 schemas bronze, silver, and gold.

	Warning:
		This script drops and recreates the database. Proceed with caution
*/


USE master;
GO

DROP DATABASE IF EXISTS UberDA;
CREATE DATABASE UberDA;
GO

USE UberDA;
GO

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO