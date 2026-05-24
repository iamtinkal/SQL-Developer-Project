-- Author: Tinkal Singh | Batch: CG-0904-46 | Tool: MySQL 

-- create the database MoreRetail (has retail chain over pan india with 900+ stores)
CREATE DATABASE MoreRetail;

-- Use the database
USE MoreRetail;

-- Phase 1: Schema Design: Create the Schema for MoreRetail Ecommerce store

-- create the table inside the MoreRetail DB (8 tables)


-- Table 1 : Catgeories: Stores all category informartion

CREATE TABLE categories (
	category_id   
	INT PRIMARY KEY AUTO_INCREMENT, -- primary key and auto increment when new records added
	category_name VARCHAR(100) NOT NULL UNIQUE,
	description   
	VARCHAR(255));
    
    
-- Table 2: Products: stores the informartion of products/SKU's used in MoreRetail stores    

CREATE TABLE products (
	product_id   INT PRIMARY KEY AUTO_INCREMENT, -- PK
	product_name VARCHAR(150) NOT NULL,
	category_id  INT,
	price        
	DECIMAL(10,2) NOT NULL CHECK (price > 0), -- check constrains(make sure price shoudl be >0)
	stock_qty    
	INT DEFAULT 0,
	supplier     
	VARCHAR(100),
	FOREIGN KEY (category_id) REFERENCES categories(category_id));     -- FK (link the category id with the pk from categories table) used to link between both the tables (products and categories)

-- Table 3: customers: stores all information of the customers, 

CREATE TABLE customers (
	customer_id INT PRIMARY KEY AUTO_INCREMENT, -- pk
	first_name  VARCHAR(50) NOT NULL,
	last_name   
	VARCHAR(50) NOT NULL,
	email       
	VARCHAR(100) UNIQUE NOT NULL,
	phone       
	VARCHAR(15), -- used varchar because int is used for calculation, varchar is perfect
	city        
	VARCHAR(50),
	country     
	VARCHAR(50) DEFAULT 'India',
	joined_date DATE,
	is_active   
	TINYINT(1) DEFAULT 1); -- to store 1 byte character
    
    
 -- Table 4: employees, store the information of the employees working in the MoreRetail   

CREATE TABLE employees (
	employee_id INT PRIMARY KEY AUTO_INCREMENT, -- PK
	first_name  VARCHAR(50) NOT NULL,
	last_name   
	VARCHAR(50) NOT NULL,
	department  VARCHAR(50),
	salary      
	DECIMAL(10,2),
	manager_id  INT,
	hire_date   
	DATE,
	FOREIGN KEY (manager_id) REFERENCES employees(employee_id)); -- link manager id with employee id
    
-- Table 5: orders table: to store each and every orders received in the MoreRetail
    
CREATE TABLE orders (
	order_id      
	INT PRIMARY KEY AUTO_INCREMENT,
	customer_id   
	INT NOT NULL,
	employee_id   
	INT, -- employee_id who manage this order
	order_date    
	DATETIME DEFAULT CURRENT_TIMESTAMP,
	total_amount  DECIMAL(10,2),
	status        
	VARCHAR(20) DEFAULT 'Pending'
	CHECK (status IN ('Pending','Processing','Shipped','Delivered','Cancelled')),
	shipping_city VARCHAR(50),
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id), -- link customer_id from customers table
	FOREIGN KEY (employee_id) REFERENCES employees(employee_id)); -- link employee id with employee table
	
-- Table 6: order_items, detail of each sku's ordered
	
CREATE TABLE order_items (
	item_id    
	INT PRIMARY KEY AUTO_INCREMENT,
	order_id   INT NOT NULL,
	product_id INT NOT NULL,
	quantity   INT NOT NULL CHECK (quantity > 0),
	unit_price DECIMAL(10,2) NOT NULL,
	FOREIGN KEY (order_id)   REFERENCES orders(order_id), 
	FOREIGN KEY (product_id) REFERENCES products(product_id),
	UNIQUE (order_id, product_id)); -- make sure order_id and product_id combination is unique in this table;		
	
-- Table 7: payments details, for each and every order received
	
