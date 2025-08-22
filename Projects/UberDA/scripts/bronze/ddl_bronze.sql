/*
	Script Purpose:
		Creates the table in the UberDA bronze schema

	Warning:
		This script drops and recreates the table if it already exists. Proceed with caution
*/

USE UberDA;
GO

IF OBJECT_ID ('bronze.uber_bookings', 'U') IS NOT NULL
DROP TABLE bronze.uber_bookings;
GO

CREATE TABLE bronze.uber_bookings (
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