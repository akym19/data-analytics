#CTEs

WITH CTE_Example AS
(
SELECT gender, AVG(salary) avg_sal, MAX(salary), MIN(salary), COUNT(salary)
FROM employee_demographics
JOIN employee_salary
ON employee_demographics.employee_id = employee_salary.employee_id
GROUP BY gender
)
SELECT AVG(avg_sal)
FROM CTE_Example;

#Multiple CTEs

WITH CTE_Example AS
(
SELECT employee_id, gender, birth_date
FROM employee_demographics
WHERE birth_date > '1985-01-01'
),
CTE_Example2 AS
(
SELECT employee_id, salary
FROM employee_salary
WHERE salary > 50000
)
SELECT *
FROM CTE_Example
JOIN CTE_Example2
ON CTE_Example.employee_id = CTE_Example2.employee_id;