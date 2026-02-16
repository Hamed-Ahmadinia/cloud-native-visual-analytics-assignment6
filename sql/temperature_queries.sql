/* ============================================================
   Assignment 6 — Optional Second Dataset (Temperatures)
   File: sql/temperature_queries.sql

   Table assumed:
     analytics.daily_temperatures(date Date, temperature Float64)
   ============================================================ */


/* ---------- 1) BASIC VERIFICATION / SANITY CHECKS ---------- */

-- 1.1 Row count (should be ~3650)
SELECT count() AS row_count
FROM analytics.daily_temperatures;

-- 1.2 Preview sample rows
SELECT *
FROM analytics.daily_temperatures
ORDER BY date ASC
LIMIT 10;

-- 1.3 Check min/max dates + number of distinct years
SELECT
  min(date) AS min_date,
  max(date) AS max_date,
  uniqExact(toYear(date)) AS distinct_years
FROM analytics.daily_temperatures;

-- 1.4 Basic temperature stats
SELECT
  round(min(temperature), 2) AS min_temp,
  round(max(temperature), 2) AS max_temp,
  round(avg(temperature), 2) AS avg_temp
FROM analytics.daily_temperatures;


/* ---------- 2) DASHBOARD PANEL QUERIES ---------- */
/* NOTE for Grafana:
   - Time series expects a "time" column + value
   - Bar chart expects category/dimension + value
*/


/* ------------------------------------------------------------
   Panel 1 — Daily Temperature (Time series)
   ------------------------------------------------------------ */
SELECT
  date AS time,
  temperature
FROM analytics.daily_temperatures
ORDER BY time;


/* ------------------------------------------------------------
   Panel 2 — Monthly Average Temperature (Time-based aggregation)
   (Time series)
   ------------------------------------------------------------ */
SELECT
  toStartOfMonth(date) AS time,
  round(avg(temperature), 2) AS avg_temp
FROM analytics.daily_temperatures
GROUP BY time
ORDER BY time;


/* ------------------------------------------------------------
   Panel 3 — Yearly Temperature Range (Derived metric: Max - Min)
   (Bar chart)
   ------------------------------------------------------------ */
SELECT
  toYear(date) AS year,
  round(max(temperature) - min(temperature), 2) AS yearly_range
FROM analytics.daily_temperatures
GROUP BY year
ORDER BY year;


/* ------------------------------------------------------------
   Panel 4 — 90th Percentile Temperature per Year (Advanced metric)
   (Bar chart)
   ------------------------------------------------------------ */
SELECT
  toYear(date) AS year,
  round(quantile(0.9)(temperature), 2) AS p90_temp
FROM analytics.daily_temperatures
GROUP BY year
ORDER BY year;


/* ---------- 3) OPTIONAL EXTRA PANELS  ---------- */

/* ------------------------------------------------------------
   Extra A — Monthly Temperature Range (Max - Min per month)
   (Time series)
   ------------------------------------------------------------ */
SELECT
  toStartOfMonth(date) AS time,
  round(max(temperature) - min(temperature), 2) AS monthly_range
FROM analytics.daily_temperatures
GROUP BY time
ORDER BY time;


/* ------------------------------------------------------------
   Extra B — Hot/Cold Day Counts per Year (threshold-based metric)
   (Bar chart / Table)
   Change thresholds if you want.
   ------------------------------------------------------------ */
SELECT
  toYear(date) AS year,
  countIf(temperature >= 15) AS days_ge_15c,
  countIf(temperature <= 0) AS days_le_0c
FROM analytics.daily_temperatures
GROUP BY year
ORDER BY year;
