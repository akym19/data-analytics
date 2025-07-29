/*
	Script Purpose:
		Creates the tables in the silver schema.

	WARNING:
		This script drops and recreates the tables if they already exists.
*/

IF OBJECT_ID ('silver.categories', 'U') IS NOT NULL
DROP TABLE silver.categories;
GO

CREATE TABLE silver.categories (
	CategoryID INT,
	CategoryName NVARCHAR(50),
	CreateDate DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.cities', 'U') IS NOT NULL
DROP TABLE silver.cities;
GO

CREATE TABLE silver.cities (
	CityID INT,
	CityName NVARCHAR(50),
	Zipcode INT,
	Country INT,
	CreateDate DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.countries', 'U') IS NOT NULL
DROP TABLE silver.countries;
GO

CREATE TABLE silver.countries (
	CountryID INT,
	CountryName NVARCHAR(50),
	CountryCode NVARCHAR(2),
	CreateDate DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.customers', 'U') IS NOT NULL
DROP TABLE silver.customers;
GO

CREATE TABLE silver.customers (
	CustomerID INT,
	FirstName NVARCHAR(50),
	MiddleInitial NVARCHAR(1),
	LastName NVARCHAR(50),
	CityID INT,
	Address NVARCHAR(50),
	CreateDate DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.employees', 'U') IS NOT NULL
DROP TABLE silver.employees;
GO

CREATE TABLE silver.employees (
	EmployeeID INT,
	FirstName NVARCHAR(50),
	MiddleInitial NVARCHAR(1),
	LastName NVARCHAR(50),
	BirthDate DATE,
	Gender NVARCHAR(50),
	CityID INT,
	HireDate DATE,
	CreateDate DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.products', 'U') IS NOT NULL
DROP TABLE silver.products;
GO

CREATE TABLE silver.products (
	ProductID INT,
	ProductName NVARCHAR(50),
	Price DECIMAL(10,4),
	CategoryID INT,
	Class NVARCHAR(50),
	ModifyDate NVARCHAR(50),
	Resistant NVARCHAR(50),
	IsAllergic NVARCHAR(50),
	VitalityDays DECIMAL(10,2),
	CreateDate DATETIME2 DEFAULT GETDATE()
)

IF OBJECT_ID ('silver.sales', 'U') IS NOT NULL
DROP TABLE silver.sales;
GO

CREATE TABLE silver.sales (
	SalesID INT,
	SalesPersonID INT,
	CustomerID INT,
	ProductID INT,
	Quantity INT,
	Discount DECIMAL(10,1),
	TotalPrice DECIMAL(10,1),
	SalesDate DATETIME,
	TransactionNumber NVARCHAR(50),
	CreateDate DATETIME2 DEFAULT GETDATE()
)
