/*
Data analytics is the process of using data to answer questions and make decisions.
In our data model, the data analytics is performed using the fact table and the dimensions.

---Types of Tables---
Fact tables are the tables that contain the actual data and are used to calculate 
metrics and perform analysis. In our data model, the fact table is fact_sales.

Dimensions are the tables that contain the attributes of the entities in the fact table.
In our data model, the dimensions are dim_customers, dim_products, and dim_date.
e.g product_name, product_id, customer_name, customer_id, order_date, order_id

---Types of Dimensions---
Low cardinality dimensions are those with a small number of unique values.
In our data model, country and marital_status are examples of low cardinality 
dimensions. These dimensions have a limited number of distinct values and are best used 
for summary and grouping purposes.

High cardinality dimensions are those with a large number of unique values.
In our data model, customer_id and product_id are examples of high cardinality 
dimensions. These dimensions have a large number of distinct values and are best used 
for drill-down and analysis purposes.

---Metrics---
Metrics are the measures that are calculated from the data in the fact table.
In our data model, the metrics are total_sales, total_quantity, total_price, 
avg_price, total_orders, total_customers, and total_products.

*/


-- bottom 3 customers by total orders
select 
	dc.customer_key,
	dc.first_name,
	dc.last_name,
	count(fs.order_number) as total_orders
from gold.fact_sales fs
left join gold.dim_customers dc
on fs.customer_key = dc.customer_key
group by dc.customer_key, dc.first_name, dc.last_name
order by total_orders asc
offset 0 rows
fetch first 3 rows only


-- top 3 customers by total orders
select 
	dc.customer_key,
	dc.first_name,
	dc.last_name,
	count(fs.order_number) as total_orders
from gold.fact_sales fs
left join gold.dim_customers dc
on fs.customer_key = dc.customer_key
group by dc.customer_key, dc.first_name, dc.last_name
order by total_orders desc
offset 0 rows
fetch first 3 rows only

-- top N customers by total orders in descending order

DECLARE @customer_count INT;
SET @customer_count = 4;

WITH CTE_rank_customer AS (
    SELECT 
        dc.customer_key,
        dc.first_name,
        dc.last_name,
        COUNT(fs.order_number) AS total_orders,
        ROW_NUMBER() OVER (ORDER BY COUNT(fs.order_number) DESC) AS C_Rank
    FROM gold.fact_sales fs
    LEFT JOIN gold.dim_customers dc
        ON fs.customer_key = dc.customer_key
    GROUP BY dc.customer_key, dc.first_name, dc.last_name
)
SELECT * 
FROM CTE_rank_customer
WHERE C_Rank <= @customer_count;

-- change over time trend , aggregate a measure by date dimension
-- e.g. total sales by month, total orders by month, total customers by month
-- use window function to calculate the change over time trend

-- below query shows the total sales by month and the total sales over time
WITH daily_sales AS (
    SELECT
        order_date,
        SUM(sales_amount) AS total_sales
    FROM gold.fact_sales
    GROUP BY order_date
)
SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_date) AS total_sales_over_time
FROM daily_sales
ORDER BY order_date;

-- running total sales by month
select
order_date,
total_sales,
sum(total_sales) over (order by order_date) as Running_Total_sales
from 
(
	select 
	datetrunc(month,order_date) as order_date,
	sum(sales_amount) as total_sales
	from gold.fact_sales
	where order_date is not null
	group by datetrunc(month,order_date)
) as t


-- eg. of lag() to calculate previous year sales
-- This query will calculate the average sales for each year, and then compare the average sales
-- for each year with the average sales of the previous year.
-- It will return the year, average sales for the current year, average sales for the previous year,
-- and the difference between the two.
select
    year_order_date,
    avg_sales_current_year,
    lag(avg_sales_current_year,1) over (order by year_order_date) as avg_sales_previous_year,
    (avg_sales_current_year - lag(avg_sales_current_year,1) over (order by year_order_date)) as avg_difference
from
    (
        Select
            year(fs.order_date) as year_order_date,
            AVG(fs.sales_amount) as avg_sales_current_year
        from gold.fact_sales fs
        left join gold.dim_products dp
            on fs.product_key = dp.product_key
        group by year(fs.order_date)
    ) t


