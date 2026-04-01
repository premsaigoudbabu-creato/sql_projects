CREATE DATABASE emp_2;
USE emp_2;
CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(50)
);

-- Create Employee table
CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    dept_id INT,
    salary DECIMAL(10,2),
    join_date DATE,
    manager_id INT,
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

-- Create Project table
CREATE TABLE Project (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50),
    dept_id INT,
    start_date DATE,
    end_date DATE
);

-- Create Employee_Project mapping table
CREATE TABLE Employee_Project (
    emp_id INT,
    project_id INT,
    role VARCHAR(30),
    hours_worked INT,
    PRIMARY KEY (emp_id, project_id),
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id),
    FOREIGN KEY (project_id) REFERENCES Project(project_id)
);

-- Insert into Department
INSERT INTO Department VALUES
(1, 'HR'),
(2, 'Finance'),
(3, 'IT'),
(4, 'Marketing');

-- Insert into Employee
INSERT INTO Employee VALUES
(101, 'Alice', 3, 85000, '2018-03-01', NULL),
(102, 'Bob', 3, 72000, '2019-06-12', 101),
(103, 'Charlie', 2, 65000, '2020-01-20', 105),
(104, 'David', 1, 50000, '2021-09-14', 106),
(105, 'Emma', 2, 90000, '2017-07-10', NULL),
(106, 'Frank', 1, 80000, '2016-04-22', NULL),
(107, 'Grace', 4, 60000, '2022-02-15', 108),
(108, 'Hannah', 4, 95000, '2015-11-03', NULL),
(109, 'Ian', 3, 70000, '2021-12-10', 101),
(110, 'Julia', 2, 75000, '2020-09-30', 105);

-- Insert into Project
INSERT INTO Project VALUES
(201, 'Payroll System', 2, '2020-03-10', '2020-10-10'),
(202, 'Website Revamp', 3, '2021-05-15', '2021-12-20'),
(203, 'Recruitment Drive', 1, '2022-01-05', '2022-06-10'),
(204, 'Ad Campaign', 4, '2021-07-01', '2021-12-31'),
(205, 'Data Migration', 3, '2022-02-01', '2022-09-30');

-- Insert into Employee_Project
INSERT INTO Employee_Project VALUES
(101, 202, 'Lead Developer', 180),
(102, 202, 'Backend Dev', 160),
(103, 201, 'Analyst', 150),
(104, 203, 'Recruiter', 120),
(105, 201, 'Manager', 200),
(106, 203, 'HR Head', 190),
(107, 204, 'Marketing Exec', 170),
(108, 204, 'Director', 210),
(109, 205, 'Data Engineer', 180),
(110, 201, 'Finance Exec', 160);
SELECT * FROM department;
SELECT * FROM employee;
SELECT * FROM employee_project;
SELECT * FROM project;

-- Find each employee’s salary and their department’s average salary using a window function.
select em.salary,de.dept_name,
avg(em.salary) over(partition by de.dept_name) as avg_salary
from department as de
join employee as em on em.dept_id = de.dept_id;
-- Show each employee’s name and the rank of their salary within their department.
select em.emp_name,em.salary,de.dept_name,
rank() over(partition by de.dept_name order by em.salary desc) as rnk
from department as de
join employee as em on em.dept_id = de.dept_id;
-- Display employees with their salary percentile within the company.
select emp_name,salary,
round(percent_rank() over(order by salary desc) * 100,2) as percent
from employee;
-- For each department, show employees and their dense rank based on salary.
select de.dept_name,em.salary,
dense_rank() over(partition by de.dept_name order by em.salary desc) as dnx
from department as de
join employee as em on em.dept_id = de.dept_id;
-- Show each employee’s running total of salary by department.
select em.emp_name,em.salary,de.dept_name,
sum(em.salary) over(partition by de.dept_name order by em.salary ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) as total_sum
from department as de
join employee as em on em.dept_id = de.dept_id;

-- Find employees whose salary is above the department average using window function.
with average as (
        select em.salary,de.dept_name,em.emp_name,
        avg(em.salary) over(partition by de.dept_name) as avg_salary
        from department as de
        join employee as em on em.dept_id = de.dept_id
)

select emp_name,dept_name,salary
from average
where salary > avg_salary;
           

-- For each department, find the highest and lowest salary using window functions.
with salary as (
        select em.salary,de.dept_name,em.emp_name,
        min(em.salary) over(partition by de.dept_name) as mini_salary,
		max(em.salary) over(partition by de.dept_name) as max_salary
        from department as de
        join employee as em on em.dept_id = de.dept_id
)

