
SELECT
	*
FROM silver.crm_cust_info


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

SELECT gen
FROM bronze.erp_cust_az12
WHERE gen != TRIM(gen);

SELECT DISTINCT gen FROM bronze.erp_cust_az12;