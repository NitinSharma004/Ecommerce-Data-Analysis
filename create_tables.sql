-- CREATE A TABLES--


--CUSTOMERS --
CREATE TABLE customers (
customer_id INT PRIMARY KEY,
name TEXT,
email TEXT,
city TEXT
);

-- PRODUCTS --
CREATE TABLE products(
product_id INT PRIMARY KEY,
name TEXT,
price INT
);

--DELIVERY_AGENTS --
CREATE TABLE delivery_agents(
agent_id INT PRIMARY KEY,
name TEXT,
contact_number TEXT
);

--ORDERS --
CREATE TABLE orders(
order_id INT PRIMARY KEY,
customer_id INT REFERENCES customers(customer_id),
order_date DATE,
status TEXT
);

-- ORDER_ITEMS --
CREATE TABLE order_items(
item_id INT PRIMARY KEY,
order_id INT REFERENCES orders(order_id),
product_id INT REFERENCES products(product_id),
quantity INT,
price INT
);

-- DELIVERIES --
CREATE TABLE deliveries (
    delivery_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    agent_id INT REFERENCES delivery_agents(agent_id),
    delivery_date DATE,
    delivery_status TEXT
);

--DELIVERY_STATUS_LOG --
CREATE TABLE delivery_status_log (
    log_id INT PRIMARY KEY,
    delivery_id INT REFERENCES deliveries(delivery_id),
    status TEXT
);

--RETURNS --
CREATE TABLE returns (
    return_id INT PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    return_date DATE,
    reason TEXT
);





