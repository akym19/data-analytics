SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;

SELECT *
FROM parks_departments;

#JOIN by default is INNER JOIN

SELECT *
FROM employee_demographics
JOIN employee_salary
ON employee_demographics.employee_id = employee_salary.employee_id;

SELECT *
FROM employee_demographics as ed
JOIN employee_salary as es
ON ed.employee_id = es.employee_id;

SELECT ed.employee_id, ed.first_name, ed.last_name, occupation, salary, department_name
FROM employee_demographics as ed
JOIN employee_salary as es
ON ed.employee_id = es.employee_id
JOIN parks_departments as pd
ON es.dept_id = pd.department_id;

#OUTER JOINS

SELECT *
FROM employee_demographics
LEFT JOIN employee_salary
ON employee_demographics.employee_id = employee_salary.employee_id;

SELECT *
FROM employee_demographics
RIGHT JOIN employee_salary
ON employee_demographics.employee_id = employee_salary.employee_id;

SELECT *
FROM employee_salary
LEFT JOIN employee_demographics
ON employee_demographics.employee_id = employee_salary.employee_id;

#SELF JOIN

SELECT emp1.employee_id as emp_santa, emp1.first_name, emp1.last_name, emp2.employee_id, emp2.first_name, emp2.last_name
FROM employee_salary as emp1
JOIN employee_salary as emp2
ON emp1.employee_id + 1 = emp2.employee_id;