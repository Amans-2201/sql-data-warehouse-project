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
    DECLARE @startTime DATETIME, @endTime DATETIME;
    BEGIN TRY
        IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
        BEGIN
            PRINT '================================================================';
            PRINT '>>Truncating table bronze.crm_cust_info';
            TRUNCATE TABLE bronze.crm_cust_info;
        END
        ELSE
            PRINT '>>Table bronze.crm_cust_info does not exist.';

        SET @startTime = GETDATE();  -- Record the start time of the operation
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
        SET @endTime = GETDATE();  -- Record the end time of the operation
        PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR(10)) + ' seconds';
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

        SET @startTime = GETDATE();  -- Record the start time of the operation
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
        SET @endTime = GETDATE();  -- Record the end time of the operation
        PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR(10)) + ' seconds';
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

        SET @startTime = GETDATE();  -- Record the start time of the operation
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
        SET @endTime = GETDATE();  -- Record the end time of the operation
        PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR(10)) + ' seconds';
        PRINT '>>Bulk insert into bronze.crm_sales_details completed.';
        PRINT '================================================================';
        PRINT '>>All CRM data has been successfully loaded into the bronze layer.';
        PRINT '================================================================';
    END TRY
    BEGIN CATCH
        -- Handle any errors that occur during the bulk insert operation
        PRINT '================================================================';
        PRINT 'An error occurred during the bulk insert operation.';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR(10));
        PRINT 'Error Severity: ' + CAST(ERROR_SEVERITY() AS NVARCHAR(10));
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR(10));
        PRINT 'Error Line: ' + CAST(ERROR_LINE() AS NVARCHAR(10));
        PRINT '================================================================';
        -- Optionally, you can log the error to a table or take other actions
    END CATCH
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
