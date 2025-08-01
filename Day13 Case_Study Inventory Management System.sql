/* Case Study: Inventory Management System with Advanced SQL Features1. IntroductionThis case study explores the application of Advanced Queries, Functions, Joins, Stored Procedures, and Transactions in an Inventory Management System for an e-commerce company, TechGadgets Inc.Business ProblemTechGadgets Inc. needs an efficient database system to:Track product inventory levels.Calculate discounts dynamically.Generate sales reports.Ensure data consistency during bulk updates.2. User StoriesAs a Sales Manager, I want to view total sales per product category to analyze performance.As a Warehouse Supervisor, I need to check low-stock items to initiate restocking.As a Customer Support Agent, I need to fetch order details with customer information for issue resolution.As a Database Administrator, I need to ensure atomicity when updating stock levels during bulk orders.*//* Database SchemaTables:Products (ProductID, ProductName, CategoryID, Price, StockQuantity)Categories (CategoryID, CategoryName)Orders (OrderID, CustomerID, OrderDate, TotalAmount)OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, UnitPrice)Customers (CustomerID, CustomerName, Email, Phone) */use CollegeDB;-- Categories Table
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL
);

-- Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    CategoryID INT,
    Price DECIMAL(10, 2),
    StockQuantity INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Customers Table
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15)
);

-- Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- OrderDetails Table
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);


-- Insert values in Categories
INSERT INTO Categories VALUES
(1, 'Smartphones'),
(2, 'Laptops'),
(3, 'Smartwatches'),
(4, 'Headphones'),
(5, 'Tablets');


--Insert values in Products
INSERT INTO Products VALUES
(101, 'Redmi Note 13', 1, 12999.00, 45),
(102, 'Realme Narzo 60', 1, 15999.00, 30),
(201, 'HP Pavilion 15', 2, 62999.00, 12),
(202, 'Dell Inspiron 14', 2, 58999.00, 8),
(301, 'boAt Xtend Smartwatch', 3, 2799.00, 25),
(401, 'Sony WH-CH520', 4, 4499.00, 15),
(501, 'Samsung Galaxy Tab A9+', 5, 18999.00, 10);

-- Insert into Customers
INSERT INTO Customers VALUES
(1, 'Ankur Sharma', 'ankur.sharma@gmail.com', '9876543210'),
(2, 'Ms Dhoni', 'ms.dhoni@yahoo.com', '9823056789'),
(3, 'Suresh Raina', 'suresh.raina@outlook.com', '9784567890'),
(4, 'Vikash Dubey', 'vikash.dubey@gmail.com', '9812233445'),
(5, 'Kanishk Gautam', 'kanishk.gautam@gmail.com', '9871200456');


--Insert into orders
INSERT INTO Orders VALUES
(1001, 1, '2025-07-28', 12999.00),
(1002, 2, '2025-07-29', 18999.00),
(1003, 3, '2025-07-30', 15898.00),
(1004, 4, '2025-07-30', 62999.00);

-- Insert into Orderdetails
INSERT INTO OrderDetails VALUES
(1, 1001, 101, 1, 12999.00),  
(2, 1002, 501, 1, 18999.00),  
(3, 1003, 102, 1, 15999.00),  
(4, 1003, 401, 1, 4499.00),   
(5, 1004, 201, 1, 62999.00);  


--As a Sales Manager, I want to view total sales per product category to analyze performance.
SELECT 
    c.CategoryName,
    SUM(od.Quantity * od.UnitPrice) AS TotalSales
FROM 
    OrderDetails od
JOIN 
    Products p ON od.ProductID = p.ProductID
JOIN 
    Categories c ON p.CategoryID = c.CategoryID
GROUP BY 
    c.CategoryName;


-- As a Warehouse Supervisor, I need to check low-stock items to initiate restocking.
SELECT 
    ProductID, ProductName, StockQuantity
FROM 
    Products
WHERE 
    StockQuantity <= 10;

-- As a Customer Support Agent, I need to fetch order details with customer information for issue resolution.

