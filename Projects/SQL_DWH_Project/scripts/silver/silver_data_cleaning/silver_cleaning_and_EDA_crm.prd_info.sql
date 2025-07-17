-- Checking nulls or duplicate primary key
-- Expectation: No result, meaning all primary keys should be unique

SELECT
	prd_id,
	COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

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
	CAST(
		LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt ASC) - 1 AS DATE
	) AS prd_end_dt -- Handle end date that is less than start date
FROM bronze.crm_prd_info;

------------------------------------------------------------------------------------------------------------

-- Checking leading, trailing spaces
-- Expectation: No result, first and last names must not have unwanted spaces

SELECT 
	prd_key
FROM bronze.crm_prd_info
WHERE prd_key != TRIM(prd_key);

------------------------------------------------------------------------------------------------------------

-- Check prd_end_dt quality. Should not be less than prd_start_dt
-- Expectation: No result, should be ahead of prd_start_dt

SELECT
	prd_id,
	prd_key,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

SELECT
	prd_id,
	prd_key,
	prd_start_dt,
	prd_end_dt,
	LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt ASC)-1 AS prd_end_dt_test
FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509', 'AC-HE-HL-U509-R');