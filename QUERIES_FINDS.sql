
--Q1.Top Selling products ? --
SELECT p.name AS product_name,
       SUM(oi.quantity) AS total_quantity_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.name
ORDER BY total_quantity_sold DESC
LIMIT 5;


--Q2. Find total revenue by months ? --
SELECT 
  TO_CHAR(o.order_date, 'YYYY-MM') AS order_month,
  SUM(oi.quantity * oi.price) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY TO_CHAR(o.order_date, 'YYYY-MM')
ORDER BY order_month;


--Q3. Find total revenue in a year?--
SELECT 
  EXTRACT(YEAR FROM o.order_date) AS order_year,
  SUM(oi.quantity * oi.price) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY EXTRACT(YEAR FROM o.order_date)
ORDER BY order_year;

--Q4 If particular year revenue niaklna ho like as 2024 ka nikalna ? (tab hum WHERE condition laga ke answer niakl te hai) --
SELECT 
  EXTRACT(YEAR FROM o.order_date) AS order_year,
  SUM(oi.quantity * oi.price) AS total_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE EXTRACT(YEAR FROM o.order_date) = 2024
GROUP BY EXTRACT(YEAR FROM o.order_date)
ORDER BY order_year;


--Q5. How I check the dupicate record in the delivery_status_log ? --
SELECT delivery_id, status,
COUNT(*)
FROM delivery_status_log
GROUP BY delivery_id, status
HAVING COUNT(*) > 1;

--Q6. How I delete the dupicate record in the delivery_status_log ? --
DELETE 
FROM delivery_status_log
WHERE log_id NOT IN (
SELECT MIN(log_id)
FROM delivery_status_log
GROUP BY delivery_id, status 
);


--Q7. Find order delivered in last 30 days ? days like(20 din phele, one year before)  --
SELECT o.order_id, c.name, d.delivery_date, d.delivery_status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN deliveries d ON o.order_id = d.order_id
WHERE d.delivery_status = 'Delivered'
  AND d.delivery_date >= CURRENT_DATE - INTERVAL '30 days';


--Q8. Find the customer who have not received any delivery for their order ? --
SELECT DISTINCT c.customer_id, c.name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
LEFT JOIN deliveries d ON o.order_id = d.order_id
WHERE d.order_id IS NULL;


--Q9. Customers who returned order with their customers name ? --
SELECT DISTINCT c.name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN returns r ON o.order_id = r.order_id;


--Q10. Find the customer who have the highest number returned items ? --
SELECT c.customer_id, c.name,
COUNT(r.return_id) AS total_returns
FROM returns r
JOIN orders o ON r.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_returns DESC;


--Q11. Find the total number returned order? --
SELECT COUNT(DISTINCT order_id) AS total_returned_orders
FROM returns;

--Q12.return order with common reason why return ? --
SELECT reason, COUNT(*) AS reason_count
FROM returns
GROUP BY reason
ORDER BY reason_count DESC
LIMIT 1;


--Q13. List an order where delivered late? (and how many days late orders)--
SELECT o.order_id, c.customer_id, c.name, o.order_date, d.delivery_status,
 d.delivery_date - o.order_date AS days_late
FROM orders o
JOIN deliveries d ON o.order_id = d.order_id
JOIN customers c ON o.customer_id=c.customer_id
WHERE d.delivery_status ='Delayed';


--Q14. List an order where delivered late and delivered after the promised date of order ?--
-- THIS CODE NOT RUN BECAUSE IN MY DATASET HAVE NO PROMISED DATE BUT I USED THIS CODE FOR KNOWLEDGE --
SELECT 
  o.order_id, 
  c.name AS customer_name, 
  o.promised_delivery_date, 
  d.delivery_date, 
  d.delivery_status,
  d.delivery_date - o.promised_delivery_date AS days_late
FROM orders o
JOIN deliveries d ON o.order_id = d.order_id
JOIN customers c ON o.customer_id = c.customer_id
WHERE d.delivery_status = 'Delivered'
  AND d.delivery_date > o.promised_delivery_date;


--Q15. Find the customesr who have placed more than 2 orders ? --
SELECT c.customer_id, c.name,
COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) > 2;


--Q16. Which agent delivered the most orrder? --
SELECT da.name,
COUNT(d.order_id) AS most_delivered_agent
FROM deliveries d 
JOIN Delivery_agents da ON d.agent_id = da.agent_id
WHERE d.delivery_status='Delivered'
GROUP BY da.name
ORDER BY most_delivered_agent DESC
LIMIT 1;


--Q17. Most expensive product with name? --
SELECT product_id, price, name
FROM products
ORDER BY price DESC
LIMIT 1;


--Q18. Find all orders placed by customer from Mumabi ? --
SELECT o.order_id,c.name, c.city, o.status
FROM customers AS c
JOIN orders o ON c.customer_id = o.customer_id
WHERE c.city= 'Mumbai';


--Q19. Most expensive order items with name ? --
SELECT p.name AS product_name, oi.price
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE oi.price = (
  SELECT MAX(price)
  FROM order_items
);


--Q20. List customers who have never placed order ? --
SELECT c.name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


--Q21. List all orders that have no delivery assigned yet ? --
SELECT o.order_id, c.customer_id, c.name, o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
LEFT JOIN deliveries d ON o.order_id = d.order_id
WHERE d.order_id IS NULL;


--Q22. Find monthly returns and deliveries compare  ? --
SELECT 
  TO_CHAR(d.delivery_date, 'YYYY-MM') AS month,
  COUNT(DISTINCT d.delivery_id) AS total_deliveries,
  COUNT(DISTINCT r.return_id) AS total_returns
FROM deliveries d
LEFT JOIN orders o ON d.order_id = o.order_id
LEFT JOIN returns r ON o.order_id = r.order_id
GROUP BY TO_CHAR(d.delivery_date, 'YYYY-MM')
ORDER BY month;
 



