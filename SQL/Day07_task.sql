CREATE DATABASE shopping_database;

# Use the Database
USE shopping_database;

# create the customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50),
    city VARCHAR(50),
    age INT,
    email VARCHAR(100)
);
# Insert cutomers Data
INSERT INTO customers (customer_id, name, city, age, email)
VALUES
(1, 'Rahul', 'Pune', 25, 'rahul@gmail.com'),
(2, 'Priya', 'Mumbai', 28, 'priya@gmail.com'),
(3, 'Aman', 'Delhi', 22, 'aman@gmail.com'),
(4, 'Sneha', 'Pune', 30, 'sneha@gmail.com'),
(5, 'Riya', 'Mumbai', 25, 'riya@gmail.com');

# Check Our Customer Data
SELECT * FROM customers;

# Create the products Table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

# Insert Product Data
INSERT INTO products (product_id, product_name, category, price)
VALUES
(101, 'Laptop', 'Electronics', 55000),
(102, 'Mouse', 'Electronics', 800),
(103, 'Keyboard', 'Electronics', 1500),
(104, 'Headphones', 'Electronics', 2500),
(105, 'Office Chair', 'Furniture', 7000);

# Check product data
SELECT * FROM products;

# Create the orders Table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

# Insert Order Data
INSERT INTO orders (order_id, customer_id, product_id, quantity, order_amount)
VALUES
(1001, 1, 101, 1, 55000),
(1002, 2, 102, 2, 1600),
(1003, 3, 105, 1, 7000),
(1004, 4, 104, 2, 5000),
(1005, 5, 103, 3, 4500);

# Now check the inserted data
SELECT * FROM orders;

# 20 Queries for Practice

# 1) Find all customers
SELECT * FROM customers;

# 2) Find customers from Pune
SELECT *
FROM customers
WHERE city = 'Pune';

# 3) Find customers older than 25
SELECT *
FROM customers
WHERE age > 25;

# 4) Find customers from Mumbai
SELECT *
FROM customers
WHERE city = 'Mumbai';

# 5) Find customers with age exactly 25
SELECT *
FROM customers
WHERE age = 25;

# 6) Sort customers by age
SELECT *
FROM customers
ORDER BY age ASC;

# 7) Display only unique cities
SELECT DISTINCT city
FROM customers;

# 8) Find all products
SELECT *
FROM products;

# 9) Find products costing more than ₹2,000
SELECT *
FROM products
WHERE price > 2000;

# 10) Find the most expensive product
SELECT *
FROM products
ORDER BY price DESC
LIMIT 1;

# 11) Find the cheapest product
SELECT *
FROM products
ORDER BY price ASC
LIMIT 1;

# 12) Find all orders
SELECT *
FROM orders;

# 13) Find orders above ₹5,000
SELECT *
FROM orders
WHERE order_amount > 5000;

# 14) Find orders below ₹5,000
SELECT *
FROM orders
WHERE order_amount < 5000;

# 15) Calculate total sales
SELECT SUM(order_amount) AS total_sales
FROM orders;

# 16) Calculate average order value
SELECT AVG(order_amount) AS average_order_value
FROM orders;

# 17) Count customers by city
SELECT city, COUNT(*) AS customer_count
FROM customers
GROUP BY city;

# 18) Find cities having more than 1 customer
SELECT city, COUNT(*) AS customer_count
FROM customers
GROUP BY city
HAVING COUNT(*) > 1;

# 19) Calculate total quantity sold for each product
SELECT product_id, SUM(quantity) AS total_quantity
FROM orders
GROUP BY product_id;

# 20) Classify orders using CASE
SELECT order_id, order_amount,
       CASE
           WHEN order_amount >= 10000 THEN 'High'
           WHEN order_amount >= 5000 THEN 'Medium'
           ELSE 'Low'
       END AS order_category
FROM orders;
