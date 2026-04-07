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

-- **************************** 3/18/26 ***************************
-- How many times each product was ordered
-- Removed AS for table alias for cleaner code and used better alias such as
-- p for products, o for orders, and c for customers tables

SELECT
    p.product_id,
    p.name AS product_name,
    COALESCE(COUNT(o.order_id), 0) AS total_orders
FROM products p
LEFT JOIN orders o
    ON p.product_id = o.product_id
GROUP BY p.product_id, p.name;

-- Products With More Than 5 Items Ordered
-- But only show products where total quantity ordered is greater than 5.
-- Removed coalesce inside having clause because nulls will not exist
-- because of joins

SELECT
    p.product_id,
    p.name AS product_name,
    COALESCE(SUM(o.quantity), 0) AS total_quantity
FROM products p
JOIN orders o
    ON p.product_id = o.product_id
GROUP BY p.product_id, p.name
HAVING SUM(o.quantity) > 5;

-- Average Quantity Per Order

SELECT
    p.product_id,
    p.name AS product_name,
    COALESCE(AVG(o.quantity), 0) AS avg_quantity_per_order
FROM products p
LEFT JOIN orders o
    ON p.product_id = o.product_id
GROUP BY p.product_id, p.name;


-- Customer Who Ordered the Most Items
-- Used alias on ORDER BY clause since it happens towards the end of
-- execution order (after select)

SELECT
    c.customer_id,
    c.name AS customer_name,
    SUM(o.quantity) AS total_items_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_items_orders DESC;

-- 3️⃣ Advanced SQL / Functions
-- Write a query that adds a calculated column total_price for each order\
-- (quantity * price) and orders by highest total_price.
-- Removed using Select * and used explicit columns instead (better duplicate
-- handling)

SELECT
    o.order_id,
    o.quantity,
    p.price,
    p.name,
    (o.quantity * p.price) AS total_price
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
ORDER BY total_price DESC;


-- Use a date function to return the month and year of each order instead
-- of the full date. USED ANSI specific functions instead of MYSQL

SELECT
    order_id,
    EXTRACT(YEAR FROM order_date) AS order_year,
    EXTRACT(MONTH FROM order_date) AS order_month,
    date_format(order_date, '%m/%d/%Y') as formatted_date -- extra work
FROM orders;



-- Write a query that concatenates the customer’s name with the product
-- name for all orders in the format: "Alice - Espresso".

SELECT
    o.order_id,
    c.name AS customer_name, -- for confirmation purposes
    p.name AS product_name, -- for confirmation purposes
    CONCAT(c.name, ' - ', p.name) AS customer_with_product_name
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN products p
    ON p.product_id = o.product_id
ORDER BY o.order_id;

/* Write a query that calculates the total amount each customer has spent
(quantity * price), and return:

customer_id

customer_name

total_spent

👉 Only return the top 3 customers who spent the most.
*/
-- Fixed readability
SELECT
    c.customer_id,
    c.name AS customer_name,
    SUM(o.quantity * p.price) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN products p
    ON p.product_id = o.product_id
GROUP BY
    c.customer_id,
    c.name
ORDER BY
    total_spent DESC
LIMIT 3;


/* Write a query that returns the total revenue per month, including:

year

month

total_revenue (quantity * price)

👉 Order results by year, then month
*/

-- Fixed readability and used explicit table aliases in group by clause
SELECT
    EXTRACT(YEAR FROM order_date) AS order_year,
    EXTRACT(MONTH FROM order_date) AS order_month,
    SUM(quantity * price) as total_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY
    EXTRACT(YEAR FROM o.order_date),
    EXTRACT(MONTH FROM o.order_date)
ORDER BY
    order_year,
    order_month;





/*
🔥 Bonus Challenge (if you want to push to 9/10)

Try this after:

👉 Return the top-selling product per month

year

month

product_name

total_quantity_sold
*/

-- LEARNED about common table expressions and how to efficiently use
-- with subqueries


