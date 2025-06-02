use DataWarehouse;
GO
-- Check If the table bronze.crm_cust_info already exists and drop it if it does
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;

-- Create table in bronze layer for CRM customer information    
-- This table contains customer details including ID, name,
CREATE TABLE bronze.crm_cust_info (
    cst_id INT,                      -- Customer ID
    cst_key NVARCHAR(50),            -- Customer Key
    cst_firstname NVARCHAR(50),      -- Customer First Name
    cst_lastname NVARCHAR(50),       -- Customer Last Name
    cst_marital_status NVARCHAR(50), -- Customer Marital Status
    cst_gndr NVARCHAR(50),           -- Customer Gender
    cst_create_date DATE             -- Customer Creation Date
);
GO
-- Check If the table bronze.crm_prd_info already exists and drop it if it does
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;

-- Create table product information in bronze layer for CRM
-- This table contains details about products including their cost, line, and availability dates
CREATE TABLE bronze.crm_prd_info (
    prd_id INT,                      -- Product ID
    prd_key NVARCHAR(50),            -- Product Key
    prd_name NVARCHAR(50),           -- Product Name
    prd_cost INT,          -- Product Cost
    prd_line NVARCHAR(50),           -- Product Line
    prd_start_date DATE,            -- Product Start Date
    prd_end_date DATE              -- Product End Date
);
-- Check If the table bronze.crm_sales_details already exists and drop it if it does
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;        
GO

-- Create table Sales Details in bronze layer for CRM
-- This table captures sales transactions including order details, customer information, and product details
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num NVARCHAR(50),                 -- Sales Order Number
    sls_prd_key NVARCHAR(50),        -- Product Key
    sls_cust_id INT,                 -- Customer ID
    sls_order_date INT,               -- Order Date
    sls_ship_date INT,                -- Shipping Date
    sls_due_date INT,                 -- Due Date
    sls_sales INT,        -- Sales Amount
    sls_quantity INT,                 -- Quantity Sold
    sls_price INT          -- Price per Unit
);


