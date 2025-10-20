.print 1. Students majoring in CS who started in 2023 or later
--    (Basic SELECT and WHERE filtering)
SELECT student_id, first_name, last_name, major_dept, start_year
FROM students
WHERE major_dept = 'CS'
  AND start_year >= 2023
ORDER BY start_year, last_name, first_name;



.print
.print 2. For each department, find the average course capacity and total number of courses offered
--    (GROUP BY, aggregation)
SELECT d.dept_id,
       d.dept_name,
       ROUND(AVG(c.capacity), 2) AS avg_capacity,
       COUNT(*) AS num_courses
FROM departments d
JOIN courses c ON c.dept_id = d.dept_id
GROUP BY d.dept_id, d.dept_name
ORDER BY avg_capacity DESC;



.print
.print 3. Which 5 courses have the largest class capacities?
--    (ORDER BY, LIMIT)
SELECT course_id, title, capacity
FROM courses
ORDER BY capacity DESC, title
LIMIT 5;



.print
.print 4. List each course title with its instructor’s name and department
--    (INNER JOIN across 3 tables)
SELECT c.course_id,
       c.title,
       i.first_name || ' ' || i.last_name AS instructor,
       d.dept_name AS department
FROM courses c
JOIN instructors i ON i.instructor_id = c.instructor_id
JOIN departments d ON d.dept_id = c.dept_id
ORDER BY d.dept_name, c.title;



.print
.print 5. Show all students and their enrolled courses (including those not enrolled)
--    (LEFT JOIN for unmatched rows)
SELECT s.student_id,
       s.first_name || ' ' || s.last_name AS student,
       e.semester,
       c.course_id,
       c.title
FROM students s
LEFT JOIN enrollments e ON e.student_id = s.student_id
LEFT JOIN courses c      ON c.course_id = e.course_id
ORDER BY s.student_id, e.semester, c.title;

.print
.print 6. Classify courses as Small (<35), Medium (35–50), or Large (>50)
--    (CASE WHEN conditional logic)
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



.print
.print 7. Find all students who have taken at least one course taught by a STAT instructor
--    (Subquery with IN and multi-table relationships)
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



.print
.print 8. Rank each student’s completed courses by alphabetical grade
--    (Window function RANK() with PARTITION BY)
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



.print
.print 9. Using a CTE, find each student’s latest semester and number of courses in that term
--    (WITH clause + aggregate + JOIN)
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



.print
.print 10A. Replace NULL grades with “Not Graded” for readability
--     (COALESCE function)
SELECT e.enroll_id,
       e.student_id,
       e.course_id,
       e.semester,
       COALESCE(e.grade, 'Not Graded') AS grade_display
FROM enrollments e
ORDER BY e.student_id, e.semester, e.course_id;


.print
.print 10B. Combine all unique course titles from MATH and STAT departments
--     (UNION set operation)
SELECT title FROM courses WHERE dept_id = 'MATH'
UNION
SELECT title FROM courses WHERE dept_id = 'STAT'
ORDER BY title;
