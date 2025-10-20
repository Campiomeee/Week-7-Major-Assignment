# Week-7-Major-Assignment
Duke IDS706 Course Week 7 Major Assignment

# 📘 SQL Reference Guide — University Database

## 🧩 Overview
This project serves as a **personalized SQL reference guide** built using a relational **University Database**.  
The database models students, instructors, courses, enrollments, and departments, providing a realistic foundation to practice both basic and advanced SQL concepts.

---

## 🗂️ Dataset Structure

The database contains **five interrelated tables**:

| Table | Description |
|--------|--------------|
| **departments** | Department information (`dept_id`, `dept_name`) |
| **instructors** | Faculty with department and hire year |
| **students** | Student demographics and major department |
| **courses** | Course details, credits, capacity, and instructor |
| **enrollments** | Student-course enrollment records with grades |

**ER Diagram (conceptual):**
departments ───< instructors ───< courses ───< enrollments >─── students

## ⚙️ Setup Instructions

### 1. Create the database

sqlite3 Data/university.db < sql/university_setup.sql


### 2. Import the CSV files
.mode csv
.import data/departments.csv departments
.import data/instructors.csv instructors
.import data/students.csv students
.import data/courses.csv courses
.import data/enrollments.csv enrollments

### 3.Design all the questions:
    1. Students majoring in CS who started in 2023 or later
    2. For each department, find the average course capacity and total number of courses offered
    3. Which 5 courses have the largest class capacities?
    4. List each course title with its instructor’s name and department
    5. Show all students and their enrolled courses (including those not enrolled)
    6. Classify courses as Small (<35), Medium (35–50), or Large (>50)
    7. Find all students who have taken at least one course taught by a STAT instructor
    8. Rank each student’s completed courses by alphabetical grade
    9. Using a CTE, find each student’s latest semester and number of courses in that term
    10A. Replace NULL grades with “Not Graded” for readability
    10B. Combine all unique course titles from MATH and STAT departments

### 4. Run all queries
sqlite3 Data/university.db < sql/SQL_Queries_clean.sql

When running the queries, the terminal displays:
Clearly labeled question sections
Column headers with aligned output
Blank lines between results for readability

### 5. Result

# 1. Students majoring in CS who started in 2023 or later
(Basic SELECT and WHERE filtering)

query:
SELECT student_id, first_name, last_name, major_dept, start_year
FROM students
WHERE major_dept = 'CS'
  AND start_year >= 2023
ORDER BY start_year, last_name, first_name;

output:
1004|Sara|Ng|CS|2023
1011|Leo|Rossi|CS|2023
1008|Olivia|Garcia|CS|2024
1001|He|Jiang|CS|2024

# 2. For each department, find the average course capacity and total number of courses offered
(GROUP BY, aggregation)

query:
SELECT d.dept_id,
       d.dept_name,
       ROUND(AVG(c.capacity), 2) AS avg_capacity,
       COUNT(*) AS num_courses
FROM departments d
JOIN courses c ON c.dept_id = d.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY avg_capacity DESC;

output：
MATH|Mathematics|52.5|2
CS|Computer Science|35.0|3
STAT|Statistics|35.0|3
dept_id|dept_name|0.0|1

# 3. Which 5 courses have the largest class capacities?
(ORDER BY, LIMIT)

query:
SELECT course_id, title, capacity
FROM courses
ORDER BY capacity DESC, title
LIMIT 5;

result:
course_id|title|capacity
MATH101|Calculus I|60
MATH240|Linear Algebra|45
CS101|Intro to Programming|40
STAT201|Probability|40

# 4. List each course title with its instructor’s name and department
(INNER JOIN across 3 tables)

query:
SELECT c.course_id,
       c.title,
       i.first_name || ' ' || i.last_name AS instructor,
       d.dept_name AS department
FROM courses c
JOIN instructors i ON i.instructor_id = c.instructor_id
JOIN departments d ON d.dept_id = c.dept_id
ORDER BY d.dept_name, c.title;

