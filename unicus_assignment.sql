-- 1. Create Database and Use It
-- ---------------------------------------------------------
CREATE DATABASE IF NOT EXISTS edupro_sql_test;
USE edupro_sql_test;

-- 2. Drop Tables If They Already Exist (to reset the schema)
-- ---------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS instructors;

SET FOREIGN_KEY_CHECKS = 1;

-- 3. Create Tables
-- ---------------------------------------------------------

-- Table: instructors
CREATE TABLE instructors (
    instructor_id     INT PRIMARY KEY,
    instructor_name   VARCHAR(100) NOT NULL,
    experience_years  INT NOT NULL
);

-- Table: students
CREATE TABLE students (
    student_id   INT PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    gender       VARCHAR(10),
    signup_date  DATE NOT NULL,
    city         VARCHAR(50)
);

-- Table: courses
CREATE TABLE courses (
    course_id      INT PRIMARY KEY,
    course_name    VARCHAR(100) NOT NULL,
    category       VARCHAR(50) NOT NULL,
    price          DECIMAL(10,2) NOT NULL,
    instructor_id  INT,
    CONSTRAINT fk_courses_instructors
        FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
);

-- Table: enrollments
CREATE TABLE enrollments (
    enrollment_id    INT PRIMARY KEY,
    student_id       INT,
    course_id        INT,
    enrollment_date  DATE NOT NULL,
    progress         INT,           -- 0 to 100
    rating           FLOAT,         -- 1 to 5, can be NULL
    CONSTRAINT fk_enrollments_students
        FOREIGN KEY (student_id) REFERENCES students(student_id),
    CONSTRAINT fk_enrollments_courses
        FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- 4. Insert Sample Data
-- ---------------------------------------------------------

-- Instructors
INSERT INTO instructors (instructor_id, instructor_name, experience_years) VALUES
(11, 'Ananya Sharma', 7),
(12, 'Rahul Verma', 5),
(13, 'Meera Iyer', 3),
(14, 'Karan Singh', 10);

-- Students
INSERT INTO students (student_id, name, gender, signup_date, city) VALUES
(1,  'Arjun',    'Male',   '2024-01-10', 'Hyderabad'),
(2,  'Siri',     'Female', '2024-02-12', 'Bangalore'),
(3,  'Vikas',    'Male',   '2024-01-25', 'Mumbai'),
(4,  'Rhea',     'Female', '2024-03-01', 'Chennai'),
(5,  'Nikhil',   'Male',   '2024-02-18', 'Delhi'),
(6,  'Priya',    'Female', '2024-02-28', 'Hyderabad'),
(7,  'Rahul',    'Male',   '2024-03-05', 'Pune'),
(8,  'Ankita',   'Female', '2024-01-30', 'Bangalore'),
(9,  'Manoj',    'Male',   '2024-03-12', 'Chennai'),
(10, 'Sneha',    'Female', '2024-03-15', 'Mumbai');

-- Courses
INSERT INTO courses (course_id, course_name, category, price, instructor_id) VALUES
(101, 'Python Basics',           'Python',        5000.00, 11),
(102, 'Machine Learning',        'Data Science', 12000.00, 11),
(103, 'SQL for Analysts',        'Data Analytics', 6000.00, 12),
(104, 'Advanced Excel',          'Data Analytics', 4000.00, 13),
(105, 'Deep Learning',           'Data Science', 15000.00, 14),
(106, 'Data Visualization',      'BI & Reporting', 8000.00, 12);

-- Enrollments
INSERT INTO enrollments (enrollment_id, student_id, course_id, enrollment_date, progress, rating) VALUES
(1,  1, 101, '2024-02-01', 80, 4.5),
(2,  2, 102, '2024-03-07', 50, NULL),
(3,  3, 103, '2024-03-10', 90, 5.0),
(4,  1, 102, '2024-03-11', 20, 3.5),
(5,  4, 104, '2024-03-15', 60, 4.0),
(6,  5, 101, '2024-02-20', 100, 4.8),
(7,  6, 103, '2024-03-01', 0, NULL),
(8,  7, 105, '2024-03-18', 30, 3.0),
(9,  8, 106, '2024-03-05', 70, 4.2),
(10, 9, 102, '2024-03-20', 10, NULL),
(11, 2, 103, '2024-03-22', 40, 4.0),
(12, 3, 101, '2024-02-05', 75, 4.3),
(13, 4, 106, '2024-03-25', 55, 4.1),
(14, 5, 102, '2024-03-26', 35, 3.8),
(15, 6, 105, '2024-03-28', 15, NULL),
(16, 7, 101, '2024-02-25', 60, 4.0),
(17, 8, 104, '2024-03-02', 90, 4.9),
(18, 9, 103, '2024-03-29', 25, 3.7),
(19, 10,106, '2024-03-30', 65, 4.4),
(20, 10,101, '2024-02-15', 85, 4.6);

-- =========================================================
--                   ASSIGNMENT QUESTIONS
-- =========================================================
-- Instructions for Learners:
-- 1. Do NOT modify the INSERT or CREATE TABLE statements.
-- 2. For each question, write your SQL query directly below the comment.
-- 3. Use SELECT queries only (no UPDATE/DELETE unless explicitly asked).
-- 4. Use proper formatting and aliases where needed.

-- ---------------------------------------------------------
-- SECTION A — BASIC QUERIES
-- ---------------------------------------------------------
select * from courses;
select * from enrollments;
select * from instructors;
select * from students;
-- Q1: Retrieve all student names and cities.
-- Write your query below:
select name,city from students;

-- Q2: List all unique course categories.
-- Write your query below:
select distinct(course_name) as unique_courses from courses;

-- Q3: Show all courses priced above 7000.
-- Write your query below:
select course_name from courses
where price > 7000;

-- Q4: Get all enrollments made in March 2024.
-- Write your query below:
select * from enrollments
where month(enrollment_date) = '03';

-- Q5: Find students who signed up before 15-Feb-2024.
-- Write your query below:
select name from students
where signup_date < '2024-02-15';

-- Q6: Count the total number of students.
-- Write your query below:
select count(name) as count_of_student from students;

-- Q7: List instructors with more than 5 years of experience.
-- Write your query below:
select instructor_name from instructors
where experience_years > 5;

-- Q8: Display all courses sorted by price from high to low.
-- Write your query below:
select course_name from courses
order by price desc;

-- Q9: Retrieve course_name and price for courses in 'Python' category.
-- Write your query below:
select course_name,price from courses
where category = 'Python';

-- Q10: Show all students belonging to either Hyderabad or Bangalore.
-- Write your query below:
select name from students
where city in ('Hyderabad','Bangalore');

select * from courses;
select * from enrollments;
select * from instructors;
select * from students;

-- ---------------------------------------------------------
-- SECTION B — JOINS
-- ---------------------------------------------------------

-- Q11: Display student name, course name, and enrollment date for all enrollments.
-- Write your query below:
select st.name,co.course_name,en.enrollment_date
from courses as co
left join enrollments as en on en.course_id = co.course_id
left join students as st on st.student_id = en.student_id;

-- Q12: List all courses with their instructor names.
-- Write your query below:
select co.course_name,ins.instructor_name
from courses as co
left join instructors as ins on ins.instructor_id = co.instructor_id;

-- Q13: Find students with progress >= 70% along with course names.
-- Write your query below:
select co.course_name,en.progress,st.name
from courses as co
join enrollments as en on en.course_id = co.course_id
join students as st on st.student_id = en.student_id
where en.progress >= 70;

-- Q14: Show all enrollments where rating is not provided (NULL).
-- Write your query below:
select * from enrollments
where rating is null;

-- Q15: For each instructor, show the number of courses they teach.
-- Write your query below:
select ins.instructor_name,count(co.course_name)
from courses as co
left join instructors as ins on ins.instructor_id = co.instructor_id
group by ins.instructor_name;

-- Q16: For each student, list how many courses they have enrolled in.
-- Write your query below:
select st.name,count(course_id) as total_course
from enrollments as en
left join students as st on st.student_id = en.student_id
group by st.name;

-- Q17: Show each course along with the number of enrollments for that course.
-- Write your query below:
select co.course_name,count(en.student_id) as total_enrolled
from courses as co
left join enrollments as en on en.course_id = co.course_id
group by co.course_name;

-- Q18: Retrieve student name, course name, and course price for all enrollments.
-- Write your query below:
select en.enrollment_id,st.name,co.course_name,co.price
from courses as co
left join enrollments as en on co.course_id = en.course_id
left join students as st on st.student_id = en.student_id;

-- Q19: Find the instructor who teaches the highest-priced course (show name and course).
-- Write your query below:
select co.course_name,ins.instructor_name,co.price
from courses as co
left join instructors as ins on ins.instructor_id = co.instructor_id
order by co.price desc;

-- Q20: List all students along with the category of courses they have enrolled in.
-- Write your query below:
select st.name,co.category
from courses as co
left join enrollments as en on en.course_id = co.course_id
left join students as st on st.student_id = en.student_id
order by st.name desc;

select * from courses;
select * from enrollments;
select * from instructors;
select * from students;
-- ---------------------------------------------------------
-- SECTION C — AGGREGATIONS & GROUPING
-- ---------------------------------------------------------

-- Q21: Calculate total revenue generated from all enrollments
--      (assume revenue is simply the course price per enrollment).
-- Write your query below:
select sum(co.price) as total_revenue
from courses as co
join enrollments as en 
on en.course_id = co.course_id;

-- Q22: Find the average price of courses in each category.
-- Write your query below:
select avg(price),course_name,category
from courses
group by course_name,category;

-- Q23: Count the number of enrollments per month in 2024.
-- Write your query below:
select 
month(enrollment_date) as month_number,
count(enrollment_id) as total_enrolled
from enrollments
group by month(enrollment_date)
order by month(enrollment_date);


-- Q24: Get the average rating for each course (ignore NULL ratings).
-- Write your query below:
select co.course_name,round(avg(en.rating),2) as rating
from courses as co
join enrollments as en on en.course_id = co.course_id
where en.rating is not null
group by co.course_name;

-- Q25: For each student, find their maximum and minimum progress across all enrollments.
-- Write your query below:
select st.name,min(en.progress) as min_progress,max(en.progress)as max_progress
from enrollments as en
join students as st on st.student_id = en.student_id
group by st.name;

-- Q26: Identify courses that have more than 2 enrollments.
-- Write your query below:
select co.course_name,count(en.student_id)
from courses as co
join enrollments as en on en.course_id = co.course_id
group by co.course_name
having count(en.student_id) > 2;

-- Q27: Get gender-wise student counts.
-- Write your query below:
select count(name),gender from students
group by gender;

-- Q28: List cities that have more than 1 student.
-- Write your query below:
select count(name),city from students
group by city
having count(name) > 1;

-- Q29: Show category-wise total number of enrollments.
-- Write your query below:
select count(en.student_id)as total_enrolled,co.category
from courses as co
join enrollments as en on en.course_id = co.course_id
group by co.category;

-- Q30: Find the course that has the highest average rating.
-- Write your query below:
select co.course_name,en.rating
from courses as co
join enrollments as en on en.course_id = co.course_id
order by en.rating desc;

select * from courses;
select * from enrollments;
select * from instructors;
select * from students;
-- ---------------------------------------------------------
-- SECTION D — SUBQUERIES
-- ---------------------------------------------------------

-- Q31: Get students who enrolled in the most expensive course.
-- Write your query below:
select name from(
select st.name,co.price
from courses as co
join enrollments as en on en.course_id = co.course_id
join students as st on st.student_id = en.student_id) as yr
order by price desc
limit 5;

-- Q32: List courses whose price is above the average course price.
-- Write your query below:
select course_name from courses
where price > (select avg(price) from courses);

-- Q33: Find students who have not enrolled in any course.
-- (Hint: Use a subquery or LEFT JOIN.)
-- Write your query below:
select name
from students
-- join students as st on st.student_id = en.student_id 
where student_id not in (select student_id from enrollments);

-- Q34: Get instructors whose courses have an average rating above 4.0.
-- Write your query below:
select instructor_name from (
select ins.instructor_name,en.course_id
from courses as co
join enrollments as en on en.course_id = co.course_id
join instructors as ins on ins.instructor_id = co.instructor_id
where en.course_id > 4.0) as yl;


-- Q35: Show all courses where at least one student has 100% progress.
-- Write your query below:
select course_name from (
select co.course_name
from courses as co
join enrollments as en on en.course_id = co.course_id
where en.progress = 100) as yp;

-- Q36: Retrieve students who have enrolled in more than 1 course.
-- Write your query below:
select name from (
select st.name,count(en.student_id)
from enrollments as en
join students as st on st.student_id = en.student_id
group by st.name
having count(en.student_id) > 1) as pl;

-- Q37: Find courses that have no enrollments.
-- Write your query below:
select course_name from (
select co.course_name
from courses as co
join enrollments as en on en.course_id = co.course_id
where en.student_id is null) as pl;

-- Q38: List the top 3 most expensive courses.
-- Write your query below:
select course_name from courses
where price in (select price from courses
               order by price desc)limit 3;

-- Q39: Fetch students who enrolled in courses taught by the most experienced instructor.
-- Write your query below:
select name,course_name from (
select st.name,co.course_name
from courses as co
join enrollments as en on co.course_id = en.course_id
join instructors as ins on ins.instructor_id = co.instructor_id
join students as st on st.student_id = en.student_id
where ins.experience_years > 5) as yl;

-- Q40: Identify the latest enrollment made on the platform
--      (show student name, course name, and enrollment_date).
-- Write your query below:

select * from courses;
select * from enrollments;
select * from instructors;
select * from students;

-- ---------------------------------------------------------
-- SECTION E — WINDOW FUNCTIONS (If Supported)
-- Note: These require MySQL 8+.
-- ---------------------------------------------------------

-- Q41: Rank courses by price in descending order.
-- Write your query below:
select course_name,price,
rank() over(order by price desc) as high_price from courses;

-- Q42: For each category, rank courses by number of enrollments (highest first).
-- Write your query below:
select category,course_name,
rank() over( order by student_id desc) as highest_first
from courses as co
join enrollments as en on en.course_id = co.course_id;

-- Q43: Show running total of revenue by enrollment_date (ordered by date).
-- Write your query below:
select course_name,total_sum,enrollment_date,
dense_rank() over(order by enrollment_date) as total_revenue from (
select co.course_name,sum(co.price) as total_sum,en.enrollment_date
from courses as co
join enrollments as en on en.course_id = co.course_id
group by co.course_name,en.enrollment_date)as yi;
-- Q44: Compute average progress per student and rank them by this average (highest first).
-- Write your query below:
select name,avg_pro,
rank() over(order by avg_pro desc) as ranker from (
select round(avg(en.progress),2) as avg_pro,st.name
from courses as co
join enrollments as en on en.course_id = co.course_id
join students as st on st.student_id = en.student_id
group by st.name) as pl;

-- Q45: For each instructor, find the highest-priced course they teach
--      using a window function.
-- Write your query below:
select co.course_name,ins.instructor_name,co.price,
rank() over(order by price desc) as highest_paided
from courses as co
left join instructors as ins on ins.instructor_id = co.instructor_id;


-- Q46: For each course, show the difference between its price and the average price of all courses.
-- Write your query below:
select course_name,price,
avg(price) over () as avg_price,
price - avg(price) over() as different_price
from courses;

-- Q47: For all enrollments, list student name, course name, and a row number ordered by enrollment_date.
-- Write your query below:
select en.enrollment_id,st.name,co.course_name,
row_number() over(order by enrollment_id) as order_counts
from courses as co
join enrollments as en on en.course_id = co.course_id
join students as st on st.student_id = en.student_id;

-- ---------------------------------------------------------
-- SECTION F — CASE EXPRESSIONS & BUSINESS LOGIC
-- ---------------------------------------------------------

-- Q48: Categorize each enrollment's progress into:
--      0–39: 'Beginner'
--      40–79: 'Intermediate'
--      80–100: 'Advanced'
-- Show student name, course name, progress, and category.
-- Write your query below:
select st.name,co.course_name,en.progress,co.category,
 case
 when en.progress <= 39 then "Beginner"
 when en.progress between 40 and 79 then "Intermediate"
 when en.progress between 80 and 100 then "Advanced"
 end as categorised
from courses as co
join enrollments as en on en.course_id = co.course_id
join students as st on st.student_id = en.student_id;

-- Q49: Create labels for course price:
--      < 5000     -> 'Low'
--      5000–10000 -> 'Medium'
--      > 10000    -> 'High'
-- Show course_name, price, and price_label.
-- Write your query below:
select course_name,price,
case 
when price < 5000 then "low"
when price between 5000 and 10000 then "medium"
when price > 10000 then "high" 
end as price_label
from courses;


-- Q50: Show a report with:
--      student name, course name, rating,
--      and rating_status = 'Rated' if rating is NOT NULL
--      else 'Not Rated'.
-- Write your query below:
select st.name,co.course_name,en.rating,
if (en.rating is null,"not rated","rated") as rate
from courses as co
join enrollments as en on en.course_id = co.course_id
join students as st on st.student_id = en.student_id;


select * from courses;
select * from enrollments;
select * from instructors;
select * from students;