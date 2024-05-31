SELECT *
FROM employee_demographics;

SELECT first_name, last_name, birth_date, age, age+10 AS added_age
FROM employee_demographics;

SELECT DISTINCT gender
FROM employee_demographics;