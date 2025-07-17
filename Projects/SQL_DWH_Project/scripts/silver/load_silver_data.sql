/*
Script Purpose:
	Creates a stored procedure to that performs ETL (Extract, Transform, Load) process to populate the 'silver' schema tables from the 'bronze' schema.

WARNING:
	This stored procedure truncates the rows in the tables. Proceed with caution.
*/

CREATE OR ALTER PROCEDURE silver.load_silver_data AS
BEGIN
	--------------------------------------------------------------------------------------------------
	-- LOAD crm_cust_info DATA

	TRUNCATE TABLE silver.crm_cust_info;

	INSERT INTO silver.crm_cust_info (
		cst_id, 
		cst_key, 
		cst_firstname, 
		cst_lastname, 
		cst_marital_status, 
		cst_gndr,
		cst_create_date
	)
	SELECT
		cst_id, 
		cst_key, 
		TRIM(cst_firstname) AS cst_firstname, -- Makes sure no unwanted spaces
		TRIM(cst_lastname) AS cst_firstname, -- Makes sure no unwanted spaces
		CASE
			WHEN cst_marital_status = UPPER(TRIM('S')) THEN 'Single' -- Normalize marital status
			WHEN cst_marital_status = UPPER(TRIM('M')) THEN 'Married' -- Normalize marital status
			ELSE 'n/a'
		END AS cst_marital_status, 
		CASE
			WHEN cst_gndr = UPPER(TRIM('F')) THEN 'Female' -- Normalize gender
			WHEN cst_gndr = UPPER(TRIM('M')) THEN 'Male' -- Normalize gender
			ELSE 'n/a'
		END AS cst_gndr,
		cst_create_date
	FROM (
		SELECT
			*,
			ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag -- Makes sure no duplicate records
		FROM bronze.crm_cust_info
		WHERE cst_id IS NOT NULL) t
	WHERE flag = 1; -- Filters duplicates

	--------------------------------------------------------------------------------------------------
	-- LOAD crm_prd_info DATA

	TRUNCATE TABLE silver.crm_prd_info;

	INSERT INTO silver.crm_prd_info (
		prd_id, 
		cat_id, 
		prd_key, 
		prd_nm, 
		prd_cost, 
		prd_line,
		prd_start_dt,
		prd_end_dt
	)
	SELECT
		prd_id,
		REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id, -- Relationship to erp_px_cat_g1v2
		SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key, -- Relationship to crm_sales_details
		prd_nm,
		COALESCE(prd_cost, 0) AS prd_cost, -- Handle null prd_cost, replace with 0
		CASE UPPER(TRIM(prd_line))		   -- Normalize prd_line
			WHEN 'M' THEN 'Mountain'
			WHEN 'R' THEN 'Road'
			WHEN 'S' THEN 'Other Sales'
			WHEN 'T' THEN 'Touring'
			ELSE 'n/a'
		END AS prd_line,
		CAST(prd_start_dt AS DATE), -- start and end date casted as date only since time always shows 00:00:00.000
		CAST(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt ASC)-1 AS DATE) AS prd_end_dt -- Handle end date that is less than start date
	FROM bronze.crm_prd_info;

	--------------------------------------------------------------------------------------------------
	-- LOAD crm_sales_details DATA

	TRUNCATE TABLE silver.crm_sales_details;

	INSERT INTO silver.crm_sales_details (
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		sls_order_dt,
		sls_ship_dt,
		sls_due_dt,
		sls_sales,
		sls_quantity,
		sls_price
	)
	SELECT
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		CASE
			WHEN sls_order_dt <= 0
			OR LEN(sls_order_dt) != 8
			THEN NULL
			ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
		END AS sls_order_dt,
		CASE
			WHEN sls_ship_dt <= 0
			OR LEN(sls_ship_dt) != 8
			THEN NULL
			ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
		END AS sls_ship_dt,
		CASE
			WHEN sls_due_dt <= 0
			OR LEN(sls_due_dt) != 8
			THEN NULL
			ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
		END AS sls_due_dt,
		CASE
			WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales !=  sls_quantity * sls_price THEN sls_quantity * ABS(sls_price)
			ELSE sls_sales
		END AS sls_sales,
		sls_quantity,
		CASE
			WHEN sls_price <= 0 OR sls_price IS NULL THEN sls_sales / NULLIF(sls_quantity, 0)
			ELSE sls_price
		END AS sls_price
	FROM bronze.crm_sales_details;

	--------------------------------------------------------------------------------------------------
	-- LOAD erp_loc_a101 DATA

	TRUNCATE TABLE silver.erp_loc_a101;

	INSERT INTO silver.erp_loc_a101 (
		cid,
		cntry
	)
	SELECT
		REPLACE(cid, '-', '') AS cid,
		CASE
			WHEN TRIM(cntry) = 'DE' THEN 'Germany'
			WHEN TRIM(cntry) = 'US' OR TRIM(cntry) = 'USA' THEN 'United States'
			WHEN TRIM(cntry) = '' OR TRIM(cntry) IS NULL THEN 'n/a'
			ELSE TRIM(cntry)
		END AS cntry
	FROM bronze.erp_loc_a101;
	--------------------------------------------------------------------------------------------------
	-- LOAD erp_loc_az12 DATA

	TRUNCATE TABLE silver.erp_cust_az12;

	INSERT INTO silver.erp_cust_az12 (
		cid,
		bdate,
		gen
	)
	SELECT
		CASE
			WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
			ELSE cid
		END AS cid,
		CASE
			WHEN bdate > GETDATE() THEN NULL
			ELSE bdate
		END AS bdate,
		CASE
			WHEN gen = UPPER(TRIM('M')) THEN 'Male'
			WHEN gen = UPPER(TRIM('F')) THEN 'Female'
			ELSE 'n/a'
		END AS gen
	FROM bronze.erp_cust_az12;
	--------------------------------------------------------------------------------------------------
	-- LOAD px_cat_g1v2 DATA

	TRUNCATE TABLE silver.erp_px_cat_g1v2;

	INSERT INTO silver.erp_px_cat_g1v2 (
		id,
		cat,
		subcat,
		maintenance
	)
	SELECT
		id,
		cat,
		subcat,
		maintenance
	FROM bronze.erp_px_cat_g1v2;
END
