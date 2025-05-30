use DataWarehouse;
-- This script creates the necessary tables in the bronze layer for ERP data
GO
-- Create table CUST_AZ12 with columns CID,BDATE,GEN as NVARCHAR, DATE & NVARCHAR
CREATE TABLE bronze.erp_cust_az12 (
    CID NVARCHAR(50),  -- Customer ID
    BDATE DATE,        -- Birth Date
    GEN NVARCHAR(50)   -- Gender
);
GO
-- Create table LOC_A101 with columns CID,CNTRY as both NVARCHAR
CREATE TABLE bronze.erp_loc_a101 (
    CID NVARCHAR(50),  -- Customer ID
    CNTRY NVARCHAR(50) -- Country
);
GO
-- Create table PX_CAT_G1V2 with columns ID, CAT, SUBCAT and Maintenance as NVARCHAR
CREATE TABLE bronze.erp_px_cat_g1v2 (
    ID NVARCHAR(50),   -- Category ID
    CAT NVARCHAR(50),  -- Category Name
    SUBCAT NVARCHAR(50), -- Subcategory Name
    Maintenance NVARCHAR(5) -- Maintenance Information
);
