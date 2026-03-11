/*

The questions should test your database design, joins,
functions, constraints, indexes, and writing efficient
 queries, not just analysis.

*/

/*
1️⃣ Joins & Relationships

Write a query to return all orders, showing the customer name, product name,
quantity, and order date.

*/

SELECT b.customer_id, b.name as customer_name, c.name as product_name,
 a.quantity,
    DATE_FORMAT(a.order_date, '%m/%d/%Y') as order_date
FROM orders as a
INNER JOIN customers as b
    ON a.customer_id = b.customer_id
INNER JOIN products as c
    ON a.product_id = c.product_id;


-- Modify the query to only include orders for products in the 'Coffee' category.

SELECT b.customer_id, b.name as customer_name, c.name as product_name,
 a.quantity,
    DATE_FORMAT(a.order_date, '%m/%d/%Y') as order_date
FROM orders as a
INNER JOIN customers as b
    ON a.customer_id = b.customer_id
INNER JOIN products as c
    ON a.product_id = c.product_id
WHERE category = 'Coffee';

-- How would you return customers who have never placed an order?

SELECT a.name as customer_name
FROM customers as a
LEFT JOIN orders as b
    ON a.customer_id = b.customer_id
GROUP BY a.name
HAVING sum(CASE WHEN b.order_id IS NOT NULL THEN 1 ELSE 0 END) = 0;

/* Try to write a query that shows:

customer_name
total_orders
total_items_ordered

*/

SELECT
a.name as customer_name,
count(b.order_id) as total_orders,
COALESCE(sum(b.quantity), 0) as total_items_ordered
FROM customers as a
LEFT JOIN orders as b
    ON a.customer_id = b.customer_id
GROUP BY a.name;


/* Show the TOP 3 customers who ordered the most items

Example result:

customer	items
Ash	25
Misty	18
Gary	14

*/

SELECT
a.customer_id,
a.name as customer_name,
COALESCE(sum(b.quantity), 0) as total_items_ordered
FROM customers as a
LEFT JOIN orders as b
    ON a.customer_id = b.customer_id
GROUP BY a.customer_id, a.name
ORDER BY total_items_ordered DESC
LIMIT 3;

/*
1️⃣ Joins & Relationships

Write a query to return all orders, showing the customer name, product name,
quantity, and order date.

*/