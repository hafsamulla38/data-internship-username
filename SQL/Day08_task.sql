#Step 1 — Check your database and tables
USE shopping_database;
Show tables;

#Step 2 – Check the table structure
DESCRIBE customers;
DESCRIBE products;
DESCRIBE orders;

#Query 1: INNER JOIN
SELECT c.name AS customer_name,p.product_name,o.quantity,o.order_amount
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id
INNER JOIN products p
    ON o.product_id = p.product_id;
    
    #Query 2 — LEFT JOIN
    SELECT c.customer_id,c.name AS customer_name,o.order_id,
    o.order_amount
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id;
    
    #Query 3 — Find customers who have not placed any orders
SELECT
    c.customer_id,
    c.name AS customer_name
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

#Query 4 — Display customer names with their order details using INNER JOIN
SELECT c.name AS customer_name,c.city,o.order_id,
    o.order_amount
FROM customers c
INNER JOIN orders o
    ON c.customer_id = o.customer_id;
    
    #Query 5 — LEFT JOIN: Show all customers and their orders
SELECT c.customer_id,c.name AS customer_name,p.product_name,o.quantity,
    o.order_amount
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
LEFT JOIN products p
    ON o.product_id = p.product_id;
    
    #Query 6 — Find total spending of each customer
SELECT c.customer_id,c.name AS customer_name,
    COALESCE(SUM(o.order_amount), 0) AS total_spending
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spending DESC;

#Query 7 — Find customers who spent more than ₹5,000
SELECT c.customer_id,c.name AS customer_name,COALESCE(SUM(o.order_amount), 0) AS total_spending
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING SUM(o.order_amount) > 5000
ORDER BY total_spending DESC;

#Query 8 — Subquery: Find customers who spent more than the average customer spending
SELECT c.customer_id,c.name AS customer_name,
    (SELECT COALESCE(SUM(o.order_amount), 0) FROM orders o
        WHERE o.customer_id = c.customer_id
    ) AS total_spending
FROM customers c
WHERE (SELECT COALESCE(SUM(o.order_amount), 0)
    FROM orders o WHERE o.customer_id = c.customer_id
) > (
    SELECT AVG(customer_total)
    FROM (
        SELECT COALESCE(SUM(order_amount), 0) AS customer_total
        FROM orders
        GROUP BY customer_id
    ) AS spending
)
ORDER BY total_spending DESC;

#Query 9 — Subquery: Find the most expensive product
SELECT product_id,product_name,category,price
FROM products
WHERE price = (
    SELECT MAX(price)
    FROM products
);
SELECT *
FROM products
WHERE product_id IS NULL
   OR product_name IS NULL
   OR category IS NULL
   OR price IS NULL;
#Verify the products table
SELECT
    product_id,
    product_name,
    category,
    price
FROM products;
SELECT COUNT(*) AS total_products
FROM products;
SELECT *
FROM products
ORDER BY product_id;
SELECT COUNT(*) AS null_product_ids
FROM products
WHERE product_id IS NULL;

#Query 10 — Subquery: Find products priced above the average price
SELECT product_id,product_name,category,price
FROM products
WHERE price > (
    SELECT AVG(price)
    FROM products)
ORDER BY price DESC;

#Query 11 — Subquery: Find customers who placed an order above ₹5,000
SELECT customer_id,name
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
    WHERE order_amount > 5000
);

#Query 12 — CTE: Calculate total spending for each customer
WITH CustomerSpending AS (SELECT customer_id,SUM(order_amount) AS total_spending
    FROM orders GROUP BY customer_id)
SELECT c.customer_id,c.name AS customer_name,COALESCE(cs.total_spending, 0) AS total_spending
FROM customers c LEFT JOIN CustomerSpending cs ON c.customer_id = cs.customer_id
ORDER BY total_spending DESC;

#Query 13 — CTE: Find customers spending more than ₹5,000
WITH CustomerSpending AS (SELECT customer_id,SUM(order_amount) AS total_spending FROM orders
    GROUP BY customer_id)
SELECT c.customer_id,c.name AS customer_name,cs.total_spending
FROM customers c
INNER JOIN CustomerSpending cs ON c.customer_id = cs.customer_id
WHERE cs.total_spending > 5000
ORDER BY cs.total_spending DESC;

