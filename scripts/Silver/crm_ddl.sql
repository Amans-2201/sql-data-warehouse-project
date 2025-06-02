use DataWarehouse;
GO
-- Check If the table silver.crm_cust_info already exists and drop it if it does
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
GO

-- Create table in silver layer for CRM customer information    
-- This table contains customer details including ID, name,
CREATE TABLE silver.crm_cust_info (
    cst_id INT,                      -- Customer ID
    cst_key NVARCHAR(50),            -- Customer Key
    cst_firstname NVARCHAR(50),      -- Customer First Name
    cst_lastname NVARCHAR(50),       -- Customer Last Name
    cst_marital_status NVARCHAR(50), -- Customer Marital Status
    cst_gndr NVARCHAR(50),           -- Customer Gender
    cst_create_date DATE,             -- Customer Creation Date
    dwh_create_date DATETIME2 DEFAULT GETDATE() -- Data Warehouse Creation Date
);
GO

-- Check If the table silver.crm_prd_info already exists and drop it if it does
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO

-- Create table product information in silver layer for CRM
-- This table contains details about products including their cost, line, and availability dates
CREATE TABLE silver.crm_prd_info (
    prd_id INT,                      -- Product ID
    cat_id NVARCHAR(50),             -- Category ID
    prd_key NVARCHAR(50),            -- Product Key
    prd_name NVARCHAR(50),           -- Product Name
    prd_cost INT,          -- Product Cost
    prd_line NVARCHAR(50),           -- Product Line
    prd_start_date DATE,            -- Product Start Date
    prd_end_date DATE,              -- Product End Date
    dwh_create_date DATETIME2 DEFAULT GETDATE() -- Data Warehouse Creation Date
);
GO

-- Check If the table silver.crm_sales_details already exists and drop it if it does
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;        
GO

-- Create table Sales Details in silver layer for CRM
-- This table captures sales transactions including order details, customer information, and product details
CREATE TABLE silver.crm_sales_details (
    sls_ord_num NVARCHAR(50),                 -- Sales Order Number
    sls_prd_key NVARCHAR(50),        -- Product Key
    sls_cust_id INT,                 -- Customer ID
    sls_order_date Date,               -- Order Date
    sls_ship_date Date,                -- Shipping Date
    sls_due_date Date,                 -- Due Date
    sls_sales INT,        -- Sales Amount
    sls_quantity INT,                 -- Quantity Sold
    sls_price INT,          -- Price per Unit
    dwh_create_date DATETIME2 DEFAULT GETDATE() -- Data Warehouse Creation Date
);


