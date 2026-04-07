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

-- Find the total number of orders per customer, but only show customers
-- who have more than 2 orders.
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

-- 3️⃣ Advanced SQL / Functions
-- Write a query that adds a calculated column total_price for each order\
-- (quantity * price) and orders by highest total_price.

SELECT
    *,
    (o.quantity * p.price) AS total_price
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
ORDER BY total_price DESC;


-- Use a date function to return the month and year of each order instead
-- of the full date.

SELECT
    order_id,
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
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

SELECT
    c.customer_id,
    c.name AS customer_name,
    SUM(o.quantity * p.price) AS total_spent
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN products p
    ON p.product_id = o.product_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC
LIMIT 3;


/* Write a query that returns the total revenue per month, including:

year

month

total_revenue (quantity * price)

👉 Order results by year, then month
*/


SELECT
    EXTRACT(YEAR FROM order_date) AS order_year,
    EXTRACT(MONTH FROM order_date) AS order_month,
    SUM(quantity * price) as total_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
ORDER BY order_year, order_month;





/*
🔥 Bonus Challenge (if you want to push to 9/10)

Try this after:

👉 Return the top-selling product per month

year

month

product_name

total_quantity_sold
*/

WITH product_totals AS (
    SELECT
        EXTRACT(YEAR FROM o.order_date) AS order_year,
        EXTRACT(MONTH FROM o.order_date) AS order_month,
        p.name AS product_name,
        SUM(o.quantity * p.price) AS product_total
    FROM orders o
    JOIN products p
        ON o.product_id = p.product_id
    GROUP BY
        p.name,
        EXTRACT(YEAR FROM o.order_date),
        EXTRACT(MONTH FROM o.order_date)
)
SELECT *
FROM product_totals pt
WHERE product_total = (
    SELECT MAX(product_total)
    FROM product_totals
    WHERE order_year = pt.order_year
      AND order_month = pt.order_month
);


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

SELECT
    c.name as customer_name,
    p.name as product_name,
    o.quantity,
    p.price,
    (p.price * o.quantity) as total_price,
    date_format(o.order_date, '%m/%d/%y') as order_date
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
    LOWER(p.category) = 'coffee'
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




SELECT
    p.name AS product_name,
    SUM(o.quantity) AS total_quantity_sold,
    SUM(o.quantity * p.price) AS total_revenue
FROM orders o
JOIN products p
    ON o.product_id = p.product_id
GROUP BY
    product_name
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

SELECT
    c.customer_id,
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
    c.customer_id,
    c.name AS customer_name,
    p.name AS product_name,
    COUNT(o.product_id) AS total_times_ordered_item
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN products p
    ON o.product_id = p.product_id
GROUP BY
    c.customer_id, c.name, p.name
HAVING
    COUNT(o.product_id) > 1;
