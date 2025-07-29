/*
	Script Purpose:
		Creates a stored procedure to insert data to the silver tables in the 'GroceryDB' database

	WARNING:
		This stored procedure truncates the rows in the tables. Proceed with caution.
*/
---------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROCEDURE silver.load_silver_data AS
BEGIN
	TRUNCATE TABLE silver.categories;

	INSERT INTO silver.categories (
		CategoryID,
		CategoryName
	)
	SELECT
		CategoryID,
		CategoryName
	FROM bronze.categories;
---------------------------------------------------------------------------------------------------------------------
	TRUNCATE TABLE silver.cities;

	INSERT INTO silver.cities (
		CityID,
		CityName,
		Zipcode,
		Country
	)
	SELECT
		CityID,
		CityName,
		Zipcode,
		Country
	FROM bronze.cities;
---------------------------------------------------------------------------------------------------------------------
	TRUNCATE TABLE silver.countries;

	INSERT INTO silver.countries (
		CountryID,
		CountryName,
		CountryCode
	)
	SELECT
		CountryID,
		CountryName,
		CountryCode
	FROM bronze.countries
---------------------------------------------------------------------------------------------------------------------
	TRUNCATE TABLE silver.customers;

	INSERT INTO silver.customers (
		CustomerID,
		FirstName,
		MiddleInitial,
		LastName,
		CityID,
		Address
	)
	SELECT
		CustomerID,
		FirstName,
		CASE
			WHEN MiddleInitial = 'NULL' THEN NULL
			ELSE MiddleInitial
		END AS MiddleInitial,
		LastName,
		CityID,
		Address
	FROM bronze.customers;
---------------------------------------------------------------------------------------------------------------------
	TRUNCATE TABLE silver.employees;

	INSERT INTO silver.employees (
		EmployeeID,
		FirstName,
		MiddleInitial,
		LastName,
		BirthDate,
		Gender,
		CityID,
		HireDate
	)
	SELECT
		EmployeeID,
		FirstName,
		MiddleInitial,
		LastName,
		FORMAT(BirthDate, 'yyyy-MM-dd') AS BirthDate,
		CASE
			WHEN UPPER(TRIM(Gender)) = 'F' THEN 'Female'
			WHEN UPPER(TRIM(Gender)) = 'M' THEN 'Male'
		END AS Gender,
		CityID,
		FORMAT(HireDate, 'yyyy-MM-dd') AS HireDate
	FROM bronze.employees;
---------------------------------------------------------------------------------------------------------------------
	TRUNCATE TABLE silver.products;

	INSERT INTO silver.products (
		ProductID,
		ProductName,
		Price,
		CategoryID,
		Class,
		ModifyDate,
		Resistant,
		IsAllergic,
		VitalityDays
	)
	SELECT
		ProductID,
		ProductName,
		Price,
		CategoryID,
		Class,
		ModifyDate,
		Resistant,
		IsAllergic,
		VitalityDays
	FROM bronze.products;
---------------------------------------------------------------------------------------------------------------------
	TRUNCATE TABLE silver.sales;

	INSERT INTO silver.sales (
		SalesID,
		SalesPersonID,
		CustomerID,
		ProductID,
		Quantity,
		Discount,
		TotalPrice,
		SalesDate,
		TransactionNumber
	)
	SELECT
		s.SalesID,
		s.SalesPersonID,
		s.CustomerID,
		s.ProductID,
		s.Quantity,
		s.Discount,
		(s.Quantity * p.Price) - s.Discount AS TotalPrice,
		s.SalesDate,
		s.TransactionNumber
	FROM bronze.sales s
	LEFT JOIN silver.products p
	ON s.ProductID = p.productID;
---------------------------------------------------------------------------------------------------------------------
END
