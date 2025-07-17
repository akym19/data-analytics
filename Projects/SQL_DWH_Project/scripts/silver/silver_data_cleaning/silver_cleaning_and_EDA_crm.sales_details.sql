-- Checking foreign keys

SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM silver.crm_prd_info);

SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN (SELECT cst_id FROM silver.crm_cust_info);

------------------------------------------------------------------------------------------------------------

-- Checking unwanted spaces in sls_ord_num

SELECT
	sls_ord_num
FROM bronze.crm_sales_details
WHERE sls_ord_num != TRIM(sls_ord_num);

------------------------------------------------------------------------------------------------------------

-- Checking invalid dates

SELECT
	sls_ord_num,
	sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
OR LEN(sls_due_dt) != 8
OR sls_due_dt > 20250101
OR sls_due_dt < 19900101;

------------------------------------------------------------------------------------------------------------

-- Checking invalid order dates

SELECT
	sls_ord_num,
	sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

------------------------------------------------------------------------------------------------------------

-- Checking invalid sales

SELECT DISTINCT
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- Found multiple nulls, negative numbers, and error in calculation in sales, qty, and price columns
-- DEFINED RULES:
-- IF SALES IS NEGATIVE OR ZERO OR NULL, DERIVE USING QTY * PRICE
-- IF PRICE IS ZERO OR NULL, DERIVE USING SALES / QTY
-- IF PRICE IS NEGATIVE, CONVERT TO POSITIVE

SELECT DISTINCT
	sls_sales AS old_sls_sales,
	sls_quantity,
	sls_price AS old_sls_price,
	CASE
		WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales !=  sls_quantity * sls_price THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales
	END AS sls_sales,
	CASE
		WHEN sls_price <= 0 OR sls_price IS NULL THEN sls_sales / NULLIF(sls_quantity, 0)
		ELSE sls_price
	END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

------------------------------------------------------------------------------------------------------------

SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE
		WHEN sls_order_dt <= 0
		OR LEN(sls_order_dt) != 8
		THEN NULL
		ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
	END AS sls_order_dt, -- Changed date datatype
	CASE
		WHEN sls_ship_dt <= 0
		OR LEN(sls_ship_dt) != 8
		THEN NULL
		ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
	END AS sls_ship_dt, -- Changed date datatype
	CASE
		WHEN sls_due_dt <= 0
		OR LEN(sls_due_dt) != 8
		THEN NULL
		ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
	END AS sls_due_dt, -- Changed date datatype
	CASE
		WHEN sls_sales <= 0 OR sls_sales IS NULL OR sls_sales !=  sls_quantity * sls_price THEN sls_quantity * ABS(sls_price)
		ELSE sls_sales
	END AS sls_sales, -- Deriving sales when invalid
	sls_quantity,
	CASE
		WHEN sls_price <= 0 OR sls_price IS NULL THEN sls_sales / NULLIF(sls_quantity, 0)
		ELSE sls_price
	END AS sls_price -- Deriving price when invalid
FROM bronze.crm_sales_details;