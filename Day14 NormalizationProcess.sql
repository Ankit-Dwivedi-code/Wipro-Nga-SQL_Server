---- retail order processing system
CREATE DATABASE RetailOrderSystem;

USE RetailOrderSystem;

CREATE SCHEMA retail;

DROP TABLE DenormalizedOrders

CREATE TABLE DenormalizedOrders (    order_id INT,    order_date DATE,    customer_id INT,    customer_name NVARCHAR(100),    customer_email NVARCHAR(100),    customer_phone NVARCHAR(20),    customer_address NVARCHAR(200),    item_id INT,    product_id INT,    product_name NVARCHAR(100),    category_id INT,    category_name NVARCHAR(50),    quantity INT,    unit_price DECIMAL(10,2),    subtotal DECIMAL(10,2));

SELECT * FROM DenormalizedOrders;

-- Inserting values 
INSERT INTO DenormalizedOrders VALUES
(1001, '2023-02-25', 501, 'John Hopkins', 'John@demo.com', '9922110054', '123ABC street', 1, 'Wireless Headphones', 5, 'Electronics', 1, 1500, 1500);

INSERT INTO DenormalizedOrders VALUES(1001, '2023-01-15', 501, 'John Smith', 'john@example.com', '555-0101',  '123 Main St, Anytown', 1, 101, 'Wireless Headphones', 5, 'Electronics', 2, 59.99, 119.98),(1001, '2023-01-15', 501, 'John Smith', 'john@example.com', '555-0101',  '123 Main St, Anytown', 2, 203, 'Coffee Mug', 12, 'Kitchenware', 1, 12.50, 12.50),(1002, '2023-01-16', 502, 'Sarah Johnson', 'sarah@example.com', '555-0102',  '456 Oak Ave, Somewhere', 1, 105, 'Bluetooth Speaker', 5, 'Electronics', 1, 89.99, 89.99),(1003, '2023-01-17', 501, 'John Smith', 'john@example.com', '555-0101',  '123 Main St, Anytown', 1, 203, 'Coffee Mug', 12, 'Kitchenware', 3, 12.50, 37.50);


--1. Customer information repeated for eachorders and items
--2. Product information repeated for each order
--3. Caegory inforamtion is repeated for each products
--4. Subtotal is calcualted field( voilated 1NF)
--5. Difficult to maintain chnaging a prodcut name requires mulitiple updates




CREATE TABLE Orders_1NF (    order_id INT,    order_date DATE,    customer_id INT,    customer_name NVARCHAR(100),    customer_email NVARCHAR(100),    customer_phone NVARCHAR(20),    customer_address NVARCHAR(200),    item_id INT,    product_id INT,    product_name NVARCHAR(100),    category_id INT,    category_name NVARCHAR(50),    quantity INT,    unit_price DECIMAL(10,2),    PRIMARY KEY (order_id, item_id) -- Composite key);-- Insert data (excluding subtotal)INSERT INTO Orders_1NFSELECT order_id, order_date, customer_id, customer_name, customer_email,        customer_phone, customer_address, item_id, product_id, product_name,        category_id, category_name, quantity, unit_priceFROM DenormalizedOrders;-- 2nf -- It should be in 1 NF-- All non key atributes full dependent on the entire primary key-- Creating tables for entities-- Customer Table-- Customers tableCREATE TABLE Customers (    customer_id INT PRIMARY KEY,    customer_name NVARCHAR(100) NOT NULL,    email NVARCHAR(100),    phone NVARCHAR(20),    address NVARCHAR(200));-- Categories TableCREATE TABLE Categories (    category_id INT PRIMARY KEY,    category_name NVARCHAR(50) NOT NULL);-- Products TableCREATE TABLE Products (    product_id INT PRIMARY KEY,    product_name NVARCHAR(100) NOT NULL,    category_id INT FOREIGN KEY REFERENCES Categories(category_id),    unit_price DECIMAL(10,2));-- Order TableCREATE TABLE Orders (    order_id INT PRIMARY KEY,    order_date DATE NOT NULL,    customer_id INT FOREIGN KEY REFERENCES Customers(customer_id));-- Order item tableCREATE TABLE OrderItems (    order_id INT,    item_id INT,    product_id INT FOREIGN KEY REFERENCES Products(product_id),    quantity INT NOT NULL,    PRIMARY KEY (order_id, item_id));-- Inserting values in above tableINSERT INTO CustomersSELECT DISTINCT customer_id, customer_name, customer_email,                 customer_phone, customer_addressFROM Orders_1NF;
INSERT INTO CategoriesSELECT DISTINCT category_id, category_nameFROM Orders_1NF;
INSERT INTO ProductsSELECT DISTINCT product_id, product_name, category_id, unit_priceFROM Orders_1NF;
INSERT INTO OrdersSELECT DISTINCT order_id, order_date, customer_idFROM Orders_1NF;
INSERT INTO OrderItemsSELECT order_id, item_id, product_id, quantityFROM Orders_1NF;-- Displayng the detailsSELECT * FROM Customers;SELECT * FROM CategoriesSELECT * FROM OrdersSELECT * FROM ProductsSELECT * FROM OrderItems

 -- for converting above table into 3NF 
 -- they should be in 2NF
 -- No transitive dpendencies)

 -- Create table for Product inventory 
 -- Create table for Customer Status 