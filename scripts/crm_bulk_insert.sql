Use DataWarehouse;
GO
/*
============================================================
This script inserts data into the bronze layer for ERP Tables
Create or alter procedure bronze.load_crm_bronze_data
============================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_crm_bronze_data   
AS
BEGIN
    IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    BEGIN
        PRINT '================================================================';
        PRINT '>>Truncating table bronze.crm_cust_info';
        TRUNCATE TABLE bronze.crm_cust_info;
    END
    ELSE
        PRINT '>>Table bronze.crm_cust_info does not exist.';

    -- Bulk Insert CRM Customer Information
    PRINT '>>Bulk inserting data into bronze.crm_cust_info ';
    Bulk Insert bronze.crm_cust_info
    -- Save the .csv dataset files in the specified path or modify the path accordingly
    FROM 'D:\Github\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
    WITH (
        FIRSTROW = 2,           -- Skip the header row
        FIELDTERMINATOR = ',',  -- Specify the field terminator
        TABLOCK,                -- Use table-level locking for the bulk insert
        ROWTERMINATOR = '\n',   -- Specify the row terminator
        FORMAT = 'CSV'          -- Specify the format as CSV
    );
    PRINT '>>Bulk insert into bronze.crm_cust_info completed.';
    PRINT '================================================================';
    -- Truncate the table bronze.crm_prd_info
    IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    BEGIN
        PRINT '>>Truncating table bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;
    END
    ELSE
        PRINT '>>Table bronze.crm_prd_info does not exist.';
    
    -- Bulk Insert CRM Product Information
    PRINT '>>Bulk inserting data into bronze.crm_prd_info ';
    Bulk Insert bronze.crm_prd_info
    FROM 'D:\Github\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'    
    WITH (
        FIRSTROW = 2,           -- Skip the header row
        FIELDTERMINATOR = ',',  -- Specify the field terminator
        TABLOCK,                -- Use table-level locking for the bulk insert
        ROWTERMINATOR = '\n',   -- Specify the row terminator
        FORMAT = 'CSV'          -- Specify the format as CSV
    );
    PRINT '>>Bulk insert into bronze.crm_prd_info completed.';
    PRINT '================================================================';

    -- Truncate the table bronze.crm_sales_details
    IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    BEGIN
        PRINT '>>Truncating table bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;
    END
    ELSE
        PRINT '>>Table bronze.crm_sales_details does not exist.';

    -- Bulk Insert CRM Sales Details
    PRINT '>>Bulk inserting data into bronze.crm_sales_details ';
    Bulk Insert bronze.crm_sales_details
    FROM 'D:\Github\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
    WITH (
        FIRSTROW = 2,           -- Skip the header row
        FIELDTERMINATOR = ',',  -- Specify the field terminator
        TABLOCK,                -- Use table-level locking for the bulk insert
        ROWTERMINATOR = '\n',   -- Specify the row terminator
        FORMAT = 'CSV'          -- Specify the format as CSV
    );
    PRINT '>>Bulk insert into bronze.crm_sales_details completed.';
    PRINT '================================================================';
    PRINT '>>All CRM data has been successfully loaded into the bronze layer.';
    PRINT '================================================================';
END
-- Execute the procedure to load data into the bronze layer CRM
GO
EXECUTE bronze.load_crm_bronze_data;
GO
--Verify the data has been inserted correctly
GO
SELECT COUNT(*) FROM bronze.crm_cust_info;
GO
SELECT COUNT(*) FROM bronze.crm_prd_info;
GO
SELECT COUNT(*) FROM bronze.crm_sales_details;
