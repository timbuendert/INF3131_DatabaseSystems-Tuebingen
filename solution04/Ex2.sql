-- Exercise 2: Relation Schema vs. Instance

-- Exercise 2.1
/* 

CHART_1
Relation schema: (CHART_1, {week, Annika, Pierre, Leonie})
Relation instance: inst(CHART_1) = {(49, TRASH & KITCHEN, null, BATHROOM), (50, BATHROOM, TRASH, KITCHEN)}

CHART_2
Relation schema: (CHART_2, {week, TRASH, KITCHEN, BATHROOM})
Relation instance: inst(CHART_2) = {(49, Annika, Annika, Leonie), (50, Pierre, Leonie, Annika)}

CHART_3
Relation schema: (CHART_3, {week, name, service})
Relation instance: inst(CHART_3) = {(49, Annika, TRASH), (49, Annika, KITCHEN), (49, Leonie, BATHROOM), (50, Annika, BATHROOM), (50, Pierre, TRASH), (50, Leonie, KITCHEN)}

*/

-- Exercise 2.2

-- Create three new domains to describe the admissible values as precise as possible
DROP TABLE IF EXISTS CHART_1;
DROP TABLE IF EXISTS CHART_2;
DROP TABLE IF EXISTS CHART_3;


DROP TYPE IF EXISTS weeks;
CREATE DOMAIN weeks AS integer
   CHECK (VALUE > 0 AND VALUE < 54); -- only allow weeks between 1 and 53

DROP TYPE IF EXISTS names;
CREATE DOMAIN names AS text
   CHECK (VALUE ~ '^[A-Z][a-z].*'); -- only allow names where the first letter is upper-cased and all the following letters are lower-cased

/*
Correction from Tutor: 
I don't think your regex for names works as you intended. If you say, only one uppercase and then lowercase letters are valid, 'Hans-Peter' shouldn't pass the check but it does. 
^[A-Z][a-z]* would do that (no dot before the *)
Furthermore, if your regex would've worked as intended: I know Prof Grust allowed it in the forum, but in a real world setting these restrictions to especially 
the names is too restrictive: Hans-Peter would create a problem, and John D. and John B. couldn't live together either	
*/

DROP TYPE IF EXISTS services;
CREATE DOMAIN services AS text
   CHECK (VALUE ~ '^[A-Z]*(\s[&]\s[A-Z]*)?$'); -- only allow services which contains only upper-cased letters; optionally, two of such services can be combined using '&'

CREATE TABLE CHART_1 (
  week    weeks NOT NULL UNIQUE,
  Annika  services, 
  Pierre  services, 
  Leonie  services 
);

CREATE TABLE CHART_2 (
  week      weeks NOT NULL UNIQUE,
  TRASH     names NOT NULL, 
  KITCHEN   names NOT NULL, 
  BATHROOM  names NOT NULL 
);

CREATE TABLE CHART_3 (
  week      weeks NOT NULL, 
  name      names NOT NULL, 
  service   services 
);

-- Exercise 2.3

/* 

(a)
CHART_1: change the instance by adding another tuple (51, KITCHEN, BATHROOM, TRASH), not change the schema
CHART_2: change the instance by adding another tuple (51, Leonie, Annika, Pierre), not change the schema
CHART_3: change the instance by adding three more tuples (51, Annika, KITCHEN), (51, Pierre, BATHROOM), (51, Leonie, TRASH), not change the schema

(b)
CHART_1: change the instance by updating (50, BATHROOM, TRASH, KITCHEN) to (50, BATHROOM, TRASH & COOK, KITCHEN), not change the schema
CHART_2: change the schema by adding a column COOK with the contents (NULL, Pierre), thereby, also changing the instance
CHART_3: change the instance by adding another tuples (50, Pierre, COOK), not change the schema

(c)
CHART_1: change the schema by renaming the column Leonie to Adrian, not change the instance
CHART_2: change the instance by updating (49, Annika, Annika, Leonie), (50, Pierre, Leonie, Annika) to (49, Annika, Annika, Adrian), (50, Pierre, Adrian, Annika), not change the schema
CHART_3: change the instance by updating (49, Leonie, BATHROOM), (50, Leonie, KITCHEN) to (49, Adrian, BATHROOM), (50, Adrian, KITCHEN), not change the schema


In the relational model, relation schemas are assumed to be stable while instances change frequently. Given this, which relation is the best choice to represent the chore chart?
As CHART_3 is the only relation which did not require to change the schmema (-> stable relation schema) but only the instances, this is the best choice to represent the chore chart.

*/


-- Exercise 2.4

-- Fill the three relations with the data tuples

INSERT INTO CHART_1(week, Annika, Pierre, Leonie) VALUES 
  (49, 'TRASH & KITCHEN', NULL, 'BATHROOM'),
  (50, 'BATHROOM', 'TRASH', 'KITCHEN');
TABLE CHART_1;

INSERT INTO CHART_2(week, TRASH, KITCHEN, BATHROOM) VALUES 
  (49, 'Annika', 'Annika', 'Leonie'),
  (50, 'Pierre', 'Leonie', 'Annika');
TABLE CHART_2;

INSERT INTO CHART_3(week, name, service) VALUES 
  (49, 'Annika', 'TRASH'),
  (49, 'Annika', 'KITCHEN'),
  (49, 'Leonie', 'BATHROOM'),
  (50, 'Annika', 'BATHROOM'),
  (50, 'Pierre', 'TRASH'),
  (50, 'Leonie', 'KITCHEN');
TABLE CHART_3;


-- Specify SQL INSERT, UPDATE and DELETE statements for 3a, 3b and 3c for those relations that only need their instance changed.

-- 3(a) - CHART_1
INSERT INTO CHART_1(week, Annika, Pierre, Leonie) VALUES 
  (51, 'KITCHEN', 'BATHROOM', 'TRASH');

-- 3(a) - CHART_2
INSERT INTO CHART_2(week, TRASH, KITCHEN, BATHROOM) VALUES 
  (51, 'Leonie', 'Annika', 'Pierre');

-- 3(a) - CHART_3
INSERT INTO CHART_3(week, name, service) VALUES 
  (51, 'Annika', 'KITCHEN'),
  (51, 'Pierre', 'BATHROOM'),
  (51, 'Leonie', 'TRASH');

-- 3(b) - CHART_1
UPDATE CHART_1 as C1
  SET Pierre = 'TRASH & COOK'
  WHERE C1.week = 50;

-- 3(b) - CHART_3
INSERT INTO CHART_3(week, name, service) VALUES 
  (50, 'Pierre', 'COOK');

-- 3(c) - CHART_2
UPDATE CHART_2 as C2
  SET KITCHEN = 'Adrian'
  WHERE C2.KITCHEN = 'Leonie';

UPDATE CHART_2 as C2
  SET BATHROOM = 'Adrian'
  WHERE C2.BATHROOM = 'Leonie';

-- 3(c) - CHART_3
UPDATE CHART_3 as C3
  SET name = 'Adrian'
  WHERE C3.name = 'Leonie';


TABLE CHART_1;
TABLE CHART_2;
TABLE CHART_3;

-------------------------------------------------------------------------------------------------------------------

-- Command to execute: psql -d scratch -f Ex2.sql
