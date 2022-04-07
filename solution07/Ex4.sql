-- Exercise 4: Intra-Table Foreign Keys

-- Set up table with appropriate constraints

DROP TABLE IF EXISTS tree CASCADE;

DROP DOMAIN IF EXISTS label;
CREATE DOMAIN label AS char(1);

CREATE TABLE tree (
  node    label,
  child1  label,
  child2  label
);

INSERT INTO tree(node, child1, child2) VALUES
  ('A', 'B', 'C'),
  ('B', 'D', NULL),
  ('C', 'E', 'F'),
  ('D', NULL, NULL),
  ('E', NULL, NULL),
  ('F', NULL, NULL);

ALTER TABLE tree
ADD PRIMARY KEY (node);

ALTER TABLE tree
  ADD FOREIGN KEY (child1) REFERENCES tree;

ALTER TABLE tree
  ADD FOREIGN KEY (child2) REFERENCES tree;

TABLE tree;


-- Exercise 4.1
SELECT t2.node AS "sibling"
FROM tree AS t1, tree AS t2
WHERE (t1.child1 = 'E'
    OR t1.child2 = 'E')
  AND (t1.child1 = t2.node
    OR t1.child2 = t2.node)
  AND t2.node != 'E';
-- or tutorial:
SELECT t2.node AS "sibling"
FROM tree AS t1, tree AS t2
WHERE  (t1.child1 = 'E' AND t1.child2 = t2.node)
    OR (t1.child2 = 'E' AND t1.child1 = t2.node);


-- Exercise 4.2
SELECT t3.node AS "grandchildren" 
FROM tree AS t1, tree AS t2, tree AS t3
WHERE t1.node = 'A'
 AND (t1.child1 = t2.node
   OR t1.child2 = t2.node)
 AND (t2.child1 = t3.node
   OR t2.child2 = t3.node);
-- or tutorial:
SELECT t3.node AS "grandchildren"
FROM tree AS t1, tree AS t2, tree AS t3
WHERE t1.node = 'A'
  AND (t1.child1 = t2.node OR t1.child2 = t2.node)
  AND (t2.child1 = t3.node OR t2.child2 = t3.node);

-- Exercise 4.3
SELECT t.node AS "root" -- distinct is superfluous
FROM tree AS t
WHERE NOT EXISTS (SELECT 1 -- or without the 1
                  FROM tree AS t1
                  WHERE (t1.child1 = t.node
                      OR t1.child2 = t.node));


-------------------------------------------------------------------------------------------------------------------

-- Command to execute: psql -d scratch -f Ex4.sql
