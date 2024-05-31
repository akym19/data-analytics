#selecting employees who works in parks and recreation department

#SUBQUERY IN WHERE
SELECT *
FROM employee_demographics
WHERE employee_id IN
(
SELECT employee_id
FROM employee_salary
WHERE dept_id = 1
);

#SUBQUERY IN SELECT

SELECT first_name, salary,
(SELECT AVG(salary)
FROM employee_salary)
FROM employee_salary;

#SUBQUERY IN FROM

SELECT *
FROM employee_demographics;

SELECT gender, AVG(age), MAX(age), MIN(age), COUNT(age)
FROM employee_demographics
GROUP BY gender;

SELECT AVG(max_age)
FROM (SELECT gender, AVG(age) ave_age, MAX(age) max_age, MIN(age) min_age, COUNT(age)
FROM employee_demographics
GROUP BY gender) AS agg_table;