Use DataWarehouse;
GO
-- This script inserts data into the bronze layer for ERP Tables
-- Bulk Insert ERP Customer AZ12    
Bulk Insert bronze.erp_cust_az12
-- Save your .csv files in the specified path or modify the path accordingly
FROM 'D:\Github\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
WITH (
    FIRSTROW = 2,           -- Skip the header row
    FIELDTERMINATOR = ',',  -- Specify the field terminator
    TABLOCK,                -- Use table-level locking for the bulk insert
    ROWTERMINATOR = '\n',   -- Specify the row terminator
    FORMAT = 'CSV'          -- Specify the format as CSV
);
GO
-- Bulk Insert ERP Location A101    
Bulk Insert bronze.erp_loc_a101
FROM 'D:\Github\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
WITH (
    FIRSTROW = 2,           -- Skip the header row
    FIELDTERMINATOR = ',',  -- Specify the field terminator
    TABLOCK,                -- Use table-level locking for the bulk insert
    ROWTERMINATOR = '\n',   -- Specify the row terminator
    FORMAT = 'CSV'          -- Specify the format as CSV
);
GO
-- Bulk Insert ERP Product Category G1V2
Bulk Insert bronze.erp_px_cat_g1v2  
FROM 'D:\Github\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
WITH (
    FIRSTROW = 2,           -- Skip the header row
    FIELDTERMINATOR = ',',  -- Specify the field terminator
    TABLOCK,                -- Use table-level locking for the bulk insert
    ROWTERMINATOR = '\n',   -- Specify the row terminator
    FORMAT = 'CSV'          -- Specify the format as CSV
);  
GO
-- Verify the data has been inserted correctly  
SELECT COUNT(*) FROM bronze.erp_cust_az12;
GO
SELECT COUNT(*) FROM bronze.erp_loc_a101;
GO
SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2;
