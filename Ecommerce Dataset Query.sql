/*=========================================================
E-COMMERCE SALES ANALYSIS
Author: Ibrahim Oyesola Adekunle
Tool: Microsoft SQL Server
=========================================================*/

USE eCommerceDB;

--=========================================================
-- DATASET OVERVIEW
--=========================================================

SELECT 
	(SELECT COUNT(OrderID) FROM EcommerceSales) AS TotalOrders,
	(SELECT COUNT(CustomerID) FROM EcommerceSales) AS TotalCustomerRecords,
	(SELECT COUNT(DISTINCT CustomerID) FROM EcommerceSales) AS TotalUniqueCustomers,
	( 
		SELECT COUNT(*) 
		FROM 
		( 
			SELECT CustomerID 
			FROM EcommerceSales 
			GROUP BY CustomerID 
			HAVING COUNT(OrderID) > 1 
			) AS RepeatCustomerList 
		) AS RepeatCustomers;

--=========================================================
-- PRODUCT ANALYSIS
--=========================================================

SELECT
	Product,
	SUM(Quantity) AS TotalUnitsSold,
	ROUND(SUM(TotalPrice), 2) AS Revenue
FROM EcommerceSales
GROUP BY Product
ORDER BY Revenue DESC;

--=========================================================
-- MARKETING ANALYSIS
--=========================================================

SELECT
ReferralSource,
	COUNT(*) AS TotalOrders,
	ROUND(SUM(TotalPrice), 2) AS Revenue,
	ROUND(AVG(TotalPrice), 2) AS AverageOrderValue
FROM EcommerceSales
GROUP BY ReferralSource
ORDER BY Revenue DESC;

SELECT
CouponCode,
	COUNT(*) AS TotalOrders,
	ROUND(SUM(TotalPrice), 2) AS Revenue,
	ROUND(AVG(TotalPrice), 2) AS AverageOrderValue
FROM EcommerceSales
GROUP BY CouponCode
ORDER BY Revenue DESC;

--=========================================================
-- PAYMENT ANALYSIS
--=========================================================

SELECT
PaymentMethod,
	COUNT(*) AS TotalOrders,
	ROUND(SUM(TotalPrice), 2) AS Revenue,
	ROUND(AVG(TotalPrice), 2) AS AverageOrderValue
FROM EcommerceSales
GROUP BY PaymentMethod
ORDER BY Revenue DESC;

--=========================================================
-- ORDER STATUS ANALYSIS
--=========================================================

SELECT
OrderStatus,
	COUNT(*) AS TotalOrders
FROM EcommerceSales
GROUP BY OrderStatus
ORDER BY TotalOrders DESC;

--=========================================================
-- REVENUE ANALYSIS
--=========================================================

SELECT
	ROUND(SUM(TotalPrice), 2) AS TotalRevenue,
	ROUND(AVG(TotalPrice), 2) AS AverageOrderValue,
	ROUND(MAX(TotalPrice), 2) AS HighestOrderValue,
	ROUND(MIN(TotalPrice), 2) AS LowestOrderValue
FROM EcommerceSales;

--=========================================================
-- REVENUE STATUS
--=========================================================
SELECT
	ROUND(SUM(TotalPrice), 2) AS CompletedRevenue
FROM EcommerceSales;

SELECT
	ROUND(SUM(TotalPrice), 2) AS CompletedRevenue
FROM EcommerceSales
WHERE OrderStatus IN ('Delivered', 'Shipped');

--=========================================================
-- REVENUE TREND ANALYSIS
--=========================================================

SELECT
	YEAR(Date) AS SalesYear,
	COUNT(OrderID) AS TotalOrders,
	ROUND(SUM(TotalPrice), 2) AS Revenue
FROM EcommerceSales
GROUP BY YEAR(Date)
ORDER BY SalesYear;

-- Compare equivalent January–June periods

SELECT
	YEAR(Date) AS SalesYear,
	COUNT(OrderID) AS TotalOrders,
	ROUND(SUM(TotalPrice), 2) AS Revenue
FROM EcommerceSales
WHERE MONTH(Date) <= 6
GROUP BY YEAR(Date)
ORDER BY SalesYear;

-- Monthly revenue trend

SELECT
	YEAR(Date) AS SalesYear,
	DATENAME(MONTH, Date) AS SalesMonth,
	COUNT(*) AS TotalOrders,
	ROUND(SUM(TotalPrice), 2) AS Revenue
FROM EcommerceSales
GROUP BY YEAR(Date), MONTH(Date), DATENAME(MONTH, Date)
ORDER BY YEAR(Date), MONTH(Date);

--=========================================================
-- CUSTOMER BEHAVIOUR ANALYSIS
--=========================================================

SELECT
	YEAR(Date) AS SalesYear,
	COUNT(*) AS TotalOrders,
	COUNT(DISTINCT CustomerID) AS UniqueCustomers,
	ROUND(AVG(TotalPrice), 2) AS AverageOrderValue
FROM EcommerceSales
WHERE MONTH(Date) <= 6
GROUP BY YEAR(Date)
ORDER BY SalesYear;

--=========================================================
-- REPEAT CUSTOMER ANALYSIS
--=========================================================

SELECT
	YEAR(Date) AS SalesYear,
	COUNT(CustomerID) AS CustomerRecords,
	COUNT(DISTINCT CustomerID) AS UniqueCustomers,
	COUNT(CustomerID) - COUNT(DISTINCT CustomerID) AS RepeatCustomers
FROM EcommerceSales
WHERE MONTH(Date) <= 6
GROUP BY YEAR(Date)
ORDER BY SalesYear;
