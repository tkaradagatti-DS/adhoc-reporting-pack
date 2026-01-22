-- Late deliveries (>5 days between order_date and ship_date)
SELECT
  o.order_id,
  o.order_date,
  o.ship_date,
  julianday(o.ship_date) - julianday(o.order_date) AS lead_time_days,
  c.region,
  c.segment
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'Shipped'
  AND o.ship_date IS NOT NULL
  AND (julianday(o.ship_date) - julianday(o.order_date)) > 5
ORDER BY lead_time_days DESC;
