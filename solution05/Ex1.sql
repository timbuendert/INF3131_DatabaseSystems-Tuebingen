-- Exercise 1: Constraints

-- Exercise 1.1

DROP TABLE IF EXISTS employees;

-- Part 1: Define constraints
DROP TYPE IF EXISTS salary;
CREATE DOMAIN salary AS float
   CHECK (VALUE > 1473.33); -- rule ii.

DROP TYPE IF EXISTS emp_role;
CREATE TYPE emp_role AS ENUM ('Manager', 'Developer', 'Accountant', 'Secretary'); -- rule iii.

-- rule i. (for all the following columns via NOT NULL -> could also use ALTER TABLE r ALTER COLUMN a SET NOT NULL; but this way: more compact specification [same for UNIQUE constraint])
CREATE TABLE employees (
  employee_id     int NOT NULL UNIQUE,    -- rule v.
  lastname        text NOT NULL,
  firstname       text NOT NULL,
  address         text NOT NULL,      
  hire_date       date NOT NULL,
  salary          salary NOT NULL,        -- monthly salary (in €)
  emp_role        emp_role NOT NULL,      -- employee role
  department_id   int NOT NULL            -- identifier of employee's department
);

-- rule iv.: (P -> Q) <-> (-P | Q)
ALTER TABLE employees
  ADD CONSTRAINT veteran_managers CHECK (NOT (emp_role='Manager' AND hire_date > '2013-11-24') OR salary<=17679.96);


-- Part 2: INSERT statement which abide by and violate the rules

-- rule i.
INSERT INTO employees(employee_id, lastname, firstname, address, hire_date, salary, emp_role, department_id) VALUES 
  ('0', 'Mayer', 'Michael', 'Weg 3', '2015-06-30', 1600, NULL, 3); -- violates rule

INSERT INTO employees(employee_id, lastname, firstname, address, hire_date, salary, emp_role, department_id) VALUES 
  ('0', 'Mayer', 'Michael', 'Weg 3', '2015-06-30', 1600, 'Developer', 3); -- abides by rule

TRUNCATE TABLE employees;

-- rule ii.
INSERT INTO employees(employee_id, lastname, firstname, address, hire_date, salary, emp_role, department_id) VALUES 
  ('0', 'Mayer', 'Michael', 'Weg 3', '2015-06-30', 1200, 'Developer', 3); -- violates rule

INSERT INTO employees(employee_id, lastname, firstname, address, hire_date, salary, emp_role, department_id) VALUES 
  ('0', 'Mayer', 'Michael', 'Weg 3', '2015-06-30', 1600, 'Developer', 3); -- abides by rule

TRUNCATE TABLE employees;


-- rule iii.
INSERT INTO employees(employee_id, lastname, firstname, address, hire_date, salary, emp_role, department_id) VALUES 
  ('0', 'Mayer', 'Michael', 'Weg 3', '2015-06-30', 1600, 'Product Owner', 3); -- violates rule

INSERT INTO employees(employee_id, lastname, firstname, address, hire_date, salary, emp_role, department_id) VALUES 
  ('0', 'Mayer', 'Michael', 'Weg 3', '2015-06-30', 1600, 'Developer', 3); -- abides rule

TRUNCATE TABLE employees;


-- rule iv.
INSERT INTO employees(employee_id, lastname, firstname, address, hire_date, salary, emp_role, department_id) VALUES 
  ('0', 'Mayer', 'Michael', 'Weg 3', '2015-06-30', 19000, 'Manager', 3); -- violates rule

INSERT INTO employees(employee_id, lastname, firstname, address, hire_date, salary, emp_role, department_id) VALUES 
  ('0', 'Mayer', 'Michael', 'Weg 3', '2015-06-30', 1600, 'Manager', 3); -- abides by rule

TRUNCATE TABLE employees;


-- rule v.
INSERT INTO employees(employee_id, lastname, firstname, address, hire_date, salary, emp_role, department_id) VALUES 
  ('0', 'Schmidt', 'Max', 'Straße 2', '2017-08-24', 3000, 'Accountant', 1);

INSERT INTO employees(employee_id, lastname, firstname, address, hire_date, salary, emp_role, department_id) VALUES 
  ('0', 'Mayer', 'Michael', 'Weg 3', '2015-06-30', 1600, 'Developer', 2); -- violates rule

INSERT INTO employees(employee_id, lastname, firstname, address, hire_date, salary, emp_role, department_id) VALUES 
  ('1', 'Mayer', 'Michael', 'Weg 3', '2015-06-30', 1600, 'Developer', 3); -- abides by rule

TRUNCATE TABLE employees;

/* 
-- Exercise 1.2

Please explain why it is impossible to enforce. . .
(a) . . . rule iv using a domain constraint (CREATE DOMAIN),
Rule IV cannot be enforced using a domain constraint because this rule is conditional on values in other columns (emp_role, hire_date) and concerns not only the column for which we want to restrict the domain (salary).
However, one cannot refer to other columns than the one for which we want to restrict the domain when defining a domain constraint and therefore, this constraint cannot be implemented.

(b) . . . rule v in terms of a CHECK constaint.
Rule V cannot be enforced using a CHECK constraint because CHECK constraints are evaluated for each row individually.
However, one cannot check this rule in one row, but would need to look at the entire table for that. 
This in turn is not possible using a CHECK constraint and hence, this rule cannot be enforced.

*/

-------------------------------------------------------------------------------------------------------------------

-- Command to execute: psql -d scratch -f Ex1.sql
