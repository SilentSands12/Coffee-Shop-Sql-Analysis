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


-- 2nd wave of data
-- Add more customers (skip IDs, auto-increment handles them)
INSERT INTO customers (name, email) VALUES
    ('Ethan', 'ethan@mail.com'),
    ('Fiona', 'fiona@mail.com'),
    ('George', 'george@mail.com'),
    ('Hannah', 'hannah@mail.com'),
    ('Ian', 'ian@mail.com'),
    ('Julia', 'julia@mail.com');
    ('Sandra', 'sandra.lopez@gmail.com');

-- Add more products
INSERT INTO products (name, category, price) VALUES
    ('Mocha', 'Coffee', 4.25),
    ('Black Tea', 'Tea', 2.75),
    ('Croissant', 'Snack', 2.00),
    ('Muffin', 'Snack', 2.50)
    ('Cheese Danish', 'Snack', 3.50);


-- Add more orders
INSERT INTO orders (customer_id, product_id, quantity, order_date) VALUES
    (1, 7, 2, '2026-03-06'),
    (2, 8, 1, '2026-03-06'),
    (3, 9, 2, '2026-03-06'),
    (4, 10, 1, '2026-03-07'),
    (5, 1, 2, '2026-03-07'),
    (6, 2, 3, '2026-03-07'),
    (7, 3, 1, '2026-03-08'),
    (8, 4, 2, '2026-03-08'),
    (9, 5, 1, '2026-03-08'),
    (10, 6, 2, '2026-03-09'),
    (1, 7, 1, '2026-03-09'),
    (2, 8, 2, '2026-03-10'),
    (3, 9, 3, '2026-03-10'),
    (4, 10, 1, '2026-03-10'),
    (5, 1, 2, '2026-03-11'),
    (6, 2, 1, '2026-03-11'),
    (7, 3, 2, '2026-03-11'),
    (8, 4, 1, '2026-03-12'),
    (9, 5, 2, '2026-03-12'),
    (10, 6, 3, '2026-03-12'),
    (2, 5, 5, '2026-02-12'),
    (7, 1, 1, '2025-08-12');