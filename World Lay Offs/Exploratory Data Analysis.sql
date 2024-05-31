SELECT *
FROM layoffs_staging_2;

SELECT company, industry, total_laid_off, percentage_laid_off, total_laid_off/percentage_laid_off AS total_employees
FROM layoffs_staging_2;

#looking for max total laid off

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging_2;

SELECT *
FROM layoffs_staging_2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT *
FROM layoffs_staging_2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

#LOOKING AT COMPANIES WITH MOST LAID OFF EMPLOYEES

SELECT company, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY company
ORDER BY 2 DESC;

#LOOKING AT INDUSTRIES WITH MOST LAID OFF EMPLOYEES

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY industry
ORDER BY 2 DESC;

#LOOKING AT COUNTRY WITH MOST LAID OFF EMPLOYEES

SELECT country, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY country
ORDER BY 2 DESC;

#LOOKING AT LAID OFF BY YEARS

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

#LOOKING AT LAID OFF BY STAGE

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY stage
ORDER BY 2 DESC;

#TOTAL LAID OFFS PER MONTH

SELECT SUBSTRING(`date`,  1, 7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging_2
WHERE SUBSTRING(`date`,  1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ;

#ROLLING TOTAL LAID OFFS PER MONTH

WITH Rolling_Laid_Off AS
(
SELECT SUBSTRING(`date`,  1, 7) AS `MONTH`, SUM(total_laid_off) AS sum_laid_off
FROM layoffs_staging_2
WHERE SUBSTRING(`date`,  1, 7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 
)
SELECT `MONTH`, sum_laid_off, SUM(sum_laid_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Laid_Off;

#COMPANY LAID OFF PER YEAR

SELECT company, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY company
ORDER BY 2 DESC;

SELECT company, YEAR(`date`) AS year, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY company, `date`
ORDER BY 3 DESC;

#Ranking company laid offs

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`) AS year, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY company, `date`
)
SELECT *,
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking #grouping results by eyar then applies rankings in the order by clause which is total laid off
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY Ranking ASC;

#Filtering above by <= 5 only

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`) AS year, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY company, `date`
), Company_Year_Rank AS
(
SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
ORDER BY Ranking ASC
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;


SELECT *
FROM layoffs_staging_2;
