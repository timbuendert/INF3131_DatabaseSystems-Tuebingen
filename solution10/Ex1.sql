-- Exercise 1: Cell Phone Tracking

-- Import the data and function
\i mobile_phone_tracking.sql
\i haversine.sql


-- Exercise 1.1
WITH celltowers_unique(lat, lon) AS (
  SELECT DISTINCT ct.lat, ct.lon -- want to count the number of celltowers, so keep only unique positions to avoid counting towers double
  FROM celltowers AS ct)
SELECT COUNT(*)
FROM celltowers_unique AS c_u
WHERE haversine(48.521460, 9.053271, c_u.lat, c_u.lon) < 10000;


-- Exercise 1.2
WITH days_cells(day, mcc, mnc, lac, cell_id, net_type, quantity) AS (
  SELECT date(c.measured_at), c.mcc, c.mnc, c.lac, c.cell_id, c.net_type, COUNT(*)
  FROM cells AS c
  GROUP BY date(c.measured_at), c.mcc, c.mnc, c.lac, c.cell_id, c.net_type)
SELECT d_c.day, d_c.mcc, d_c.mnc, d_c.lac, d_c.cell_id, d_c.net_type, d_c.quantity
FROM days_cells AS d_c
WHERE d_c.quantity = (SELECT MAX(d_c2.quantity)
                      FROM days_cells AS d_c2
                      WHERE d_c.day = d_c2.day);

-- Tutorial solution:
WITH celltowers_count(day, mcc, mnc, lac, cell_id, net_type, count) AS (
  SELECT date(c.measured_at) AS day, c.mcc, c.mnc, c.lac, c.cell_id, c.net_type, COUNT(*) AS count
  FROM cells AS c
  GROUP BY day, c.mcc, c.mnc, c.lac, c.cell_id, c.net_type
)
SELECT tc1.day, tc1.mcc, tc1.mnc, tc1.lac, tc1.cell_id, tc1.net_type, tc1.count
FROM celltowers_count AS tc1, (SELECT tc.day, MAX(tc.count) AS max
                               FROM celltowers_count AS tc
                               GROUP BY tc.day) AS tc2 -- there, know that have 3 days -> 3 results
WHERE tc1.day = tc2.day                          
AND tc1.count = tc2.max;

-- Exercise 1.3                                
WITH change_locations(pos, next_pos) AS (
  SELECT current_pos.measured_at, next_pos.measured_at
  FROM cells AS current_pos, cells AS next_pos
  WHERE next_pos.measured_at = (SELECT MIN(c2.measured_at) -- 'Note that a mobile phone can record one measurement at a time only'
                                FROM cells AS c2
                                WHERE c2.measured_at > current_pos.measured_at
                                AND (c2.mcc, c2.mnc, c2.lac, c2.cell_id, c2.net_type) IN (SELECT t.mcc, t.mnc, t.lac, t.cell_id, t.net_type -- that was missing for correct solution: zum ausschließen fehlerhafter Messungen
                                                                                          FROM celltowers AS t)) -- that was missing for correct solution
-- need join over celltowers and cells beforehand -> otherwise contains connections to celltowers that are not in the celltowers table, i.e. the distances for these connections are wrong 
)
SELECT date(c.measured_at), SUM(haversine(ct.lat, ct.lon, ct_next.lat, ct_next.lon)) AS distance
FROM change_locations AS c_l, cells AS c, cells AS c_next, celltowers AS ct, celltowers AS ct_next
WHERE c_l.pos = c.measured_at
  AND c_l.next_pos = c_next.measured_at
  AND date(c.measured_at) = date(c_next.measured_at)
  
  AND c.mcc = ct.mcc
  AND c.mnc = ct.mnc
  AND c.lac = ct.lac
  AND c.cell_id = ct.cell_id
  AND c.net_type = ct.net_type

  AND c_next.mcc = ct_next.mcc
  AND c_next.mnc = ct_next.mnc
  AND c_next.lac = ct_next.lac
  AND c_next.cell_id = ct_next.cell_id
  AND c_next.net_type = ct_next.net_type
  
  GROUP BY date(c.measured_at);

-- Tutorial solution:
WITH successors AS (
  SELECT c.mcc, c.mnc, c.lac, c.cell_id, c.net_type, (SELECT MIN(c_.measured_at)
                                                      FROM cells as c_
                                                      WHERE c.measured_at < c_.measured_at
                                                      AND date(c.measured_at) = date(c_.measured_at)
                                                      AND (c_.mcc, c_.mnc, c_.lac, c_.cell_id, c_.net_type) IN (SELECT t.mcc, t.mnc, t.lac, t.cell_id, t.net_type
                                                                                                                FROM celltowers AS t)
                                                      ) AS successor_time
  FROM cells AS c
)
SELECT date(c.measured_at) AS day, SUM(haversine(t1.lat, t1.lon, t2.lat, t2.lon)) AS distance
FROM cells AS c NATURAL JOIN celltowers AS t1,
     successors AS s NATURAL JOIN celltowers AS t2
WHERE s.successor_time = c.measured_at
GROUP BY day;

-------------------------------------------------------------------------------------------------------------------

-- Command to execute: psql -d scratch -f Ex1.sql