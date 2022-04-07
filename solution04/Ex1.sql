-- Exercise 1: Types

-- Exercise 1.1

-- (a)
DROP TABLE IF EXISTS CARDS_BAD;

CREATE TABLE CARDS_BAD (
  suit    CHAR(1),
  rank    VARCHAR(2)
);

-- (b)
INSERT INTO CARDS_BAD(rank, suit) VALUES 
  ('2', 'C'),
  ('3', 'C'),
  ('4', 'C'),
  ('5', 'C'),
  ('6', 'C'),
  ('7', 'C'),
  ('8', 'C'),
  ('9', 'C'),
  ('J', 'C'),
  ('Q', 'C'),
  ('K', 'C'),
  ('10', 'C'),
  ('A', 'C'),

  ('2', 'S'),
  ('3', 'S'),
  ('4', 'S'),
  ('5', 'S'),
  ('6', 'S'),
  ('7', 'S'),
  ('8', 'S'),
  ('9', 'S'),
  ('J', 'S'),
  ('Q', 'S'),
  ('K', 'S'),
  ('10', 'S'),
  ('A', 'S'),

  ('2', 'H'),
  ('3', 'H'),
  ('4', 'H'),
  ('5', 'H'),
  ('6', 'H'),
  ('7', 'H'),
  ('8', 'H'),
  ('9', 'H'),
  ('J', 'H'),
  ('Q', 'H'),
  ('K', 'H'),
  ('10', 'H'),
  ('A', 'H'),

  ('2', 'D'),
  ('3', 'D'),
  ('4', 'D'),
  ('5', 'D'),
  ('6', 'D'),
  ('7', 'D'),
  ('8', 'D'),
  ('9', 'D'),
  ('J', 'D'),
  ('Q', 'D'),
  ('K', 'D'),
  ('10', 'D'),
  ('A', 'D');

TABLE CARDS_BAD;

-- (c)

DROP TABLE IF EXISTS CARDS_GOOD;

DROP TYPE IF EXISTS suits;
CREATE TYPE suits AS ENUM ('C', 'S', 'H', 'D');

DROP TYPE IF EXISTS ranks;
CREATE TYPE ranks AS ENUM ('2', '3', '4', '5', '6', '7', '8', '9', 'J', 'Q', 'K', '10', 'A');

CREATE TABLE CARDS_GOOD (
  suit    suits,
  rank    ranks
);
-- Remark: one could also add a NOT NULL constraint for both attributes since a poker card must possess both attributes

-- (d)

-- reuse the previusly created INSERT statement
INSERT INTO CARDS_GOOD(suit, rank) 
SELECT suit :: suits, rank :: ranks FROM CARDS_BAD; -- enforces the type constraints on the inserted data tuples

/*
alternatively, one could also insert the poker card deck manually as before:

INSERT INTO CARDS_GOOD(rank, suit) VALUES 
  ('2', 'C'),
  ('3', 'C'),
  ('4', 'C'),
  ('5', 'C'),
  ('6', 'C'),
  ('7', 'C'),
  ('8', 'C'),
  ('9', 'C'),
  ('J', 'C'),
  ('Q', 'C'),
  ('K', 'C'),
  ('10', 'C'),
  ('A', 'C'),

  ('2', 'S'),
  ('3', 'S'),
  ('4', 'S'),
  ('5', 'S'),
  ('6', 'S'),
  ('7', 'S'),
  ('8', 'S'),
  ('9', 'S'),
  ('J', 'S'),
  ('Q', 'S'),
  ('K', 'S'),
  ('10', 'S'),
  ('A', 'S'),

  ('2', 'H'),
  ('3', 'H'),
  ('4', 'H'),
  ('5', 'H'),
  ('6', 'H'),
  ('7', 'H'),
  ('8', 'H'),
  ('9', 'H'),
  ('J', 'H'),
  ('Q', 'H'),
  ('K', 'H'),
  ('10', 'H'),
  ('A', 'H'),

  ('2', 'D'),
  ('3', 'D'),
  ('4', 'D'),
  ('5', 'D'),
  ('6', 'D'),
  ('7', 'D'),
  ('8', 'D'),
  ('9', 'D'),
  ('J', 'D'),
  ('Q', 'D'),
  ('K', 'D'),
  ('10', 'D'),
  ('A', 'D');
*/

TABLE CARDS_GOOD;


-- Exercise 1.2

DELETE FROM CARDS_BAD AS t 
  WHERE t.rank < '7';
TABLE CARDS_BAD;
-- No, the results are not as expected because the cards with rank = 10 were also removed.
-- This is because this table contains the ranks as strings and the string '10' is lexicographically smaller than the string '7' (see SELECT '10' < '7'; in psql shell).
-- Hence, it is also removed from the relation, although this was not intended. So in this respect, CARDS_BAD is "bad" and highlights the need for a correct specification of the types.

DELETE FROM CARDS_GOOD AS t 
  WHERE t.rank < '7';
TABLE CARDS_GOOD;
-- Yes, the results as expected as the string '7' can be casted into the type rank and the domain of this type contains an order due to the ENUM function. 
-- Hence, '10' is not smaller than '7'.

-- Exercise 1.3

INSERT INTO CARDS_BAD(rank, suit) VALUES 
  ('Jo', NULL);
-- The joker can be successfully inserted into the relation CARDS_BAD because it presents an admissible value under the determined types (i.e., VARCHAR(2)).

INSERT INTO CARDS_GOOD(rank, suit) VALUES 
  ('Jo', NULL);
-- This produces an error because only the thirteen ranks which are contained in a poker card deck where defined to be admissible values for the rank column.
-- The Joker ('Jo') belongs to the skat card game and was therefore not part in the definition of the type rank. 
-- Therefore, this row cannot be inserted as 'Jo' is not part of the domain of rank.

-------------------------------------------------------------------------------------------------------------------

-- Command to execute: psql -d scratch -f Ex1.sql
