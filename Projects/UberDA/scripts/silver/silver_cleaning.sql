/*
	Script Purpose:
		Queries to clean the bronze table prior importing to silver table

	Warning:
		This script drops and recreates the table if it already exists. Proceed with caution
*/

-- Rows with avg_vtat and avg_ctat is null will not be imported in silver
SELECT * FROM bronze.uber_bookings
WHERE avg_vtat IS NOT NULL AND avg_ctat IS NOT NULL;

--------------------------------------------------------------------------------------------
-- Dataset contains year 2024 bookings only. Checking if any booking before or after 2024 is present in the dataset

SELECT date
FROM bronze.uber_bookings
WHERE date < '2024-01-01'
OR date > '2024-12-31';

--------------------------------------------------------------------------------------------
-- Checking booking_id

SELECT
	REPLACE(booking_id, '"','') AS booking_id,
	COUNT(*) AS counts
FROM bronze.uber_bookings
GROUP BY booking_id
HAVING COUNT(*) > 1

--Found duplicates in booking_id, diving further

WITH duplicates AS (
SELECT
	REPLACE(booking_id, '"','') AS booking_id,
	COUNT(*) AS counts
FROM bronze.uber_bookings
GROUP BY booking_id
HAVING COUNT(*) > 1
),
allbookings AS (
SELECT [date]
      ,[time]
      ,REPLACE(booking_id, '"','') AS booking_id
      ,[booking_status]
      ,[customer_id]
      ,[payment_method]
FROM bronze.uber_bookings)
SELECT ab.*
FROM allbookings ab
JOIN duplicates d 
    ON ab.booking_id = d.booking_id
ORDER BY booking_id;

SELECT booking_id, COUNT(DISTINCT customer_id) AS unique_customers
FROM bronze.uber_bookings
GROUP BY booking_id
HAVING COUNT(DISTINCT customer_id) > 1

--Looks like there are duplicate booking_id with for different rides. Will assign surrogate keys for rides in the gold layer

SELECT REPLACE(booking_id, '"','')
FROM bronze.uber_bookings;

SELECT DISTINCT booking_id
FROM bronze.uber_bookings;

--------------------------------------------------------------------------------------------
-- Checking low cardinality column booking_status
SELECT booking_status
FROM bronze.uber_bookings
WHERE booking_status != TRIM(booking_status);

SELECT DISTINCT booking_status
FROM bronze.uber_bookings;

--------------------------------------------------------------------------------------------
-- Checking customer_id
SELECT REPLACE(customer_id, '"','')
FROM bronze.uber_bookings;

--------------------------------------------------------------------------------------------
-- Checking low cardinality column vehicle_type
SELECT vehicle_type
FROM bronze.uber_bookings
WHERE vehicle_type != TRIM(vehicle_type);

SELECT DISTINCT vehicle_type
FROM bronze.uber_bookings;

--------------------------------------------------------------------------------------------
-- Checking pickup_location
SELECT pickup_location
FROM bronze.uber_bookings
WHERE pickup_location != TRIM(pickup_location);

SELECT DISTINCT pickup_location
FROM bronze.uber_bookings;

--------------------------------------------------------------------------------------------
-- Checking drop_location
SELECT drop_location
FROM bronze.uber_bookings
WHERE drop_location != TRIM(drop_location);

SELECT DISTINCT drop_location
FROM bronze.uber_bookings;

--------------------------------------------------------------------------------------------
-- Checking avg_vtat
SELECT MIN(avg_vtat), MAX(avg_vtat)
FROM bronze.uber_bookings;

--------------------------------------------------------------------------------------------
-- Checking avg_ctat
SELECT MIN(avg_ctat), MAX(avg_ctat)
FROM bronze.uber_bookings;

--------------------------------------------------------------------------------------------
-- Checking cancelled_rides_by_customer
SELECT DISTINCT cancelled_rides_by_customer
FROM bronze.uber_bookings;

SELECT ISNULL(cancelled_rides_by_customer, 0)
FROM bronze.uber_bookings;

--------------------------------------------------------------------------------------------
-- Checking customer_cancellation_reason
SELECT DISTINCT customer_cancellation_reason
FROM bronze.uber_bookings;

SELECT customer_cancellation_reason
FROM bronze.uber_bookings
WHERE customer_cancellation_reason != TRIM(customer_cancellation_reason);

SELECT
	booking_status,
	cancelled_rides_by_customer
FROM bronze.uber_bookings
WHERE booking_status = 'Cancelled by Customer'
AND cancelled_rides_by_customer IS NOT NULL;

--------------------------------------------------------------------------------------------
-- Checking cancelled_rides_by_driver
SELECT DISTINCT cancelled_rides_by_driver
FROM bronze.uber_bookings;