SELECT 
    o.OrderID,
    o.OrderDate,
    c.CustomerName,
    c.Phone,
    p.ProductName,
    od.Quantity,
    od.UnitPrice,
    od.Quantity * od.UnitPrice AS TotalLineAmount
FROM 
    Orders o
JOIN 
    Customers c ON o.CustomerID = c.CustomerID
JOIN 
    OrderDetails od ON o.OrderID = od.OrderID
JOIN 
    Products p ON od.ProductID = p.ProductID;


-- As a Database Administrator, I need to ensure atomicity when updating stock levels during bulk orders.

BEGIN TRANSACTION;

BEGIN TRY
    -- Deduct stock for Product 101
    UPDATE Products
    SET StockQuantity = StockQuantity - 2
    WHERE ProductID = 101;

    -- Deduct stock for Product 202
    UPDATE Products
    SET StockQuantity = StockQuantity - 1
    WHERE ProductID = 202;

    COMMIT TRANSACTION;
    PRINT 'Stock updated successfully.';

    -- Display updated stock
    SELECT ProductID, ProductName, StockQuantity
    FROM Products
    WHERE ProductID IN (101, 202);
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Transaction failed. Rolled back.';
END CATCH;

-- Cutomer order history
SELECT c.CustomerName, o.OrderDate, p.ProductName, od.Quantity
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID = od.OrderID
INNER JOIN Products p ON od.ProductID = p.ProductID;

-- Function for discount
alter function GetDiscountedPrice(@price decimal(10, 2), @discount decimal(5, 2))
RETURNS DECIMAL (10, 2)
AS
BEGIN
RETURN @price * (1 - @discount / 100)
END

SELECT dbo.GetDiscountedPrice(1000, 10)
SELECT *,  DBO.GetDiscountedPrice(Price, 10) as DiscountedPrice from Products;



-- Create a procedure deducts the stalks 
CREATE PROCEDURE sp_PlaceOrder
    @CustomerID INT,
    @ProductID INT,
    @Quantity INT
AS
BEGIN
    DECLARE @OrderID INT, @UnitPrice DECIMAL(10,2), @TotalAmount DECIMAL(10,2), @Stock INT;

    -- Check stock first
    SELECT @Stock = StockQuantity, @UnitPrice = Price FROM Products WHERE ProductID = @ProductID;

    IF @Stock < @Quantity
    BEGIN
        PRINT 'Insufficient stock. Order not processed.';
        RETURN;
    END

    SET @TotalAmount = @Quantity * @UnitPrice;

    BEGIN TRANSACTION;

    BEGIN TRY
        -- Generate new OrderID
        SELECT @OrderID = ISNULL(MAX(OrderID), 1000) + 1 FROM Orders;

        -- Insert into Orders
        INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
        VALUES (@OrderID, @CustomerID, GETDATE(), @TotalAmount);

        -- Insert into OrderDetails
        INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity, UnitPrice)
        VALUES (
            (SELECT ISNULL(MAX(OrderDetailID), 0) + 1 FROM OrderDetails),
            @OrderID, @ProductID, @Quantity, @UnitPrice
        );

        -- Deduct stock
        UPDATE Products
        SET StockQuantity = StockQuantity - @Quantity
        WHERE ProductID = @ProductID;

        COMMIT TRANSACTION;
        PRINT 'Order placed successfully.';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Order failed. Rolled back.';
    END CATCH;
END;


EXEC sp_PlaceOrder @CustomerID = 3, @ProductID = 202, @Quantity = 2;


-- View for Sales Manager to analyze total sales per category
CREATE VIEW vw_TotalSalesPerCategory AS
SELECT 
    C.CategoryName,
    SUM(OD.Quantity * OD.UnitPrice) AS TotalSales
FROM 
    OrderDetails OD
    INNER JOIN Products P ON OD.ProductID = P.ProductID
    INNER JOIN Categories C ON P.CategoryID = C.CategoryID
GROUP BY 
    C.CategoryName;

