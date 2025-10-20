
-- University sample schema (SQLite)
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS instructors;
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
  dept_id TEXT PRIMARY KEY,
  dept_name TEXT NOT NULL
);

CREATE TABLE instructors (
  instructor_id INTEGER PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  dept_id TEXT NOT NULL REFERENCES departments(dept_id),
  hire_year INTEGER
);

CREATE TABLE students (
  student_id INTEGER PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  major_dept TEXT NOT NULL REFERENCES departments(dept_id),
  start_year INTEGER
);

CREATE TABLE courses (
  course_id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  dept_id TEXT NOT NULL REFERENCES departments(dept_id),
  credits INTEGER NOT NULL,
  instructor_id INTEGER NOT NULL REFERENCES instructors(instructor_id),
  capacity INTEGER NOT NULL
);

CREATE TABLE enrollments (
  enroll_id INTEGER PRIMARY KEY,
  student_id INTEGER NOT NULL REFERENCES students(student_id),
  course_id TEXT NOT NULL REFERENCES courses(course_id),
  semester TEXT NOT NULL,
  grade TEXT
);

-- Helpful indexes
CREATE INDEX idx_students_major ON students(major_dept);
CREATE INDEX idx_courses_dept ON courses(dept_id);
CREATE INDEX idx_enrollments_course ON enrollments(course_id);
CREATE INDEX idx_enrollments_student ON enrollments(student_id);

-- Import commands (run from sqlite3 shell)
-- .mode csv
-- .import departments.csv departments
-- .import instructors.csv instructors
-- .import students.csv students
-- .import courses.csv courses
-- .import enrollments.csv enrollments
