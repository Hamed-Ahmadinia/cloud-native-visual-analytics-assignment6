/* ============================================================
   Assignment 6 — Movies Dataset
   File: sql/movies_table.sql
   Dataset:
   https://people.arcada.fi/~welandfr/temp/kaggle_metacritic_movies.csv
   ============================================================ */


/* ---------- 1) Create Database ---------- */

CREATE DATABASE IF NOT EXISTS movies;


/* ---------- 2) Use Database ---------- */

USE movies;


/* ---------- 3) Drop Table If Exists (Safe Re-run) ---------- */

DROP TABLE IF EXISTS metacritic_movies;


/* ---------- 4) Create Table ---------- */
/*
   We store most columns as String for safe CSV import.
   Numeric columns are typed properly for analytics.
*/

CREATE TABLE metacritic_movies
(
    title String,
    year Int32,
    genre String,
    director String,
    metascore Nullable(Float64),
    imdb_rating Nullable(Float64),
    imdb_votes Nullable(Int32),
    runtime Nullable(Int32),
    gross Nullable(Float64)
)
ENGINE = MergeTree
ORDER BY (year, title);


/* ---------- 5) Verify Table Structure ---------- */

DESCRIBE TABLE metacritic_movies;
