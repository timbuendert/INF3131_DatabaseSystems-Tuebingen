-- Exercise 2: ER → SQL

-- Exercise 2.1
DROP TABLE IF EXISTS hospitals CASCADE;
DROP TABLE IF EXISTS wards CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS assigned_to CASCADE;
DROP TABLE IF EXISTS doctors CASCADE;
DROP TABLE IF EXISTS patients CASCADE;
DROP TABLE IF EXISTS treated_by CASCADE;
DROP TABLE IF EXISTS responsible_for CASCADE;

CREATE TABLE hospitals (
  name            text,
  address         text
  );
ALTER TABLE hospitals ADD PRIMARY KEY (name);

CREATE TABLE wards (
  number            int,
  designation       text
  );
ALTER TABLE wards ADD belong_to text NOT NULL;
ALTER TABLE wards ADD PRIMARY KEY (belong_to, number);
ALTER TABLE wards ADD FOREIGN KEY (belong_to) REFERENCES hospitals(name) ON DELETE CASCADE;

CREATE TABLE employees (
  ssn             char(9), -- US version of SSN: nine digit number
  name            text,
  last_name       text,
  salary          float,
  date_of_birth   date
  );
ALTER TABLE employees ADD PRIMARY KEY (ssn);
ALTER TABLE employees ADD COLUMN works_at text NOT NULL;
ALTER TABLE employees ADD FOREIGN KEY (works_at) REFERENCES hospitals(name);

CREATE TABLE assigned_to (
  belong_to       text,
  number          int,
  ssn             char(9)
  );
ALTER TABLE assigned_to ADD PRIMARY KEY (belong_to, number, ssn);
ALTER TABLE assigned_to ADD FOREIGN KEY (belong_to, number) REFERENCES wards(belong_to, number) ON DELETE CASCADE;
ALTER TABLE assigned_to ADD FOREIGN KEY (ssn) REFERENCES employees(ssn) ON DELETE CASCADE;

CREATE TABLE doctors (
  license_number   int,
  academic_title   text,
  med_field        text
  );
ALTER TABLE doctors ADD PRIMARY KEY (license_number);
ALTER TABLE doctors ADD is_a char(9) NOT NULL;
ALTER TABLE doctors ADD FOREIGN KEY (is_a) REFERENCES employees(ssn);
ALTER TABLE doctors ADD UNIQUE (is_a);

CREATE TABLE patients (
  hin               int,
  name              text,
  last_name         text,
  date_of_birth     date,
  address           text
  );
ALTER TABLE patients ADD PRIMARY KEY (hin);

CREATE TABLE treated_by (
  license_number    int,
  hin               int
  );
ALTER TABLE treated_by ADD PRIMARY KEY (license_number, hin);
ALTER TABLE treated_by ADD FOREIGN KEY (license_number) REFERENCES doctors(license_number) ON DELETE CASCADE;
ALTER TABLE treated_by ADD FOREIGN KEY (hin) REFERENCES patients(hin) ON DELETE CASCADE;

CREATE TABLE responsible_for (
  license_number    int,
  hin               int
  );
ALTER TABLE responsible_for ADD PRIMARY KEY (license_number, hin);
ALTER TABLE responsible_for ADD FOREIGN KEY (license_number) REFERENCES doctors(license_number) ON DELETE CASCADE;
ALTER TABLE responsible_for ADD FOREIGN KEY (hin) REFERENCES patients(hin) ON DELETE CASCADE;


-- Exercise 2.2
INSERT INTO hospitals(name, address) VALUES
  ('Universitätsklinikum Tuebingen', 'Geissweg 3, 72076 Tubingen');

INSERT INTO wards(number, designation, belong_to) VALUES
  (1, 'Orthopedics', 'Universitätsklinikum Tuebingen'),
  (2, 'Sports Medicine', 'Universitätsklinikum Tuebingen');

INSERT INTO employees(ssn, name, last_name, salary, date_of_birth, works_at) VALUES
  (123456789, 'John', 'Doe', 3000, '1970-01-01', 'Universitätsklinikum Tuebingen'),
  (234567890, 'Pete', 'Campbell', 6000, '1980-01-01', 'Universitätsklinikum Tuebingen'),
  (345678901, 'Frank', 'Miller', 45000, '1975-01-01', 'Universitätsklinikum Tuebingen');

INSERT INTO assigned_to(belong_to, number, ssn) VALUES
  ('Universitätsklinikum Tuebingen', 1, 123456789),
  ('Universitätsklinikum Tuebingen', 1, 234567890),
  ('Universitätsklinikum Tuebingen', 2, 345678901);

INSERT INTO doctors(license_number, academic_title, med_field, is_a) VALUES
  (24389234, 'Dr. med.', 'Arthroplasty', 234567890),
  (69793823, 'Prof. Dr. med.', 'Spine disease', 345678901);

INSERT INTO patients(hin, name, last_name, date_of_birth, address) VALUES
  (48432, 'Matt', 'Johnson', '1976-03-23', 'Geissweg 3, 72076 Tubingen'),
  (67745, 'Bruce', 'Kleber', '2000-05-15', 'Mohlstrasse 50, 72074 Tubingen'),
  (45786, 'Steve', 'Morant', '1992-11-08', 'Dieselstrasse 6, 72074 Tubingen'),
  (51469, 'Nico', 'Jordan', '1984-04-21', 'Schellingstrasse 6, 72072 Tubingen');

INSERT INTO treated_by(license_number, hin) VALUES
  (24389234, 48432),
  (24389234, 67745),
  (24389234, 45786),
  (24389234, 51469),
  (69793823, 51469),
  (69793823, 67745);

INSERT INTO responsible_for(license_number, hin) VALUES
  (24389234, 48432),
  (69793823, 67745),
  (24389234, 45786),
  (24389234, 51469),
  (69793823, 51469);

TABLE hospitals;
TABLE wards;
TABLE employees;
TABLE assigned_to;
TABLE doctors;
TABLE patients;
TABLE treated_by;
TABLE responsible_for;

-- Exercise 2.3                                
/*

Yes, the following constraints of the EER diagram cannot be enforced by the SQL database schema:
- The 1 in (1,*) between hospitals and wards (belong_to), because we cannot enforce that each hospital appears (at least once) in the column belong_to in wards.
- The 1 in (1,*) between employees and wards (assigned_to), because we cannot enforce that each employee appears (at least once) in the assigned_to table.
- The 1 in (1,*) between patients and doctors (responsible_for), because we cannot enforce that each patient appears (at least once) in the responsible_for table.

As these constraints cannot be implemented, they would need to be either checked by the application program or some general SQL constraint mechanism such that only correct data is inputted.

*/

-------------------------------------------------------------------------------------------------------------------

-- Command to execute: psql -d scratch -f Ex2.sql