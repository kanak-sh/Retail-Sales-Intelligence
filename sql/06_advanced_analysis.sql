-- =====================================================
-- Query 1: Rank Sellers by Revenue
-- =====================================================
WITH seller_revenue AS(
    SELEct seller_id, ROUND(SUM(price), 2) AS revenue
    FROM fact_order_items
    GROUP BY seller_id
)
SELECT RANK() OVER(ORDER BY revenue DESC) AS seller_rank, seller_id, revenue
FROM seller_revenue
LIMIT 10;

-- =====================================================
-- Query 2: Best Selling Category in Each State
-- =====================================================
WITH category_sales AS (
    SELECT c.customer_state, COALESCE(ct.product_category_name_english, p.product_category_name) AS category, COUNT(*) AS orders
    FROM fact_order_items oi
    JOIN fact_orders o
    ON oi.order_id = o.order_id
    JOIN dim_customers c
    ON o.customer_id = c.customer_id
    JOIN dim_products p
    ON oi.product_id = p.product_id
    LEFT JOIN dim_category_translation ct
    ON p.product_category_name = ct.product_category_name
    GROUP BY c.customer_state, category
)
SELECT *
FROM(
    SELECT customer_state, category, orders, ROW_NUMBER() OVER(PARTITION BY customer_state ORDER BY orders DESC) AS rn
    FROM category_sales
) ranked
WHERE rn = 1
ORDER BY customer_state;

-- =====================================================
-- Query 3: Monthly Revenue and Running Total
-- =====================================================
WITH monthly_sales AS(
    SELECT DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month, ROUND(SUM(p.payment_value), 2) AS revenue
    FROM fact_orders o
    JOIN fact_payments p
    ON o.order_id = p.order_id
    GROUP BY month
)
SELECT month, revenue, SUM(revenue) OVER(ORDER BY month) AS running_total
FROM monthly_sales;

-- =====================================================
-- Query 4: Month-over-Month Revenue Growth
-- =====================================================
WITH monthly_sales AS (
	SELECT DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS month, SUM(p.payment_value) AS revenue
    FROM fact_orders o
    JOIN fact_payments p
	ON o.order_id = p.order_id
    GROUP BY month
)
SELECT month, ROUND(revenue,2) AS revenue, ROUND(((revenue - LAG(revenue) OVER (ORDER BY month)) / NULLIF(LAG(revenue) OVER (ORDER BY month),0)) * 100, 2) AS growth_percent
FROM monthly_sales;

-- =====================================================
-- Query 5: Pareto Analysis of Sellers
-- =====================================================
WITH seller_sales AS(
    SELECT seller_id, SUM(price) revenue
    FROM fact_order_items
    GROUP BY seller_id
), 
ranked AS(
    SELECT seller_id, revenue, SUM(revenue) OVER(ORDER BY revenue DESC) cumulative_revenue, SUM(revenue) OVER() total_revenue
    FROM seller_sales
)
SELECT seller_id, ROUND(revenue, 2), ROUND(cumulative_revenue, 2), ROUND(100 * cumulative_revenue/total_revenue, 2) cumulative_percent
FROM ranked
ORDER BY revenue DESC
LIMIT 20;

-- =====================================================
-- Query 6: RFM Metrics
-- =====================================================
SELECT c.customer_unique_id, DATEDIFF(MAX(o.order_purchase_timestamp), MIN(o.order_purchase_timestamp)) recency, COUNT(DISTINCT o.order_id) frequency, ROUND(SUM(p.payment_value), 2) monetary
FROM fact_orders o
JOIN dim_customers c
ON o.customer_id = c.customer_id
JOIN fact_payments p
ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
ORDER BY monetary DESC
LIMIT 20;