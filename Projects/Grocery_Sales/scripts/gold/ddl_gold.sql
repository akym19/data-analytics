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
-- From the data model, tables used were customers, cities, countries

IF OBJECT_ID ('gold.dim_customers', 'V') IS NOT NULL
DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
	SELECT
		ROW_NUMBER() OVER(ORDER BY CustomerID) AS CustomerKey,
		cu.CustomerID,
		cu.FirstName,
		cu.MiddleInitial,
		cu.LastName,
		cu.Address,
		ci.CityName AS City,
		ci.Zipcode,
		co.CountryName AS Country
	FROM silver.customers cu
	LEFT JOIN silver.cities ci
	ON cu.CityID = ci.CityID
	LEFT JOIN silver.countries co
	ON ci.Country = co.CountryID
GO

------------------------------------------------------------------------------------------------------------
-- Create Dimension: gold.dim_employees
------------------------------------------------------------------------------------------------------------

-- Create employee dimension based on joined tables
-- From the data model, tables used were employees, cities, countries

IF OBJECT_ID ('gold.dim_employees', 'V') IS NOT NULL
DROP VIEW gold.dim_employees;
GO

CREATE VIEW gold.dim_employees AS
	SELECT
		ROW_NUMBER() OVER(ORDER BY EmployeeID) AS EmployeeKey,
		e.EmployeeID,
		e.FirstName,
		e.MiddleInitial,
		e.LastName,
		e.Gender,
		e.BirthDate,
		e.HireDate,
		ci.CityName AS City,
		ci.Zipcode,
		co.CountryName AS Country
	FROM silver.employees e
	LEFT JOIN silver.cities ci
	ON e.CityID = ci.CityID
	LEFT JOIN silver.countries co
	ON ci.Country = co.CountryID
GO

------------------------------------------------------------------------------------------------------------
-- Create Dimension: gold.dim_products
------------------------------------------------------------------------------------------------------------

-- Create product dimension based on joined tables
-- From the data model, tables used were products, categories

IF OBJECT_ID ('gold.dim_products', 'V') IS NOT NULL
DROP VIEW gold.dim_products
GO

CREATE VIEW gold.dim_products AS
	SELECT
		ROW_NUMBER() OVER(ORDER BY ProductID) AS ProductKey,
		p.ProductID,
		p.ProductName,
		p.Price,
		c.CategoryName AS Category,
		p.Class,
		p.ModifyDate,
		p.Resistant,
		p.IsAllergic,
		p.VitalityDays
	FROM silver.products p
	LEFT JOIN silver.categories c
	ON p.CategoryID = c.CategoryID
GO

------------------------------------------------------------------------------------------------------------
-- Create Dimension: gold.fact_sales
------------------------------------------------------------------------------------------------------------

-- Create fact sales based on joined tables
-- From the data model, tables used where sales, employees, customers, products

IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
DROP VIEW gold.fact_sales
GO

CREATE VIEW gold.fact_sales AS
	SELECT
		TOP 1000
		s.SalesID,
		e.EmployeeKey,
		c.CustomerKey,
		p.ProductKey,
		p.Price,
		s.Quantity,
		s.Discount,
		s.TotalPrice AS Sales,
		s.SalesDate,
		s.TransactionNumber
	FROM silver.sales s
	LEFT JOIN gold.dim_employees e
	ON s.SalesPersonID = e.EmployeeID
	LEFT JOIN gold.dim_customers c
	ON s.CustomerID = c.CustomerID
	LEFT JOIN gold.dim_products p
	ON s.ProductID = p.ProductID
GO
