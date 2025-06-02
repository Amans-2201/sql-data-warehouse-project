Use DataWarehouse;
Go  

-- Create a stored procedure to execute below queries
CREATE OR ALTER PROCEDURE silver.load_silver_erp_tables
AS
BEGIN
    PRINT 'Truncating table: silver.erp_cust_az12';
    If object_id('silver.erp_cust_az12', 'U') is not null
        truncate table silver.erp_cust_az12;

    -- Insert into silver.erp_cust_az12 after transformation
    -- Transformations applied:
    -- 1. cid: Remove leading 'NAS' if present
    -- 2. bdate: Set to NULL if greater than current date
    -- 3. gen: Convert to 'Female', 'Male', or 'n/a'

    PRINT 'Inserting data into table: silver.erp_cust_az12';
    Insert into silver.erp_cust_az12 (
      CID,
      bdate,
      GEN
    )
    SELECT CASE
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
        ELSE cid
      END AS cid,
      CASE
        WHEN bdate > GETDATE() THEN NULL
        ELSE bdate
      END bdate,
      CASE
        WHEN UPPER(TRIM(gen)) IN ('F', 'Female') THEN 'Female'
        WHEN UPPER(TRIM(gen)) IN ('M', 'Male') THEN 'Male'
        ELSE 'n/a'
      END AS gen
    FROM bronze.erp_cust_az12
    PRINT 'Data inserted into silver.erp_cust_az12. Rows inserted: ' + CAST(@@ROWCOUNT AS VARCHAR);

    -- Truncate table silver.erp_loc_a101 before inserting
    PRINT 'Truncating table: silver.erp_loc_a101';
    If object_id('silver.erp_loc_a101', 'U') is not null
        truncate table silver.erp_loc_a101;

    -- Insert into silver.erp_loc_a101
    -- Add transformations:
    -- 1. cid: Remove leading or in-between or trailing '-' if present
    -- 2. cntry: Convert to 'Germany', 'United States', or 'n/a' for invalid values  

    PRINT 'Inserting data into table: silver.erp_loc_a101';
    Insert into silver.erp_loc_a101 (
      cid,
      cntry
    )
    SELECT 
      REPLACE(cid, '-', '') AS cid,
      CASE 
        WHEN cleaned_cntry = 'DE' THEN 'Germany'
        WHEN cleaned_cntry IN ('USA', 'US') THEN 'United States'
        WHEN cleaned_cntry = '' THEN 'n/a'
        ELSE orig_cntry
      END AS cntry
    FROM (
      SELECT 
        cid,
        TRIM(cntry) AS orig_cntry,
        UPPER(TRIM(COALESCE(cntry, ''))) AS cleaned_cntry
      FROM bronze.erp_loc_a101
    ) AS prep
    PRINT 'Data inserted into silver.erp_loc_a101. Rows inserted: ' + CAST(@@ROWCOUNT AS VARCHAR);

    -- Truncate table silver.erp_px_cat_g1v2 before inserting
    PRINT 'Truncating table: silver.erp_px_cat_g1v2';
    If object_id('silver.erp_px_cat_g1v2', 'U') is not null
        truncate table silver.erp_px_cat_g1v2; 

    -- Insert into silver.erp_px_cat_g1v2
    -- No transformations required as all data is valid
    PRINT 'Inserting data into table: silver.erp_px_cat_g1v2';
    Insert into silver.erp_px_cat_g1v2 (
      ID,
      CAT,
      SUBCAT,
      Maintenance
    )
    Select 
      ID,
      CAT,
      SUBCAT,
      MAINTENANCE
    from bronze.erp_px_cat_g1v2
    PRINT 'Data inserted into silver.erp_px_cat_g1v2. Rows inserted: ' + CAST(@@ROWCOUNT AS VARCHAR);
End;
Go

-- Execute the stored procedure
exec silver.load_silver_erp_tables;

Go  
-- Verify the data in silver.erp_cust_az12 table
select count(*) from silver.erp_cust_az12
Go  
select * from silver.erp_cust_az12
Go  

--Verify the data in silver.erp_loc_a101 table
select count(*) from silver.erp_loc_a101
Go  
select * from silver.erp_loc_a101
Go  

-- Verify the data in silver.erp_px_cat_g1v2 table
select count(*) from silver.erp_px_cat_g1v2
Go  
select * from silver.erp_px_cat_g1v2