CREATE TABLE payments (
	payment_id     
	INT PRIMARY KEY AUTO_INCREMENT,
	order_id       
	INT NOT NULL UNIQUE,
	payment_date   DATETIME DEFAULT CURRENT_TIMESTAMP,
	amount         
	DECIMAL(10,2) NOT NULL,
	method  VARCHAR(30) CHECK (method IN ('UPI','Credit Card','Debit Card','Net Banking', 'COD')),
    payment_status VARCHAR(20) DEFAULT 'Pending',
	FOREIGN KEY (order_id) REFERENCES orders(order_id));
   
-- Table 8: reviews details
   
CREATE TABLE reviews (
	review_id   
	INT PRIMARY KEY AUTO_INCREMENT,
	product_id  INT NOT NULL,
	customer_id INT NOT NULL,
	rating      
	TINYINT CHECK (rating BETWEEN 1 AND 5),
	review_text VARCHAR(500),
	review_date DATE,
	FOREIGN KEY (product_id)  REFERENCES products(product_id),
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id)) ;   
    
-- *******************************************************************************************************************************

-- Phase 2: Data Insertion: Insert Sample data inside all the tables:

INSERT INTO categories VALUES 
(1,'Electronics','Gadgets'),
(2,'Clothing','Apparel'),
(3,'Books','All genres'),
(4,'Home & Kitchen','Appliances'),
(5,'Sports','Equipment');


INSERT INTO products (product_name,category_id,price,stock_qty,supplier) 
VALUES
('iPhone 15',1,79999,50,'Apple India'),
('Samsung TV 55"',1,54999,20,'Samsung'),
('Nike Running Shoes',2,4999,100,'Nike'),
('Levi Jeans 501',2,2499,80,'Levi'),
('Python Crash Course',3,699,200,'No Starch'),
('SQL Server Bible',3,899,150,'Wiley'),
('Air Fryer 4L',4,3999,60,'Philips'),
('Yoga Mat',5,799,120,'Decathlon');  
    
INSERT INTO customers(first_name,last_name,email,phone,city,joined_date) 
VALUES
('Arjun','Sharma','arjun@email.com','9876543210','Delhi','2023-01-10'),
('Priya','Kapoor','priya@email.com','9876543211','Mumbai','2023-02-15'),
('Rohit','Verma','rohit@email.com','9876543212','Bangalore','2023-03-20'),
('Sneha','Mehta','sneha@email.com','9876543213','Pune','2023-04-05'),
('Amit','Gupta','amit@email.com','9876543214','Chennai','2023-05-12'),
('Kavya','Reddy','kavya@email.com','9876543215','Hyderabad','2023-06-18');   
    
INSERT INTO employees(first_name,last_name,department,salary,manager_id,hire_date) 
VALUES
('Rajesh','Kumar','Management',120000,NULL,'2020-01-01'),
('Sunita','Rao','Sales',75000,1,'2021-03-15'),
('Manoj','Pillai','Sales',65000,1,'2021-06-20'),
('Divya','Nair','Support',55000,1,'2022-01-10'),
('Kiran','Bhat','Logistics',60000,1,'2022-04-05');
    
INSERT INTO orders(customer_id,employee_id,order_date,total_amount,status,shipping_city) 
VALUES
(1,2,'2024-01-15',79999,'Delivered','Delhi'),
(2,2,'2024-01-16',4999,'Delivered','Mumbai'),
(3,3,'2024-01-18',2499,'Shipped','Bangalore'),
(1,3,'2024-02-01',699,'Delivered','Delhi'),
(4,4,'2024-02-10',54999,'Processing','Pune'),
(5,2,'2024-02-14',3999,'Pending','Chennai'),
(6,5,'2024-03-01',1598,'Delivered','Hyderabad'),
(2,4,'2024-03-10',899,'Delivered','Mumbai');


INSERT INTO order_items(order_id,product_id,quantity,unit_price) 
VALUES
(1,1,1,79999),
(2,3,1,4999),
(3,4,1,2499),
(4,5,1,699),
(5,2,1,54999),
(6,7,1,3999),
(7,6,1,899),
(7,8,1,799),
(8,6,1,899);

