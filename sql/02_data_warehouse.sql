USE RetailSales;


-- =============================================
-- 02. DATA WAREHOUSE - STAR SCHEMA
-- =============================================

-- Struktur:
-- DimDate
-- DimCustomer
-- DimProduct
-- DimPayment
-- FactSales


-- 1. Membuat DimDate
CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY,
    FullDate DATE,
    DayNumber INT,
    MonthNumber INT,
    MonthName VARCHAR(20),
    QuarterNumber INT,
    YearNumber INT
);


-- 2. Mengisi DimDate dari TransactionDate
INSERT INTO DimDate (
    DateKey,
    FullDate,
    DayNumber,
    MonthNumber,
    MonthName,
    QuarterNumber,
    YearNumber
)
SELECT DISTINCT
    CONVERT(INT, CONVERT(VARCHAR(8), TransactionDate, 112)) AS DateKey,
    TransactionDate AS FullDate,
    DAY(TransactionDate) AS DayNumber,
    MONTH(TransactionDate) AS MonthNumber,
    DATENAME(MONTH, TransactionDate) AS MonthName,
    DATEPART(QUARTER, TransactionDate) AS QuarterNumber,
    YEAR(TransactionDate) AS YearNumber
FROM dbo.Sales;


-- 3. Mengecek Data DimDate
SELECT TOP 10 *
FROM DimDate
ORDER BY FullDate;


-- 4. Mengecek Jumlah Data DimDate
SELECT
    COUNT(*) AS Total_Dates,
    MIN(FullDate) AS Start_Date,
    MAX(FullDate) AS End_Date
FROM DimDate;


-- 5. Membuat DimCustomer
CREATE TABLE DimCustomer (
    CustomerKey INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID VARCHAR(50)
);


-- 6. Mengisi DimCustomer
INSERT INTO DimCustomer (
    CustomerID
)
SELECT DISTINCT
    CustomerID
FROM dbo.Sales;


-- 7. Mengecek DimCustomer
SELECT *
FROM DimCustomer
ORDER BY CustomerKey;


-- 8. Membuat DimProduct
CREATE TABLE DimProduct (
    ProductKey INT IDENTITY(1,1) PRIMARY KEY,
    Item VARCHAR(100),
    Category VARCHAR(100)
);


-- 9. Mengisi DimProduct
INSERT INTO DimProduct (
    Item,
    Category
)
SELECT DISTINCT
    Item,
    Category
FROM dbo.Sales;


-- 10. Mengecek Data DimProduct
SELECT *
FROM DimProduct
ORDER BY ProductKey;


-- 11. Mengecek Jumlah Data DimProduct
SELECT
    COUNT(*) AS Total_Products
FROM DimProduct;


-- 12. Membuat DimPayment
CREATE TABLE DimPayment (
    PaymentKey INT IDENTITY(1,1) PRIMARY KEY,
    PaymentMethod VARCHAR(50),
    Location VARCHAR(50)
);


-- 13. Mengisi DimPayment
INSERT INTO DimPayment (
    PaymentMethod,
    Location
)
SELECT DISTINCT
    PaymentMethod,
    Location
FROM dbo.Sales;


-- 14. Mengecek DimPayment
SELECT *
FROM DimPayment
ORDER BY PaymentKey;


-- 15. Membuat FactSales
CREATE TABLE FactSales (
    SalesKey INT IDENTITY(1,1) PRIMARY KEY,
    TransactionID VARCHAR(50),
    DateKey INT,
    CustomerKey INT,
    ProductKey INT,
    PaymentKey INT,
    PricePerUnit DECIMAL(10,2),
    Quantity DECIMAL(10,2),
    TotalSpent DECIMAL(10,2),
    DiscountApplied VARCHAR(10)
);


-- 16. Mengisi FactSales
INSERT INTO FactSales (
    TransactionID,
    DateKey,
    CustomerKey,
    ProductKey,
    PaymentKey,
    PricePerUnit,
    Quantity,
    TotalSpent,
    DiscountApplied
)
SELECT
    S.TransactionID,
    D.DateKey,
    C.CustomerKey,
    P.ProductKey,
    PY.PaymentKey,
    S.PricePerUnit,
    S.Quantity,
    S.TotalSpent,
    S.DiscountApplied
FROM dbo.Sales AS S
INNER JOIN DimDate AS D
    ON S.TransactionDate = D.FullDate
INNER JOIN DimCustomer AS C
    ON S.CustomerID = C.CustomerID
INNER JOIN DimProduct AS P
    ON S.Item = P.Item
    AND S.Category = P.Category
INNER JOIN DimPayment AS PY
    ON S.PaymentMethod = PY.PaymentMethod
    AND S.Location = PY.Location;


-- 17. Mengecek Jumlah Data FactSales
SELECT
    COUNT(*) AS Total_Transactions,
    SUM(TotalSpent) AS Total_Sales,
    AVG(TotalSpent) AS Average_Transaction
FROM FactSales;


-- 18. Validasi Sales per Category dari Star Schema
SELECT
    P.Category,
    COUNT(*) AS Total_Transactions,
    SUM(F.TotalSpent) AS Total_Sales,
    AVG(F.TotalSpent) AS Average_Transaction
FROM FactSales AS F
INNER JOIN DimProduct AS P
    ON F.ProductKey = P.ProductKey
GROUP BY P.Category
ORDER BY Total_Sales DESC;


-- 19. Validasi Sales per Customer dari Star Schema
SELECT
    C.CustomerID,
    COUNT(*) AS Total_Transactions,
    SUM(F.TotalSpent) AS Total_Sales,
    AVG(F.TotalSpent) AS Average_Transaction
FROM FactSales AS F
INNER JOIN DimCustomer AS C
    ON F.CustomerKey = C.CustomerKey
GROUP BY C.CustomerID
ORDER BY Total_Sales DESC;


-- 20. Validasi Sales per Metode Pembayaran dan Lokasi dari Star Schema
SELECT
    P.PaymentMethod,
    P.Location,
    COUNT(*) AS Total_Transactions,
    SUM(F.TotalSpent) AS Total_Sales
FROM FactSales AS F
INNER JOIN DimPayment AS P
    ON F.PaymentKey = P.PaymentKey
GROUP BY
    P.PaymentMethod,
    P.Location
ORDER BY
    P.PaymentMethod,
    P.Location;


-- 21. Validasi Sales per Tahun dari Star Schema
SELECT
    D.YearNumber AS Transaction_Year,
    COUNT(*) AS Total_Transactions,
    SUM(F.TotalSpent) AS Total_Sales,
    AVG(F.TotalSpent) AS Average_Transaction
FROM FactSales AS F
INNER JOIN DimDate AS D
    ON F.DateKey = D.DateKey
GROUP BY D.YearNumber
ORDER BY D.YearNumber;
