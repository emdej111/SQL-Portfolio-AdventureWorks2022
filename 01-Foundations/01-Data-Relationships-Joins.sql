/*
===============================================================================
FILE NAME:   01-Regional-Sales-Performance.sql
PROJECT:     AdventureWorks Sales Analysis
AUTHOR:      emdej111 - Monika Jurak
DATE:        07-01-2026
DESCRIPTION: Aggregating sales data by territory to evaluate regional performance.
===============================================================================
1. GOAL:       Summarize Total Due, Order Count, and Average Order Value.
2. TABLES:     Sales.SalesOrderHeader, Sales.SalesTerritory.
3. LOGIC:      Inner Join on TerritoryID, Group by Territory Name.
===============================================================================
*/

SELECT * FROM Sales.SalesOrderHeader;
SELECT * FROM Sales.SalesTerritory;

SELECT * FROM Sales.SalesOrderHeader o
JOIN Sales.SalesTerritory t on o.TerritoryID = t.TerritoryID;

----------------- FINAL BUSINESS REPORT -----------------

SELECT t.[Name] AS TerritoryName,
       COUNT(o.SalesOrderID) AS TotalOrders,
       ROUND(SUM(o.TotalDue), 2) AS TotalRevenue,
       ROUND(AVG(o.TotalDue), 2) AS AverageOrderValue
FROM Sales.SalesOrderHeader AS o
JOIN Sales.SalesTerritory AS t
    ON o.TerritoryID = t.TerritoryID
GROUP BY t.[Name]
ORDER BY TotalRevenue DESC;
