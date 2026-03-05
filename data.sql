-- data.sql: sample coffee shop data

-- Customers added 4 customers
INSERT INTO customers (name, email) VALUES
('Alice', 'alice@mail.com'),
('Bob', 'bob@mail.com'),
('Charlie', 'charlie@mail.com'),
('Diana', 'diana@mail.com');

-- Products added 6 products from coffee shop inventory
INSERT INTO products (name, category, price) VALUES
('Espresso', 'Coffee', 3.50),
('Latte', 'Coffee', 4.50),
('Cappuccino', 'Coffee', 4.00),
('Americano', 'Coffee', 3.00),
('Green Tea', 'Tea', 2.50),
('Chai Latte', 'Tea', 3.75);

-- Orders added 10 orders
INSERT INTO orders (customer_id, product_id, quantity, order_date) VALUES
(1, 1, 2, '2026-03-01'),
(2, 2, 1, '2026-03-01'),
(3, 3, 3, '2026-03-02'),
(1, 4, 1, '2026-03-02'),
(4, 5, 2, '2026-03-03'),
(2, 6, 1, '2026-03-03'),
(3, 1, 1, '2026-03-04'),
(4, 2, 2, '2026-03-04'),
(1, 3, 1, '2026-03-05'),
(2, 4, 2, '2026-03-05');