WITH product_totals AS (
    SELECT
        EXTRACT(YEAR FROM o.order_date) AS order_year,
        EXTRACT(MONTH FROM o.order_date) AS order_month,
        p.name AS product_name,
        SUM(o.quantity) AS total_quantity_sold
    FROM orders o
    JOIN products p
        ON o.product_id = p.product_id
    GROUP BY
        p.name,
        EXTRACT(YEAR FROM o.order_date),
        EXTRACT(MONTH FROM o.order_date)
)
SELECT 
    pt.order_year,
    pt.order_month,
    pt.product_name,
    pt.total_quantity_sold
FROM product_totals pt
WHERE total_quantity_sold = (
    SELECT MAX(total_quantity_sold)
    FROM product_totals
    WHERE order_year = pt.order_year
      AND order_month = pt.order_month
)
ORDER BY
    pt.order_year,
    pt.order_month;


-- **************************** 4/7/26 ***************************
-- 4️⃣  SQL Joins in Depth
-- Write a query that adds a calculated column total_price for each order\
-- (quantity * price) and orders by highest total_price.


/*☕ 1. Basic INNER JOIN (foundation)

👉 Real-world: “Show me what customers are buying”

Write a query to return:

customer name
product name
quantity
order date

Only include rows where a valid order exists.


*/
-- Capitalized AS keyword for consistency


SELECT
    c.name AS customer_name,
    p.name AS product_name,
    o.quantity,
    p.price,
    (p.price * o.quantity) AS total_price,
    date_format(o.order_date, '%m/%d/%y') AS order_date
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
JOIN customers c
    ON o.customer_id = c.customer_id
ORDER BY total_price DESC;


/*☕ 2. Filtering with JOIN (slightly harder)

👉 Real-world: “What coffee items are selling?”

Return:

customer name
product name
category
quantity

BUT only for products in the 'Coffee' category.
Sort by quantity descending.

*/
-- Removed LOWER() function because of query performance
-- Instead used like or = operator for increased speeds

SELECT
    c.name AS customer_name,
    p.name AS product_name,
    p.category,
    o.quantity
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
JOIN customers c
    ON o.customer_id = c.customer_id
WHERE
    p.category LIKE 'coffee'
ORDER BY
    o.quantity DESC;


/*☕ 3. LEFT JOIN (important concept)

👉 Real-world: “Who hasn't bought anything yet?”

Return all customers, including:

customers with orders
customers with NO orders

Output:

customer name
order_id (if exists, otherwise NULL)

*/


-- No improvements needed

SELECT
    c.name AS customer_name,
    o.order_id
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id;


/*☕ 4. Multi-table JOIN + Aggregation (real job level)

👉 Real-world: “How much money are we making per product?”

Return:

product name
total quantity sold
total revenue

👉 Revenue = quantity * price

Sort from highest revenue to lowest.

*/


-- Used qualified column name aka column reference instead of column alias for
-- consistency and fewer DB issues

SELECT
    p.name AS product_name,
    SUM(o.quantity) AS total_quantity_sold,
    SUM(o.quantity * p.price) AS total_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY
    p.name
ORDER BY
    total_revenue DESC;


/*
☕ 5. Advanced JOIN Scenario (challenging but realistic)

👉 Real-world: “Top customer spending report”

Return:

customer name
total number of orders
total amount spent

BUT:

Only include customers who spent more than $20 total
Sort by total spent descending
🔥 Bonus (optional, but very good for interviews)

👉 Real-world: “Find customers who bought the same product multiple times”

Return:

customer name
product name
total times they ordered it

Only show results where they ordered the same product more than once.
*/


-- Removed customer id column from select since we only need it on GROUP BY
-- ALSO did the same for product_id since its better to group by that primary key


SELECT
    c.name AS customer_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.quantity * p.price) AS total_amount_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN products p
    ON o.product_id = p.product_id
GROUP BY
    c.customer_id, c.name
HAVING
    SUM(o.quantity * p.price) > 20
ORDER BY
    total_amount_spent DESC;


SELECT
    c.name AS customer_name,
    p.name AS product_name,
    COUNT(o.product_id) AS total_times_ordered_item
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN products p
    ON o.product_id = p.product_id
GROUP BY
    c.customer_id, c.name, p.product_id, p.name
HAVING
    COUNT(o.product_id) > 1;