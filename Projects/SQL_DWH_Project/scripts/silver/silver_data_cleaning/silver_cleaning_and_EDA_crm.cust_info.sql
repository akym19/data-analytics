-- Checking nulls or duplicate primary key
-- Expectation: No result, meaning all primary keys should be unique

SELECT
	cst_id,
	COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

/*
	DUPLICATE cs_id WERE FOUND:
	29449
	29473
	29433
	NULL
	29483
	29466
*/

-- With ROW_NUMBER() Window Function, I flagged the cst_id making sure that each cst_id appears only once

SELECT
*
FROM (
SELECT *,
ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag
FROM bronze.crm_cust_info) t
WHERE flag = 1;

------------------------------------------------------------------------------------------------------------

-- Checking leading, trailing spaces
-- Expectation: No result, first and last names must not have unwanted spaces

SELECT
	cst_firstname,
	cst_lastname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)
OR cst_lastname != TRIM(cst_lastname)

------------------------------------------------------------------------------------------------------------

-- Check consistency of values in cst_marital_status and cst_gndr
-- Expectation: Values should be consistent

SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info;

SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info;

SELECT cst_marital_status,
CASE
	WHEN cst_marital_status = UPPER(TRIM('S')) THEN 'Single'
	WHEN cst_marital_status = UPPER(TRIM('M')) THEN 'Married'
	ELSE 'n/a'
END AS cst_marital_status
FROM bronze.crm_cust_info;

SELECT cst_gndr,
CASE
	WHEN cst_gndr = UPPER(TRIM('F')) THEN 'Female'
	WHEN cst_gndr = UPPER(TRIM('M')) THEN 'Male'
	ELSE 'n/a'
END AS cst_gndr
FROM bronze.crm_cust_info;

-- COMBINING DATA CHECK DONE AND INSERTING TO THE SILVER cst_info TABLE
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
	TRIM(cst_firstname) AS cst_firstname, 
	TRIM(cst_lastname) AS cst_firstname, 
	CASE
		WHEN cst_marital_status = UPPER(TRIM('S')) THEN 'Single'
		WHEN cst_marital_status = UPPER(TRIM('M')) THEN 'Married'
		ELSE 'n/a'
	END AS cst_marital_status, 
	CASE
		WHEN cst_gndr = UPPER(TRIM('F')) THEN 'Female'
		WHEN cst_gndr = UPPER(TRIM('M')) THEN 'Male'
		ELSE 'n/a'
	END AS cst_gndr,
	cst_create_date
FROM (
	SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL) t
WHERE flag = 1;

-- RERUN QUALITY CHECK
SELECT
	cst_id,
	COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

SELECT
	cst_firstname,
	cst_lastname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)
OR cst_lastname != TRIM(cst_lastname)

-- FINAL LOOK AT CREATED TABLE
SELECT * FROM silver.crm_cust_info;