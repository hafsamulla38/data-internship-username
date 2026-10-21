# Day08_Advaanced SQL
USE shopping_database;
SHOW TABLES;

# JOIN (join customers and orders)
SELECT customers.name,
       orders.order_id,
       orders.order_amount
FROM customers
INNER JOIN orders
ON customers.customer_id = orders.customer_id;

# INNER JOIN with Product Information
SELECT orders.order_id,
       products.product_name,
       products.price,
       orders.quantity
FROM orders
INNER JOIN products
ON orders.product_id = products.product_id;

# Join all three tables (customer, products, order)
SELECT customers.name,
       orders.order_id,
       products.product_name,
       orders.quantity,
       orders.order_amount
FROM customers
INNER JOIN orders
ON customers.customer_id = orders.customer_id
INNER JOIN products
ON orders.product_id = products.product_id;

# creating simple LEFT JOIN
SELECT customers.name,
       orders.order_id,
       orders.order_amount
FROM customers
LEFT JOIN orders
ON customers.customer_id = orders.customer_id;

# See why LEFT JOIN is different, To really understand LEFT JOIN, let's create a situation where a customer doesn't have an order.
# First, add one new customer:
INSERT INTO customers (customer_id, name, city, age, email)
VALUES (6, 'Neha', 'Kolhapur', 24, 'neha@gmail.com');

# for checking the new values
SELECT *
FROM customers;   # But Neha doesn't have any order in the orders table.

# Now run our LEFT JOIN again:
SELECT customers.name,
       orders.order_id,
       orders.order_amount
FROM customers
LEFT JOIN orders
ON customers.customer_id = orders.customer_id;

# Find customers who have no orders
SELECT customers.name
FROM customers
LEFT JOIN orders
ON customers.customer_id = orders.customer_id
WHERE orders.order_id IS NULL;

# Find the most expensive product using a Subquery
# 1) Find the highest price:
SELECT MAX(price)
FROM products;
# 2) Now find the product whose price is ₹55,000.
SELECT product_name, price
FROM products
WHERE price = (
    SELECT MAX(price)
    FROM products
);
# 3) Find products more expensive than the average price
SELECT AVG(price)
FROM products;
# Now instead of manually entering 13360, we'll use a subquery.
SELECT product_name, price
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products
);
# 4) Find customers whose order amount is above the average order amount
# First, the inner query calculates the average order amount:
SELECT AVG(order_amount)
FROM orders;
# Now use it inside the outer query:
SELECT order_id, customer_id, order_amount
FROM orders
WHERE order_amount > (
    SELECT AVG(order_amount)
    FROM orders
);

# CTE
# 1) Create a CTE for high-value orders
SELECT *
FROM orders
WHERE order_amount > 5000;
# Now using CTE
WITH high_value_orders AS (
    SELECT *
    FROM orders
    WHERE order_amount > 5000
)
SELECT *
FROM high_value_orders;

# 2) CTE to calculate total sales
WITH sales_data AS (
    SELECT SUM(order_amount) AS total_sales
    FROM orders
)
SELECT *
FROM sales_data;

# 3) CTE with GROUP BY
WITH product_sales AS (
    SELECT product_id,
           SUM(quantity) AS total_quantity
    FROM orders
    GROUP BY product_id
)
SELECT *
FROM product_sales;

#  DENSE()
# 1) Basic query
SELECT order_id,
       customer_id,
       order_amount,
       DENSE_RANK() OVER (ORDER BY order_amount DESC) AS order_rank
FROM orders;

# 2) Now let's compare all three
SELECT order_id,
       order_amount,
       ROW_NUMBER() OVER (ORDER BY order_amount DESC) AS rownumber,
       RANK() OVER (ORDER BY order_amount DESC) AS rank_number,
       DENSE_RANK() OVER (ORDER BY order_amount DESC) AS dense_rank_number
FROM orders;

# LAG()
# 1) Let's practice with your orders table
SELECT *
FROM orders;

# 2) Now let's see the previous order amount.
SELECT order_id,
       order_amount,
       LAG(order_amount) OVER (ORDER BY order_id) AS previous_amount
FROM orders;

# 3) Now let's calculate the difference between the current order and previous order.
SELECT order_id,
       order_amount,
       LAG(order_amount) OVER (ORDER BY order_id) AS previous_amount,
       order_amount - LAG(order_amount) OVER (ORDER BY order_id) AS difference
FROM orders;

# LEAD()
# 1) Practice with  orders table
SELECT order_id,
       order_amount,
       LEAD(order_amount) OVER (ORDER BY order_id) AS next_amount
FROM orders;

# 2) Calculate the difference with the next row
SELECT order_id,
       order_amount,
       LEAD(order_amount) OVER (ORDER BY order_id) AS next_amount,
       LEAD(order_amount) OVER (ORDER BY order_id) - order_amount AS difference
FROM orders;

# 5) Get 2 rows ahead
SELECT order_id,
       order_amount,
       LEAD(order_amount, 2) OVER (ORDER BY order_id) AS amount_two_rows_ahead
FROM orders;