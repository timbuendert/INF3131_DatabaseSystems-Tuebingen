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
DROP TABLE IF EXISTS r;

CREATE TABLE r(a int, b int);

INSERT INTO r(a, b) VALUES -- DML statement
  (1, 2),
  (1, 3),
  (1, 4),
  (2, 2),
  (2, 3),
  (2, 4);

-- Query 1
SELECT r.a, COUNT(*) AS c
FROM r AS r
WHERE r.b = 4
GROUP BY r.a;

-- Query 2
SELECT r.a, COUNT(*) AS c
FROM r AS r
GROUP BY r.a
HAVING EVERY(r.b = 4);


-- Exercise 1.2
SELECT r.a, MAX(r.b) AS m -- original
FROM r AS r
GROUP BY r.a
HAVING COUNT(*) > 2;


SELECT r.a, MAX(r.b) AS m -- new query
FROM r AS r 
WHERE (SELECT COUNT(r1.a)
       FROM r AS r1
       WHERE r1.a = r.a) > 2
GROUP BY r.a;


-- Exercise 1.3
SELECT s.student_name, COUNT(*) AS "workload"
FROM student AS s, enrolled AS e
WHERE s.student_id = e.enrolled_student_id
  AND s.pursued_degree = 'MSc'
GROUP BY s.student_name
HAVING COUNT(*) > 2;


-- Exercise 1.4
SELECT f.staff_name
FROM enrolled AS e, class AS c, staff AS f 
WHERE e.enrolled_class_id = c.class_id
 AND c.class_staff_id = f.staff_id 
GROUP BY f.staff_name
HAVING COUNT(*) < 5;

-- This query is incorrect because it does not include, due to the equi-join, staff members who either teach courses which are entirely unattended or not give any courses at all.

-- Correct alternative:
SELECT f.staff_name -- geht so, da staff_name als unique angenommen wurde
FROM staff AS f
WHERE (SELECT COUNT(*)
       FROM enrolled AS e, class AS c
       WHERE e.enrolled_class_id = c.class_id
         AND c.class_staff_id = f.staff_id) < 5;

-------------------------------------------------------------------------------------------------------------------

-- Command to execute: psql -d scratch -f Ex1.sql
