-- Crear una vista materializada para análisis de ventas por región
CREATE MATERIALIZED VIEW mv_sales_summary AS
SELECT c.region, COUNT(s.sale_id) AS total_sales, SUM(s.total_amount) AS total_revenue
FROM sales s
JOIN customers c ON s.customer_id = c.customer_id
GROUP BY c.region;

-- Refrescar la vista materializada
REFRESH MATERIALIZED VIEW mv_sales_summary;
