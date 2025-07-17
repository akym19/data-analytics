/*
Script Purpose:
	Creates views for the gold layer.
	Represents the final dimension and fact table (Star schema)

	Each view performs transformations and combines data from the silver layer to produce a clean, enriched
	and business-ready dataset.
*/

------------------------------------------------------------------------------------------------------------
-- Create Dimension: gold.dim_customers
------------------------------------------------------------------------------------------------------------

-- Create customer dimension based on joined tables
-- From the data model, tables to use will be crm_cust_info, erp_cust_az12, erp_loc_a101

IF OBJECT_ID ('gold.dim_customers', 'V') IS NOT NULL
DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT
	ROW_NUMBER() OVER(ORDER BY ci.cst_id) AS customer_key,
	ci.cst_id				AS customer_id,
	ci.cst_key				AS customer_number,
	ci.cst_firstname		AS first_name,
	ci.cst_lastname			AS last_name,
	la.cntry				AS country,
	ci.cst_marital_status	AS marital_status,
	CASE
		WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		ELSE COALESCE(ca.gen, 'n/a')
	END						AS gender,
	ca.bdate				AS birthdate,
	ci.cst_create_date		AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid; 
GO

------------------------------------------------------------------------------------------------------------
-- Create Dimension: gold.dim_customers
------------------------------------------------------------------------------------------------------------

-- Create product dimension based on joined tables
-- From the data model, tables to use will be crm_prd_info, erp_px_cat_g1v2

CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER(ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
	pn.prd_id			AS product_id,
	pn.prd_key			AS product_number,
	pn.prd_nm			AS product_name,
	pn.cat_id			AS category_id,
	pc.cat				AS category,
	pc.subcat			AS sucategory,
	pc.maintenance		AS maintenance,
	pn.prd_cost			AS cost,
	pn.prd_line			AS product_line,
	pn.prd_start_dt		AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE pn.prd_end_dt IS NULL; --Filters historical data
GO

------------------------------------------------------------------------------------------------------------
-- Create Dimension: gold.fact_sales
------------------------------------------------------------------------------------------------------------

CREATE VIEW gold.fact_sales AS 
SELECT
	sd.sls_ord_num		AS order_number,
	pr.product_key		AS product_key,
	cu.customer_key		AS customer_key,
	sd.sls_order_dt		AS order_date,
	sd.sls_ship_dt		AS shipping_date,
	sd.sls_due_dt		AS due_date,
	sd.sls_sales		AS sales_amount,
	sd.sls_quantity		AS quantity,
	sd.sls_price		AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id;
GO