output:
CS201|Data Structures|Alan Turing|Computer Science
CS301|Databases|Grace Hopper|Computer Science
CS101|Intro to Programming|Ada Lovelace|Computer Science
MATH101|Calculus I|Carl Gauss|Mathematics
MATH240|Linear Algebra|Carl Gauss|Mathematics
STAT410|Machine Learning|Florence Nightingale|Statistics
STAT201|Probability|Florence Nightingale|Statistics
STAT301|Regression|Pierre Laplace|Statistics

# 5. Show all students and their enrolled courses (including those not enrolled)
(LEFT JOIN for unmatched rows)

query:
SELECT s.student_id,
       s.first_name || ' ' || s.last_name AS student,
       e.semester,
       c.course_id,
       c.title
FROM students s
LEFT JOIN enrollments e ON e.student_id = s.student_id
LEFT JOIN courses c      ON c.course_id = e.course_id
ORDER BY s.student_id, e.semester, c.title;

output:
1001|He Jiang|2024FA|CS101|Intro to Programming
1001|He Jiang|2025SP|CS301|Databases
1001|He Jiang|2025SP|STAT410|Machine Learning
1002|Mina Kim|2024FA|STAT201|Probability
1002|Mina Kim|2025SP|STAT301|Regression
1003|Diego Ramirez|2022FA|MATH101|Calculus I
1003|Diego Ramirez|2023SP|MATH240|Linear Algebra
1004|Sara Ng|2023FA|CS101|Intro to Programming
1004|Sara Ng|2024SP|CS201|Data Structures
1005|Liam O'Neil|2024FA|STAT201|Probability
1005|Liam O'Neil|2025SP|STAT301|Regression
1006|Ava Chen|2024FA|MATH101|Calculus I
1006|Ava Chen|2025SP|MATH240|Linear Algebra
1007|Noah Patel|2022FA|CS201|Data Structures
1007|Noah Patel|2023SP|CS301|Databases
1008|Olivia Garcia|2024FA|CS101|Intro to Programming
1008|Olivia Garcia|2025SP|STAT201|Probability
1009|Ethan Wong|2023FA|STAT201|Probability
1009|Ethan Wong|2024SP|STAT301|Regression
1010|Zara Khan|2024FA|MATH101|Calculus I
1010|Zara Khan|2025SP|CS101|Intro to Programming
1011|Leo Rossi|2023FA|CS201|Data Structures
1011|Leo Rossi|2024SP|STAT410|Machine Learning
1012|Emma Brown|2022FA|STAT201|Probability
1012|Emma Brown|2023SP|STAT301|Regression


# 6. Classify courses as Small (<35), Medium (35–50), or Large (>50)
(CASE WHEN conditional logic)

query:
SELECT course_id,
       title,
       capacity,
       CASE
         WHEN capacity < 35 THEN 'Small'
         WHEN capacity <= 50 THEN 'Medium'
         ELSE 'Large'
       END AS capacity_size
FROM courses
ORDER BY capacity DESC;

output:
course_id|title|capacity|Large
MATH101|Calculus I|60|Large
MATH240|Linear Algebra|45|Medium
CS101|Intro to Programming|40|Medium
STAT201|Probability|40|Medium
CS201|Data Structures|35|Medium
STAT301|Regression|35|Medium
CS301|Databases|30|Small
STAT410|Machine Learning|30|Small

# 7. Find all students who have taken at least one course taught by a STAT instructor
(Subquery with IN and multi-table relationships)

query:
SELECT DISTINCT s.student_id,
       s.first_name || ' ' || s.last_name AS student
FROM students s
WHERE s.student_id IN (
  SELECT e.student_id
  FROM enrollments e
  JOIN courses c      ON c.course_id = e.course_id
  JOIN instructors i  ON i.instructor_id = c.instructor_id
  WHERE i.dept_id = 'STAT'
);

output:
1001|He Jiang
1002|Mina Kim
1005|Liam O'Neil
1008|Olivia Garcia
1009|Ethan Wong
1011|Leo Rossi
1012|Emma Brown

# 8. Rank each student’s completed courses by alphabetical grade
(Window function RANK() with PARTITION BY)

query:
SELECT e.student_id,
       e.course_id,
       e.semester,
       e.grade,
       RANK() OVER (
         PARTITION BY e.student_id
         ORDER BY e.grade
       ) AS grade_rank_alpha
