/* ============================================================
   Assignment 6 — Movies Dataset (ClickHouse)
   File: sql/movies_queries.sql

   ============================================================ */


/* ---------- 0) USE DATABASE  ---------- */
-- USE movies;


/* ---------- 1) BASIC VERIFICATION / SANITY CHECKS ---------- */

-- 1.1 Row count (should be ~16939 based on dataset)
SELECT count() AS row_count
FROM movies.metacritic_movies;

-- 1.2 Preview sample rows
SELECT *
FROM movies.metacritic_movies
LIMIT 10;

-- 1.3 Check which years exist (and min/max year)
SELECT
  min(toInt32OrZero(year)) AS min_year,
  max(toInt32OrZero(year)) AS max_year,
  uniqExact(toInt32OrZero(year)) AS distinct_years
FROM movies.metacritic_movies;

-- 1.4 Missingness checks (safe even if values are strings)
SELECT
  countIf(trim(BOTH ' ' FROM toString(title)) = '' OR title IS NULL) AS missing_title,
  countIf(toInt32OrZero(year) = 0) AS invalid_year,
  countIf(trim(BOTH ' ' FROM toString(genre)) = '' OR genre IS NULL) AS missing_genre,
  countIf(trim(BOTH ' ' FROM toString(director)) = '' OR director IS NULL) AS missing_director,
  countIf(toFloat64OrNull(metascore) IS NULL) AS missing_metascore
FROM movies.metacritic_movies;


/* ---------- 2) DASHBOARD PANEL QUERIES ---------- */
/* NOTE for Grafana:
   - For Bar chart / Table: return dimension + metric
   - For Time series: return "time" + value
*/


/* ------------------------------------------------------------
   Panel A — Movies per Year (Bar chart)
   ------------------------------------------------------------ */
SELECT
  toInt32OrZero(year) AS year,
  count() AS movies
FROM movies.metacritic_movies
WHERE toInt32OrZero(year) > 0
GROUP BY year
ORDER BY year;


/* ------------------------------------------------------------
   Panel B — Movies per Decade (Alternative to Year)
   (Bar chart)
   ------------------------------------------------------------ */
SELECT
  intDiv(toInt32OrZero(year), 10) * 10 AS decade,
  count() AS movies
FROM movies.metacritic_movies
WHERE toInt32OrZero(year) > 0
GROUP BY decade
ORDER BY decade;


/* ------------------------------------------------------------
   Panel C — Average Metascore by Genre (Simple)
   If genre is a single value per row (Bar chart)
   ------------------------------------------------------------ */
SELECT
  genre,
  round(avg(toFloat64OrNull(metascore)), 2) AS avg_metascore,
  count() AS movies
FROM movies.metacritic_movies
WHERE toFloat64OrNull(metascore) IS NOT NULL
  AND genre IS NOT NULL
  AND trim(BOTH ' ' FROM toString(genre)) != ''
GROUP BY genre
HAVING movies >= 5
ORDER BY avg_metascore DESC
LIMIT 20;


/* ------------------------------------------------------------
   Panel C (Advanced) — Average Metascore by Genre (Split genres)
   If genre is a delimited string like "Action, Drama"
   This query splits by comma and trims spaces.
   (Bar chart)
   ------------------------------------------------------------ */
SELECT
  trim(BOTH ' ' FROM genre_item) AS genre,
  round(avg(toFloat64OrNull(metascore)), 2) AS avg_metascore,
  count() AS movies
FROM
(
  SELECT
    metascore,
    arrayJoin(splitByChar(',', toString(genre))) AS genre_item
  FROM movies.metacritic_movies
  WHERE toFloat64OrNull(metascore) IS NOT NULL
    AND genre IS NOT NULL
    AND trim(BOTH ' ' FROM toString(genre)) != ''
)
WHERE trim(BOTH ' ' FROM genre_item) != ''
GROUP BY genre
HAVING movies >= 10
ORDER BY avg_metascore DESC
LIMIT 20;


/* ------------------------------------------------------------
   Panel D — Top Directors by Number of Movies (Bar chart)
   ------------------------------------------------------------ */
SELECT
  director,
  count() AS movies
FROM movies.metacritic_movies
WHERE director IS NOT NULL
  AND trim(BOTH ' ' FROM toString(director)) != ''
GROUP BY director
ORDER BY movies DESC
LIMIT 20;


/* ---------- 3) EXTRA PANELS (choose at least one) ---------- */

/* ------------------------------------------------------------
   Extra 1 — Average Metascore per Year (Time-based trend)
   (Time series in Grafana)
   Note: Grafana expects a "time" column. We create Jan 1 of each year.
   ------------------------------------------------------------ */
SELECT
  toDate(concat(toString(toInt32OrZero(year)), '-01-01')) AS time,
  round(avg(toFloat64OrNull(metascore)), 2) AS avg_metascore
FROM movies.metacritic_movies
WHERE toInt32OrZero(year) > 0
  AND toFloat64OrNull(metascore) IS NOT NULL
GROUP BY time
ORDER BY time;


/* ------------------------------------------------------------
   Extra 2 — Metascore Distribution (Histogram buckets)
   (Bar chart)
   ------------------------------------------------------------ */
SELECT
  intDiv(toInt32OrZero(metascore), 10) * 10 AS score_bucket,
  count() AS movies
FROM movies.metacritic_movies
WHERE toFloat64OrNull(metascore) IS NOT NULL
GROUP BY score_bucket
ORDER BY score_bucket;


/* ------------------------------------------------------------
   Extra 3 — Top Genres by Movie Count (Split genres)
   (Bar chart)
   ------------------------------------------------------------ */
SELECT
  trim(BOTH ' ' FROM genre_item) AS genre,
  count() AS movies
FROM
(
  SELECT
    arrayJoin(splitByChar(',', toString(genre))) AS genre_item
  FROM movies.metacritic_movies
  WHERE genre IS NOT NULL
    AND trim(BOTH ' ' FROM toString(genre)) != ''
)
WHERE trim(BOTH ' ' FROM genre_item) != ''
GROUP BY genre
ORDER BY movies DESC
LIMIT 20;


/* ------------------------------------------------------------
   Extra 4 — Best Directors by Average Metascore (min movies filter)
   (Bar chart)
   ------------------------------------------------------------ */
SELECT
  director,
  round(avg(toFloat64OrNull(metascore)), 2) AS avg_metascore,
  count() AS movies
FROM movies.metacritic_movies
WHERE director IS NOT NULL
  AND trim(BOTH ' ' FROM toString(director)) != ''
  AND toFloat64OrNull(metascore) IS NOT NULL
GROUP BY director
HAVING movies >= 5
ORDER BY avg_metascore DESC
LIMIT 20;
