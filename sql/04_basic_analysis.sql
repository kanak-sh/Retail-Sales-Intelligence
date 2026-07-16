-- ==========================================
-- Query 1: Total Revenue
-- ==========================================
SELECT ROUND(SUM(payment_value), 2) AS total_revenue
FROM fact_payments;

-- ==========================================
-- QUERY 2: Total Orders
-- ==========================================
SELECT COUNT(*) AS total_orders
FROM fact_orders;

-- ==========================================
-- Query 3: Total Customers
-- ==========================================
SELECT COUNT(*) AS total_customers
FROM dim_customers;

-- ==========================================
-- Query 4: Total Sellers
-- ==========================================
SELECT COUNT(*) AS total_sellers
FROM dim_sellers;

-- ==========================================
-- Query 5: Average Order Value
-- ==========================================
SELECT ROUND(AVG(payment_value), 2) AS average_order_value
FROM fact_payments; 

-- ==========================================
-- Query 6: Orders by State
-- ==========================================
SELECT c.customer_state, COUNT(o.order_id) AS total_orders
FROM fact_orders o 
JOIN dim_customers c
ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_orders DESC;

-- ==========================================
-- Query 7: Revenue by State
-- ==========================================
SELECT c.customer_state, ROUND(SUM(p.payment_value), 2) AS revenue
FROM fact_orders o 
JOIN dim_customers c
ON o.customer_id = c.customer_id
JOIN fact_payments p
ON o.order_id = p.order_id
GROUP BY c.customer_state
ORDER BY revenue DESC;

-- ==========================================
-- Query 8: Orders by Payment Type
-- ==========================================
SELECT payment_type, COUNT(DISTINCT order_id) AS orders
FROM fact_payments
GROUP BY payment_type
ORDER BY orders DESC;

-- ==========================================
-- Query 9: Revenue by Payment Type
-- ==========================================
SELECT payment_type, ROUND(SUM(payment_value), 2) AS revenue
FROM fact_payments
GROUP BY payment_type
ORDER BY revenue DESC;

-- ==========================================
-- Query 10: Monthly Orders
-- ==========================================
SELECT DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS month, COUNT(*) AS orders
FROM fact_orders 
GROUP BY month
ORDER BY month;
