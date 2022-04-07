-- Exercise 1: Aggregate Queries

-- Import the schema [or via: ! psql -d scratch -f uni/uni-schema.sql]
\i uni/uni-schema.sql

-- Load data into tables (DELIMITER ',' is default for csv files):
\copy class FROM 'uni/class.csv' CSV
\copy department FROM 'uni/department.csv' CSV
\copy enrolled FROM 'uni/enrolled.csv' CSV
\copy staff FROM 'uni/staff.csv' CSV
\copy student FROM 'uni/student.csv' CSV


-- Exercise 1.1
SELECT s.pursued_degree :: text, avg(s.age) AS "average_age"
FROM student AS s
GROUP BY s.pursued_degree;


-- Exercise 1.2
SELECT count(DISTINCT s.major) AS "subject_count"
FROM student AS s;


-- Exercise 1.3
SELECT s.student_name, s.age
FROM student AS s
WHERE s.age = (SELECT max(s1.age)
               FROM student AS s1);


-- Exercise 1.4

-- Option 1: students not enrolled in any classes are included
SELECT s.student_name, (SELECT count(*)
                        FROM enrolled AS e
                        WHERE s.student_id = e.enrolled_student_id
                        GROUP BY s.student_name) AS "classes_count"
FROM student AS s;

-- Option 2: students not enrolled in any classes are not included
SELECT s.student_name, count(*) AS "classes_count"
FROM student AS s, enrolled AS e
WHERE s.student_id = e.enrolled_student_id
GROUP BY s.student_name;

-------------------------------------------------------------------------------------------------------------------

-- Command to execute: psql -d scratch -f Ex1.sql
