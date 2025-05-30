use DataWarehouse;
-- This script creates the necessary tables in the bronze layer for ERP data
GO
-- Check If the table bronze.erp_cust_az12 already exists and drop it if it does
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
GO
-- Create table CUST_AZ12 with columns CID,BDATE,GEN as NVARCHAR, DATE & NVARCHAR
CREATE TABLE bronze.erp_cust_az12 (
    CID NVARCHAR(50),  -- Customer ID
    BDATE DATE,        -- Birth Date
    GEN NVARCHAR(50)   -- Gender
);
GO
-- Check If the table bronze.erp_loc_a10 already exists and drop it if it does
IF OBJECT_ID('bronze.erp_loc_a10', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a10;
GO
-- Create table LOC_A101 with columns CID,CNTRY as both NVARCHAR
CREATE TABLE bronze.erp_loc_a10 (
    CID NVARCHAR(50),  -- Customer ID
    CNTRY NVARCHAR(50) -- Country
);
GO
-- Check If the table bronze.erp_px_cat_g1v2 already exists and drop it if it does
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;  
GO
-- Create table PX_CAT_G1V2 with columns ID, CAT, SUBCAT and Maintenance as NVARCHAR
CREATE TABLE bronze.erp_px_cat_g1v2 (
    ID NVARCHAR(50),   -- Category ID
    CAT NVARCHAR(50),  -- Category Name
    SUBCAT NVARCHAR(50), -- Subcategory Name
    Maintenance NVARCHAR(5) -- Maintenance Information
);
