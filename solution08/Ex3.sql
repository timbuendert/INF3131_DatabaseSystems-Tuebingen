-- Exercise 3: LEGO Data Warehouse

-- Import the schema
\i legodw.sql

-- Exercise 3.1
SELECT st.store, st.city, d.dow, SUM(sa.items * sa.price) AS "turnover"
FROM dates AS d, sales AS sa, stores AS st
WHERE sa.store = st.store
  AND sa.date = d.date
  AND st.country = 'Germany'
GROUP BY st.store, st.city, d.dow; -- can add st.city because store is primary key in stores


-- Exercise 3.2
WITH turnover_days(store, city, dow, turnover) AS (
  SELECT st.store, st.city, d.dow, SUM(sa.items * sa.price) AS "turnover"
  FROM dates AS d, sales AS sa, stores AS st
  WHERE sa.store = st.store
    AND sa.date = d.date
    AND st.country = 'Germany'
  GROUP BY st.store, st.city, d.dow)
SELECT t.store, t.city, t.dow, t.turnover
FROM turnover_days AS t
WHERE t.turnover = (SELECT max(t2.turnover)
                    FROM turnover_days AS t2
                    WHERE t.store = t2.store);


-- Exercise 3.3
WITH sets_county(country, set, items) AS (
  SELECT st.country, sa.set, SUM(sa.items) AS "items"
  FROM sales AS sa, stores AS st
  WHERE sa.store = st.store
  GROUP BY st.country, sa.set)
SELECT s.country, s.set, s.items
FROM sets_county AS s
WHERE s.items = (SELECT max(s2.items)
                 FROM sets_county AS s2
                 WHERE s.country = s2.country);

-------------------------------------------------------------------------------------------------------------------

-- Command to execute: psql -d scratch -f Ex3.sql
