/*

Analysis queries that were improved and made more effective in order to optimize
and minimize runtime from queries

*/

/*
1️⃣ Joins & Relationships

Write a query to return all orders, showing the customer name, product name,
quantity, and order date.

*/

-- ** Formatted clauses for visibility and removed INNER word for cleaner code **

SELECT
    b.customer_id,
    b.name as customer_name,
    c.name as product_name,
    a.quantity,
    DATE_FORMAT(a.order_date, '%m/%d/%Y') as order_date
FROM orders as a
    JOIN customers as b
        ON a.customer_id = b.customer_id
    JOIN products as c
        ON a.product_id = c.product_id;


-- Modify the query to only include orders for products in the 'Coffee' category.

-- ** Formatted clauses for visibility and added table prefix to where clause **
SELECT
    b.customer_id,
    b.name as customer_name,
    c.name as product_name,
    a.quantity,
    DATE_FORMAT(a.order_date, '%m/%d/%Y') as order_date
FROM orders as a
JOIN customers as b
    ON a.customer_id = b.customer_id
JOIN products as c
    ON a.product_id = c.product_id
WHERE c.category = 'Coffee';

-- How would you return customers who have never placed an order?

-- ** Removed GROUP BY clause since it is not safe for duplicates in
--    name column and removed HAVING clause due to removal of GROUP BY clause.
--    simplified query with a WHERE clause where order_is is NULL due to normal process
--    from left join for empty fields **

SELECT
    a.name as customer_name
FROM customers as a
LEFT JOIN orders as b
    ON a.customer_id = b.customer_id
WHERE b.order_id IS NULL;

/* Try to write a query that shows:

customer_name
total_orders
total_items_ordered

*/

-- ** Added customer_id and group by that primary key to inaccurate query results
--    from duplicate names in name column **

SELECT
a.customer_id,
a.name as customer_name,
count(b.order_id) as total_orders,
COALESCE(sum(b.quantity), 0) as total_items_ordered
FROM customers as a
LEFT JOIN orders as b
    ON a.customer_id = b.customer_id
GROUP BY a.customer_id, a.name;

/* Show the TOP 3 customers who ordered the most items

Example result:

customer	items
Ash	25
Misty	18
Gary	14

*/

-- ** Added tab space on columns for readability **

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
-- Added name column to GROUP BY clause to follow standard SQL rules across
-- DBs and SQL servers

SELECT
    a.product_id,
    a.name as product_name,
    COALESCE(SUM(b.quantity), 0) as total_quantity
FROM products as a
LEFT JOIN orders as b
    ON a.product_id = b.product_id
GROUP BY a.product_id, a.name;


-- How would you find the product that has been ordered the most in terms of quantity?
-- Added name column to GROUP BY clause to follow standard SQL rules across
-- DBs and SQL servers

SELECT
    a.name as product_name,
    COALESCE(SUM(b.quantity), 0) as total_quantity
FROM products as a
JOIN orders as b
    ON a.product_id = b.product_id
GROUP BY a.product_id, a.name
ORDER BY total_quantity DESC
LIMIT 1;

-- Find the total number of orders per customer, but only show customers who have more than 2 orders.
-- Removed alias from HAVING clause to follow cross-DB/server-environment issues

SELECT
    a.customer_id,
    a.name as customer_name,
    COUNT(b.order_id) as total_orders
FROM customers as a
JOIN orders as b
    ON a.customer_id = b.customer_id
GROUP BY a.customer_id, a.name
HAVING COUNT(b.order_id) > 2;
