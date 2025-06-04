-- Create New Database DataWarehouseAnalytics
-- Check if Database Exists
IF DB_ID('DataWarehouseAnalytics') IS NOT NULL
BEGIN
    PRINT 'Database DataWarehouseAnalytics already exists.';
END
ELSE
BEGIN
    CREATE DATABASE DataWarehouseAnalytics;
    PRINT 'Database DataWarehouseAnalytics created successfully.';
END
GO

-- Use the New Database
USE DataWarehouseAnalytics;
GO

-- Create schema gold
CREATE SCHEMA gold;
GO

-- Drop if table exists
DROP TABLE IF EXISTS gold.dim_customers;
GO

-- Create table gold.dim_customers  
CREATE TABLE gold.dim_customers (
    customer_key INT,
    customer_id INT,
    customer_number nvarchar(50),
    first_name NVARCHAR(50),
    last_name NVARCHAR(50),
    marital_status NVARCHAR(50),
    gender NVARCHAR(50),
    created_date DATE,
    birth_date DATE,
    country NVARCHAR(50)
);
GO

-- Insert Data into gold.dim_customers from view datawarehouse.gold.dim_customers
INSERT INTO gold.dim_customers
SELECT * FROM datawarehouse.gold.dim_customers; -- use datawarehouse database as prefix for views
GO

-- Drop table gold.dim_products
DROP TABLE IF EXISTS gold.dim_products;
GO

-- Create table gold.dim_products   
CREATE TABLE gold.dim_products (
    product_key INT,
    product_id INT,
    product_number nvarchar(50),
    product_name NVARCHAR(50),
    category_id nvarchar(50),
    category NVARCHAR(50),
    subcategory NVARCHAR(50),
    maintenance NVARCHAR(50),
    cost int,
    product_line NVARCHAR(50),
    start_date DATE
);      
GO

-- Insert Data into gold.dim_products from view datawarehouse.gold.dim_products
INSERT INTO gold.dim_products
SELECT * FROM datawarehouse.gold.dim_products; -- use datawarehouse database as prefix for views
GO

-- Drop table gold.fact_sales
DROP TABLE IF EXISTS gold.fact_sales;
GO

-- Create table gold.fact_sales   
CREATE TABLE gold.fact_sales (
    order_number nvarchar(50),
    product_key INT,
    customer_key INT,
    order_date DATE,
    shipping_date DATE,
    due_date DATE,
    sales_amount INT,
    quantity tinyint,
    price int
);      
GO

-- Insert Data into gold.fact_sales from view datawarehouse.gold.fact_sales
INSERT INTO gold.fact_sales
SELECT * FROM datawarehouse.gold.fact_sales; -- use datawarehouse database as prefix for views
GO