-- this query will calculate the total sales by year and product and compare it with the average sales
-- and return the year, product name, current sales, average sales, difference between current and average sales
-- to create avg performance metric
with cte_yearly_sales as
(
    Select
        year(fs.order_date) as order_year,
        dp.product_name,
        sum(fs.sales_amount) as current_sales
    from gold.fact_sales fs
    left join gold.dim_products dp
        on fs.product_key = dp.product_key
    group by year(fs.order_date), dp.product_name
)
select 
    order_year,
    product_name,
    current_sales,
    -- calculate the average sales for each product over all years
    avg(current_sales) over (partition by product_name) as avg_sales,
    -- calculate the difference between the current sales and the average sales
    current_sales - avg(current_sales) over (partition by product_name) as diff_avg,
    case 
        -- if the difference is positive, then the current sales are above average
        when current_sales - avg(current_sales) over (partition by product_name) > 0 then 'Above Average'
        -- if the difference is negative, then the current sales are below average
        when current_sales - avg(current_sales) over (partition by product_name) < 0 then 'Below Average'
        -- if the difference is zero, then the current sales are average
        else 'Average'
    end as avg_change,
    -- Year-over-year analysis
    -- calculate the previous year sales
    lag(current_sales) over (partition by product_name order by order_year) as prev_year_sales,
    -- calculate the sales change
    case 
        when current_sales > lag(current_sales) over (partition by product_name order by order_year) then 'Increase'
        when current_sales < lag(current_sales) over (partition by product_name order by order_year) then 'Decrease'
        else 'No Change'
    end as sales_change
from cte_yearly_sales
order by product_name,  order_year


-- sales by category proportion to total sales
-- this query helps decision making by showing the proportion of total sales for each category
-- to assist business in making decisions on which category to focus on
with cte_sales_by_category as
(
    -- Calculate total sales by category
    Select
        dp.category,
        sum(fs.sales_amount) as sales_by_category
    from gold.fact_sales fs
    left join gold.dim_products dp
        on fs.product_key = dp.product_key
    group by dp.category
)
select 
    category,
    sales_by_category,
    -- Get the total sales
    sum(sales_by_category) over () as total_sales,
    -- Calculate the percentage of total sales for each category
    round(cast(sales_by_category as float)/sum(sales_by_category) over ()*100,2) as percent_of_total
from cte_sales_by_category
order by sales_by_category desc


-- product count by cost, convert one measure to dimension like cost to create cost segment
-- this query helps decision making by showing the count of products for each cost segment
-- to assist business in making decisions on which cost segment to focus on
with cte_product_by_cost
as
(
	-- This query is used to count the number of products in each cost segment
	-- The cost segments are: low cost (0-500), medium cost (500-1500), high cost (>1500)
	select 
		product_name,
		cost,
		case 
			when cost between 0 and 500 then 'low cost'
			when cost between 500 and 1500 then 'medium cost'
			else 'high cost'
		end as product_segment
	from gold.dim_products
)
select 
	-- Select the product_segment and the count of products for each segment
	product_segment,
	count(product_name) as product_count
from cte_product_by_cost
-- Group by product_segment so that we can get the count of products for each segment
group by product_segment
-- Order by the product_count in descending order
order by 2 desc

-- optimized version

WITH customer_aggregated_behaviour AS (
    -- This CTE calculates aggregated metrics per customer (duration, total sales)
    -- and then assigns a behaviour category in the same step.
    SELECT
        -- dc.customer_key, -- Included for clarity, used by COUNT(*) in the final SELECT implicitly
        CASE
            WHEN DATEDIFF(MONTH, MIN(fs.order_date), MAX(fs.order_date)) >= 12 AND SUM(fs.sales_amount) > 5000 THEN 'VIP'
            WHEN DATEDIFF(MONTH, MIN(fs.order_date), MAX(fs.order_date)) >= 12 AND SUM(fs.sales_amount) < 5000 THEN 'Regular'
            WHEN DATEDIFF(MONTH, MIN(fs.order_date), MAX(fs.order_date)) < 12 THEN 'New'
            -- Customers with duration >= 12 months and sales_amount = 5000 will have NULL behaviour
        END AS customer_behaviour
    FROM gold.dim_customers dc
    JOIN gold.fact_sales fs ON dc.customer_key = fs.customer_key
    WHERE fs.order_date IS NOT NULL -- Ensures that only sales with valid order dates are considered, matching original logic.
    GROUP BY dc.customer_key -- Aggregate at the customer level
)
SELECT
    customer_behaviour,
    COUNT(*) AS total_customer -- Counts unique customers per behaviour group due to the GROUP BY in the CTE
FROM customer_aggregated_behaviour
GROUP BY customer_behaviour;