select emp_name,dept_name,salary
from salary
where salary = mini_salary or salary = max_salary; 
-- Compute each employee’s salary difference from their department’s average.
with average as (
		select em.salary,de.dept_name,em.emp_name,
		avg(em.salary) over(partition by de.dept_name) as avg_salary
		from department as de
		join employee as em on em.dept_id = de.dept_id
)
select salary,dept_name,emp_name,round(salary-avg_salary) as differents
from average;

-- Display each employee’s salary and the cumulative sum of salaries company-wide.
select em.emp_id,em.salary,
sum(em.salary) over(order by em.emp_id rows between unbounded preceding and current row) as cumulative_salary
from department as de
join employee as em on em.dept_id = de.dept_id;

-- Show each employee and their row number ordered by salary descending.
select em.emp_name,em.salary,
row_number() over(order by em.salary desc) as ro_num
from department as de
join employee as em on em.dept_id = de.dept_id;

SELECT * FROM department;
SELECT * FROM employee;
SELECT * FROM employee_project;
SELECT * FROM project;
-- Find each department’s top 2 highest-paid employees.
with info as (select em.emp_name,em.salary,de.dept_name,
			  rank() over(partition by de.dept_name order by em.salary desc) as highest_paid
			  from department as de
			  join employee as em on em.dept_id = de.dept_id
)

select emp_name,salary,dept_name,highest_paid
from info
where highest_paid <= 2;

-- Show each employee and their previous employee’s salary in the same department (using LAG).
select em.emp_name,em.salary,de.dept_name,
lag(em.salary) over(partition by de.dept_name order by em.salary) as previous
from department as de
join employee as em on em.dept_id = de.dept_id;

-- Show each employee and the next employee’s salary in the same department (using LEAD).
select em.emp_name,em.salary,
lead(em.salary) over(partition by de.dept_name order by em.salary) as previous
from department as de
join employee as em on em.dept_id = de.dept_id;
-- Display each employee and how much more they earn than the previous employee (difference using LAG).
 with sal as (select em.emp_name,em.salary,
			lag(em.salary) over(partition by de.dept_name order by em.salary) as previous
			from department as de
			join employee as em on em.dept_id = de.dept_id
)
select emp_name,salary,previous,(salary - previous) as different
from sal;
-- Find each department’s average salary using both GROUP BY and window functions and compare.
select avg(em.salary),de.dept_name
from department as de
join employee as em on em.dept_id = de.dept_id
group by de.dept_name;
select de.dept_name,
avg(em.salary) over(partition by de.dept_name) as avg_salary
from department as de
join employee as em on em.dept_id = de.dept_id;

-- Display each employee’s years of experience rank (based on join_date).
select emp_id,emp_name,join_date,
dense_rank() over (order by join_date) as rnk
from employee;
-- Show each project’s employees ordered by hours_worked, assigning a rank.
select em.emp_name,pro.hours_worked,proj.project_name,
dense_rank() over (order by pro.hours_worked) as dn
from employee as em
join employee_project as pro on pro.emp_id = em.emp_id
join project as proj on proj.project_id = pro.project_id;
-- Find the employee with the earliest joining date per department using a window function.
select em.emp_name,de.dept_name,
min(em.join_date) over(partition by de.dept_name) as first_one
from department as de
join employee as em on em.dept_id = de.dept_id;
-- Display cumulative hours worked by each employee across all their projects.
select em.emp_name,pro.project_id,pro.hours_worked,proj.project_name
from employee as em
join employee_project as pro on pro.emp_id = em.emp_id
join project as proj on proj.project_id = pro.project_id;
-- For each department, find median salary using window functions.
with pre as (select de.dept_name,em.salary,em.emp_name,
			row_number() over(partition by de.dept_name order by em.salary asc) as min_salary
            
			from department as de
			join employee as em on em.dept_id = de.dept_id
)
select salary,emp_name,dept_name
from pre
where min_salary = 1;

-- JOINS FOR ABOVE TABLE
SELECT * FROM department;
SELECT * FROM employee;
SELECT * FROM employee_project;
SELECT * FROM project;
-- List all employees with their department names.
select em.emp_name,de.dept_name
from department as de
join employee as em on em.dept_id = de.dept_id;
-- Display all employees along with the projects they are working on.
select em.emp_name,proj.project_name
from employee as em
join employee_project as pro on pro.emp_id = em.emp_id
join project as proj on proj.project_id = pro.project_id;