INSERT INTO payments(order_id,amount,method,payment_status) VALUES
(1,79999,'UPI','Completed'),
(2,4999,'Credit Card','Completed'),
(3,2499,'Debit Card','Completed'),
(4,699,'Net Banking','Completed'),
(5,54999,'COD','Pending'),
(6,3999,'UPI','Pending'),
(7,1598,'Credit Card','Completed'),
(8,899,'Net Banking','Completed');

INSERT INTO reviews(product_id,customer_id,rating,review_text,review_date) 
VALUES
(1,1,5,'Excellent phone!','2024-01-25'),
(3,2,4,'Great shoes.','2024-01-26'),
(4,3,3,'Average jeans.','2024-01-28'),
(5,1,5,'Perfect for beginners.','2024-02-10'),
(2,4,4,'Good TV.','2024-02-20'),
(7,5,4,'Love the air fryer.','2024-03-05');



-- *******************************************************************************************************************************


-- Phase 3: Query Development

-- this is the summary from orders table to get the total_orders, unique customers, total_reveue, avg_order_value, smallest and largest order in the history.
SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    SUM(total_amount) AS total_revenue,
    AVG(total_amount)  AS avg_order_value,
    MIN(total_amount) AS smallest_order,
    MAX(total_amount)  AS largest_order
FROM orders;


-- Revenue and order count per status
SELECT status, COUNT(*) AS cnt, SUM(total_amount) AS revenue
FROM orders GROUP BY status ORDER BY revenue DESC;

-- Products per category with price stats
SELECT category_name, COUNT(product_id) as products, 
ROUND(avg(price), 2) as avg_price, MIN(price) as min_pric, MAX(price) as max_price
FROM categories c JOIN products p ON c.category_id = p.category_id
GROUP BY 1; 

-- Customers who placed more than 1 order
SELECT c.customer_id, c.first_name,  COUNT(*) AS order_count
FROM orders o JOIN customers c on o.customer_id = c.customer_id
GROUP BY 1 , 2
HAVING COUNT(*) > 1;

-- Cities with total revenue above 50,000
SELECT shipping_city, SUM(total_amount) AS revenue
FROM orders WHERE status <> 'Cancelled'
GROUP BY 1 
HAVING SUM(total_amount) > 50000 
ORDER BY revenue DESC;

-- total revenue per payment method, only method with > 10000 revenue
SELECT method, SUM(total_amount) AS total_revenue from payments p JOIN orders o on p.order_id = o.order_id
GROUP BY 1
HAVING SUM(total_amount) > 10000
ORDER BY total_revenue DESC ;

-- SUBQUERIES:
-- Products more expensive than average
SELECT product_name, price FROM products
WHERE price > (SELECT AVG(price) FROM products) 
ORDER BY price DESC;

