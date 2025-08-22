/*
	Script Purpose:
		Creates the tables in the UberDA silver schema.
		Since the bronze schema only has 1 table, this script also creates dimension tables

	Warning:
		This script drops and recreates the table if it already exists. Proceed with caution
*/

USE UberDA;
GO

IF OBJECT_ID ('silver.uber_bookings', 'U') IS NOT NULL
DROP TABLE silver.uber_bookings;
GO

CREATE TABLE silver.uber_bookings (
	date DATE,
	time TIME,
	booking_id NVARCHAR(50),
	booking_status NVARCHAR(50),
	customer_id NVARCHAR(50),
	vehicle_type NVARCHAR(50),
	pickup_location NVARCHAR(50),
	drop_location NVARCHAR(50),
	avg_vtat DECIMAL(5, 2),
	avg_ctat DECIMAL(5, 2),
	cancelled_rides_by_customer INT,
	customer_cancellation_reason NVARCHAR(50),
	cancelled_rides_by_driver INT,
	driver_cancellation_reason NVARCHAR(50),
	incomplete_rides INT,
	incomplete_rides_reason NVARCHAR(50),
	booking_value INT,
	ride_distance DECIMAL(5, 2),
	driver_ratings DECIMAL(3, 1),
	customer_rating DECIMAL(3, 1),
	payment_method NVARCHAR(50)
)

IF OBJECT_ID ('silver.customers', 'U') IS NOT NULL
DROP TABLE silver.customers
GO

CREATE TABLE silver.customers (
	customer_key INT,
	customer_id NVARCHAR(20)
)

IF OBJECT_ID ('silver.vehicles', 'U') IS NOT NULL
DROP TABLE silver.vehicles
GO

CREATE TABLE silver.vehicles (
	vehicle_key INT,
	vehicle_type NVARCHAR(20)
)

IF OBJECT_ID ('silver.locations', 'U') IS NOT NULL
DROP TABLE silver.locations
GO

CREATE TABLE silver.locations (
	location_key INT,
	locations NVARCHAR(50)
)

IF OBJECT_ID ('silver.cancellation_reasons', 'U') IS NOT NULL
DROP TABLE silver.cancellation_reasons
GO

CREATE TABLE silver.cancellation_reasons (
	cancellation_reason_key INT,
	cancelled_by NVARCHAR(30),
	reason NVARCHAR(50)
)

IF OBJECT_ID ('silver.incomplete_rides_reason', 'U') IS NOT NULL
DROP TABLE silver.incomplete_rides_reason
GO

CREATE TABLE silver.incomplete_rides_reason (
	incomplete_rides_reason_key INT,
	incomplete_rides_reason NVARCHAR(50)
)

IF OBJECT_ID ('silver.payment_methods', 'U') IS NOT NULL
DROP TABLE silver.payment_methods
GO

CREATE TABLE silver.payment_methods (
	payment_methods_key INT,
	payment_methods NVARCHAR(20)
)