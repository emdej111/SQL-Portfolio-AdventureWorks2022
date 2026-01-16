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

/* LOGIC EXPLANATION:
   1. DATA LINKAGE (JOIN): 
      I linked the 'SalesOrderHeader' (transactions) with 'SalesTerritory' (geography) 
      using the 'TerritoryID' as the common key.
      
   2. AGGREGATION (MATHEMATICS):
      - COUNT: Calculated the volume of business by counting unique Order IDs.
      - SUM: Calculated the total gross revenue per region.
      - AVG: Calculated the mean value of a single transaction (Average Ticket).
      
   3. DATA REFINEMENT (ROUNDING):
      Used the ROUND function to limit currency values to 2 decimal places 
      for a clean, professional financial report.
      
   4. GROUP BY:
      Collapsed thousands of individual sales into summary rows based on the 
      Territory Name. Every non-aggregated column in SELECT must be here.
      
   5. ORDER BY:
      Ranked the territories from highest to lowest revenue to immediately 
      highlight the top-performing regions.
*/
