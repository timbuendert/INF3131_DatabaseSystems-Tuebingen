-- Exercise 1: About SQL

-- Exercise 1.1

DROP TABLE IF EXISTS r;
DROP TABLE IF EXISTS s;
DROP TABLE IF EXISTS t;
CREATE TABLE r(d real, e int, f int);
CREATE TABLE s(x int, y int);
CREATE TABLE t(a real, b text, c text);

INSERT INTO r(d, e, f) VALUES 
  (1.2, 2, 3),
  (3.4, 22, 9);
INSERT INTO s(x, y) VALUES 
  (6, 12),
  (20, 3);
INSERT INTO t(a, b, c) VALUES 
  (0.3, 'Hi', 'Du'),
  (6.2, 'Was', 'Geht');

-- r1
SELECT r.*, t.a, t.b 
FROM r AS r,t AS t
WHERE r.d < t.a;

-- query result
SELECT * 
FROM (SELECT r.*, t.a, t.b 
      FROM r AS r,t AS t
      WHERE r.d < t.a) AS r1,
      s AS r2
WHERE r2.x <> r1.f;


-- Exercise 1.2

-- (a)
DROP TABLE IF EXISTS r;
CREATE TABLE r(a int, b int, c int);

INSERT INTO r(a, b, c) VALUES 
  (2, 3, 4),
  (6, 7, 8);
SELECT t.b, r.c, t.d
FROM (SELECT r.*, r.a + r.b AS d FROM r AS r) as t;


-- (b)
DROP TABLE IF EXISTS r;
DROP TABLE IF EXISTS s;
CREATE TABLE r(a int, b int, c int);
CREATE TABLE s(x int, y int);

INSERT INTO r(a, b, c) VALUES 
  (2, 3, 4),
  (6, 7, 8);
INSERT INTO s(x, y) VALUES 
  (0, 1),
  (10, 11);

SELECT r.*, t.y
FROM r AS r, (SELECT s.y
              FROM s AS s
              WHERE s.x = r.a) as t;

-- (c)
DROP TABLE IF EXISTS r;
DROP TABLE IF EXISTS s;
CREATE TABLE r(a int, b int, c int);
CREATE TABLE s(x int, y int);
ALTER TABLE s ADD PRIMARY KEY (x);

INSERT INTO r(a, b, c) VALUES 
  (2, 3, 4),
  (6, 7, 8);
INSERT INTO s(x, y) VALUES 
  (0, 1),
  (10, 11);

SELECT s.a, (SELECT s.y
             FROM s AS s
             WHERE s.x = s.a) AS c
FROM (SELECT r.a, r.b FROM r AS r) AS s;

-- Exercise 1.3

-- (a)
DROP TABLE IF EXISTS r;
CREATE TABLE r(a int, b int, c int, d int);

INSERT INTO r(a, b, c, d) VALUES 
  (2, 3, 4, 5),
  (6, 7, 8, 9);

SELECT r1.a, r1.b, r1.c
FROM (TABLE r) AS r1
WHERE true;

SELECT r.a, r.b, r.c
FROM r;

-- (b)
DROP TABLE IF EXISTS r;
CREATE TABLE r(a int, b int, c int, d int);

INSERT INTO r(a, b, c, d) VALUES 
  (2, 3, 4, 5),
  (6, 7, 8, 9);

SELECT r1.a, r1.b, r1.c, r1.d
FROM (SELECT t.* FROM r AS t) AS r1;

TABLE r;

SELECT * FROM r AS r;

SELECT r.* FROM r AS r;


-- (c)
SELECT ROW(v.*) :: r FROM r AS v;

SELECT r FROM r AS r;

-------------------------------------------------------------------------------------------------------------------

-- Command to execute: psql -d scratch -f Ex1.sql
