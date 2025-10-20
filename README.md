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
```bash
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