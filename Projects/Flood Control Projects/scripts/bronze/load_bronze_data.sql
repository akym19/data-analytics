/*
	Script Purpose:
		Creates a stored procedure for importing data to the bronze table in the 'FloodControl' database

	Warning:
		This stored procedure truncates the rows in the tables. Proceed with caution.
*/


CREATE OR ALTER PROCEDURE bronze.load_bronze_data AS
BEGIN

	TRUNCATE TABLE bronze.flood_control_projects;

	BULK INSERT bronze.flood_control_projects
	FROM 'C:\Users\raffy\Documents\Data Analytics\PowerBI\Projects\Flood Control\Dataset\PBI Pinas Comm Data Challenge 2025 Data\Projects.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		FORMAT = 'CSV',
		FIELDQUOTE = '"',
		TABLOCK
	);

END