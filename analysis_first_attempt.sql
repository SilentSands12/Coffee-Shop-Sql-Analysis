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


-- 2️⃣ Aggregations & Grouping

-- Write a query to get total quantity ordered per product.

SELECT
    a.product_id,
    a.name as product_name,
    COALESCE(SUM(b.quantity), 0) as total_quantity
FROM products as a
LEFT JOIN orders as b
    ON a.product_id = b.product_id
GROUP BY a.product_id;


-- How would you find the product that has been ordered the most in terms of quantity?

SELECT
    a.name as product_name,
    COALESCE(SUM(b.quantity), 0) as total_quantity
FROM products as a
JOIN orders as b
    ON a.product_id = b.product_id
GROUP BY a.product_id
ORDER BY total_quantity DESC
LIMIT 1;

-- Find the total number of orders per customer, but only show customers who have more than 2 orders.
SELECT
    a.customer_id,
    a.name as customer_name,
    COUNT(b.order_id) as total_orders
FROM customers as a
JOIN orders as b
    ON a.customer_id = b.customer_id
GROUP BY a.customer_id, a.name
HAVING total_orders > 2;

-- How many times each product was ordered

SELECT
    a.product_id,
    a.name as product_name,
    COALESCE(COUNT(b.order_id), 0) as total_orders
FROM products as a
LEFT JOIN orders as b
    ON a.product_id = b.product_id
GROUP BY a.product_id, a.name;

-- Products With More Than 5 Items Ordered
-- But only show products where total quantity ordered is greater than 5.

SELECT
    a.product_id,
    a.name as product_name,
    COALESCE(SUM(b.quantity), 0) as total_quantity
FROM products as a
JOIN orders as b
    ON a.product_id = b.product_id
GROUP BY a.product_id, a.name
HAVING COALESCE(SUM(b.quantity), 0) > 5;

-- Average Quantity Per Order

SELECT
    a.product_id,
    a.name as product_name,
    COALESCE(AVG(b.quantity), 0) as avg_quantity_per_order
FROM products as a
LEFT JOIN orders as b
    ON a.product_id = b.product_id
GROUP BY a.product_id, a.name;


-- Customer Who Ordered the Most Items
SELECT
    a.customer_id,
    a.name as customer_name,
    SUM(b.quantity) as total_items_orders
FROM customers as a
JOIN orders as b
    ON a.customer_id = b.customer_id
GROUP BY a.customer_id, a.name
ORDER BY SUM(b.quantity) DESC;


SELECT
    a.customer_id,
    a.name as customer_name,
    * as orders_information
FROM customers as a
WHERE a.customer_id = 3
JOIN orders as b
    ON a.customer_id = b.customer_id;