#Query 14 — ROW_NUMBER(): Give each customer a spending position
SELECT c.customer_id,c.name AS customer_name,COALESCE(SUM(o.order_amount), 0) AS total_spending,
    ROW_NUMBER() OVER (ORDER BY COALESCE(SUM(o.order_amount), 0) DESC
    ) AS row_num FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

#Query 15 — RANK(): Rank customers by spending
SELECT c.customer_id,c.name AS customer_name,
    COALESCE(SUM(o.order_amount), 0) AS total_spending,RANK() OVER (
        ORDER BY COALESCE(SUM(o.order_amount), 0) DESC
    ) AS customer_rank FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;


DESCRIBE customers;
DESCRIBE orders;

#Query 16 — DENSE_RANK(): Rank customers without gaps
SELECT c.customer_id,c.name AS customer_name,SUM(o.order_amount) AS total_spending,
    DENSE_RANK() OVER (ORDER BY SUM(o.order_amount) DESC
    ) AS spending_position
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

#Query 17 — LAG(): Compare each order with the previous order
SELECT order_id,customer_id,
    order_amount,
    LAG(order_amount) OVER (
        ORDER BY order_id
    ) AS previous_order_amount
FROM orders;
 #Query 18 — LEAD(): Get the next order amount
SELECT order_id,
    customer_id,
    order_amount,
    LEAD(order_amount) OVER (
        ORDER BY order_id
    ) AS next_order_amount
FROM orders;
#Query 19 — Top 3 customers by total spending
SELECT c.customer_id,c.name AS customer_name,
    SUM(o.order_amount) AS total_spending
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spending DESC
LIMIT 3;
#Query 20 — Top 3 products by total sales amount
SELECT p.product_id,p.product_name,p.category,SUM(o.quantity) AS total_quantity_sold,
    SUM(o.order_amount) AS total_sales
FROM products p INNER JOIN orders o
    ON p.product_id = o.product_id
GROUP BY p.product_id,p.product_name,p.category
ORDER BY total_sales DESC LIMIT 3;

DESCRIBE customers;
DESCRIBE products;
DESCRIBE orders;
#Step 3 — Create a monthly revenue practice table
CREATE TABLE monthly_revenue_practice (
    month_start DATE PRIMARY KEY,
    revenue DECIMAL(12,2)
);
#Insert sample data
INSERT INTO monthly_revenue_practice (month_start, revenue)
VALUES
('2026-01-01', 50000),
('2026-02-01', 60000),
('2026-03-01', 55000),
('2026-04-01', 75000),
('2026-05-01', 80000),
('2026-06-01', 70000);

#Qyery 21 - Calculate monthly revenue
SELECT
    MONTHNAME(month_start) AS month_name,
    revenue AS monthly_revenue
FROM monthly_revenue_practice
ORDER BY month_start;
#Query 22 - Find the previous month's revenue using LAG()
SELECT MONTHNAME(month_start) AS month_name,revenue AS current_revenue,
    LAG(revenue) OVER (
        ORDER BY month_start
    ) AS previous_month_revenue
FROM monthly_revenue_practice
ORDER BY month_start;

#Query 23 - Calculate month-over-month (MoM) growth
SELECT MONTHNAME(month_start) AS month_name,revenue AS current_revenue,
    LAG(revenue) OVER (ORDER BY month_start
    ) AS previous_month_revenue,
    ROUND((revenue - LAG(revenue) OVER (ORDER BY month_start)) * 100.0/ NULLIF(
            LAG(revenue) OVER (ORDER BY month_start), 0),2) AS mom_growth_percentage
FROM monthly_revenue_practice ORDER BY month_start;

#Employee salary ranking
CREATE TABLE employee_salary_practice (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50),
    salary DECIMAL(10,2)
);
INSERT INTO employee_salary_practice
    (employee_id, employee_name, salary)
VALUES
    (1, 'Rahul', 55000),
    (2, 'Aman', 45000),
    (3, 'Sneha', 60000),
    (4, 'Priya', 45000),
    (5, 'Riya', 35000);
    
    #Query 24 - Employee salary ranking using RANK()
    SELECT employee_id,employee_name,salary,
    RANK() OVER (ORDER BY salary DESC
    ) AS salary_rank
FROM employee_salary_practice
ORDER BY salary DESC;