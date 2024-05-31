SELECT *
FROM employee_demographics;

SELECT first_name, LENGTH(first_name)
FROM employee_demographics;

SELECT first_name, UPPER(first_name)
FROM employee_demographics;

SELECT first_name, LOWER(first_name)
FROM employee_demographics;

#TRIM removes spaces from both side, LTRIM from the left, RTRIM from the right

#LEFT and RIGHT returns number of characters with provided number

SELECT first_name, LEFT(first_name, 2), RIGHT(first_name, 2)
FROM employee_demographics;

#SUBSTRING
#SUBSTRING(COLUMN, POSITION, NUMBER OF CHARACTERS)

SELECT first_name, SUBSTRING(first_name, 3, 2)
FROM employee_demographics;

#REPLACE
#SUBSTRING(COLUMN, WHAT TO REPLACE, WHAT TO REPLACE WITH) - case sensitive

SELECT first_name, REPLACE(first_name, 'o', 'a')
FROM employee_demographics;

#LOCATE
#LOCATE(CHARACTER/S, VALUE)
#RETURNS POSITION OF CHARACTER FROM A GIVEN VALUE

SELECT first_name, LOCATE('o', first_name)
FROM employee_demographics;

#CONCATENATION - COMBINES COLUMNS

SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM employee_demographics;