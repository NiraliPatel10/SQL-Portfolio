SELECT
    ROUND(SUM(amount), 2) AS total_revenue,
    ROUND(AVG(amount), 2) AS avg_order,
    COUNT(*) AS total_orders
FROM orders;


SELECT
    c.name AS customer_name,
    SUM(o.amount) AS total_revenue,
    AVG(o.amount) AS avg_order_value
FROM orders o
JOIN customers c
    ON o.customer_id = c.id
GROUP BY c.name
ORDER BY total_revenue DESC;

WITH avg_order AS (
    SELECT AVG(amount) AS avg_order_value
    FROM orders
),
customer_revenue AS (
    SELECT
        c.id,
        c.name,
        SUM(o.amount) AS total_revenue
    FROM customers c
    JOIN orders o ON c.id = o.customer_id
    GROUP BY c.id, c.name
)
SELECT
    cr. name,
    cr.total_revenue
FROM customer_revenue cr
CROSS JOIN avg_order ao
WHERE cr.total_revenue > ao.avg_order_value;

SELECT
    c.name AS customer_name,
    SUM(o.amount) AS total_revenue,
    RANK() OVER (ORDER BY SUM(o.amount) DESC) AS revenue_rank,
    ROUND(
        SUM(o.amount) * 100.0 / SUM(SUM(o.amount)) OVER (),
        2
    ) AS revenue_percentage
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY revenue_rank;

SELECT
    c.name AS customer_name,
    SUM(o.amount) AS total_revenue,
    RANK() OVER (ORDER BY SUM(o.amount) DESC) AS revenue_rank,
    ROUND(
        SUM(o.amount) * 100.0 / SUM(SUM(o.amount)) OVER (),
        2
    ) AS revenue_percentage
FROM customers c
JOIN orders o
    ON c.id = o.customer_id
GROUP BY c.name
ORDER BY revenue_rank;