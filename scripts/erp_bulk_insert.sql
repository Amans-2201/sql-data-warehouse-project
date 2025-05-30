Use DataWarehouse;
GO
/*
============================================================
This script inserts data into the bronze layer for ERP Tables
Create or alter procedure bronze.load_erp_bronze_data
============================================================
*/
Create or alter procedure bronze.load_erp_bronze_data
AS
BEGIN
    -- Truncate the tables if they already exist to ensure fresh data insertion
    IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    BEGIN
        PRINT '================================================================';
        PRINT 'Truncating table bronze.erp_cust_az12';
        TRUNCATE TABLE bronze.erp_cust_az12;
    END
    ELSE
        PRINT 'Table bronze.erp_cust_az12 does not exist.';
    
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
    PRINT 'Bulk insert into bronze.erp_px_cat_g1v2 completed.';
    PRINT '================================================================';
    PRINT '>>All ERP data has been successfully loaded into the bronze layer.';
    PRINT '================================================================';
END
-- execute the procedure to load data into the bronze layer ERP
GO
EXECUTE bronze.load_erp_bronze_data;
GO
-- Verify the data has been inserted correctly  
SELECT COUNT(*) FROM bronze.erp_cust_az12;
GO
SELECT COUNT(*) FROM bronze.erp_loc_a101;
GO
SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2;
