# Cloud Native Visual Analytics 

Cloud-native visual analytics pipeline built using **ClickHouse** and **Grafana**, deployed on **CSC Rahti OpenShift**.

---

## 📌 Overview

This project documents the implementation of a cloud-native database and visualization stack inside OpenShift. The goal of the assignment was to deploy analytical services in a containerized environment, import datasets into a high-performance columnar database, and create interactive dashboards with meaningful aggregations and derived metrics.

The assignment demonstrates:

- Deploying ClickHouse using OpenShift YAML
- Deploying Grafana in the same OpenShift App/network
- Importing datasets into ClickHouse
- Configuring Grafana data source using internal service networking
- Building analytical dashboards with SQL aggregations and advanced metrics

---

## 🏗 Architecture

The system was deployed inside CSC Rahti OpenShift using the following architecture:

OpenShift Project  
&nbsp;&nbsp;&nbsp;&nbsp;├── ClickHouse (Database)  
&nbsp;&nbsp;&nbsp;&nbsp;└── Grafana (Visualization)  

Both services run inside the same OpenShift **App**, allowing internal service communication via Kubernetes service DNS.

---

## 📊 Datasets Used

### 1️⃣ Movies Dataset (Main Assignment)

Metacritic movies dataset imported into ClickHouse.

Used for:

- Movies per year
- Average metascore by genre
- Top directors by number of movies
- Additional aggregations

---

### 2️⃣ Daily Temperature Dataset (Optional Advanced Section)

Daily minimum temperatures dataset (1981–1990), approximately 3,650 rows.

This dataset was selected because it fits Rahti resource limits while enabling time-based analysis.

Used for:

- Daily time-series visualization
- Monthly average temperature aggregation
- Yearly temperature range (Max − Min)
- 90th percentile temperature using ClickHouse quantile function

---

## 🧮 Example SQL Queries

### Yearly Temperature Range

```sql
SELECT
    toYear(date) AS year,
    max(temperature) - min(temperature) AS yearly_range
FROM analytics.daily_temperatures
GROUP BY year
ORDER BY year;
```

### 90th Percentile Temperature

```sql
SELECT
    toYear(date) AS year,
    quantile(0.9)(temperature) AS p90_temp
FROM analytics.daily_temperatures
GROUP BY year
ORDER BY year;
```

### Movies Per Year

```sql
SELECT
    year,
    count() AS total_movies
FROM movies.metacritic_movies
GROUP BY year
ORDER BY year;
```

---

## 📷 Screenshots

All verification screenshots are included in the `/screenshots` folder, showing:

- OpenShift Pods running (ClickHouse + Grafana)
- OpenShift Topology view (same App/network)
- ClickHouse table creation and query results
- Grafana data source showing “Data source is working”
- Movies dashboard
- Temperature analytics dashboard

---

## 📁 Project Structure

```
cloud-native-visual-analytics-assignment6
│
├── README.md
├── report/
│   └── Assignment6_Report.pdf
│
├── screenshots/
│
├── sql/
│   ├── movies_table.sql
│   ├── movies_queries.sql
│   ├── temperature_table.sql
│   └── temperature_queries.sql
│
├── yaml/
│   ├── clickhouse-rahti.yaml
│   └── grafana-rahti.yaml
```

---

## ⚙ Technologies Used

- OpenShift (CSC Rahti)
- ClickHouse
- Grafana
- SQL
- YAML
- Git & GitHub

---

## ✅ Requirements Covered

✔ ClickHouse deployed and verified  
✔ Grafana deployed and connected internally  
✔ Dataset imports validated  
✔ Multiple dashboards created  
✔ Time-based aggregations implemented  
✔ Group-by dimensions implemented  
✔ Derived metrics (average, range, percentile) implemented  

---

## 👤 Author

Hamed Ahmadinia  
Cloud Native Visual Analytics — Arcada MIND
