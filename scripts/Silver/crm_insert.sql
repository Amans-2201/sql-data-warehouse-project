use datawarehouse;

GO

-- Create a stored procedure to load Silver CRM tables
CREATE PROCEDURE silver.load_silver_crm_tables
AS
BEGIN
    -- Truncate table crm_cust_info before inserting 
    IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
        TRUNCATE TABLE silver.crm_cust_info;

    -- =============================================
    -- Description: Inserting data into Silver.crm_cust_info after applying transformation
    -- Transformation Details:
    -- 1. Duplicates Removed using ROW_NUMBER()
    -- 2. Leading and trailing white spaces removed from cst_firstname and cst_lastname
    -- 3. cst_material_status converted to 'Single', 'Married', or 'n/a'
    -- 4. cst_gndr converted to 'Female', 'Male', or 'n/a'
    -- =============================================
    INSERT INTO silver.crm_cust_info (
        cst_id,
        cst_key,
        cst_firstname,
        cst_lastname,
        cst_material_status,
        cst_gndr,
        cst_create_date
    )
    SELECT
        cst_id,
        cst_key,
        TRIM(cst_firstname) AS cst_firstname,
        TRIM(cst_lastname) AS cst_lastname,
        CASE
            WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'
            WHEN UPPER(TRIM(cst_material_status)) = 'M' THEN 'Married'
            ELSE 'n/a'
        END AS cst_material_status,
        CASE
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
            ELSE 'n/a'
        END AS cst_gndr,
        cst_create_date
    FROM (
        SELECT
            *,
            ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS Flag_last
        FROM
            bronze.crm_cust_info
    ) t
    WHERE Flag_last = 1;

    -- Truncate table crm_prd_info before inserting 
    IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
        TRUNCATE TABLE silver.crm_prd_info;

    -- ===================================================================================
    -- Description: Inserting data into Silver.crm_prd_info after applying transformation
    -- Transformation Details:
    -- 1. The first 5 characters of prd_key are extracted and hyphens are replaced with underscores to create cat_id.
    -- 2. Characters from the 7th position to the end of prd_key are extracted to create prd_key.
    -- 3. If prd_cost is null, it is replaced with 0.
    -- 4. prd_line is converted to 'Mountain', 'Road', 'Other Sales', 'Touring', or 'n/a' based on its value.
    -- 5. prd_end_date is calculated as one day before the next prd_start_date for the same prd_key.
    -- ===================================================================================
    INSERT INTO silver.crm_prd_info (
        prd_id,
        cat_id,
        prd_key,
        prd_name,
        prd_cost,
        prd_line,
        prd_start_date,
        prd_end_date
    )
    SELECT
      prd_id,
      Replace(substring(prd_key, 1, 5), '-', '_') AS cat_id, -- Extracts the first 5 characters of prd_key, replacing '-' with '_'
      substring(prd_key, 7, LEN(prd_key)) AS prd_key, -- Extracts characters from the 7th position to the end of prd_key
      prd_name,
      isnull(prd_cost, 0) AS prd_cost, -- Replaces null prd_cost values with 0
      CASE
        upper(trim(prd_line))
        WHEN 'M' THEN 'Mountain'
        WHEN 'R' THEN 'Road'
        WHEN 'S' THEN 'Other Sales'
        WHEN 'T' THEN 'Touring'
        ELSE 'n/a'
      END AS prd_line, -- Converts prd_line values to corresponding names
      prd_start_date,
      dateadd(day,-1,lead(prd_start_date) OVER (PARTITION BY prd_key ORDER BY prd_start_date))  AS prd_end_date -- Calculates prd_end_date based on the next prd_start_date
    FROM
      bronze.crm_prd_info;

    -- Truncate table crm_sales_details before inserting 
    IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
        TRUNCATE TABLE silver.crm_sales_details;

    -- ======================================================================
    -- Description: Inserting data into Silver crm_sales_details
    -- Transformation Details:
    -- 1. Converts invalid order dates to NULL.
    -- 2. Converts invalid ship dates to NULL.
    -- 3. Converts invalid due dates to NULL.
    -- 4. Calculates sales amount if it is NULL, invalid, or inconsistent.
    -- 5. Calculates price if it is invalid or NULL.
    -- ======================================================================
    Insert into silver.crm_sales_details (
      sls_ord_num,
      sls_prd_key,
      sls_cust_id,
      sls_order_date,
      sls_ship_date,
      sls_due_date,
      sls_sales,
      sls_quantity,
      sls_price
    )
    SELECT
      sls_ord_num,
      sls_prd_key,
      sls_cust_id,
      CASE
        WHEN sls_order_date = 0
        OR LEN(sls_order_date) != 8 THEN NULL
        ELSE TRY_CAST(CAST(sls_order_date AS VARCHAR) AS DATE)
      END AS sls_order_date,
      CASE
        WHEN sls_ship_date = 0
        OR LEN(sls_ship_date) != 8 THEN NULL
        ELSE TRY_CAST(CAST(sls_ship_date AS VARCHAR) AS DATE)
      END AS sls_ship_date,
      CASE
        WHEN sls_due_date = 0
        OR LEN(sls_due_date) != 8 THEN NULL
        ELSE TRY_CAST(CAST(sls_due_date AS VARCHAR) AS DATE)
      END AS sls_due_date,
      CASE
        WHEN sls_sales IS NULL
        OR sls_sales <= 0
        OR sls_sales != sls_quantity * ABS(sls_price) THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
      END AS sls_sales,
      sls_quantity,
      CASE
        WHEN sls_price <= 0
        OR sls_price IS NULL THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price
      END AS sls_price
    FROM
      bronze.crm_sales_details;

END;
GO

-- execute the stored procedure
exec silver.load_silver_crm_tables;

Go
-- Verify the rows are inserted into silver.crm_cust_info
SELECT count(*) FROM silver.crm_cust_info;
Go
select * from silver.crm_cust_info
Go

-- Verify the rows are inserted into silver.crm_prd_info
SELECT count(*) FROM silver.crm_prd_info;
Go
select * from silver.crm_prd_info
Go

-- verify the rows are inserted into silver.crm_sales_details
SELECT count(*) FROM silver.crm_sales_details;
Go
select * from silver.crm_sales_details