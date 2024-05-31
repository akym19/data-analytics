SELECT *
FROM layoffs;

#1. Remove duplicates
#2. Standardize the Data
#3. Null values or blank values
#4. Remove any columns

#CREATE STAGING TABLE

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT *
FROM layoffs_staging;

INSERT INTO layoffs_staging
SELECT *
FROM layoffs;

#CLEANING DUPLICATES
#using ROW_NUMBER() function and PARTITION BY(), match against all columns to check for more than 1 row, means there are duplicates
#then use CTE or temp table to check for more than 1 rows

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

WITH duplicates AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicates
WHERE row_num > 1;

#checking if the results are really duplicates

SELECT *
FROM layoffs_staging
WHERE company IN ('Casper', 'Cazoo', 'Hibob', 'Wildlife Studios', 'Yahoo')
ORDER BY company;

#I now confirm the rows are duplicates through CTE and PARTITION BY columns

#CREATE ANOTHER STAGING TABLE

DROP TABLE IF EXISTS layoffs_staging_2;
CREATE TABLE `layoffs_staging_2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_staging_2;

INSERT INTO layoffs_staging_2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging_2
WHERE row_num > 1;

#DELETING DUPLICATES

DELETE
FROM layoffs_staging_2
WHERE row_num > 1;

#STANDARDIZING DATA. Finding issues in the data and then fixing it

#Trimming

SELECT company, TRIM(company)
FROM layoffs_staging_2;

UPDATE layoffs_staging_2
SET company = TRIM(company);

#Examining industry

SELECT DISTINCT industry
FROM layoffs_staging_2
ORDER BY 1;

SELECT industry
FROM layoffs_staging_2
WHERE industry LIKE '%crypto%';

UPDATE layoffs_staging_2
SET industry = 'Crypto'
WHERE industry LIKE '%crypto%';

#Examining location

SELECT DISTINCT location
FROM layoffs_staging_2
ORDER BY 1;

#Examining country

SELECT DISTINCT country
FROM layoffs_staging_2
ORDER BY 1;

SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging_2
ORDER BY 1;

UPDATE layoffs_staging_2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE '%.%';

#Examining date

SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_staging_2;

#Updating date format

UPDATE layoffs_staging_2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

SELECT `date`
FROM layoffs_staging_2;

#Altering date datatype

ALTER TABLE layoffs_staging_2
MODIFY COLUMN `date` DATE;

#BLANKS AND NULLS

SELECT *
FROM layoffs_staging_2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

#Examining industry

SELECT *
FROM layoffs_staging_2
WHERE industry IS NULL
OR industry = '';

#Returns rows where industry in tbl1 is null or blank and industry in tbl2 is not null or not blank

SELECT *
FROM layoffs_staging_2 tbl1
JOIN layoffs_staging_2 tbl2
	ON tbl1.company = tbl2.company
	AND tbl1.location = tbl2.location
WHERE tbl1.industry IS NULL OR tbl1.industry = ''
AND tbl2.industry IS NOT NULL;

SELECT tbl1.company, tbl1.industry, tbl2.company, tbl2.industry
FROM layoffs_staging_2 tbl1
JOIN layoffs_staging_2 tbl2
	ON tbl1.company = tbl2.company
	AND tbl1.location = tbl2.location
WHERE tbl1.industry IS NULL OR tbl1.industry = ''
AND tbl2.industry IS NOT NULL;

UPDATE layoffs_staging_2
SET industry = NULL
WHERE industry = '';

UPDATE layoffs_staging_2 tbl1
JOIN layoffs_staging_2 tbl2
	ON tbl1.company = tbl2.company
SET tbl1.industry = tbl2.industry
WHERE (tbl1.company = tbl2.company AND tbl1.industry IS NULL AND tbl2.industry IS NOT NULL)
OR (tbl1.company = tbl2.company AND tbl1.industry = '' AND tbl2.industry IS NOT NULL);

SELECT *
FROM layoffs_staging_2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging_2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT *
FROM layoffs_staging_2;

ALTER TABLE layoffs_staging_2
DROP COLUMN row_num;