Cloud Native Visual Analytics — Assignment 6

Overview



This project documents the implementation of a cloud-native visual analytics pipeline using ClickHouse and Grafana deployed on CSC Rahti OpenShift. The assignment demonstrates how to deploy database and visualization services in a containerized environment, import datasets, execute analytical SQL queries, and create interactive dashboards.



The goal was to:



Deploy ClickHouse using OpenShift YAML



Deploy Grafana in the same OpenShift App/network



Import datasets into ClickHouse



Configure Grafana data source using internal service networking



Build analytical dashboards with aggregations and derived metrics



Technologies Used



OpenShift (CSC Rahti)



ClickHouse (columnar database)



Grafana (data visualization)



YAML (Kubernetes deployment configs)



SQL (analytical queries)



Git \& GitHub (version control)



Project Structure

cloud-native-visual-analytics-assignment6

│

├── README.md

├── report/

│   └── Assignment6\_Report.pdf

│

├── screenshots/

│   ├── clickhouse-pods.png

│   ├── clickhouse-query.png

│   ├── grafana-datasource-working.png

│   ├── dashboard-movies.png

│   └── dashboard-temperature.png

│

├── sql/

│   ├── movies\_table.sql

│   ├── movies\_queries.sql

│   ├── temperature\_table.sql

│   └── temperature\_queries.sql

│

├── yaml/

│   ├── clickhouse-rahti.yaml

│   └── grafana-rahti.yaml



Dataset 1 — Movies (Metacritic Dataset)



The first dataset contains movie information including:



Title



Year



Genre



Director



Metascore



The dataset was imported into ClickHouse using SQL and analyzed with aggregations such as:



Movies per year



Average metascore by genre



Top directors by number of movies



Dataset 2 — Daily Minimum Temperatures (Optional Section)



The optional section includes a time-series dataset containing daily minimum temperatures from 1981–1990 (~3,650 rows).



This dataset demonstrates:



Time-based aggregation



Group-by dimensions



Derived metrics (average, range)



Advanced statistical metric using quantile(0.9)



Example advanced query:



SELECT

&nbsp;   toYear(date) as year,

&nbsp;   quantile(0.9)(temperature) as p90\_temp

FROM analytics.daily\_temperatures

GROUP BY year

ORDER BY year;



Deployment Summary

ClickHouse



Deployed using provided YAML



Exposed via OpenShift Route



MergeTree tables created



CSV datasets imported via SQL



Grafana



Deployed in same OpenShift App (Shift + Drag in Topology)



ClickHouse data source configured using internal service DNS



Verified with "Data source is working"



Multiple dashboards created



Key Learning Outcomes



Deploying containerized applications on OpenShift



Managing internal service networking



Writing analytical SQL queries in ClickHouse



Implementing time-series and statistical aggregations



Building professional dashboards in Grafana



Handling cloud resource constraints



Reproducibility



To redeploy:



Apply YAML files from /yaml



Create tables using SQL files from /sql



Import datasets



Configure Grafana data source



Import dashboards (if exported JSON is included)



Author



Hamed Ahmadinia

Cloud Native Visual Analytics

Arcada MIND

