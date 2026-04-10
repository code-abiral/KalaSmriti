-- KalaSmriti E-Commerce Database Schema
-- This script creates all tables for the KalaSmriti mobile e-commerce application
-- Compatible with both SQL Server and LocalDB

-- For LocalDB: Just run this script after connecting to the database
-- For SQL Server: Uncomment the lines below
/*
USE master;
GO

IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'KalaSmritiDB')
BEGIN
    CREATE DATABASE KalaSmritiDB;
END
GO

USE KalaSmritiDB;
GO
*/

-- Table: Customer
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Customer]') AND type in (N'U'))
BEGIN
    CREATE TABLE Customer (
        CustomerID INT PRIMARY KEY IDENTITY(1,1),
        FirstName NVARCHAR(50) NOT NULL,
        LastName NVARCHAR(50) NOT NULL,
        Email NVARCHAR(100) NOT NULL UNIQUE,
        Password NVARCHAR(255) NOT NULL,
        Phone NVARCHAR(20),
        Address NVARCHAR(255),
        City NVARCHAR(50),
        State NVARCHAR(50),
        ZipCode NVARCHAR(10),
        Country NVARCHAR(50) DEFAULT 'Nepal',
        IsAdmin BIT DEFAULT 0,
        CreatedDate DATETIME DEFAULT GETDATE(),
        LastLogin DATETIME
    );
END
GO

-- Table: Category
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Category]') AND type in (N'U'))
BEGIN
    CREATE TABLE Category (
        CategoryID INT PRIMARY KEY IDENTITY(1,1),
        CategoryName NVARCHAR(100) NOT NULL,
        Description NVARCHAR(MAX),
        ImageUrl NVARCHAR(255),
        IsActive BIT DEFAULT 1,
        CreatedDate DATETIME DEFAULT GETDATE()
    );
END
GO

-- Table: Product
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Product]') AND type in (N'U'))
BEGIN
    CREATE TABLE Product (
        ProductID INT PRIMARY KEY IDENTITY(1,1),
        ProductName NVARCHAR(200) NOT NULL,
        Description NVARCHAR(MAX),
        Price DECIMAL(10,2) NOT NULL,
        DiscountPrice DECIMAL(10,2),
        CategoryID INT NOT NULL,
        StockQuantity INT NOT NULL DEFAULT 0,
        ImageUrl NVARCHAR(255),
        Image2Url NVARCHAR(255),
        Image3Url NVARCHAR(255),
        IsActive BIT DEFAULT 1,
        IsFeatured BIT DEFAULT 0,
        CreatedDate DATETIME DEFAULT GETDATE(),
        ModifiedDate DATETIME,
        CONSTRAINT FK_Product_Category FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
    );
END
GO

-- Table: Order
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Order]') AND type in (N'U'))
BEGIN
    CREATE TABLE [Order] (
        OrderID INT PRIMARY KEY IDENTITY(1,1),
        CustomerID INT NOT NULL,
        OrderDate DATETIME DEFAULT GETDATE(),
        TotalAmount DECIMAL(10,2) NOT NULL,
        OrderStatus NVARCHAR(50) DEFAULT 'Pending',
        PaymentStatus NVARCHAR(50) DEFAULT 'Pending',
        ShippingAddress NVARCHAR(255),
        ShippingCity NVARCHAR(50),
        ShippingState NVARCHAR(50),
        ShippingZipCode NVARCHAR(10),
        ShippingCountry NVARCHAR(50),
        TrackingNumber NVARCHAR(100),
        DeliveryDate DATETIME,
        Notes NVARCHAR(MAX),
        CONSTRAINT FK_Order_Customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
    );
END
GO

-- Table: Order_Item
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Order_Item]') AND type in (N'U'))
BEGIN
    CREATE TABLE Order_Item (
        OrderItemID INT PRIMARY KEY IDENTITY(1,1),
        OrderID INT NOT NULL,
        ProductID INT NOT NULL,
        Quantity INT NOT NULL,
        UnitPrice DECIMAL(10,2) NOT NULL,
        TotalPrice DECIMAL(10,2) NOT NULL,
        CONSTRAINT FK_OrderItem_Order FOREIGN KEY (OrderID) REFERENCES [Order](OrderID),
        CONSTRAINT FK_OrderItem_Product FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
    );
END
GO

-- Table: Cart
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cart]') AND type in (N'U'))
BEGIN
    CREATE TABLE Cart (
        CartID INT PRIMARY KEY IDENTITY(1,1),
        CustomerID INT NOT NULL,
        ProductID INT NOT NULL,
        Quantity INT NOT NULL DEFAULT 1,
        AddedDate DATETIME DEFAULT GETDATE(),
        CONSTRAINT FK_Cart_Customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
        CONSTRAINT FK_Cart_Product FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
    );
END
GO

-- Table: Review
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Review]') AND type in (N'U'))
BEGIN
    CREATE TABLE Review (
        ReviewID INT PRIMARY KEY IDENTITY(1,1),
        ProductID INT NOT NULL,
        CustomerID INT NOT NULL,
        Rating INT NOT NULL CHECK (Rating >= 1 AND Rating <= 5),
        ReviewText NVARCHAR(MAX),
        ReviewDate DATETIME DEFAULT GETDATE(),
        IsApproved BIT DEFAULT 1,
        CONSTRAINT FK_Review_Product FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
        CONSTRAINT FK_Review_Customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
    );
