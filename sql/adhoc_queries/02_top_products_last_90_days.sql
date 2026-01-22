-- Top 10 products by revenue (last 90 days)
SELECT
  p.product_name,
  SUM(o.quantity * o.unit_price_gbp) AS revenue_gbp
FROM orders o
JOIN products p ON o.product_id = p.product_id
WHERE o.status = 'Shipped'
  AND date(o.order_date) >= date('now', '-90 day')
GROUP BY 1
ORDER BY revenue_gbp DESC
LIMIT 10;
