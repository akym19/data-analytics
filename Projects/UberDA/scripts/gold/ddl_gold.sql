/*
Script Purpose:
	Creates views for the gold layer.
	Represents the final dimension and fact table (Star schema)

	Each view performs transformations and combines data from the silver layer to produce a clean, enriched
	and business-ready dataset.
*/

------------------------------------------------------------------------------------------------------------
-- Create Dimension: gold.fact_bookings
------------------------------------------------------------------------------------------------------------
	
-- Create bookings view, separating the dimensions and only adding foreign keys

IF OBJECT_ID ('gold.fact_bookings', 'V') IS NOT NULL
DROP VIEW gold.fact_bookings;
GO

CREATE VIEW gold.fact_bookings AS
SELECT
	ROW_NUMBER() OVER(ORDER BY date, time) AS booking_key,
	date,
	time,
	booking_id,
	cu.customer_key,
	booking_status,
	CASE
		WHEN booking_status = 'Cancelled by Driver' THEN 'Cancelled by Driver'
		WHEN booking_status = 'Cancelled by Customer' THEN 'Cancelled by Customer'
		ELSE NULL
	END AS cancelled_by,
	CASE
		WHEN cancelled_rides_by_customer = 1 THEN crc.cancellation_reason_key
		WHEN cancelled_rides_by_driver = 1 THEN crd.cancellation_reason_key
		ELSE NULL
	END AS cancellation_reason_key,
	vehicle_key,
	ploc.location_key AS pickup_location_key,
	dloc.location_key AS drop_location_key,
	avg_vtat,
	avg_ctat,
	irs.incomplete_rides_reason_key,
	booking_value,
	ride_distance,
	driver_ratings,
	customer_rating,
	pm.payment_methods_key
FROM silver.uber_bookings bk
LEFT JOIN silver.customers cu
ON bk.customer_id = cu.customer_id
LEFT JOIN silver.cancellation_reasons crc
ON bk.customer_cancellation_reason = crc.reason
LEFT JOIN silver.cancellation_reasons crd
ON bk.driver_cancellation_reason = crd.reason
LEFT JOIN silver.vehicles ve
ON  bk.vehicle_type = ve.vehicle_type
LEFT JOIN silver.locations ploc
ON bk.pickup_location = ploc.locations
LEFT JOIN silver.locations dloc
ON bk.drop_location = dloc.locations
LEFT JOIN silver.incomplete_rides_reason irs
ON bk.incomplete_rides_reason = irs.incomplete_rides_reason
LEFT JOIN silver.payment_methods pm
ON bk.payment_method = pm.payment_methods
GO

------------------------------------------------------------------------------------------------------------
-- Create Dimension: gold.dim_cancellation_reasons
------------------------------------------------------------------------------------------------------------
	
-- Create cancellation reasons view

IF OBJECT_ID ('gold.dim_cancellations', 'V') IS NOT NULL
DROP VIEW gold.dim_cancellations;
GO

CREATE VIEW gold.dim_cancellations AS
SELECT * FROM silver.cancellation_reasons
GO

------------------------------------------------------------------------------------------------------------
-- Create Dimension: gold.dim_customers
------------------------------------------------------------------------------------------------------------
	
-- Create customers view

IF OBJECT_ID ('gold.dim_customers', 'V') IS NOT NULL
DROP VIEW gold.dim_customers;
GO

CREATE VIEW gold.dim_customers AS
SELECT * FROM silver.customers
GO

------------------------------------------------------------------------------------------------------------
-- Create Dimension: gold.incomplete_rides_reason
------------------------------------------------------------------------------------------------------------
	
-- Create incomplete rides reasons view

IF OBJECT_ID ('gold.dim_incomplete_rides', 'V') IS NOT NULL
DROP VIEW gold.dim_incomplete_rides;
GO

CREATE VIEW gold.dim_incomplete_rides AS
SELECT * FROM silver.incomplete_rides_reason
GO

------------------------------------------------------------------------------------------------------------
-- Create Dimension: gold.locations
------------------------------------------------------------------------------------------------------------
	
-- Create locations view

IF OBJECT_ID ('gold.dim_locations', 'V') IS NOT NULL
DROP VIEW gold.dim_locations;
GO

CREATE VIEW gold.dim_locations AS
SELECT * FROM silver.locations
GO

------------------------------------------------------------------------------------------------------------
-- Create Dimension: gold.payment_methods
------------------------------------------------------------------------------------------------------------
	
-- Create payment_methods view

IF OBJECT_ID ('gold.dim_payment_methods', 'V') IS NOT NULL
DROP VIEW gold.dim_payment_methods;
GO

CREATE VIEW gold.dim_payment_methods AS
SELECT * FROM silver.payment_methods
GO

------------------------------------------------------------------------------------------------------------
-- Create Dimension: gold.vehicles
------------------------------------------------------------------------------------------------------------
	
-- Create vehicles view

IF OBJECT_ID ('gold.dim_vehicles', 'V') IS NOT NULL
DROP VIEW gold.dim_vehicles;
GO

CREATE VIEW gold.dim_vehicles AS
SELECT * FROM silver.vehicles
GO