# 🧠 SQL Data Warehouse & Analytics Portfolio Project

Welcome to my Data Warehouse and Analytics Portfolio Project! 📊  
This project simulates a real-world data analytics workflow—from raw data ingestion to insights generation—using **Medallion Architecture**. The goal is to showcase best practices in data engineering and analysis, culminating in a business-ready data warehouse and actionable reporting.

---

## 🧱 Data Architecture: Medallion Design

This project follows the **Medallion Architecture** approach, organizing data into three logical layers:

- **🔸 Bronze Layer:** Raw, ingested CSV files loaded directly into the staging database (`bronze_` tables).
- **🔹 Silver Layer:** Cleaned, validated, and transformed data ready for analysis (`silver_` tables).
- **🏅 Gold Layer:** Business-focused fact and dimension tables modeled for analytics and reporting (`gold_` tables, star schema).

---

## 📖 Project Scope

This project involves:

- **Data Architecture Design**: Schema development following Medallion principles.
- **ETL Pipelines**: Manual SQL-based ingestion and transformation from CSV to a SQL database.
- **Data Modeling**: Creating analytical models such as star schemas with dimension and fact tables.
- **Business Analysis**: Using SQL to uncover insights related to customer behavior, sales performance, and product trends.
- **Scenario Simulation**: Acting under the guidance of a fictional manager (Conrad) for realistic task delegation and decision-making.

---

## 📂 Source Data - [Kaggle](https://www.kaggle.com/datasets/andrexibiza/grocery-sales-dataset?select=products.csv)

Seven CSV files simulating a retail sales system:

- `categories.csv` – Product category info
- `cities.csv` – City and region data
- `countries.csv` – Country details
- `customers.csv` – Customer demographic data
- `employees.csv` – Employee profiles
- `products.csv` – Product catalog with allergy/resistance/vitality attributes
- `sales.csv` – Transaction-level sales data

---

## 💡 Business Objective

> Simulated by Conrad, the fictional data manager.

We aim to deliver insights into:
- Top-performing products and underperformers by category
- Revenue contribution by geography (country/city)
- Salesperson productivity and discount behaviors
- Patterns in customer behavior based on product attributes

---

## 🚀 Technical Requirements

- **SQL Environment**: MS SQL Server
- **Data Ingestion**: CSV file parsing into staging tables
- **Validation**: Handling of nulls, duplicates, mismatches
- **Modeling**: Star schema (Fact + Dimension tables)
- **Querying**: Analytical SQL queries for business metrics

---

## 📊 Expected Outcomes

- Reusable and modular data warehouse with clear documentation
- SQL scripts for ingestion, transformation, and analysis
- Sample business reports and dashboards (optional)
- GitHub-hosted project demonstrating end-to-end analytics workflow

---

## 📁 Folder Structure

```
📁 Grocery_Sales
├── 📂 datasets/ # Sales file is too large (500MB) Please see link above
├── 📂 scripts/
│ ├── 📂 bronze
│ ├── 📂 silver
│ ├── 📂 gold
│ ├── 📂 EDA
├── 📂 docs/
└── README.md
```

---

## 🧑‍💻 Author

**Raffy Jay Dayag** – Aeronautical Engineer turned Data Analyst  

---

## 📬 Contact

For questions or feedback, feel free to reach out via [LinkedIn](https://www.linkedin.com/in/raffy-jay-dayag/).
