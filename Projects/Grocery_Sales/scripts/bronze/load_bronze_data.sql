/*
	Script Purpose:
		Creates a stored procedure to insert data to the bronze tables in the 'GrocerDB' database

	WARNING:
		This stored procedure truncates the rows in the tables. Proceed with caution.
*/
---------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE bronze.load_bronze_data AS
BEGIN
	TRUNCATE TABLE bronze.categories;

	BULK INSERT bronze.categories
	FROM 'C:\Users\raffy\Documents\Data Analytics\SQL\SQL Project\Grocery Sales\datasets\categories.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);
	---------------------------------------------------------------------------------------------------------------------
	TRUNCATE TABLE bronze.cities;

	BULK INSERT bronze.cities
	FROM 'C:\Users\raffy\Documents\Data Analytics\SQL\SQL Project\Grocery Sales\datasets\cities.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);
	---------------------------------------------------------------------------------------------------------------------
	TRUNCATE TABLE bronze.countries;

	BULK INSERT bronze.countries
	FROM 'C:\Users\raffy\Documents\Data Analytics\SQL\SQL Project\Grocery Sales\datasets\countries.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);
	---------------------------------------------------------------------------------------------------------------------
	TRUNCATE TABLE bronze.customers;

	BULK INSERT bronze.customers
	FROM 'C:\Users\raffy\Documents\Data Analytics\SQL\SQL Project\Grocery Sales\datasets\customers.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);
	---------------------------------------------------------------------------------------------------------------------
	TRUNCATE TABLE bronze.employees;

	BULK INSERT bronze.employees
	FROM 'C:\Users\raffy\Documents\Data Analytics\SQL\SQL Project\Grocery Sales\datasets\employees.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);
	---------------------------------------------------------------------------------------------------------------------
	TRUNCATE TABLE bronze.products;

	BULK INSERT bronze.products
	FROM 'C:\Users\raffy\Documents\Data Analytics\SQL\SQL Project\Grocery Sales\datasets\products.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		FORMAT = 'CSV',
		FIELDQUOTE = '"',
		TABLOCK
	);
	---------------------------------------------------------------------------------------------------------------------
	TRUNCATE TABLE bronze.sales;

	BULK INSERT bronze.sales
	FROM 'C:\Users\raffy\Documents\Data Analytics\SQL\SQL Project\Grocery Sales\datasets\sales.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '0x0a',
		TABLOCK
	);
END
