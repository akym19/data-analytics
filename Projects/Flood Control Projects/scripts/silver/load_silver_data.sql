/*
Script Purpose:
	Creates a stored procedure that performs ETL (Extract, Transform, Load) process to populate the 'silver' schema table from the 'bronze' schema.

WARNING:
	This stored procedure truncates the rows in the tables. Proceed with caution.
*/


CREATE OR ALTER PROCEDURE silver.load_silver_data AS
BEGIN

	TRUNCATE TABLE silver.flood_control_projects

	INSERT INTO silver.flood_control_projects (
		ProjectID,
		Latitude,
		Longitude,
		ProjectStatus,
		ImplementingOfficeID,
		ProgramID,
		ContractorID,
		SourceOfFundsID,
		ProjectName,
		ProjectCode,
		ProjectDescription,
		CityCode,
		ZipCode,
		ProjectCost,
		UtilizedAmount,
		PlannedStartDate,
		PlannedContractCompletionDate,
		ActualContractCompletionDate,
		BarangayName,
		BarangayCode,
		ProvinceCode,
		RegionCode,
		LastUpdatedProjectCost,
		CorrespondenceCode,
		Archipelago,
		ApprovalCategoryIndex,
		ProvinceName,
		CityName,
		RegionName,
		NCRLegislativeDistrict,
		ImplementingOfficeName,
		ImplementingOfficeAbbrev,
		ProgramName,
		ProgramAbbrev,
		ProgramDescription,
		ContractorName,
		ContractorAbbrev,
		SourceOfFundsName,
		SourceOfFundsAbbrev
	)
	SELECT
		ProjectID,
		Latitude,
		Longitude,
		TRIM(ProjectStatus) AS ProjectStatus,
		ImplementingOfficeID,
		ProgramID,
		ContractorID,
		SourceOfFundsID,
		TRIM(ProjectName) AS ProjectName,
		CASE 
			WHEN ProjectCode LIKE '%E%' 
				 AND TRY_CAST(ProjectCode AS FLOAT) IS NOT NULL
				THEN CONVERT(NVARCHAR(50), 
							 CAST(TRY_CAST(ProjectCode AS FLOAT) AS DECIMAL(38,0)))
			ELSE ProjectCode
		END AS ProjectCode,
		TRIM(ProjectDescription) AS ProjectDescription,
		CityCode,
		ZipCode,
		ProjectCost,
		CASE
			WHEN ProjectStatus = 'Completed' THEN ProjectCost
			ELSE UtilizedAmount
		END AS UtilizedAmount,
		PlannedStartDate,
		PlannedContractCompletionDate,
		ActualContractCompletionDate,
		TRIM(BarangayName) AS BarangayName,
		BarangayCode,
		ProvinceCode,
		RegionCode,
		LastUpdatedProjectCost,
		CorrespondenceCode,
		TRIM(Archipelago) AS Archipelago,
		ApprovalCategoryIndex,
		TRIM(ProvinceName) AS ProvinceName,
		TRIM(CityName) AS CityName,
		TRIM(RegionName) AS RegionName,
		TRIM(NCRLegislativeDistrict) AS NCRLegislativeDistrict,
		TRIM(ImplementingOfficeName) AS ImplementingOfficeName,
		TRIM(ImplementingOfficeAbbrev) AS ImplementingOfficeAbbrev,
		TRIM(ProgramName) AS ProgramName,
		TRIM(ProgramAbbrev) AS ProgramAbbrev,
		TRIM(ProgramDescription) AS ProgramDescription,
		TRIM(ContractorName) AS ContractorName,
		TRIM(ContractorAbbrev) AS ContractorAbbrev,
		TRIM(SourceOfFundsName) AS SourceOfFundsName,
		TRIM(SourceOfFundsAbbrev) AS SourceOfFundsAbbrev
	FROM bronze.flood_control_projects

END