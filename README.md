# Data Warehouse and Analytics Project

This project focuses on building a robust data warehouse and performing insightful analytics. It includes scripts for data extraction, transformation, and loading (ETL), as well as tools for data analysis and visualization.

---

## 🔗 Important Links

#### 📂 **[Datasets](datasets)**: Access to project datasets(csv files)

#### 📚 **[Documentation](docs)**: Access to project documentation

#### 📜 **[Scripts](scripts)**: Access to project scripts

---

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective

Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

#### Specifications

* **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.
* **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
* **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
* **Scope**: Focus on the latest dataset only; historization of data is not required.
* **Documentation**: Provide clear documentation of the data model to support both business stakeholders and analytics teams.

---

### BI: Analytics & Reporting (Data Analytics)

---

#### Objective ✨

Develop SQL-based analytics to deliver detailed insights into:

* **Customer Behavior**
* **Product Performance**
* **Sales Trends**

These insights empower stakeholders with key business metrics, enabling strategic decision-making.

---

### Data Architecture

---



The data architecture for this project is designed to efficiently manage and process data across three distinct layers: Bronze, Silver, and Gold. The Bronze Layer serves as the initial staging area, where raw data is ingested from source systems with minimal transformations. The Silver Layer focuses on data cleansing, transformation, and integration, applying business rules and ensuring data quality. Finally, the Gold Layer provides refined and aggregated data, optimized for analytical reporting and business intelligence, allowing stakeholders to make informed decisions based on accurate and timely insights.

![Data Architecture](docs/Images/Data_Architecture.png)

#### Data Layering

The data will be structured in three layers:

* **Bronze Layer**: The raw data imported from the source systems, with minimal transformations.
* **Silver Layer**: The cleansed and transformed data, applying business rules and data quality checks.
* **Gold Layer**: The refined and aggregated data, optimized for reporting and analytics.

---

## 📁 Repository Structure

```
sql-data-warehouse-project/
│
├── datasets/
│
├── docs/
│   └── Catalog/
│       └── data_catalog.md
│   └── Images/
│       ├── Bronze_Layer.png
│       ├── Data_Architecture.png
│       ├── Data_Model.png
│       ├── DataFlow.png
│       ├── Integration_Model.png
│       └── Silver_layer.png
│
├── scripts/
│   ├── Bronze/
│   ├── Gold/
│   └── Silver/
│
├── tests/
│   ├── quality_checks_gold.sql
│   └── quality_checks_silver.sql
│
├── .gitattributes
├── .gitignore
├── Guidelines.md
├── LICENSE
├── README.md
```

---

## 🛡️ License

This project is licensed under the [MIT License](LICENSE). You are free to use, modify, and share this project with proper attribution.
