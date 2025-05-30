Use DataWarehouse;
GO
-- This script inserts data into the bronze layer for CRM customer information

-- Bulk Insert CRM Customer Information
Bulk Insert bronze.crm_cust_info
FROM 'D:\Github\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
WITH (
    FIRSTROW = 2,           -- Skip the header row
    FIELDTERMINATOR = ',',  -- Specify the field terminator
    TABLOCK,                -- Use table-level locking for the bulk insert
    ROWTERMINATOR = '\n',   -- Specify the row terminator
    FORMAT = 'CSV'          -- Specify the format as CSV
);  
GO
-- Bulk Insert CRM Product Information
Bulk Insert bronze.crm_prd_info
FROM 'D:\Github\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'    
WITH (
    FIRSTROW = 2,           -- Skip the header row
    FIELDTERMINATOR = ',',  -- Specify the field terminator
    TABLOCK,                -- Use table-level locking for the bulk insert
    ROWTERMINATOR = '\n',   -- Specify the row terminator
    FORMAT = 'CSV'          -- Specify the format as CSV
);
GO
-- Bulk Insert CRM Sales Details
Bulk Insert bronze.crm_sales_details    
FROM 'D:\Github\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
WITH (
    FIRSTROW = 2,           -- Skip the header row
    FIELDTERMINATOR = ',',  -- Specify the field terminator
    TABLOCK,                -- Use table-level locking for the bulk insert
    ROWTERMINATOR = '\n',   -- Specify the row terminator
    FORMAT = 'CSV'          -- Specify the format as CSV
);  

--Verify the data has been inserted correctly
GO
SELECT COUNT(*) FROM bronze.crm_cust_info;
GO
SELECT COUNT(*) FROM bronze.crm_prd_info;
GO
SELECT COUNT(*) FROM bronze.crm_sales_details