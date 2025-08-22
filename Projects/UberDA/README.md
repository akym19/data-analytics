https://github.com/user-attachments/assets/87a7907d-7bff-475d-baf7-2e5e18c52845

# 🧠 Uber Ride Performance 2024 Data Warehouse and Power BI Analysis Portfolio Project

Welcome to my Data Warehouse and Analytics Portfolio Project! 📊
This project simulates a real-world analytics workflow for an Uber-like ride-hailing platform, following the Medallion Architecture. It showcases best practices in data engineering, data modeling, and business analytics, culminating in a Power BI dashboard for decision-making.

---

## 🧱 Data Architecture: Medallion Design

This project follows the **Medallion Architecture** approach, organizing data into three logical layers:

- **🔸 Bronze Layer:** Raw, ingested CSV files loaded directly into the staging database (`bronze_` tables).
- **🔹 Silver Layer:** Cleaned, validated, and conformed tables with surrogate keys (`silver_` tables). Dimension tables such as customers, locations, and vehicles are prepared here.
- **🏅 Gold Layer:** Star schema with fact and dimension tables optimized for analytics (`gold_` views). This serves as the foundation for Power BI reporting.

---

## 📖 Project Scope

This project involves:

- **Data Architecture Design**: Schema development using Medallion principles.
- **ETL Pipelines**: SQL-based ingestion and transformation from CSVs to business-ready tables.
- **Data Modeling**: Fact and dimension modeling (star schema).
- **Business Metrics**: Creating KPIs such as total bookings, revenue, cancellation rate, average fare per ride, and ride distance.
- **Dashboarding**: Building an interactive Power BI report to analyze booking trends, cancellations, and rider behavior.

---

## 📂 Source Data - [Kaggle](https://www.kaggle.com/datasets/yashdevladdha/uber-ride-analytics-dashboard)

Seven CSV files simulating a retail sales system:

- `categories.csv` – Product category info
- `cities.csv` – City and region data
- `countries.csv` – Country details
- `customers.csv` – Customer demographic data
- `employees.csv` – Employee profiles
- `products.csv` – Product catalog with allergy/resistance/vitality attributes
- `sales.csv` – Transaction-level sales data

---
This project uses a single raw dataset simulating Uber ride bookings. The dataset contains transaction-level booking details.

From this single source, the data was normalized and split into fact and dimension tables to enable star-schema modeling in the Gold Layer:

**Fact Table**

- `fact_bookings` – Central transactional table storing ride-level facts (booking ID, booking status, booking value, pickup/dropoff, timestamps).

**Dimension Tables**

- `dim_customers` – Rider information (customer ID, demographics if available).
- `dim_cancellations` – Customer and Driver ride cancellation reason.
- `dim_incomplete_rides` – Reasons for having incomplete rides.
- `dim_vehicles` – Vehicle types.
- `dim_locations` – Normalized pickup/dropoff location data.
- `dim_payment_methods` – Normalized payment methods data.

This transformation process ensures the raw dataset is clean, scalable, and optimized for analytical queries and Power BI visualization.
---

## 💡 Business Objective

We aim to deliver insights into:
- 📈 What are the booking trends over time?
- 🚘 Which vehicle types are most popular?
- 🛑 What is the cancellation rate, and what factors drive it?
- 💵 What is the total revenue generated and its trend?
- 🌍 Which pickup locations are most active?
- ⏰ At what hours do most bookings occur?

---

## 🚀 Technical Requirements

- **SQL Environment**: MS SQL Server
- **Data Ingestion**: CSV file parsing into staging tables
- **Validation**: Handling of nulls, duplicates, mismatches, and creating surrogate keys
- **Modeling**: Star schema (Fact + Dimension tables)
- **Visualization**: Power BI dashboard with KPIs and interactive charts

---

## 📊 Dashboard Outcomes

The Power BI dashboard delivers:
- High-level KPIs: total bookings, revenue, cancellation rate, customer and driver ratings.
- Booking trends (completed vs total)
- Vehicle type preference
- Location insights (top pickup areas)
- Hourly booking demand analysis
- Cancellation behavior monitoring

---

## 📁 Folder Structure

```
📁 Uber_DataWarehouse
├── 📂 datasets/
├── 📂 scripts/
│   ├── 📂 bronze
│   ├── 📂 silver
│   ├── 📂 gold
├── 📂 docs/
├── 📂 powerbi_dashboard/
└── README.md
```

---

## 🧑‍💻 Author

**Raffy Jay Dayag** – Aeronautical Engineer turned Data Analyst  

---

## 📬 Contact

For questions or feedback, feel free to reach out via [LinkedIn](https://www.linkedin.com/in/raffy-jay-dayag/).
