#CASE Statements are just like if/else statements

SELECT *
FROM employee_demographics
ORDER BY age DESC;

SELECT first_name, last_name,
CASE
    WHEN age <= 30 THEN "Young"
	WHEN age > 30 AND age < 40 THEN "Adult" #this can also be 'BETWEEN 30 AND 40'
    WHEN age >= 40 THEN "Old"
END AS 'Label'
FROM employee_demographics;

# <= 50000 = 5%
# > 50000 = 7%
# Finance dept = 10%

SELECT *
FROM employee_salary;

SELECT *
FROM parks_departments;

SELECT first_name, last_name, salary, department_name,
CASE
	WHEN salary <= 50000 THEN salary + salary*0.05
    WHEN salary > 50000 THEN salary + salary*0.07
END AS "Salary_Raise",
CASE
    WHEN dept_id = 6 THEN salary*0.1
END AS "Finance_Bonus"
FROM employee_salary
JOIN parks_departments
ON employee_salary.dept_id = parks_departments.department_id
ORDER BY Salary_Raise DESC;