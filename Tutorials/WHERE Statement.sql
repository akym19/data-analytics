SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

SELECT first_name, last_name, salary
FROM employee_salary
WHERE salary > 50000;

SELECT *
FROM employee_demographics
WHERE gender = 'Female';

SELECT *
FROM employee_demographics
WHERE gender = 'Female'
AND age > 30;

SELECT *
FROM employee_demographics
WHERE gender = 'Female'
OR age > 30;

#% means anything and _ means specific number of values

SELECT *
FROM employee_demographics
WHERE last_name LIKE '%er%';

SELECT *
FROM employee_demographics
WHERE first_name LIKE '___';