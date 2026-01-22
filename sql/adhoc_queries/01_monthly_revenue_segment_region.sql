-- Monthly revenue by segment and region
SELECT
  substr(o.order_date, 1, 7) AS month,
  c.segment,
  c.region,
  SUM(o.quantity * o.unit_price_gbp) AS revenue_gbp
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status != 'Cancelled'
GROUP BY 1,2,3
ORDER BY 1, revenue_gbp DESC;