/*
Customer Report

Purpose:
- This report consolidates key customer metrics and behaviors

Highlights:
1. Gathers essential fields such as names, ages, and transaction details.
2. Segments customers into categories (VIP, Regular, New) and age groups.
3. Aggregates customer-level metrics:
- total orders
- total sales
- total quantity purchased
- total products
- lifespan (in months)
4. Calculates valuable KPIs:
- recency (months since last order)
- average order value
- average monthly spend
*/  
create view gold.customer_report as
with cte_base_query as 
(
    -- Filter out invalid order dates
    select 
        fs.order_number,
        fs.product_key,
        fs.order_date,
        fs.sales_amount,
        fs.quantity,
        dc.customer_key,
        dc.customer_number,
        -- Concatenate names
        CONCAT(dc.first_name,' ',dc.last_name) as customer_name,
        -- Calculate customer age
        datediff(year,dc.birth_date,GETDATE()) as age
    from gold.fact_sales fs
    left join gold.dim_customers dc
        on dc.customer_key = fs.customer_key
    where fs.order_date is not null
), cte_customer_aggregation as
(
    -- Aggregate customer-level metrics
    select 
        customer_key,
        customer_number,
        customer_name,
        age,
        -- Count unique orders
        count(distinct order_number) as total_orders,
        -- Sum sales amount
        sum(sales_amount) as total_sales,
        -- Sum quantity
        sum(quantity) as total_quantity,
        -- Count unique products
        count(distinct product_key) as total_products,
        -- Last order date
        max(order_date) as last_order_date,
        -- Lifespan in months
        datediff(month,min(order_date),max(order_date)) as lifespan
    from cte_base_query
    group by customer_key,customer_number, customer_name,age
)
select 
    customer_key,
    customer_number,
    customer_name,
    -- Age group
    case 
        when age < 20 then 'Under 20'
        when age between 20 and 29 then '20-29'
        when age between 30 and 39 then '30-39'
        when age between 40 and 49 then '40-49'
        else '50 and above'
    end as age_group,
    -- Customer segment
    case
        when lifespan >=12 and total_sales > 5000 then 'VIP'
        when lifespan >=12 and total_sales < 5000 then 'Regular'
        else 'New'
    end as customer_segment,
    -- Last order date
    last_order_date,
    -- Recency
    datediff(month,last_order_date,GETDATE()) as recency,
    -- Total orders
    total_orders,
    -- Total sales
    total_sales,
    -- Total quantity
    total_quantity,
    -- Total products
    total_products,
    -- Lifespan
    lifespan,
    -- Average order value
    case
        when total_orders = 0 then 0
        else total_sales/total_orders
    end as avg_order_value,
    -- Average monthly spend
    case 
        when lifespan = 0 then total_sales
        else total_sales/lifespan 
    end as avg_monthly_spend
from cte_customer_aggregation

/*
Product Report

Purpose:
- This report consolidates key product metrics and behaviors.

Highlights:
1. Gathers essential fields such as product name, category, subcategory, and cost.
2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
3. Aggregates product-level metrics:
- total orders
- total sales
- total quantity sold
- total customers (unique)
- lifespan (in months)
4. Calculates valuable KPIs:
- recency (months since last sale)
- average order revenue (AOR)
- average monthly revenue
*/
create view gold.product_report as
with cte_base_query as
(
    -- Base query to gather essential product metrics
    select
        dp.product_key,
        dp.product_name,
        dp.category,
        dp.subcategory,
        dp.cost,
        count(distinct fs.order_number) as total_orders,
        sum(fs.sales_amount) as total_sales,
        sum(fs.quantity) as total_quantity,
        count(distinct fs.customer_key) as total_customers,
        max(fs.order_date) as last_order_date,
        -- Lifespan is calculated as the difference between the first and last order date
        datediff(month, min(order_date), max(order_date)) as lifespan
    from gold.fact_sales fs
    left join gold.dim_products dp
        on fs.product_key = dp.product_key
    group by dp.product_key,
             dp.product_name,
             dp.category,
             dp.subcategory,
             dp.cost
)
select
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_order_date,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    lifespan,
    -- Segments products by revenue
    case
        when total_sales <= 10000 then 'Low-Performers'
        when total_sales <= 225817 then 'Mid-range'
        else 'High-Performers'
    end as product_segment,
    -- Recency is calculated as the difference between the current date and the last order date
    datediff(month, last_order_date, getdate()) as recency,
    -- Average order revenue (AOR) is calculated as total sales divided by total orders
    case
        when total_orders = 0 then 0
        else total_sales / total_orders
    end as avg_order_value,
    -- Average monthly revenue is calculated as total sales divided by lifespan
    case
        when lifespan = 0 then total_sales
        else total_sales / lifespan
    end as avg_monthly_revenue
from cte_base_query;