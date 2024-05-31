SELECT *
FROM employee_demographics
UNION
SELECT *
FROM employee_salary;

SELECT first_name, last_name
FROM employee_demographics
UNION DISTINCT
SELECT first_name, last_name
FROM employee_salary;

SELECT first_name, last_name
FROM employee_demographics
UNION ALL
SELECT first_name, last_name
FROM employee_salary;

#Let's say the company wants to lay off people older than 50yrs and those with salary higher than 70000
#firstly examine the tables

SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

#query for above use case

SELECT first_name, last_name, 'Old' AS Label
FROM employee_demographics
WHERE age > 50
UNION
SELECT first_name, last_name, 'Highly Paid' AS Label
FROM employee_salary
WHERE salary > 70000;