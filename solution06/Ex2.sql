-- Exercise 2: SQL University

-- Import the schema [or via: ! psql -d scratch -f uni/uni-schema.sql]
\i uni/uni-schema.sql

-- Load data into tables (DELIMITER ',' is default for csv files):
\copy class FROM 'uni/class.csv' CSV
\copy department FROM 'uni/department.csv' CSV
\copy enrolled FROM 'uni/enrolled.csv' CSV
\copy staff FROM 'uni/staff.csv' CSV
\copy student FROM 'uni/student.csv' CSV

-- Exercise 2.1
SELECT s.student_name
FROM student AS s
WHERE s.pursued_degree = 'BSc'
  AND s.student_name LIKE 'Mar%';

-- Exercise 2.2
SELECT c.class_name, s.staff_name
FROM class AS c, staff AS s
WHERE c.class_staff_id = s.staff_id;

-- Exercise 2.3
SELECT DISTINCT s.student_id, s.student_name
FROM student AS s, enrolled AS e, class AS c, staff AS st, department AS d
WHERE s.student_id = e.enrolled_student_id
  AND e.enrolled_class_id = c.class_id
  AND c.class_staff_id = st.staff_id
  AND st.staff_department_id = d.department_id
  AND d.department_name = 'Computer Science';
-- Using DISTINCT is necessary here, because one student may be enrolled in several classes of the ”Computer Science” department.
-- Hence, duplicate rows of student_id and student_name might be produced which can be avoided with DISTINCT.

-- Exercise 2.4
-- Correction: 		-0.5 DISTINCT missing - it is not obvious for Ivana Teach but if you replace her with Linda Davis you can see that it creates duplicates
SELECT DISTINCT s.student_name
FROM student AS s, enrolled AS e, class AS c, staff AS st
WHERE s.student_id = e.enrolled_student_id
  AND e.enrolled_class_id = c.class_id
  AND c.class_staff_id = st.staff_id
  AND s.pursued_degree = 'BSc'
  AND st.staff_name = 'Ivana Teach';
-- Join graph: please see Ex2_join_graphs.pdf

-- Exercise 2.5
SELECT DISTINCT st.staff_name
FROM student AS s, enrolled AS e, class AS c, staff AS st
WHERE s.student_id = e.enrolled_student_id
  AND e.enrolled_class_id = c.class_id
  AND c.class_staff_id = st.staff_id
  AND st.age >= 2*s.age;
-- Note: DISTINCT is used such that "some student in some of the classes" is incorporated

-- Exercise 2.6
WITH -- alternatively, this query could also be formulated using subqueries within the SELECT-FROM-WHERE block
  courses_degrees(class_name, deg) AS 
  (SELECT c.class_name, s.pursued_degree
    FROM student AS s, enrolled AS e, class AS c
    WHERE s.student_id = e.enrolled_student_id
      AND e.enrolled_class_id = c.class_id)
SELECT DISTINCT cd.class_name
FROM courses_degrees AS cd, courses_degrees AS cd2
WHERE cd.class_name = cd2.class_name
  AND cd.deg != cd2.deg; -- such that both BSc and MSc students enrolled
-- Join graph: please see Ex2_join_graphs.pdf

-- Alternative from tutorial:
SELECT DISTINCT c.class_name
FROM student AS s1, student AS s2, enrolled AS e1, enrolled AS e2, class AS c
WHERE s1.student_id = e1.enrolled_student_id
  AND s2.student_id = e2.enrolled_student_id
  AND e1.enrolled_class_id = e2.enrolled_class_id
  AND e1.enrolled_class_id = c.class_id
--  AND s1.student_id <> s2.student_id -- not necessary here (otherwise need also to include in join graph): know if one is BSc and other ist MSc: cannot be same student (as student_id is key)
  AND s1.pursued_degree = 'BSc'
  AND s2.pursued_degree = 'MSc';



-- Exercise 2.7
SELECT c.class_name, st.staff_name, (SELECT d.department_name
                                     FROM department AS d
                                     WHERE st.staff_department_id = d.department_id) AS department_name
FROM class AS c, staff AS st
WHERE c.class_staff_id = st.staff_id;

-------------------------------------------------------------------------------------------------------------------

-- Command to execute: psql -d scratch -f Ex2.sql
