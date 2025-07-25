/*
	Script Purpose:
		Creates the database 'GroceryDB' and 3 Schemas (Bronze, Silver, Gold)

	Warning:
		This script drops and recreates the database if it already exists. Proceed with caution
*/


USE master;
GO

DROP DATABASE IF EXISTS GroceryDB;
CREATE DATABASE GroceryDB;
GO

USE GroceryDB;
GO

CREATE SCHEMA bronze;
GO

CREATE SCHEMA silver;
GO

CREATE SCHEMA gold;
GO
