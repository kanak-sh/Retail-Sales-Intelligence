-- =====================================================
-- Query 1: Top 10 Product Categories by Revenue
-- =====================================================
SELECT COALESCE(ct.product_category_name_english, p.product_category_name) AS category, ROUND(SUM(pay.payment_value), 2) AS total_revenue
FROM fact_order_items oi
JOIN dim_products p
ON oi.product_id = p.product_id
LEFT JOIN dim_category_translation ct
ON p.product_category_name = ct.product_category_name
JOIN fact_payments pay
ON oi.order_id = pay.order_id
GROUP BY category
ORDER BY total_revenue DESC
LIMIT 10;

-- =====================================================
-- Query 2: Top 10 Product Categories by Units Sold
-- =====================================================
SELECT COALESCE(ct.product_category_name_english, p.product_category_name) AS category, COUNT(*) AS units_sold
FROM fact_order_items oi 
JOIN dim_products p
ON oi.product_id = p.product_id
LEFT JOIN dim_category_translation ct
ON p.product_category_name = ct.product_category_name
GROUP BY category
ORDER BY units_sold DESC
LIMIT 10;

-- =====================================================
-- Query 3: Top 10 Sellers by Revenue
-- =====================================================
SELECT oi.seller_id, ROUND(SUM(oi.price), 2) AS revenue
FROM fact_order_items oi
GROUP BY oi.seller_id
ORDER BY revenue DESC
LIMIT 10;

-- =====================================================
-- Query 4: Top 10 Customers by Total Spending
-- =====================================================
SELECT c.customer_unique_id, ROUND(SUM(p.payment_value), 2) AS total_spent
FROM fact_orders o
JOIN dim_customers c
ON o.customer_id = c.customer_id
JOIN fact_payments p
ON o.order_id = p.order_id
GROUP BY c.customer_unique_id
ORDER BY total_spent DESC
LIMIT 10;

-- =====================================================
-- Query 5: Average Delivery Time
-- =====================================================
SELECT ROUND(AVG(DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)), 2) AS avg_delivery_days
FROM fact_orders
WHERE order_delivered_customer_date IS NOT NULL;

-- =====================================================
-- Query 6: Percentage of Late Deliveries
-- ===================================================
SELECT COUNT(*) AS total_orders, SUM(order_delivered_customer_date > order_estimated_delivery_date) AS late_orders, ROUND(SUM( order_delivered_customer_date > order_estimated_delivery_date) * 100.0 / COUNT(*), 2) AS late_percentage
FROM fact_orders
WHERE order_delivered_customer_date IS NOT NULL;