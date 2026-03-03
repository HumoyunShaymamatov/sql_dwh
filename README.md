# 🚀 SQL Data Warehouse Project

### Medallion Architecture | ETL | Dimensional Modeling | Analytics-Ready

---

## 📌 Project Summary

Designed and implemented a **SQL-based Data Warehouse** using the **Medallion Architecture (Bronze → Silver → Gold)** to transform raw CRM and ERP data into an analytics-ready **star schema**.

This project demonstrates hands-on experience in:

* Data modeling (Fact & Dimension design)
* ETL development in T-SQL
* Data cleansing & standardization
* Surrogate key generation
* Business logic implementation
* Analytical data preparation

---

## 🏗 Architecture Overview

### 🥉 Bronze Layer (Raw Data)

* Stores source CRM & ERP data
* No transformation
* Serves as ingestion/staging layer

### 🥈 Silver Layer (Cleansed Data)

* Deduplication using `ROW_NUMBER()`
* Data standardization (gender, marital status, country)
* Date validation and conversion
* Sales recalculation for inconsistent records
* NULL handling and fallback logic
* Full reload strategy (`TRUNCATE + INSERT`)

Implemented via:

```sql
EXEC silver.load_silver;
```

---

### 🥇 Gold Layer (Business Model)

Implemented as **star schema views**:

* `gold.dim_customers`
* `gold.dim_products`
* `gold.fact_sales`

Optimized for BI tools and reporting queries.

---

## 📊 Data Model

### ⭐ Fact Table

**`gold.fact_sales`**

* Sales Amount
* Quantity
* Price
* Order / Shipping / Due Dates
* Foreign Keys to Customers & Products

### ⭐ Dimensions

**Customers**

* Surrogate key
* CRM + ERP enrichment
* Gender fallback logic
* Country standardization
* Birthdate integration

**Products**

* Category & Subcategory mapping
* Product line standardization
* Historical filtering (active products only)

---

## 🔎 Key Technical Highlights

* Built a **modular ETL pipeline** using stored procedures
* Implemented **data quality validation rules**
* Designed a **star schema for analytical workloads**
* Generated surrogate keys using window functions
* Applied business transformation rules in Silver layer
* Created audit tracking column (`dwh_create_date`)
* Used LEFT JOIN strategy to preserve referential completeness

---

## 🛠 Tech Stack

* Microsoft SQL Server
* T-SQL
* Window Functions
* Stored Procedures
* Views
* Star Schema Modeling
* Medallion Architecture
