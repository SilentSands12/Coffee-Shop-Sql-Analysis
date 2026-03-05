-- Create the database if it doesn't exist
CREATE DATABASE IF NOT EXISTS coffee_shop;

-- Switch to the database
USE coffee_shop;

-- Now create your tables
-- Customer table showing 3 columns PK customer_id
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    email VARCHAR(100)
);

-- prodcuts table showing 4 columns PK product_id
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50),
    category VARCHAR(50),
    price DECIMAL(5,2)
);

-- orders table showing 5 columns PK order_id wtih FK customer_id & product_id
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
