/*
==============================================================================
DDL Script: Create Gold Views
==============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse.
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
==============================================================================
*/
Use DataWarehouse;
GO

----------------------------
-- Create View Dim Customers
----------------------------
CREATE VIEW gold.dim_customers AS
    SELECT
        ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,
        ci.cst_id AS customer_id,
        ci.cst_key AS customer_number,
        ci.cst_firstname AS first_name,
        ci.cst_lastname AS last_name,
        ci.cst_marital_status AS marital_status,
        CASE
            WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr 
            ELSE COALESCE(ca.gen, 'n/a')
        END AS gender,
        ci.cst_create_date AS created_date,
        ca.BDATE AS birth_date,
        la.CNTRY AS country
    FROM silver.crm_cust_info ci
    LEFT JOIN silver.erp_cust_az12 ca
        ON ci.cst_key = ca.CID
    LEFT JOIN silver.erp_loc_a101 la
        ON ci.cst_key = la.CID;
GO

---------------------------------
-- Verify View gold.dim_customers
---------------------------------
select * from gold.dim_customers;

-- Create View Dim Products
CREATE VIEW gold.dim_products AS
    SELECT 
        ROW_NUMBER() OVER (ORDER BY pi.prd_start_date, pi.prd_key) AS product_key,
        pi.prd_id AS product_id,
        pi.prd_key AS product_number,
        pi.prd_name AS product_name,
        pi.cat_id AS category_id,
        px.cat AS category,
        px.subcat AS subcategory,
        px.maintenance,
        pi.prd_cost AS cost,
        pi.prd_line AS line,
        pi.prd_start_date AS start_date
    FROM silver.crm_prd_info pi
    LEFT JOIN silver.erp_px_cat_g1v2 px
        ON pi.cat_id = px.id
    WHERE pi.prd_end_date IS NULL; -- Filter out all historical data
GO
---------------------------------
-- Verify View gold.dim_products
---------------------------------
select * from gold.dim_products;
Go

-------------------------
-- Create View fact_sales
-------------------------
CREATE VIEW gold.fact_sales AS
SELECT
	sd.sls_ord_num AS order_number,
	pr.product_key,
	cu.customer_key,
	sd.sls_order_date AS order_date,
	sd.sls_ship_date AS shipping_date,
	sd.sls_due_date AS due_date,
	sd.sls_sales AS sales_amount,
	sd.sls_quantity AS quantity,
	sd.sls_price AS price
FROM
	silver.crm_sales_details sd
	LEFT JOIN
	gold.dim_products pr
	ON
	sd.sls_prd_key = pr.product_number
	LEFT JOIN
	gold.dim_customers cu
	ON
	sd.sls_cust_id = cu.customer_id;
GO
---------------------------------
-- Verify View gold.fact_sales
---------------------------------
select * from gold.fact_sales;


---------------------------------------------------
--- Join fact with all dim tables for a quick check
---------------------------------------------------
SELECT *
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
ON fs.customer_key = dc.customer_key
LEFT JOIN gold.dim_products dp
ON fs.product_key = dp.product_key

---------------------------------------------------
-- Foreign key integrity with customer_key
---------------------------------------------------
select *
from gold.fact_sales fs
left join gold.dim_customers dc
on fs.customer_key = dc.customer_key
where dc.customer_key is null

---------------------------------------------------
-- Foreign key integrity with product_key
---------------------------------------------------
select *
from gold.fact_sales fs
left join gold.dim_products dp
on fs.product_key = dp.product_key
where dp.product_key is null