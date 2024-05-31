SELECT *
from employee_demographics;

SELECT gender, count(gender)
FROM employee_demographics
GROUP BY gender;

SELECT gender, AVG(age), max(age), min(age), count(age)
FROM employee_demographics
GROUP BY gender;

SELECT *
FROM employee_salary
ORDER BY salary DESC;

SELECT *
FROM parks_departments;

SELECT dept_id, avg(salary)
FROM employee_salary
JOIN parks_departments
ON employee_salary.dept_id = parks_departments.department_id
GROUP BY dept_id;