-- SQL Assessment: Employees & Sales Database

-- (These tasks were completed using the 'people' database created during the D4 session.)

--------------------------------------------------------------------------------------------------------------------------------
-- TASK 1 - Query Challenges

-- 1) List the first name, last name, and salary of all employees who earn more than the average salary in the company.-- method 1: finding the average salary and hard-coding the value into another SELECT statement.SELECT ROUND(AVG(salary),2)FROM employees; -- returns the average salary to 2.d.p.SELECT first_name, last_name, salaryFROM employeesWHERE salary > 4388.16;-- method 2: using a subquerySELECT first_name, last_name, salaryFROM employeesWHERE salary > (SELECT AVG(salary) FROM employees);

-- 2) Show the total salary per department, but only include departments where the total salary exceeds 60,000.
SELECT department, SUM(salary) AS total_salary
FROM employees
GROUP BY department
HAVING SUM(salary) > 60000; -- both department totals are greater than 60,000

-- 3) Count how many employees are in each department.
SELECT department, COUNT(*) AS employee_count
FROM employees
GROUP BY department;

-- 4) Show all employees whose last names contain the letter “e” AND whose salary is below 4000.
SELECT *
FROM employees
WHERE last_name LIKE '%e%' AND salary < 4000;

-- 5) Identify the highest salary in the “Private Individuals” department.
SELECT TOP 1 * -- returns the first row (i.e. the highest salary after sorting)
FROM employees
WHERE department = 'Private Individuals'
ORDER BY salary DESC;

-- 6) Identify the lowest salary in the “Corporate” department.
SELECT TOP 1 *
FROM employees
WHERE department = 'Corporate'
ORDER BY salary ASC;

-- 7) List all employees whose first name starts with ‘A’ OR ends with ‘a’.
SELECT *
FROM employees
WHERE first_name LIKE 'A%' OR first_name LIKE '%a';

-- 8) Show all employees sorted by salary in descending order. Display only first name, last name, and salary.
SELECT first_name, last_name, salary
FROM employees
ORDER BY salary DESC;

--------------------------------------------------------------------------------------------------------------------------------
-- TASK 2 - Create a New Table & JOIN

-- Part A - Departments Table
-- Create a new table called departments with columns for department ID and department name. Then insert two departments: Corporate and Private Individuals.
CREATE TABLE departments (
	department_id int,
	department_name nvarchar(50)
	CONSTRAINT dept_id_pkey PRIMARY KEY (department_id) 
);

INSERT INTO departments (department_id, department_name)
VALUES (1, 'Corporate'),
	   (2, 'Private Individuals');

-- Part B - Foreign Key
-- Add a new column department_id to the employees table and set it as a foreign key referencing the departments table.
ALTER TABLE employees
ADD department_id int CONSTRAINT dept_id_fkey FOREIGN KEY REFERENCES departments(department_id);

-- Part C - Update Employees
-- Update all employees so they have the correct department ID.
-- method 1: multiple updates
UPDATE employees
SET department_id = 1
WHERE department = 'Coporate'

UPDATE employees
SET department_id = 2
WHERE department = 'Private Individuals'
-- this method would be more time consuming to implement for a greater number of departments

-- method 2: updating the department_id column using information from the departments table
UPDATE employees
SET employees.department_id = departments.department_id
FROM employees, departments
WHERE employees.department = departments.department_name;
-- this method is more convenient and dynamic for a greater number of departments

-- Part D - JOIN Queries
-- Answer the following using JOINs: 
-- 1) Show first name, last name, and department name for all employees.
SELECT emp.first_name, emp.last_name, dep.department_name -- returning the department_name column from the departments table
FROM employees AS emp
JOIN departments AS dep
ON emp.department_id = dep.department_id;

-- 2) Show the total salary per department using the departments table. 
SELECT dep.department_name, SUM(emp.salary) AS total_salary
FROM departments AS dep
JOIN employees AS emp
ON dep.department_id = emp.department_id
GROUP BY dep.department_name;

-- 3) List all employees in the Corporate department using a JOIN. SELECT emp.first_name, emp.last_nameFROM employees AS empJOIN departments AS depON emp.department_id = dep.department_idWHERE dep.department_name = 'Corporate';-- 4) Show the average salary per department, rounded to two decimal places.SELECT dep.department_name, CAST(AVG(emp.salary) AS DECIMAL(10,2)) AS average_salary
FROM employees AS emp
JOIN departments AS dep
ON emp.department_id = dep.department_id
GROUP BY dep.department_name;
-- I had trouble rounding the the average to 2.d.p. 
-- Using the round function still produced trailing zeroes following the 2.d.p. but the CAST function seems to work

--------------------------------------------------------------------------------------------------------------------------------
-- TASK 3 - Company Salary Report
-- Create a series of SQL queries to produce a company salary report:
-- 1) Show the number of employees in each department.
SELECT department, COUNT(*) AS number_of_employees
FROM employees
GROUP BY department;

-- 2) Show the total salary cost per department.
SELECT department, SUM(salary) AS total_salary
FROM employees
GROUP BY department;

-- 3) Show the highest and lowest salary in each department.
SELECT department, MIN(salary) AS min_salary, MAX(salary) AS max_salary
FROM employees
GROUP BY department;

-- 4) Show the average salary in each department, rounded to two decimal places.
SELECT department, CAST(AVG(salary) AS DECIMAL(10,2)) AS average_salary
FROM employees
GROUP BY department;
-- Again, using the ROUND function results in trailing zeroes whereas a cast to a DECIMAL produces the desired result

-- 5) Produce a final report listing all employees sorted by department (A–Z) and salary (highest to lowest).
SELECT first_name, last_name, department, salary
FROM employees
ORDER BY 3 ASC, 4 DESC; -- 3 refering to department in the SELECT statement and 4 referring to salary