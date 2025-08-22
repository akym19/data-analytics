/*
Script Purpose:
	Creates a stored procedure that performs ETL (Extract, Transform, Load) process to populate the 'silver' schema tables from the 'bronze' schema.

WARNING:
	This stored procedure truncates the rows in the tables. Proceed with caution.
*/

CREATE OR ALTER PROCEDURE silver.load_silver_data AS
BEGIN
--------------------------------------------------------------------------------------------------------
-- MASTER SILVER TABLE
	TRUNCATE TABLE silver.uber_bookings

	INSERT INTO silver.uber_bookings (
		date,
		time,
		booking_id,
		booking_status,
		customer_id,
		vehicle_type,
		pickup_location,
		drop_location,
		avg_vtat,
		avg_ctat,
		cancelled_rides_by_customer,
		customer_cancellation_reason,
		cancelled_rides_by_driver,
		driver_cancellation_reason,
		incomplete_rides,
		incomplete_rides_reason,
		booking_value,
		ride_distance,
		driver_ratings,
		customer_rating,
		payment_method
	)
	SELECT
		date,
		time,
		REPLACE(booking_id, '"','') AS booking_id,
		booking_status,
		REPLACE(customer_id, '"','') AS customer_id,
		vehicle_type,
		TRIM(pickup_location) AS pickup_location,
		TRIM(drop_location) AS drop_location,
		avg_vtat,
		avg_ctat,
		ISNULL(cancelled_rides_by_customer, 0) AS cancelled_rides_by_customer,
		TRIM(customer_cancellation_reason) AS customer_cancellation_reason,
		ISNULL(cancelled_rides_by_driver, 0) AS cancelled_rides_by_driver,
		TRIM(driver_cancellation_reason) AS driver_cancellation_reason,
		ISNULL(incomplete_rides, 0) AS incomplete_rides,
		TRIM(incomplete_rides_reason) AS incomplete_rides_reason,
		booking_value,
		ride_distance,
		driver_ratings,
		customer_rating,
		CASE 
        WHEN LEN(LTRIM(RTRIM(REPLACE(REPLACE(payment_method, CHAR(13), ''), CHAR(10), '')))) = 0 THEN NULL
        ELSE payment_method
    END AS payment_method
	FROM bronze.uber_bookings

--------------------------------------------------------------------------------------------------------
-- CANCELLATIONS
	TRUNCATE TABLE silver.cancellation_reasons

	INSERT INTO silver.cancellation_reasons(
		cancellation_reason_key,
		cancelled_by,
		reason
	)
	SELECT
		ROW_NUMBER() OVER(ORDER BY customer_cancellation_reason) AS customer_cancellation_key,
		cancelled_by,
		customer_cancellation_reason
	FROM
	(
		SELECT
			customer_cancellation_reason,
			COUNT(*) AS reason_count,
			CASE
				WHEN cancelled_rides_by_customer = 1 THEN 'Cancelled by Customer'
				ELSE NULL
			END AS cancelled_by
		FROM silver.uber_bookings
		WHERE customer_cancellation_reason IS NOT NULL
		GROUP BY customer_cancellation_reason, cancelled_rides_by_customer
		UNION
		SELECT
			driver_cancellation_reason,
			COUNT(*) AS reason_count,
			CASE
				WHEN cancelled_rides_by_driver = 1 THEN 'Cancelled by Driver'
				ELSE NULL
			END AS cancelled_by
		FROM silver.uber_bookings
		WHERE driver_cancellation_reason IS NOT NULL
		GROUP BY driver_cancellation_reason, cancelled_rides_by_driver
	) t

--------------------------------------------------------------------------------------------------------
-- CUSTOMERS
	TRUNCATE TABLE silver.customers

	INSERT INTO silver.customers(
		customer_key,
		customer_id
	)
	SELECT ROW_NUMBER() OVER(ORDER BY customer_id) AS customer_key,
	customer_id
	FROM (
		SELECT
			customer_id,
			COUNT(*) AS customer_count
		FROM silver.uber_bookings
		GROUP BY customer_id
	) t

--------------------------------------------------------------------------------------------------------
-- INCOMPLETE RIDES REASON
	TRUNCATE TABLE silver.incomplete_rides_reason

	INSERT INTO silver.incomplete_rides_reason(
		incomplete_rides_reason_key,
		incomplete_rides_reason
	)
	SELECT
		ROW_NUMBER() OVER(ORDER BY incomplete_rides_reason) AS incomplete_rides_reason_key,
		incomplete_rides_reason
	FROM
	(
		SELECT
			incomplete_rides_reason,
			COUNT(*) AS reason_count
		FROM silver.uber_bookings
		WHERE incomplete_rides_reason IS NOT NULL
		GROUP BY incomplete_rides_reason
	) t

--------------------------------------------------------------------------------------------------------
-- LOCATIONS
	TRUNCATE TABLE silver.locations

	INSERT INTO silver.locations(
		location_key,
		locations
	)
	SELECT
		ROW_NUMBER() OVER(ORDER BY location) AS location_key,
		location
	FROM
	(
		SELECT
			pickup_location AS location
		FROM silver.uber_bookings
		UNION
		SELECT
			drop_location AS location
		FROM silver.uber_bookings
	) t

--------------------------------------------------------------------------------------------------------
-- PAYMENT METHODS
	TRUNCATE TABLE silver.payment_methods

	INSERT INTO silver.payment_methods(
		payment_methods_key,
		payment_methods
	)
	SELECT
		ROW_NUMBER() OVER(ORDER BY payment_method) AS payment_methods_key,
		payment_method
	FROM
	(
		SELECT DISTINCT
			payment_method,
			COUNT(*) AS method_count
		FROM silver.uber_bookings
		WHERE payment_method IS NOT NULL
		GROUP BY payment_method
	) t

--------------------------------------------------------------------------------------------------------
-- VEHICLES
	TRUNCATE TABLE silver.vehicles

	INSERT INTO silver.vehicles(
		vehicle_key,
		vehicle_type
	)
	SELECT
		ROW_NUMBER() OVER(ORDER BY vehicle_type) AS vehicle_key,
		vehicle_type
	FROM
	(
		SELECT
			vehicle_type,
			COUNT(*) AS vehicle_count
		FROM silver.uber_bookings
		GROUP BY vehicle_type
	) t
END