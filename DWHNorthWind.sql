-- Crear la base de datos para el Data Warehouse
CREATE DATABASE DWHNorthwindOrders;
GO

USE DWHNorthwindOrders;
GO

-- DimCustomers
CREATE TABLE DimCustomers (
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID NVARCHAR(5) UNIQUE NOT NULL,
    CompanyName NVARCHAR(50) NOT NULL,
    ContactName NVARCHAR(50),
    ContactTitle NVARCHAR(50),
    Country NVARCHAR(50),
    City NVARCHAR(50),
    Region NVARCHAR(50),
    PostalCode NVARCHAR(20),
    Phone NVARCHAR(20)
);

-- DimEmployees
CREATE TABLE DimEmployees (
    EmployeeKey INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT UNIQUE NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Title NVARCHAR(50),
    BirthDate DATE,
    HireDate DATE,
    Country NVARCHAR(50),
    City NVARCHAR(50),
    Region NVARCHAR(50)
);

-- DimShippers
CREATE TABLE DimShippers (
    ShipperKey INT IDENTITY(1,1) PRIMARY KEY,
    ShipperID INT UNIQUE NOT NULL,
    CompanyName NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20)
);

-- DimCategory
CREATE TABLE DimCategory (
    CategoryKey INT IDENTITY(1,1) PRIMARY KEY,
    CategoryID INT UNIQUE NOT NULL,
    CategoryName NVARCHAR(50) NOT NULL,
    Description NVARCHAR(MAX)
);

-- DimProducts
CREATE TABLE DimProducts (
    ProductKey INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT UNIQUE NOT NULL,
    ProductName NVARCHAR(50) NOT NULL,
    CategoryKey INT NOT NULL,
    QuantityPerUnit NVARCHAR(50),
    UnitPrice DECIMAL(10,2),
    UnitsInStock INT,
    UnitsOnOrder INT,
    ReorderLevel INT,
    Discontinued BIT,
    FOREIGN KEY (CategoryKey) REFERENCES DimCategory(CategoryKey)
);

-- DimDates
CREATE TABLE DimDates (
    DateKey INT PRIMARY KEY, -- Formato YYYYMMDD
    FullDate DATE NOT NULL,
    Year INT NOT NULL,
    Month INT NOT NULL,
    Day INT NOT NULL,
    Quarter INT NOT NULL,
    DayOfWeek INT NOT NULL,
    WeekOfYear INT NOT NULL,
    MonthName NVARCHAR(20) NOT NULL,
    QuarterName NVARCHAR(20) NOT NULL
);

-- FactVentas
CREATE TABLE FactVentas (
    VentaKey INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT NOT NULL,
    OrderDateKey INT NOT NULL,
    CustomerKey INT NOT NULL,
    EmployeeKey INT NOT NULL,
    ShipperKey INT NOT NULL,
    ProductKey INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    Discount FLOAT NOT NULL,
    TotalVenta AS (Quantity * UnitPrice * (1 - Discount)) PERSISTED,
    FOREIGN KEY (OrderDateKey) REFERENCES DimDates(DateKey),
    FOREIGN KEY (CustomerKey) REFERENCES DimCustomers(CustomerKey),
    FOREIGN KEY (EmployeeKey) REFERENCES DimEmployees(EmployeeKey),
    FOREIGN KEY (ShipperKey) REFERENCES DimShippers(ShipperKey),
    FOREIGN KEY (ProductKey) REFERENCES DimProducts(ProductKey)
);

-- Índices para mejorar la performance
CREATE INDEX IX_FactVentas_CustomerKey ON FactVentas(CustomerKey);
CREATE INDEX IX_FactVentas_EmployeeKey ON FactVentas(EmployeeKey);
CREATE INDEX IX_FactVentas_ShipperKey ON FactVentas(ShipperKey);
CREATE INDEX IX_FactVentas_ProductKey ON FactVentas(ProductKey);
CREATE INDEX IX_FactVentas_OrderDateKey ON FactVentas(OrderDateKey);
