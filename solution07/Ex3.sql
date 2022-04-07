-- Exercise 2: Existential Quantification

-- Create tables and insert values
DROP TABLE IF EXISTS p;
DROP TABLE IF EXISTS q;

CREATE TABLE p (x int); 
CREATE TABLE q (x int);

ALTER TABLE p ALTER COLUMN x SET NOT NULL; 
ALTER TABLE q ALTER COLUMN x SET NOT NULL;

INSERT INTO p(x) VALUES
(0),
(4),
(3),
(20),
(5),
(47);


INSERT INTO q(x) VALUES
(3),
(10),
(3),
(48),
(0),
(12);


-- Exercise 2.1
SELECT DISTINCT p.x AS "p \ q"
FROM p AS p
WHERE p.x NOT IN (TABLE q);

-- Exercise 2.2
SELECT DISTINCT p.x AS "p INTERSECT q"
FROM p AS p
WHERE p.x IN (TABLE q); 

-- Exercise 2.3: all p in q -> not exists p.x which is not in q.x
SELECT NOT EXISTS (SELECT 1
                   FROM p AS p
                   WHERE p.x NOT IN (SELECT q.x
                                     FROM q AS q)) AS "p SUBSET OF q";

-- second case: now p is a subset of q
TRUNCATE TABLE p;
INSERT INTO p(x) VALUES
(0),
(3),
(10);

SELECT NOT EXISTS (SELECT 1
                   FROM p AS p
                   WHERE p.x NOT IN (SELECT q.x
                                     FROM q AS q)) AS "p SUBSET OF q";

-- Note Tutorial: or only p instead of p.x  & q instead of q.x (more general)
-- or tutorial:
SELECT NOT EXISTS (SELECT 
                   FROM p AS p
                   WHERE NOT EXISTS (SELECT 
                                     FROM q AS q
                                     WHERE p = q)) AS "p SUBSET OF q";

-------------------------------------------------------------------------------------------------------------------

-- Command to execute: psql -d scratch -f Ex3.sql
