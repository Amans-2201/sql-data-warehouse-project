Use DataWarehouse;
GO
/*
============================================================
This script inserts data into the bronze layer for ERP Tables
Create or alter procedure bronze.load_erp_bronze_tables
============================================================
*/
Create or alter procedure bronze.load_erp_bronze_tables
AS
BEGIN
    DECLARE @startTime DATETIME, @endTime DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
        SET @batch_start_time = GETDATE();  -- Record the start time of the batch operation
    -- Truncate the tables if they already exist to ensure fresh data insertion
        IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
        BEGIN
            PRINT '================================================================';
            PRINT 'Truncating table bronze.erp_cust_az12';
            TRUNCATE TABLE bronze.erp_cust_az12;
        END
        ELSE
            PRINT 'Table bronze.erp_cust_az12 does not exist.';

        SET @startTime = GETDATE();  -- Record the start time of the operation
        -- Bulk Insert ERP Customer AZ12 
        PRINT 'Bulk inserting data into bronze.erp_cust_az12 ';   
        Bulk Insert bronze.erp_cust_az12
        -- Save the .csv dataset files in the specified path or modify the path accordingly
        FROM 'D:\Github\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
        WITH (
            FIRSTROW = 2,           -- Skip the header row
            FIELDTERMINATOR = ',',  -- Specify the field terminator
            TABLOCK,                -- Use table-level locking for the bulk insert
            ROWTERMINATOR = '\n',   -- Specify the row terminator
            FORMAT = 'CSV'          -- Specify the format as CSV
        );
        SET @endTime = GETDATE();  -- Record the end time of the operation
        PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR(10)) + ' seconds';
        PRINT 'Bulk insert into bronze.erp_cust_az12 completed.';
        PRINT '================================================================';

        -- Truncate the table bronze.erp_loc_a101
        IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
        BEGIN
            PRINT 'Truncating table bronze.erp_loc_a101';
            TRUNCATE TABLE bronze.erp_loc_a101;
        END
        ELSE
            PRINT 'Table bronze.erp_loc_a101 does not exist.';

        SET @startTime = GETDATE();  -- Record the start time of the operation
        -- Bulk Insert ERP Location A101  
        PRINT 'Bulk inserting data into bronze.erp_loc_a101 ';  
        Bulk Insert bronze.erp_loc_a101
        FROM 'D:\Github\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
        WITH (
            FIRSTROW = 2,           -- Skip the header row
            FIELDTERMINATOR = ',',  -- Specify the field terminator
            TABLOCK,                -- Use table-level locking for the bulk insert
            ROWTERMINATOR = '\n',   -- Specify the row terminator
            FORMAT = 'CSV'          -- Specify the format as CSV
        );
        SET @endTime = GETDATE();  -- Record the end time of the operation
        PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR(10)) + ' seconds';
        PRINT 'Bulk insert into bronze.erp_loc_a101 completed.';
        PRINT '================================================================';

        -- Truncate the table bronze.erp_px_cat_g1v2
        IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
        BEGIN
            PRINT 'Truncating table bronze.erp_px_cat_g1v2';
            TRUNCATE TABLE bronze.erp_px_cat_g1v2; 
        END
        ELSE
            PRINT 'Table bronze.erp_px_cat_g1v2 does not exist.';

        SET @startTime = GETDATE();  -- Record the start time of the operation
        -- Bulk Insert ERP Product Category G1V2
        PRINT 'Bulk inserting data into bronze.erp_px_cat_g1v2 ';
        Bulk Insert bronze.erp_px_cat_g1v2  
        FROM 'D:\Github\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
        WITH (
            FIRSTROW = 2,           -- Skip the header row
            FIELDTERMINATOR = ',',  -- Specify the field terminator
            TABLOCK,                -- Use table-level locking for the bulk insert
            ROWTERMINATOR = '\n',   -- Specify the row terminator
            FORMAT = 'CSV'          -- Specify the format as CSV
        );  
        SET @endTime = GETDATE();  -- Record the end time of the operation
        PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(SECOND, @startTime, @endTime) AS NVARCHAR(10)) + ' seconds';
        PRINT 'Bulk insert into bronze.erp_px_cat_g1v2 completed.';
        SET @batch_end_time = GETDATE();  -- Record the end time of the batch operation
        PRINT '================================================================';
        PRINT '>>All ERP data has been successfully loaded into the bronze layer.';
        PRINT '>>Batch operation completed in: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR(10)) + ' seconds';
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
-- execute the procedure to load data into the bronze layer ERP
GO
EXECUTE bronze.load_erp_bronze_tables;
GO
-- Verify the data has been inserted correctly  
SELECT COUNT(*) FROM bronze.erp_cust_az12;
GO
SELECT COUNT(*) FROM bronze.erp_loc_a101;
GO
SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2;
