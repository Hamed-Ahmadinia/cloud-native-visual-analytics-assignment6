/* ============================================================
   Assignment 6 — Optional Second Dataset (Temperatures)
   File: sql/temperature_table.sql

   Dataset:
   Daily temperature dataset (1981–1990)
   Imported from external CSV URL

   Table:
   analytics.daily_temperatures
   ============================================================ */


/* ---------- 1) CREATE DATABASE (if not exists) ---------- */

CREATE DATABASE IF NOT EXISTS analytics;


/* ---------- 2) DROP TABLE (optional reset) ---------- */
/* Uncomment if you want to recreate cleanly */

/*
DROP TABLE IF EXISTS analytics.daily_temperatures;
*/


/* ---------- 3) CREATE TABLE ---------- */

CREATE TABLE IF NOT EXISTS analytics.daily_temperatures
(
    date Date,
    temperature Float64
)
ENGINE = MergeTree()
ORDER BY date;


/* ---------- 4) IMPORT DATA FROM CSV URL ---------- */

INSERT INTO analytics.daily_temperatures
SELECT *
FROM url(
    'https://raw.githubusercontent.com/jbrownlee/Datasets/master/daily-min-temperatures.csv',
    'CSVWithNames'
);


/* ---------- 5) VERIFY IMPORT ---------- */

-- Check number of rows
SELECT count() AS total_rows
FROM analytics.daily_temperatures;

-- Preview first rows
SELECT *
FROM analytics.daily_temperatures
ORDER BY date ASC
LIMIT 10;

-- Check date range
SELECT
    min(date) AS min_date,
    max(date) AS max_date
FROM analytics.daily_temperatures;
