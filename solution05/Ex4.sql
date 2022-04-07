-- Exercise 4: Using Keys

DROP TABLE IF EXISTS r;

CREATE TABLE r (a int, b varchar(9999), c int, d int, e text);

ALTER TABLE r ALTER COLUMN a SET NOT NULL; 
ALTER TABLE r ALTER COLUMN b SET NOT NULL; 
ALTER TABLE r ALTER COLUMN c SET NOT NULL;

ALTER TABLE r ADD UNIQUE (a, c); 
ALTER TABLE r ADD UNIQUE (b);
ALTER TABLE r ADD UNIQUE (d);

-- Exercise 4.1

-- Combinations that are eligible for primary key: {{a,c}, {b}} because these are the only minimal combinations of columns (without superfluous columns) which are known to be not null and uniquely identify the rows.
-- While {b} presents a possible key consisting of only one column, it is of type varchar(9999) which would make the frequent evaluation of the primary key very expensive.
-- Hence, as a and c are both of type integer, the combination {a,c} would be more suitable to be a primary key (would be chosen) because the evaluations would be very cheap.


-- Exercise 4.2
ALTER TABLE r
  ADD PRIMARY KEY (a, c); 


-- Exercise 4.3
ALTER TABLE r DROP CONSTRAINT r_pkey; -- remove primary key from 4.2
ALTER TABLE r ADD COLUMN id int;
ALTER TABLE r ADD PRIMARY KEY (id);

-- The new column id being the primary key provides the advantage that it is only one column and in addition of type integer, which makes the frequent evaluation and identification of rows as well as joins very fast/cheap.
-- In addition, such an artifical (surrogate) key will not change while natural keys might be subject to changes (even though they are constrained to be unique) which makes evaluations more stable.
-- Also, by setting this new column as the primary key, the NOT NULL and UNIQUE constraints regarding the column id are automatically integrated.
-- Now, the identification of rows also becomes more straightforward (requires no additional knowledge) and easier as it does not require to consider two columns of the relation, but only one.

-- However, a disadvantage of this new column is that it somehow breaks the logical consistency in the relation (as it is artifically created) and can be considered unnecessary as the relation already contains possible primary keys.
-- Hence it may waste space.


/* 
Exercise 4.4

SELECT DISTINCT v.a, v.b, v.e 
FROM r AS v;

DISTINCT is superfluous and not necessary here because the column b alone presents a candidate key for the relation r which rules out the possibility of duplicate rows as it is inherently unique.
Hence, the columns {a,b,e} altogether form a superkey which consequently also rules out any duplicate rows.
Therefore, the DISTINCT modifier is not required in this query but will only incur (computational) costs.
*/

-------------------------------------------------------------------------------------------------------------------

-- Command to execute: psql -d scratch -f Ex4.sql 
