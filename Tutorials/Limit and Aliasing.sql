SELECT *
FROM employee_demographics
LIMIT 3;

SELECT first_name, last_name, age
FROM employee_demographics
ORDER BY age DESC
LIMIT 5;

SELECT first_name, last_name, age
FROM employee_demographics
ORDER BY age DESC
LIMIT 3, 1;

SELECT gender, avg(age) AS avg_age
FROM employee_demographics
GROUP BY gender;