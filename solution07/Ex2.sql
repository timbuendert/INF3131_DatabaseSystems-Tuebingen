-- Exercise 2: Cascading Deletes

-- Note: auch via CREATE TRIGGER (?)

-- Creating and filling the tables
DROP TABLE IF EXISTS r CASCADE;
CREATE TABLE r (
  a   int UNIQUE,
  b   text,
  c   int UNIQUE
);

DROP TABLE IF EXISTS s CASCADE;
CREATE TABLE s (
  x    int UNIQUE,
  y    text,
  z    int UNIQUE
);

INSERT INTO s(x, y, z) VALUES
(0, 'pineapple', 1),
(1, 'strawberry', 2),
(2, 'apple', 3),
(3, 'banana', 4),
(4, 'kiwi', 5),
(5, 'orange', 0);

INSERT INTO r(a, b, c) VALUES
(0, 'England', 1),
(1, 'Germany', 2),
(2, 'USA', 3),
(3, 'France', 4),
(4, 'Australia', 5),
(5, 'Ecuador', 0);

-- Adding the constraints

ALTER TABLE s
  ADD PRIMARY KEY (x);

ALTER TABLE r
  ADD PRIMARY KEY (a);

ALTER TABLE r
  ADD FOREIGN KEY (a) REFERENCES s(x)
  ON DELETE CASCADE;

ALTER TABLE r
  ADD FOREIGN KEY (c) REFERENCES r(a)
  ON DELETE CASCADE;

ALTER TABLE s
  ADD FOREIGN KEY (z) REFERENCES s(x)
  ON DELETE CASCADE;

-- Showing tables before DELETE statements
TABLE s;
TABLE r;

-- Showing the two desired properties (by commenting out the other one)

-- Showing property 1
DELETE FROM s AS s
WHERE s.y = 'banana';

-- Showing property 2
--DELETE FROM r AS r
--WHERE r.b = 'Ecuador';

-- Showing tables after DELETE statements
TABLE s;
TABLE r;


-------------------------------------------------------------------------------------------------------------------

-- Command to execute: psql -d scratch -f Ex2.sql
