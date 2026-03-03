# Data Warehouse Project – Medallion Architecture (Bronze → Silver → Gold)

## 📌 Project Overview

This project implements a **SQL-based Data Warehouse** using the **Medallion Architecture**:

* **Bronze Layer** → Raw data ingestion
* **Silver Layer** → Cleaned and transformed data
* **Gold Layer** → Business-ready star schema for analytics

The solution integrates **CRM and ERP data sources**, applies data cleansing and transformations, and exposes a **star schema model** for reporting and BI tools.

---

## 🏗 Architecture

### 🥉 Bronze Layer

* Stores raw source data as-is
* Minimal transformation
* Used as a historical staging layer

### 🥈 Silver Layer

* Cleansed and standardized data
* Deduplication (latest customer records)
* Data type corrections (dates, numeric fields)
* Standardized values (gender, marital status, country)
* Basic data quality handling (NULL fixes, recalculated sales)

### 🥇 Gold Layer

* Star schema design
* Surrogate keys generated using `ROW_NUMBER()`
* Optimized for reporting and analytics

---

## 📊 Data Model (Gold Layer)

### ⭐ `gold.dim_customers`

Customer dimension combining CRM + ERP attributes.

**Key features:**

* Surrogate key (`customer_key`)
* Gender fallback logic (CRM → ERP)
* Country enrichment
* Birthdate from ERP
* Business identifiers preserved

---

### ⭐ `gold.dim_products`

Product dimension enriched with category data.

**Key features:**

* Surrogate key (`product_key`)
* Category + Subcategory mapping
* Product line standardization
* Historical filtering (`prd_end_dt IS NULL`)

---

### ⭐ `gold.fact_sales`

Sales fact table.

**Measures:**

* `sales_amount`
* `quantity`
* `price`

**Foreign Keys:**

* `customer_key`
* `product_key`

**Dates:**

* Order date
* Shipping date
* Due date

---

## 🔄 ETL Process

### 1️⃣ Bronze → Silver

Handled via stored procedure:

```
silver.load_silver
```

**Operations performed:**

* Table truncation (full reload strategy)
* Deduplication using `ROW_NUMBER()`
* Value standardization using `CASE`
* Date validation & conversion
* Sales recalculation when inconsistent
* Data quality fixes

---

### 2️⃣ Silver → Gold

Implemented using SQL `VIEW`s:

* `gold.dim_customers`
* `gold.dim_products`
* `gold.fact_sales`

Gold layer does not store data physically — it serves analytical queries.

---

## 🧱 Schema Structure

```
bronze
silver
gold
```

Each layer is logically separated for clarity and maintainability.

---

## 📌 Design Decisions

* **Full reload strategy** in Silver (TRUNCATE + INSERT)
* **Surrogate keys generated in views**
* **LEFT JOINs** to avoid data loss
* **Audit column** (`dwh_create_date`) in Silver tables
* **Historical product handling** via end-date logic

---

## 🛠 Technologies Used

* Microsoft SQL Server
* T-SQL (Stored Procedures, Views, Window Functions)
* Star Schema Modeling
* Medallion Architecture

---

## 🚀 How to Run

1. Create schemas: `bronze`, `silver`, `gold`
2. Load raw data into Bronze tables
3. Execute:

   ```sql
   EXEC silver.load_silver;
   ```
4. Query Gold views:

   ```sql
   SELECT * FROM gold.fact_sales;
   ```

---

## 📈 Use Cases

* Sales performance analysis
* Customer segmentation
* Product category analysis
* BI dashboards (Power BI / Tableau)
* KPI reporting

---

## 🔮 Possible Improvements

* Add incremental loading strategy
* Add indexes on foreign keys
* Implement SCD Type 2 for customers/products
* Add data validation logging
* Implement automated scheduling (SQL Agent)

---

## 👨‍💻 Author

Data Warehouse project demonstrating:

* ETL design
* Data cleansing
* Dimensional modeling
* SQL performance patterns
* Production-style structure

---

If you'd like, I can also generate:

* A **short GitHub version**
* A **more technical enterprise-style version**
* Or a **portfolio-optimized version for recruiters**
