USE RetailSales;


-- 1. KPI Utama
SELECT
    COUNT(*) AS Total_Transactions,
    SUM(TotalSpent) AS Total_Sales,
    AVG(TotalSpent) AS Average_Transaction
FROM dbo.Sales;


-- 2. Sales by Category
SELECT
    Category,
    COUNT(*) AS Total_Transactions,
    SUM(TotalSpent) AS Total_Sales,
    AVG(TotalSpent) AS Average_Transaction
FROM dbo.Sales
GROUP BY Category
ORDER BY Total_Sales DESC;


-- 3. Sales by Payment Method
SELECT
    PaymentMethod,
    COUNT(*) AS Total_Transactions,
    SUM(TotalSpent) AS Total_Sales,
    AVG(TotalSpent) AS Average_Transaction
FROM dbo.Sales
GROUP BY PaymentMethod
ORDER BY Total_Sales DESC;


-- 4. Sales by Location
SELECT
    Location,
    COUNT(*) AS Total_Transactions,
    SUM(TotalSpent) AS Total_Sales,
    AVG(TotalSpent) AS Average_Transaction
FROM dbo.Sales
GROUP BY Location
ORDER BY Total_Sales DESC;


-- 5. Sales by Year
SELECT
    YEAR(TransactionDate) AS Transaction_Year,
    COUNT(*) AS Total_Transactions,
    SUM(TotalSpent) AS Total_Sales,
    AVG(TotalSpent) AS Average_Transaction
FROM dbo.Sales
GROUP BY YEAR(TransactionDate)
ORDER BY Transaction_Year;


-- 6. Sales by Month
SELECT
    YEAR(TransactionDate) AS Transaction_Year,
    MONTH(TransactionDate) AS Transaction_Month,
    COUNT(*) AS Total_Transactions,
    SUM(TotalSpent) AS Total_Sales,
    AVG(TotalSpent) AS Average_Transaction
FROM dbo.Sales
GROUP BY
    YEAR(TransactionDate),
    MONTH(TransactionDate)
ORDER BY
    Transaction_Year,
    Transaction_Month;


-- 7. Top 10 Items by Sales
SELECT TOP 10
    Item,
    COUNT(*) AS Total_Transactions,
    SUM(TotalSpent) AS Total_Sales,
    SUM(Quantity) AS Total_Quantity
FROM dbo.Sales
GROUP BY Item
ORDER BY Total_Sales DESC;


-- 8. Customer Analysis
SELECT TOP 10
    CustomerID,
    COUNT(*) AS Total_Transactions,
    SUM(TotalSpent) AS Total_Sales,
    AVG(TotalSpent) AS Average_Transaction
FROM dbo.Sales
GROUP BY CustomerID
ORDER BY Total_Sales DESC;


-- 9. Sales Contribution by Category
SELECT
    Category,
    SUM(TotalSpent) AS Total_Sales,
    CAST(
        SUM(TotalSpent) * 100.0 /
        (SELECT SUM(TotalSpent) FROM dbo.Sales)
        AS DECIMAL(10,2)
    ) AS Sales_Contribution_Percentage
FROM dbo.Sales
GROUP BY Category
ORDER BY Total_Sales DESC;


-- 10. Monthly Sales Ranking
WITH MonthlySales AS (
    SELECT
        YEAR(TransactionDate) AS Transaction_Year,
        MONTH(TransactionDate) AS Transaction_Month,
        SUM(TotalSpent) AS Total_Sales
    FROM dbo.Sales
    GROUP BY
        YEAR(TransactionDate),
        MONTH(TransactionDate)
)
SELECT
    Transaction_Year,
    Transaction_Month,
    Total_Sales,
    RANK() OVER (
        ORDER BY Total_Sales DESC
    ) AS Sales_Rank
FROM MonthlySales
ORDER BY Sales_Rank;


-- 11. Customer Sales Ranking
WITH CustomerSales AS (
    SELECT
        CustomerID,
        COUNT(*) AS Total_Transactions,
        SUM(TotalSpent) AS Total_Sales,
        AVG(TotalSpent) AS Average_Transaction
    FROM dbo.Sales
    GROUP BY CustomerID
)
SELECT
    CustomerID,
    Total_Transactions,
    Total_Sales,
    Average_Transaction,
    RANK() OVER (
        ORDER BY Total_Sales DESC
    ) AS Sales_Rank
FROM CustomerSales
ORDER BY Sales_Rank;


-- 12. Top Customer per Category
WITH CustomerCategorySales AS (
    SELECT
        Category,
        CustomerID,
        SUM(TotalSpent) AS Total_Sales
    FROM dbo.Sales
    GROUP BY
        Category,
        CustomerID
),
RankedCustomer AS (
    SELECT
        Category,
        CustomerID,
        Total_Sales,
        RANK() OVER (
            PARTITION BY Category
            ORDER BY Total_Sales DESC
        ) AS Sales_Rank
    FROM CustomerCategorySales
)
SELECT
    Category,
    CustomerID,
    Total_Sales,
    Sales_Rank
