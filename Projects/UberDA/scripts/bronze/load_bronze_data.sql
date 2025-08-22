/*
	Script Purpose:
		Creates a stored procedure for importing data to the bronze table in the 'UberDA' database

	Warning:
		This stored procedure truncates the rows in the tables. Proceed with caution.
*/

TRUNCATE TABLE bronze.uber_bookings;

BULK INSERT bronze.uber_bookings
FROM 'C:\Users\raffy\Documents\Data Analytics\SQL\SQL Project\Uber Data Analytics\datasets\uber_bookings.csv'
WITH (
	FIRSTROW = 2,
	FIELDTERMINATOR = ',',
	ROWTERMINATOR = '0x0a',
	FORMAT = 'CSV',
	FIELDQUOTE = '"',
	TABLOCK
)