-- customers who have ordered Electronics
SELECT customer_id, first_name
FROM customers c 
WHERE customer_id IN (
SELECT distinct customer_id FROM orders o 
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Electronics');

-- joins

-- INNER JOIN

-- Orders with customer names
SELECT o.order_id, c.first_name, c.last_name, o.order_date, o.total_amount, o.status
FROM orders o INNER JOIN customers c ON o.customer_id = c.customer_id;

-- LEFT JOIN
-- ALL customers, also with no orders
SELECT c.first_name, c.city, COUNT(o.order_id) AS order_count
FROM customers c LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.city 
ORDER BY order_count DESC;

-- RIGHT JOIN
SELECT p.product_name, p.stock_qty, SUM(oi.quantity) AS total_sold
FROM order_items oi
RIGHT JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.stock_qty;

-- SELF JOIN
-- Each employee with their managers name
SELECT e.first_name AS employee, e.department, e.salary,
m.first_name AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id
ORDER BY e.employee_id;

-- CROSS JOIN
-- All category × shipping_city combinations
SELECT c.category_name, cities.shipping_city
FROM categories c
CROSS JOIN (SELECT DISTINCT shipping_city FROM orders) cities
ORDER BY 1,2;



-- CTE AND RECUSRIVE CTE

WITH customer_spending AS (
SELECT customer_id, SUM(total_amount) AS total_spent FROM orders GROUP BY customer_id
)
SELECT c.first_name, c.city, cs.total_spent
FROM customer_spending cs JOIN customers c ON cs.customer_id = c.customer_id
WHERE cs.total_spent > 5000 ORDER BY cs.total_spent DESC;


WITH
category_revenue AS (
    SELECT c.category_name, SUM(oi.quantity*oi.unit_price) AS revenue
    FROM categories c JOIN products p ON c.category_id=p.category_id
    JOIN order_items oi ON p.product_id=oi.product_id 
    GROUP BY 1
),
total_rev AS (SELECT SUM(revenue) AS grand_total FROM category_revenue)

SELECT cr.category_name, cr.revenue,
ROUND(cr.revenue*100.0/tr.grand_total, 2) AS pct_share
FROM category_revenue cr, total_rev tr 
ORDER BY cr.revenue DESC;


-- RECURSIVE CTE
WITH RECURSIVE org_chart AS (
SELECT employee_id, first_name, department, manager_id,
0 AS level, first_name AS path
FROM employees WHERE manager_id IS NULL
UNION ALL

SELECT e.employee_id, e.first_name, e.department, e.manager_id,
oc.level+1, CONCAT(oc.path,' -> ',e.first_name)
FROM employees e JOIN org_chart oc ON e.manager_id = oc.employee_id
)
SELECT level, first_name, department, path FROM org_chart ORDER BY level, first_name;



-- WINDOWS FUNCTION
-- Rank customers by total spending
SELECT c.first_name, SUM(o.total_amount) AS spent,
ROW_NUMBER() OVER (ORDER BY SUM(o.total_amount) DESC) AS row_num,
RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS rank_pos,
DENSE_RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS dense_r
FROM customers c JOIN orders o ON c.customer_id=o.customer_id
GROUP BY c.customer_id, c.first_name 
ORDER BY spent DESC;

-- Rank products by price WITHIN each category 
SELECT product_name, category_id, price,
RANK() OVER (PARTITION BY category_id ORDER BY price DESC) AS rank_in_cat
FROM products;


-- 2nd highest order value
SELECT total_amount 
FROM (
SELECT total_amount, DENSE_RANK() OVER (ORDER BY total_amount DESC) AS dr 
FROM orders
) ranked WHERE dr = 2;

-- *******************************************************************************************************************************

-- VIEWS

-- create a order summary view and use it later

CREATE VIEW order_summary AS 
SELECT o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_full_name, 
c.city, o.order_date, o.total_amount, o.status, pm.method, pm.payment_status
FROM orders o
JOIN customers c on c.customer_id = o.customer_id
LEFT JOIN payments pm on pm.order_id= o.order_id;

SELECT * FROM order_summary LIMIT 10; -- TO SEE THE VIEW

-- Use the view like a table
SELECT * FROM order_summary 
WHERE status = 'Delivered';

SELECT city, COUNT(*) FROM order_summary 
GROUP BY city;





-- *******************************************************************************************************************************


--  Phase 4: Stored Procedures/functions & Triggers

-- STORED PROCEDURE
-- Basic stored procedure
-- create delimitter as // so that begin statement has query with end with ; 
DELIMITER // 
CREATE PROCEDURE GetOrdersByCustomerID (IN p_customer_id INT)
BEGIN
    SELECT o.order_id, o.order_date, o.total_amount, o.status, p.product_name, oi.quantity
    FROM orders o 
    JOIN order_items oi ON o.order_id=oi.order_id
    JOIN products p ON oi.product_id=p.product_id
    WHERE o.customer_id = p_customer_id 
    ORDER BY o.order_date DESC;
END //
DELIMITER ; 
-- change the delimiter to ;

SHOW PROCEDURE STATUS WHERE Db = 'moreretail';

-- call the procedure
CALL GetOrdersByCustomerID(1);



-- UDF (functions)
-- function for gst calculation
DELIMITER //
CREATE FUNCTION fn_GetGST (p_price DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN ROUND(p_price * 0.18, 2);
END //
DELIMITER ;

-- use it to get gst
SELECT 
    product_name,
    price,
    fn_GetGST(price) AS gst_amount,
    price + fn_GetGST(price) AS price_with_gst
FROM products;




-- TRIGGERS 

-- Create audit log table
CREATE TABLE order_audit_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT, order_id INT,
    action VARCHAR(30), old_status VARCHAR(20), new_status VARCHAR(20),
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP);
    
-- Trigger 1 — AFTER INSERT on orders (Auto Create Payment)
DELIMITER //
CREATE TRIGGER trg_after_order_insert
AFTER INSERT ON orders FOR EACH ROW
BEGIN
    INSERT INTO payments (order_id, amount, method, payment_status)
    VALUES (NEW.order_id, NEW.total_amount, 'COD', 'Pending');
    INSERT INTO order_audit_log (order_id, action, new_status)
    VALUES (NEW.order_id, 'ORDER_CREATED', NEW.status);
END //
DELIMITER ;


-- when we insert the rows in orders table, it will automatically reflect in payments table and order_audit_log table
INSERT INTO orders(customer_id,employee_id,order_date,total_amount,status,shipping_city) 
VALUES
(1,2,'2024-01-18',60000,'Delivered','Delhi'),
(4,2,'2024-01-12',70000,'Pending','Mumbai');



-- Trigger 2 — AFTER UPDATE on orders (Audit Log)

-- craete audit_log table
CREATE TABLE IF NOT EXISTS order_audit_log_2 (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    old_status VARCHAR(20),      
    new_status VARCHAR(20),      
    changed_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- create the triger
DELIMITER //
CREATE TRIGGER trg_OrderStatusChange 
AFTER UPDATE
ON orders
FOR EACH ROW
BEGIN
 IF OLD.status <> NEW.status THEN 
	INSERT INTO order_audit_log_2 (order_id, old_status, new_status)
    VALUES (OLD.order_id, OLD.status, NEW.status);
 END IF;
END//
DELIMITER ;

-- TEST
UPDATE orders SET status = 'Delivered' WHERE order_id = 3;

SELECT * FROM order_audit_log_2;

-- Trigger 3 — BEFORE INSERT on reviews (Validate Rating)
DELIMITER //
CREATE TRIGGER trg_validate_reviews 
BEFORE INSERT ON reviews 
FOR EACH ROW
BEGIN
  IF NEW.rating <1 or NEW.rating >5 then 
  SIGNAL SQLSTATE '45000'
  SET MESSAGE_TEXT = 'RATING MUST BE BETWEEN 1 TO 5';
  END IF;
END//
DELIMITER ;

-- TEST
INSERT INTO reviews (product_id, customer_id, rating, review_text, review_date)
VALUES (1,1,8, 'EXCELENT PRODUCT', DEFAULT);



-- Trigger 4 — BEFORE UPDATE on products (Validate Price)
-- SAME AS BEFORE INSERT

DELIMITER //
CREATE TRIGGER trg_validate_price 
BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
IF NEW.price <= 0 THEN 
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT  = 'PRICE MUST BE GREATER THAN 0';
END IF;
END//
DELIMITER ;

-- TEST
UPDATE products 
SET price  = -50
WHERE product_id = 1;





-- EVENTS
SET GLOBAL event_scheduler = ON;

-- first we create a log table where data will store
CREATE TABLE event_log2 (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    activity VARCHAR(100),
    executed_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- second we create the event
DELIMITER //
CREATE EVENT evt_LogActivity
ON SCHEDULE EVERY 1 MINUTE
DO
BEGIN
    INSERT INTO event_log2 (activity)
    VALUES ('moreretail system is running fine');
END //
DELIMITER ;

-- second event (count pending orders)

DELIMITER //
CREATE EVENT evt_Check_Pending_Orders
ON SCHEDULE EVERY 1 MINUTE 
DO 
BEGIN 
DECLARE v_pending_count INT;

SELECT COUNT(*) INTO v_pending_count 
FROM orders
WHERE status = 'Pending';

INSERT INTO event_log2(activity) 
VALUES (CONCAT('Pending Orders Count: ', v_pending_count ));
END //
DELIMITER ;

-- check log table
SELECT * FROM event_log2 
ORDER BY executed_at DESC;


drop event evt_Check_Pending_Orders;




-- Phase 5: Optimization & Security 



-- INDEX


-- Non-Clustered index on FOREIGN KEY column (speeds up JOINs)
CREATE INDEX idx_orders_customer ON orders(customer_id);

-- Composite index for common filter combination
CREATE INDEX idx_orders_status_date ON orders(status, order_date);

-- Unique index
CREATE UNIQUE INDEX idx_customers_email ON customers(email);

CREATE INDEX idx_orderitems_product ON order_items(product_id);

CREATE INDEX idx_products_category ON products(category_id);

CREATE INDEX idx_payments_status ON payments(payment_status);

CREATE INDEX idx_reviews_product ON reviews(product_id);

-- to see the index in the tables
SHOW INDEX FROM orders;
SHOW INDEX FROM customers;
SHOW INDEX FROM products;
SHOW INDEX FROM order_items;
SHOW INDEX FROM payments;



-- QUERY OPTIMIZATION:

-- USE EXPLAIN TO ANALYZE QUERY:
EXPLAIN
SELECT o.order_id, c.first_name, o.total_amount, o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.status = 'Delivered';


-- slow query:
EXPLAIN SELECT * FROM orders
WHERE YEAR(order_date) = 2024;

-- fast query
EXPLAIN SELECT * FROM orders
WHERE order_date BETWEEN '2024-01-01' AND '2024-12-31';


-- BELOW ARE THE MY UNDERSTANDING FOR QUERY OPTIMIXATION:
-- 1: VERIFY EXECUTION PLAN USING EXPLAIN OR EXPLAIN ANALYZE TO SEE, QUERY IS DOING FULL SCAN OR NOT
-- 2: USE COLUMNS NAME IN SELECT QUERY INSTEAD OF SELECT *, TO AVOID LOAD IN THE DATABSE
-- 3: USE CTE AND JOINS FOR NESTED SUBQUERIES
-- 4: USE WHERE BEFORE JOIN WHENEVER POSSIBLE



-- SECURITY

-- SECURITY MEANS WHO CAN SEE WHICH TABLES:
-- EXAMPLE:
-- SALES TEAM CAN USE ONLY SELECT ORDERS
-- HR TEAMS CAN USE ONLY SELECT EMPLOYEE
-- MANAGER CAN SELECT EVERYTHING


-- STEP 1: CREATE USER
-- create read only user for reporting team:
CREATE USER 'report-user'@'localhost' IDENTIFIED BY 'Report@123';

-- create user for sales tem
CREATE USER 'sales-user'@'localhost' IDENTIFIED BY 'Sales@123';

-- create manager user
CREATE USER 'manager-user'@'localhost' IDENTIFIED BY 'Manager@123';

-- See all users created
SELECT user, host FROM mysql.user;


-- SSTEP 2: GRANT PERMISSION:

-- grant read only for all the tables in our db to report-user
GRANT SELECT ON moreretail.* TO 'report-user'@'localhost';


-- sales user: can read orders and customers only
GRANT SELECT ON moreretail.customers TO 'sales-user'@'localhost';
GRANT SELECT ON moreretail.orders TO 'sales-user'@'localhost';

-- manager user- can read everything + update the orders
GRANT SELECT ON moreretail.* TO 'manager-user'@'localhost';
GRANT UPDATE ON moreretail.orders TO 'manager-user'@'localhost';

-- Apply the grants immediately
FLUSH PRIVILEGES;


-- STEP 3: CHECK WHAT PERMISION EACH USER HAS
SHOW GRANTS FOR 'report-user'@'localhost';
SHOW GRANTS FOR 'sales-user'@'localhost';
SHOW GRANTS FOR 'manager-user'@'localhost';


-- STEP 4: REVOKE PERMISSIONS

-- STEP 4: REVOKE PERMISSION
REVOKE UPDATE ON moreretail.orders FROM 'manager-user'@'localhost';

-- STEP 5: DROP USERS 
DROP USER IF EXISTS 'report-user'@'localhost';
DROP USER IF EXISTS 'sales-user'@'localhost';
DROP USER IF EXISTS 'manager-user'@'localhost';

FLUSH PRIVILEGES;