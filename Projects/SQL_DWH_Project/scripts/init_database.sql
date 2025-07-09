/*
Script Purpose:
	Creates the 'DataWarehouse' database and 3 schemas (bronze, silver, and gold).

WARNING:
	This script drops and recreates the database 'DataWarehouse' if it already exists. Proceed with caution.

*/


USE master;
GO

DROP DATABASE IF EXISTS DataWarehouse;
CREATE DATABASE DataWarehouse;

USE DataWarehouse;
GO

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
