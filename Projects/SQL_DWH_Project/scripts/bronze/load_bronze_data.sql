/*
Script Purpose:
	Creates a stored procedure to insert data to the bronze tables in the 'DataWarehouse' database

WARNING:
	This stored procedure truncates the rows in the tables. Proceed with caution.
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze_data AS
BEGIN
	--------------------------------------------------------------------------------------------------
	-- LOAD crm_cust_info DATA

	TRUNCATE TABLE bronze.crm_cust_info;

	BULK INSERT bronze.crm_cust_info
	FROM 'C:\Users\raffy\Documents\Data Analytics\SQL\SQL Project\datasets\source_crm\cust_info.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	--------------------------------------------------------------------------------------------------
	-- LOAD crm_prd_info DATA

	TRUNCATE TABLE bronze.crm_prd_info;

	BULK INSERT bronze.crm_prd_info
	FROM 'C:\Users\raffy\Documents\Data Analytics\SQL\SQL Project\datasets\source_crm\prd_info.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	--------------------------------------------------------------------------------------------------
	-- LOAD crm_sales_details DATA

	TRUNCATE TABLE bronze.crm_sales_details

	BULK INSERT bronze.crm_sales_details
	FROM 'C:\Users\raffy\Documents\Data Analytics\SQL\SQL Project\datasets\source_crm\sales_details.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	--------------------------------------------------------------------------------------------------
	-- LOAD erp_loc_a101 DATA

	TRUNCATE TABLE bronze.erp_loc_a101;

	BULK INSERT bronze.erp_loc_a101
	FROM 'C:\Users\raffy\Documents\Data Analytics\SQL\SQL Project\datasets\source_erp\LOC_A101.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	--------------------------------------------------------------------------------------------------
	-- LOAD erp_loc_az12 DATA

	TRUNCATE TABLE bronze.erp_cust_az12;

	BULK INSERT bronze.erp_cust_az12
	FROM 'C:\Users\raffy\Documents\Data Analytics\SQL\SQL Project\datasets\source_erp\CUST_AZ12.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
	--------------------------------------------------------------------------------------------------
	-- LOAD px_cat_g1v2 DATA

	TRUNCATE TABLE bronze.erp_px_cat_g1v2;

	BULK INSERT bronze.erp_px_cat_g1v2
	FROM 'C:\Users\raffy\Documents\Data Analytics\SQL\SQL Project\datasets\source_erp\PX_CAT_G1V2.csv'
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);
END