FROM RankedCustomer
WHERE Sales_Rank = 1
ORDER BY Total_Sales DESC;


-- 13. Sales Performance by Discount Status
SELECT
    DiscountApplied,
    COUNT(*) AS Total_Transactions,
    SUM(TotalSpent) AS Total_Sales,
    AVG(TotalSpent) AS Average_Transaction
FROM dbo.Sales
WHERE DiscountApplied IS NOT NULL
GROUP BY DiscountApplied
ORDER BY Total_Sales DESC;


-- 14. Top 3 Item per Category
WITH ItemSales AS (
    SELECT
        Category,
        Item,
        SUM(TotalSpent) AS Total_Sales
    FROM dbo.Sales
    WHERE Item <> 'Unknown'
    GROUP BY
        Category,
        Item
),
RankedItems AS (
    SELECT
        Category,
        Item,
        Total_Sales,
        ROW_NUMBER() OVER (
            PARTITION BY Category
            ORDER BY Total_Sales DESC
        ) AS Item_Rank
    FROM ItemSales
)
SELECT
    Category,
    Item,
    Total_Sales,
    Item_Rank
FROM RankedItems
WHERE Item_Rank <= 3
ORDER BY
    Category,
    Item_Rank;


-- 15. Monthly Sales vs Previous Month
WITH MonthlySales AS (
    SELECT
        YEAR(TransactionDate) AS Transaction_Year,
        MONTH(TransactionDate) AS Transaction_Month,
        SUM(TotalSpent) AS Total_Sales
    FROM dbo.Sales
    GROUP BY
        YEAR(TransactionDate),
        MONTH(TransactionDate)
),
SalesComparison AS (
    SELECT
        Transaction_Year,
        Transaction_Month,
        Total_Sales,
        LAG(Total_Sales) OVER (
            ORDER BY Transaction_Year, Transaction_Month
        ) AS Previous_Month_Sales
    FROM MonthlySales
)
SELECT
    Transaction_Year,
    Transaction_Month,
    Total_Sales,
    Previous_Month_Sales
FROM SalesComparison
ORDER BY
    Transaction_Year,
    Transaction_Month;


-- 16. Monthly Sales Growth
WITH MonthlySales AS (
    SELECT
        YEAR(TransactionDate) AS Transaction_Year,
        MONTH(TransactionDate) AS Transaction_Month,
        SUM(TotalSpent) AS Total_Sales
    FROM dbo.Sales
    GROUP BY
        YEAR(TransactionDate),
        MONTH(TransactionDate)
),
SalesComparison AS (
    SELECT
        Transaction_Year,
        Transaction_Month,
        Total_Sales,
        LAG(Total_Sales) OVER (
            ORDER BY Transaction_Year, Transaction_Month
        ) AS Previous_Month_Sales
    FROM MonthlySales
)
SELECT
    Transaction_Year,
    Transaction_Month,
    Total_Sales,
    Previous_Month_Sales,
    CAST(
        (Total_Sales - Previous_Month_Sales)
        * 100.0 / Previous_Month_Sales
        AS DECIMAL(10,2)
    ) AS Growth_Percentage
FROM SalesComparison
ORDER BY
    Transaction_Year,
    Transaction_Month;


-- 17. Monthly Running Total Sales
WITH MonthlySales AS (
    SELECT
        YEAR(TransactionDate) AS Transaction_Year,
        MONTH(TransactionDate) AS Transaction_Month,
        SUM(TotalSpent) AS Total_Sales
    FROM dbo.Sales
    GROUP BY
        YEAR(TransactionDate),
        MONTH(TransactionDate)
)
SELECT
    Transaction_Year,
    Transaction_Month,
    Total_Sales,
    SUM(Total_Sales) OVER (
        ORDER BY Transaction_Year, Transaction_Month
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS Running_Total_Sales
FROM MonthlySales
ORDER BY
    Transaction_Year,
    Transaction_Month;


-- 18. Customer Sales Contribution
WITH CustomerSales AS (
    SELECT
        CustomerID,
        SUM(TotalSpent) AS Total_Sales
    FROM dbo.Sales
    GROUP BY CustomerID
)
SELECT
    CustomerID,
    Total_Sales,
    CAST(
        Total_Sales * 100.0 /
        SUM(Total_Sales) OVER ()
        AS DECIMAL(10,2)
    ) AS Sales_Contribution_Percentage
FROM CustomerSales
ORDER BY Total_Sales DESC;