SELECT ISNULL(cancelled_rides_by_driver, 0)
FROM bronze.uber_bookings;

--------------------------------------------------------------------------------------------
-- Checking driver_cancellation_reason
SELECT DISTINCT driver_cancellation_reason
FROM bronze.uber_bookings;

SELECT driver_cancellation_reason
FROM bronze.uber_bookings
WHERE driver_cancellation_reason != TRIM(driver_cancellation_reason);

SELECT
	booking_status,
	cancelled_rides_by_driver
FROM bronze.uber_bookings
WHERE booking_status = 'Completed'
AND cancelled_rides_by_driver IS NOT NULL;

--------------------------------------------------------------------------------------------
-- Checking incomplete_rides
SELECT DISTINCT incomplete_rides
FROM bronze.uber_bookings;

SELECT ISNULL(incomplete_rides, 0)
FROM bronze.uber_bookings;

--------------------------------------------------------------------------------------------
-- Checking incomplete_rides_reason
SELECT DISTINCT incomplete_rides_reason
FROM bronze.uber_bookings;

SELECT
	booking_status,
	incomplete_rides_reason
FROM bronze.uber_bookings
WHERE booking_status = 'Incomplete'
AND incomplete_rides_reason IS NOT NULL;
/* 
No Driver Found
Cancelled by Customer
Incomplete
Cancelled by Driver
Completed
*/

--------------------------------------------------------------------------------------------
-- Checking booking_value
SELECT MIN(booking_value) minv, MAX(booking_value) maxv, AVG(booking_value) avgv
FROM bronze.uber_bookings;

SELECT PERCENTILE_CONT(0.5)
	WITHIN GROUP (ORDER BY booking_value)
	OVER () AS median
FROM bronze.uber_bookings;

SELECT booking_value
FROM bronze.uber_bookings
WHERE booking_value IS NOT NULL
ORDER BY booking_value ASC;

SELECT
	booking_value,
	CASE
		WHEN booking_value <= 200 THEN 'Low Fare'
		WHEN booking_value <= 800 THEN 'Economy Fare'
		WHEN booking_value <= 2000 THEN 'Mid-High Fare'
		WHEN booking_value <= 3000 THEN 'High Fare'
		WHEN booking_value > 3000 THEN 'Premium Fare'
		ELSE NULL
	END AS fare_category
FROM bronze.uber_bookings;

--------------------------------------------------------------------------------------------
-- Checking ride_distance
SELECT MIN(ride_distance) minD, MAX(ride_distance) maxD, AVG(ride_distance) avgD
FROM bronze.uber_bookings;

SELECT PERCENTILE_CONT(0.5)
	WITHIN GROUP (ORDER BY ride_distance)
	OVER () AS median
FROM bronze.uber_bookings;

SELECT
	ride_distance,
	booking_value,
	fare_category,
	vehicle_type
FROM (
SELECT
	booking_value,
	CASE
		WHEN booking_value <= 200 THEN 'Low Fare'
		WHEN booking_value <= 800 THEN 'Economy Fare'
		WHEN booking_value <= 2000 THEN 'Mid-High Fare'
		WHEN booking_value <= 3000 THEN 'High Fare'
		WHEN booking_value > 3000 THEN 'Premium Fare'
		ELSE NULL
	END AS fare_category,
	ride_distance,
	vehicle_type
FROM bronze.uber_bookings )t
WHERE fare_category = 'Premium Fare'
ORDER BY ride_distance ASC;

--------------------------------------------------------------------------------------------
-- Checking driver_ratings
SELECT MIN(driver_ratings) minR, MAX(driver_ratings) maxR, AVG(driver_ratings) avgR
FROM bronze.uber_bookings;

SELECT PERCENTILE_CONT(0.5)
	WITHIN GROUP (ORDER BY driver_ratings)
	OVER () AS median
FROM bronze.uber_bookings;

--------------------------------------------------------------------------------------------
-- Checking customer_rating
SELECT MIN(customer_rating) minR, MAX(customer_rating) maxR, AVG(customer_rating) avgR
FROM bronze.uber_bookings;

SELECT PERCENTILE_CONT(0.5)
	WITHIN GROUP (ORDER BY customer_rating)
	OVER () AS median
FROM bronze.uber_bookings;

--------------------------------------------------------------------------------------------
-- Checking payment_method
SELECT payment_method
FROM bronze.uber_bookings
WHERE payment_method != TRIM(payment_method);

SELECT DISTINCT TRIM(payment_method)
FROM bronze.uber_bookings;

SELECT DISTINCT
	payment_method
FROM bronze.uber_bookings
WHERE UNICODE(LEFT(payment_method, 1)) = 13;