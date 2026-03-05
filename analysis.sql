-- Sample queries to look over data

SELECT *, DATE_FORMAT(order_date, '%m/%d/%Y') AS order_date2
FROM orders;

SELECT count(*) from orders;