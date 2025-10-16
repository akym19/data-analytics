/*
	Script Purpose:
		Creates the table in the FloodControl bronze schema

	Warning:
		This script drops and recreates the table if it already exists. Proceed with caution
*/

USE FloodControl;
GO

IF OBJECT_ID ('bronze.flood_control_projects', 'U') IS NOT NULL
DROP TABLE bronze.flood_control_projects;
GO

CREATE TABLE bronze.flood_control_projects (
	ProjectID INT,
	Latitude DECIMAL (18, 9),
	Longitude DECIMAL (18, 9),
	ProjectStatus NVARCHAR(20),
	ImplementingOfficeID INT,
	ProgramID INT,
	ContractorID INT,
	SourceOfFundsID INT,
	ProjectName NVARCHAR(610),
	ProjectCode NVARCHAR(30),
	ProjectDescription NVARCHAR(760),
	CityCode INT,
	ZipCode INT,
	ProjectCost INT,
	UtilizedAmount INT,
	PlannedStartDate DATE,
	PlannedContractCompletionDate DATE,
	ActualContractCompletionDate NVARCHAR(50),
	BarangayName NVARCHAR(35),
	BarangayCode INT,
	ProvinceCode INT,
	RegionCode INT,
	LastUpdatedProjectCost DATE,
	CorrespondenceCode INT,
	Archipelago NVARCHAR(15),
	ApprovalCategoryIndex INT,
	ProvinceName NVARCHAR(20),
	CityName NVARCHAR(35),
	RegionName NVARCHAR(60),
	NCRLegislativeDistrict NVARCHAR(20),
	ImplementingOfficeName NVARCHAR(45),
	ImplementingOfficeAbbrev NVARCHAR(10),
	ProgramName NVARCHAR(30),
	ProgramAbbrev NVARCHAR(20),
	ProgramDescription NVARCHAR(250),
	ContractorName NVARCHAR(200),
	ContractorAbbrev NVARCHAR(25),
	SourceOfFundsName NVARCHAR(35),
	SourceOfFundsAbbrev NVARCHAR(15)
)