END
GO

-- Table: Payment
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payment]') AND type in (N'U'))
BEGIN
    CREATE TABLE Payment (
        PaymentID INT PRIMARY KEY IDENTITY(1,1),
        OrderID INT NOT NULL,
        PaymentMethod NVARCHAR(50) NOT NULL,
        PaymentAmount DECIMAL(10,2) NOT NULL,
        PaymentDate DATETIME DEFAULT GETDATE(),
        PaymentStatus NVARCHAR(50) DEFAULT 'Pending',
        TransactionID NVARCHAR(100),
        CONSTRAINT FK_Payment_Order FOREIGN KEY (OrderID) REFERENCES [Order](OrderID)
    );
END
GO

-- Table: Notification
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Notification]') AND type in (N'U'))
BEGIN
    CREATE TABLE Notification (
        NotificationID INT PRIMARY KEY IDENTITY(1,1),
        CustomerID INT NOT NULL,
        Title NVARCHAR(150) NOT NULL,
        Message NVARCHAR(MAX) NOT NULL,
        IsRead BIT NOT NULL DEFAULT 0,
        CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_Notification_Customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
    );
END
GO

-- Table: OrderFeedback (transaction level feedback)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OrderFeedback]') AND type in (N'U'))
BEGIN
    CREATE TABLE OrderFeedback (
        OrderFeedbackID INT PRIMARY KEY IDENTITY(1,1),
        OrderID INT NOT NULL,
        CustomerID INT NOT NULL,
        Rating INT NOT NULL CHECK (Rating >= 1 AND Rating <= 5),
        FeedbackText NVARCHAR(MAX),
        FeedbackDate DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_OrderFeedback_Order FOREIGN KEY (OrderID) REFERENCES [Order](OrderID),
        CONSTRAINT FK_OrderFeedback_Customer FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
        CONSTRAINT UQ_OrderFeedback_OrderCustomer UNIQUE (OrderID, CustomerID)
    );
END
GO

-- Insert Sample Categories
INSERT INTO Category (CategoryName, Description, ImageUrl) VALUES
('Traditional Paintings', 'Authentic handmade paintings showcasing local art and culture', '/Images/categories/paintings.jpg'),
('Sculptures', 'Hand-carved sculptures and statues made from wood and stone', '/Images/categories/sculptures.jpg'),
('Pottery & Ceramics', 'Traditional pottery and ceramic products', '/Images/categories/pottery.jpg'),
('Textiles & Fabrics', 'Handwoven textiles, carpets, and traditional fabrics', '/Images/categories/textiles.jpg'),
('Jewelry', 'Traditional handmade jewelry with cultural significance', '/Images/categories/jewelry.jpg'),
('Wood Crafts', 'Intricately carved wooden artifacts and decorative items', '/Images/categories/woodcraft.jpg');
GO

-- Insert Sample Admin User (Password: Admin@123)
INSERT INTO Customer (FirstName, LastName, Email, Password, Phone, IsAdmin, Address, City, State, ZipCode, Country) VALUES
('Admin', 'User', 'admin@kalasmriti.com', 'Admin@123', '9841234567', 1, 'Thamel', 'Kathmandu', 'Bagmati', '44600', 'Nepal');
GO

-- Insert Sample Customer (Password: User@123)
INSERT INTO Customer (FirstName, LastName, Email, Password, Phone, IsAdmin, Address, City, State, ZipCode, Country) VALUES
('Bibhab', 'Sharma', 'bibhab@gmail.com', 'User@123', '9851234567', 0, 'Patan', 'Lalitpur', 'Bagmati', '44700', 'Nepal');
GO

-- Insert Sample Products
INSERT INTO Product (ProductName, Description, Price, DiscountPrice, CategoryID, StockQuantity, ImageUrl, IsFeatured) VALUES
('Mandala Thangka Painting', 'Authentic Buddhist mandala painting on cotton canvas, hand-painted by skilled artisans. Size: 24x24 inches', 15000.00, 12000.00, 1, 5, '/Images/products/mandala1.jpg', 1),
('Ganesha Wooden Sculpture', 'Hand-carved Ganesha statue made from Sal wood, height 12 inches', 8500.00, NULL, 2, 10, '/Images/products/ganesha1.jpg', 1),
('Traditional Clay Pot Set', 'Set of 3 handmade clay pots with traditional designs', 2500.00, 2000.00, 3, 20, '/Images/products/claypot1.jpg', 0),
('Pashmina Shawl', 'Pure pashmina shawl with intricate embroidery, size: 80x28 inches', 12000.00, 10000.00, 4, 15, '/Images/products/shawl1.jpg', 1),
('Silver Filigree Necklace', 'Traditional Nepali silver necklace with filigree work', 6500.00, NULL, 5, 8, '/Images/products/necklace1.jpg', 0),
('Carved Wooden Window Frame', 'Antique style wooden window frame with traditional motifs', 18000.00, 15000.00, 6, 3, '/Images/products/window1.jpg', 1),
('Buddha Statue Bronze', 'Meditation Buddha statue in bronze finish, height 8 inches', 5500.00, 4500.00, 2, 12, '/Images/products/buddha1.jpg', 0),
('Dhaka Fabric', 'Traditional Dhaka fabric roll, 5 meters, handwoven', 3500.00, 3000.00, 4, 25, '/Images/products/dhaka1.jpg', 0);
GO

PRINT 'Database schema created successfully!';
GO

