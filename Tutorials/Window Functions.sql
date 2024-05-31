SELECT gender, AVG(salary) AS avg_salary
FROM employee_demographics dem
JOIN employee_salary sal
ON dem.employee_id = sal.employee_id
GROUP BY gender;

#The below query shows the average salary based of the different gender and shows the result on each row instead of only returning 2 rows from the above query

SELECT dem.first_name, dem.last_name, sal.salary, gender, AVG(salary) OVER(PARTITION BY gender)
FROM employee_demographics dem
JOIN employee_salary sal
ON dem.employee_id = sal.employee_id;

SELECT dem.first_name, dem.last_name, sal.salary, gender, SUM(salary) OVER(PARTITION BY gender ORDER BY dem.employee_id)
FROM employee_demographics dem
JOIN employee_salary sal
ON dem.employee_id = sal.employee_id;

SELECT dem.first_name, dem.last_name, sal.salary, gender, ROW_NUMBER() OVER(PARTITION BY gender)
FROM employee_demographics dem
JOIN employee_salary sal
ON dem.employee_id = sal.employee_id;

SELECT dem.first_name, dem.last_name, sal.salary, gender, ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC)
FROM employee_demographics dem
JOIN employee_salary sal
ON dem.employee_id = sal.employee_id;

SELECT dem.first_name, dem.last_name, sal.salary, gender,
ROW_NUMBER() OVER(PARTITION BY gender ORDER BY salary DESC) row_num, #just shows the rows
RANK() OVER(PARTITION BY gender ORDER BY salary DESC) rank_num, #will duplicate based on given criteria to group
DENSE_RANK() OVER(PARTITION BY gender ORDER BY salary DESC) dense_rank_num #same with rank but will continue the number to next rank
FROM employee_demographics dem
JOIN employee_salary sal
ON dem.employee_id = sal.employee_id;