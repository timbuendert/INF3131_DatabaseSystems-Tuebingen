-- Exercise 2: From NF^2 to 1NF

-- Exercise 2.1

-- Rough description of workflow:
-- For each attribute of Departments is has to be evaluated whether it contains an atomic value (-> is fine & can be kept) or a table.
-- In the latter case, a new table is created which references to the original table using surrogates and it is tried to encode it in 1NF format as before.
-- If once again, an attribute of this new table contains tables (e.g. employees -> tasks -> {task, duedate}), another table is created which references again using surrogates.
-- This is repeated until it is possible to encode all the information in flat 1NF format and the tables are connected using the respective surrogates.
-- In case a subtable is empty, the respective surrogate simply does not appear in the respective 1NF table.

DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS tasks;
DROP TABLE IF EXISTS contacts;

DROP TYPE IF EXISTS surrogate;
CREATE DOMAIN surrogate integer NOT NULL;

CREATE TABLE departments (
  department        text,
  employees_sur     surrogate NOT NULL,
  contacts_sur      surrogate NOT NULL
  );

CREATE TABLE employees (
  employee_sur    surrogate NOT NULL,
  name            text NOT NULL,
  salary          int,
  tasks_sur       surrogate NOT NULL
  );

CREATE TABLE tasks (
  task_sur   surrogate NOT NULL,
  task       text NOT NULL,
  duedate    date NOT NULL
  );

CREATE TABLE contacts (
  contact_sur    surrogate NOT NULL,
  contact        text NOT NULL,
  client         boolean NOT NULL
  );


ALTER TABLE departments
  ADD PRIMARY KEY (department);

ALTER TABLE employees
  ADD PRIMARY KEY (name);

ALTER TABLE tasks
  ADD PRIMARY KEY (task);

ALTER TABLE contacts
  ADD PRIMARY KEY (contact);



-- Exercise 2.2

INSERT INTO departments(department, employees_sur, contacts_sur) VALUES
  ('Engineering', 1, 1),
  ('IT Security', 2, 2),
  ('Advertising', 3, 3);

INSERT INTO employees(employee_sur, name, salary, tasks_sur) VALUES
  (1, 'John Doe', 7000, 1),
  (1, 'Jane Doe', 10000, 2),
  (2, 'Eve', 10000, 3),
  (2, 'Mallory', 5000, 4),
  (2, 'Alice', 5000, 5),
  (2, 'Bob', 5000, 6),
  (3, 'Donald Draper', 10000, 7),
  (3, 'Peter Campbell', 5000, 8);

INSERT INTO tasks(task_sur, task, duedate) VALUES
  (1, 'task1', '2014-01-19'),
  (1, 'task2', '2014-01-18'),
  (2, 'task3', '2014-01-19'),
  (2, 'task4', '2014-01-18'),
  (2, 'task5', '2014-01-17'),
  (2, 'task6', '2014-01-10'),
  (2, 'task7', '2013-12-23'),
  (3, 'task8', '2014-01-19'),
  (3, 'task9', '2014-01-18'),
  (4, 'task10', '2014-01-19'),
  (6, 'task11', '2014-02-02'),
  (6, 'task12', '2014-01-18'),
  (6, 'task13', '2014-01-18'),
  (7, 'task14', '2014-01-19'),
  (7, 'task15', '2014-01-18');

INSERT INTO contacts(contact_sur, contact, client) VALUES
  (2, 'contact4', true),
  (2, 'contact5', false),
  (2, 'contact6', false),
  (3, 'contact7', true),
  (3, 'contact8', true),
  (3, 'contact9', true),
  (3, 'contact10', true),
  (3, 'contact11', true),
  (3, 'contact12', true),
  (3, 'contact13', true);

TABLE departments;
TABLE employees;
TABLE tasks;
TABLE contacts;



-- Exercise 2.3
-- a)
SELECT d.department, count(e.name) AS "employees_count"
FROM departments AS d, employees AS e
WHERE d.employees_sur = e.employee_sur
GROUP BY d.department;

-- b)
SELECT d.department
FROM departments AS d
WHERE NOT EXISTS(SELECT 1
                 FROM contacts AS c
                 WHERE d.contacts_sur = c.contact_sur);

-- c)
SELECT e.name, d.department
FROM  departments AS d, employees AS e
WHERE d.employees_sur = e.employee_sur
  AND NOT EXISTS(SELECT 1
                 FROM tasks AS t
                 WHERE e.tasks_sur = t.task_sur);

-- d)
SELECT d.department, (SELECT count(c.client)
                      FROM contacts AS c
                      WHERE d.contacts_sur = c.contact_sur
                        AND c.client = true) AS "clients_count"
FROM  departments AS d;

-------------------------------------------------------------------------------------------------------------------

-- Command to execute: psql -d scratch -f Ex2.sql