-- Find employees who are not assigned to any project.
select em.emp_name,em.emp_id
from employee as em
left join employee_project as pro on pro.emp_id = em.emp_id
where pro.project_id is null;
-- Retrieve all projects along with the number of employees working on them.
select count(em.emp_id) as total_employees,pro.project_name
from employee_project as em
join project as pro on pro.project_id = em.project_id
group by pro.project_name;
-- Show each department and the total salary of its employees.
select em.emp_name,em.salary,de.dept_name
from department as de
join employee as em on em.dept_id = de.dept_id;
-- Find employees who work in the same department as “Emma.”
select em.emp_name,de.dept_name
from department as de
join employee as em on em.dept_id = de.dept_id;
-- List employees who report to “Frank.”
select Subordinate.emp_name
from employee as Subordinate
join Employee as Manager on Subordinate.manager_id = Manager.emp_id 
where Manager.emp_name = 'Frank';
  
-- Display employee names and their manager names using self-join.
select em1.emp_name,em2.emp_name as manager_name
from employee as em1
join employee as em2 on em2.emp_id = em1.manager_id;
-- Find employees who are working on projects outside their own department.
SELECT e.emp_name, p.project_name
FROM employee e
JOIN employee_project ep 
    ON ep.emp_id = e.emp_id
JOIN project p 
    ON p.project_id = ep.project_id
WHERE e.dept_id <> p.dept_id;
-- Show each department and the average salary of employees who work on a project.
select de.dept_name,round(avg(em.salary),2) as avg_salary,pro.project_name
from department as de
join employee as em on em.dept_id = de.dept_id
join project as pro on em.dept_id = pro.dept_id
group by de.dept_name,pro.project_name;
-- List projects handled by employees who joined before 2020.
select em.emp_name,em.join_date,pro.project_name
from employee as em
join project as pro on pro.dept_id = em.dept_id
having year(em.join_date) < 2020;
-- Retrieve the department name, employee name, and project name for all assignments.
select de.dept_name,em.emp_name,pro.project_name
from department as de
join employee as em on em.dept_id = de.dept_id
join project as pro on pro.dept_id = em.dept_id;
-- Show departments that have no projects assigned.
select de.dept_name
from department as de
join project as pro on pro.dept_id = de.dept_id
where pro.project_id is null;
-- Find projects that involve employees from more than one department.
select pro.project_name,count(em.dept_id),de.dept_name
from department as de
join employee as em on de.dept_id = em.dept_id
join project as pro on pro.dept_id = de.dept_id
group by pro.project_name,de.dept_name
having count(em.dept_id) > 1;
-- List employees working on multiple projects.
select em.emp_name,count(pro.project_id)
from employee as em
join employee_project as pro on pro.emp_id = em.emp_id
group by em.emp_name
having count(pro.project_id) > 1;

-- Retrieve the total hours worked per employee across all projects.
select sum(em.hours_worked) as total_hours,pro.project_name,em.emp_id
from employee_project as em
join project as pro on em.project_id = pro.project_id
group by pro.project_name,em.emp_id;
-- Find the highest paid employee in each department using a join.
select  de.dept_name,em.emp_name,em.salary
from employee em
join department de on em.dept_id = de.dept_id
where em.salary = (
    select max(salary)
    from employee
    where dept_id = em.dept_id
);
-- Display employees whose salary is above the average salary of their department.
select  de.dept_name,em.emp_name,em.salary
from employee em
join department de on em.dept_id = de.dept_id
where em.salary > (
    select avg(salary)
    from employee
    where dept_id = em.dept_id
);
-- Find departments and managers who have at least one employee under them.
select de.dept_name,em.manager_id,count(em.emp_id)
from department as de
join employee as em on em.dept_id = de.dept_id
where em.manager_id is not null
group by de.dept_name,em.manager_id
having count(em.emp_id) = 1;
-- Display all employee details along with project and department details in a single joined view.
 WITH total AS (
    SELECT 
        de.dept_id AS department_id,
        de.dept_name,
        em.emp_id,
        em.emp_name,
        em.salary,
        pro.project_id,
        pro.project_name,
        jet.role,
        jet.hours_worked
    FROM department AS de
    JOIN employee AS em 
        ON em.dept_id = de.dept_id
    JOIN project AS pro 
        ON pro.dept_id = em.dept_id
	JOIN employee_project as jet
        ON jet.emp_id = em.emp_id
)
SELECT * 
FROM total;




