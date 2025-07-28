/*
	Script Purpose:
		Creates the tables in the bronze schema.

	WARNING:
		This script drops and recreates the tables if they already exists.
*/

IF OBJECT_ID ('bronze.categories', 'U') IS NOT NULL
DROP TABLE bronze.categories;
GO

CREATE TABLE bronze.categories (
	CategoryID INT,
	CategoryName NVARCHAR(50)
);

IF OBJECT_ID ('bronze.cities', 'U') IS NOT NULL
DROP TABLE bronze.cities;
GO

CREATE TABLE bronze.cities (
	CityID INT,
	CityName NVARCHAR(50),
	Zipcode INT,
	Country NVARCHAR(50)
);

IF OBJECT_ID ('bronze.countries', 'U') IS NOT NULL
DROP TABLE bronze.countries;
GO

CREATE TABLE bronze.countries (
	CountryID INT,
	CountryName NVARCHAR(50),
	CountryCode NVARCHAR(2)
);

IF OBJECT_ID ('bronze.customers', 'U') IS NOT NULL
DROP TABLE bronze.customers;
GO

CREATE TABLE bronze.customers (
	CustomerID INT,
	FirstName NVARCHAR(50),
	MiddleInitial NVARCHAR(4),
	LastName NVARCHAR(50),
	CityID INT,
	Address NVARCHAR(50)
);

IF OBJECT_ID ('bronze.employees', 'U') IS NOT NULL
DROP TABLE bronze.employees;
GO

CREATE TABLE bronze.employees (
	EmployeeID INT,
	FirstName NVARCHAR(50),
	MiddleInitial NVARCHAR(1),
	LastName NVARCHAR(50),
	BirthDate DATETIME,
	Gender NVARCHAR(50),
	HireDate NVARCHAR(50)
);

IF OBJECT_ID ('bronze.products', 'U') IS NOT NULL
DROP TABLE bronze.products;
GO

CREATE TABLE bronze.products (
	ProductID INT,
	ProductName NVARCHAR(50),
	Price DECIMAL(10,5),
	CategoryID INT,
	Class NVARCHAR(50),
	ModifyDate NVARCHAR(50),
	Resistant NVARCHAR(50),
	IsAllergic NVARCHAR(50),
	VitalityDays DECIMAL(10,5),
)

IF OBJECT_ID ('bronze.sales', 'U') IS NOT NULL
DROP TABLE bronze.sales;
GO

CREATE TABLE bronze.sales (
	SalesID INT,
	SalesPersonID INT,
	CustomerID INT,
	ProductID INT,
	Quantity INT,
	Discount DECIMAL(10,5),
	TotalPrice DECIMAL(10,5),
	SalesDate DATETIME,
	TransactionNumber NVARCHAR(50)
)
