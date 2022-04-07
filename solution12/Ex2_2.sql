-- Exercise 2: SQL and Relational Algebra

-- Exercise 2.1
DROP TABLE IF EXISTS aircraft CASCADE;
DROP TABLE IF EXISTS pilots CASCADE;
DROP TABLE IF EXISTS certified CASCADE;
DROP TABLE IF EXISTS flights CASCADE;
DROP TABLE IF EXISTS crew CASCADE;

CREATE TABLE aircraft (
  aid             int,
  name            text,
  manufacturer    text,
  cruisingrange   int
  );
ALTER TABLE aircraft ADD PRIMARY KEY (aid);

CREATE TABLE pilots (
  pid            int,
  name           text,
  salary         int
  );
ALTER TABLE pilots ADD PRIMARY KEY (pid);

CREATE TABLE certified (
  pid           int,
  aid           int
  );
ALTER TABLE certified ADD PRIMARY KEY (pid, aid);
ALTER TABLE certified ADD FOREIGN KEY (aid) REFERENCES aircraft(aid) ON DELETE CASCADE;
ALTER TABLE certified ADD FOREIGN KEY (pid) REFERENCES pilots(pid) ON DELETE CASCADE;

CREATE TABLE flights (
  flno       int,
  from_      text,
  to_        text,
  distance   int,
  departs    timestamp,
  arrives    timestamp
  );
ALTER TABLE flights ADD PRIMARY KEY (flno);

CREATE TABLE crew (
  flno       int,
  pid        int
  );
ALTER TABLE crew ADD PRIMARY KEY (flno, pid);
ALTER TABLE crew ADD FOREIGN KEY (flno) REFERENCES flights(flno) ON DELETE CASCADE;
ALTER TABLE crew ADD FOREIGN KEY (pid) REFERENCES pilots(pid) ON DELETE CASCADE;

-- Populate table
\COPY aircraft(aid, name, manufacturer, cruisingrange) FROM 'airline/aircraft.csv' delimiter E'\t' CSV HEADER;
\COPY pilots(pid, name, salary) FROM 'airline/pilots.csv' delimiter E'\t' CSV HEADER;
\COPY certified(pid, aid) FROM 'airline/certified.csv' delimiter E'\t' CSV HEADER;
\COPY flights(flno, from_, to_, distance, departs, arrives) FROM 'airline/flights.csv' delimiter E'\t' CSV HEADER;
\COPY crew(flno, pid) FROM 'airline/crew.csv' delimiter E'\t' CSV HEADER;

-- Exercise 2.2
SELECT p.* -- generally: add DISTINCT when RA -> SQL to ensure set semantic (no duplicates)
FROM pilots AS p
WHERE NOT EXISTS (SELECT 1
                  FROM aircraft AS a, certified AS c
                  WHERE a.cruisingrange >= 800
                    AND c.aid = a.aid
                    AND c.pid = p.pid);

-------------------------------------------------------------------------------------------------------------------

-- Command to execute: psql -d scratch -f Ex2_2.sql