-- 10_views.sql (SQLite)

-- Revenue per order line (excluding cancelled)
DROP VIEW IF EXISTS vw_order_lines;
CREATE VIEW vw_order_lines AS
SELECT
  o.order_id,
  o.order_date,
  o.ship_date,
  o.customer_id,
  c.region,
  c.segment,
  o.product_id,
  p.category,
  o.quantity,
  o.unit_price_gbp,
  (o.quantity * o.unit_price_gbp) AS revenue_gbp,
  o.status
FROM orders o
LEFT JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN products p ON o.product_id = p.product_id
WHERE o.status != 'Cancelled';

-- Monthly revenue by region
DROP VIEW IF EXISTS vw_monthly_revenue_region;
CREATE VIEW vw_monthly_revenue_region AS
SELECT
  substr(order_date, 1, 7) AS month,
  region,
  SUM(revenue_gbp) AS revenue_gbp
FROM vw_order_lines
GROUP BY 1,2
ORDER BY 1,3 DESC;

-- Return rate by month
DROP VIEW IF EXISTS vw_return_rate_monthly;
CREATE VIEW vw_return_rate_monthly AS
SELECT
  substr(o.order_date, 1, 7) AS month,
  COUNT(DISTINCT r.order_id) * 1.0 / COUNT(DISTINCT o.order_id) AS return_rate
FROM orders o
LEFT JOIN returns r ON o.order_id = r.order_id
WHERE o.status = 'Shipped'
GROUP BY 1
ORDER BY 1;