FROM enrollments e
WHERE e.grade IS NOT NULL
ORDER BY e.student_id, grade_rank_alpha, e.course_id;

output:
1001|STAT410|2025SP||1
1001|CS301|2025SP|A|2
1001|CS101|2024FA|A-|3
1002|STAT301|2025SP||1
1002|STAT201|2024FA|B+|2
1003|MATH101|2022FA|A|1
1003|MATH240|2023SP|A-|2
1004|CS101|2023FA|B|1
1004|CS201|2024SP|B+|2
1005|STAT301|2025SP||1
1005|STAT201|2024FA|A-|2
1006|MATH240|2025SP||1
1006|MATH101|2024FA|B-|2
1007|CS201|2022FA|A|1
1007|CS301|2023SP|A-|2
1008|STAT201|2025SP||1
1008|CS101|2024FA|B|2
1009|STAT301|2024SP|A-|1
1009|STAT201|2023FA|B+|2
1010|CS101|2025SP||1
1010|MATH101|2024FA|B+|2
1011|CS201|2023FA|A-|1
1011|STAT410|2024SP|B+|2
1012|STAT301|2023SP|A|1
1012|STAT201|2022FA|A-|2

# 9. Using a CTE, find each student’s latest semester and number of courses in that term
(WITH clause + aggregate + JOIN)

query:
WITH latest AS (
  SELECT student_id, MAX(semester) AS latest_sem
  FROM enrollments
  GROUP BY student_id
)
SELECT l.student_id,
       s.first_name || ' ' || s.last_name AS student,
       l.latest_sem,
       COUNT(e.enroll_id) AS classes_in_latest_sem
FROM latest l
JOIN students s    ON s.student_id = l.student_id
LEFT JOIN enrollments e
       ON e.student_id = l.student_id
      AND e.semester   = l.latest_sem
GROUP BY l.student_id, s.first_name, s.last_name, l.latest_sem
ORDER BY classes_in_latest_sem DESC, student;

output:
1001|He Jiang|2025SP|2
1006|Ava Chen|2025SP|1
1003|Diego Ramirez|2023SP|1
1012|Emma Brown|2023SP|1
1009|Ethan Wong|2024SP|1
1011|Leo Rossi|2024SP|1
1005|Liam O'Neil|2025SP|1
1002|Mina Kim|2025SP|1
1007|Noah Patel|2023SP|1
1008|Olivia Garcia|2025SP|1
1004|Sara Ng|2024SP|1
1010|Zara Khan|2025SP|1

# 10A. Replace NULL grades with “Not Graded” for readability
(COALESCE function)

query:
SELECT e.enroll_id,
       e.student_id,
       e.course_id,
       e.semester,
       COALESCE(e.grade, 'Not Graded') AS grade_display
FROM enrollments e
ORDER BY e.student_id, e.semester, e.course_id;

output:
1|1001|CS101|2024FA|A-
2|1001|CS301|2025SP|A
3|1001|STAT410|2025SP|
4|1002|STAT201|2024FA|B+
5|1002|STAT301|2025SP|
6|1003|MATH101|2022FA|A
7|1003|MATH240|2023SP|A-
8|1004|CS101|2023FA|B
9|1004|CS201|2024SP|B+
10|1005|STAT201|2024FA|A-
11|1005|STAT301|2025SP|
12|1006|MATH101|2024FA|B-
13|1006|MATH240|2025SP|
14|1007|CS201|2022FA|A
15|1007|CS301|2023SP|A-
16|1008|CS101|2024FA|B
17|1008|STAT201|2025SP|
18|1009|STAT201|2023FA|B+
19|1009|STAT301|2024SP|A-
20|1010|MATH101|2024FA|B+
21|1010|CS101|2025SP|
22|1011|CS201|2023FA|A-
23|1011|STAT410|2024SP|B+
24|1012|STAT201|2022FA|A-
25|1012|STAT301|2023SP|A

# 10B. Combine all unique course titles from MATH and STAT departments
(UNION set operation)

query:
SELECT title FROM courses WHERE dept_id = 'MATH'
UNION
SELECT title FROM courses WHERE dept_id = 'STAT'
ORDER BY title;

output:
Calculus I
Linear Algebra
Machine Learning
Probability
Regression
