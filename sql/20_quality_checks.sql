-- 20_quality_checks.sql (SQLite)

-- Duplicate customers
SELECT customer_id, COUNT(*) AS cnt
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Negative quantity
SELECT order_id, quantity
FROM orders
WHERE quantity <= 0;

-- Missing ship_date for shipped orders
SELECT order_id, order_date, ship_date
FROM orders
WHERE status = 'Shipped' AND (ship_date IS NULL OR TRIM(ship_date) = '');

