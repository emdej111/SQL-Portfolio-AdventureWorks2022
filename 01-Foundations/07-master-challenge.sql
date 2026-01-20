/*
===============================================================================
FILE NAME:    07-Master-Logistics-Audit.sql
PROJECT:      AdventureWorks Foundations Capstone
AUTHOR:       emdej111 - Monika Jurak
DATE:         20-01-2026
DESCRIPTION:  Final Graduation Challenge - Linking shipping costs to delivery 
              delays to identify financial losses.
===============================================================================

--------------------------- BUSINESS REQUIREMENTS -----------------------------
The Logistics Manager wants to identify which shipping methods are failing us.
We need a report that shows:
1. The NAME of the shipping method.
2. The TOTAL SUM of freight costs (rounded to 2 decimals).
3. The NUMBER of orders that suffered a 'CRITICAL DELAY' (More than 5 days late).

------------------------------ TECHNICAL HINTS --------------------------------
- TABLES: Sales.SalesOrderHeader (soh) and Purchasing.ShipMethod (sm).
- JOIN: Link them on ShipMethodID.
- CALCULATION: DATEDIFF(DAY, DueDate, ShipDate) determines the delay.
- AGGREGATION: Use SUM() for costs and a CASE inside a COUNT() for delays.
- FILTER: Use HAVING to show only methods with at least 1 'CRITICAL DELAY'.
- SORTING: Rank by Total Freight Cost (highest first).
-------------------------------------------------------------------------------
*/

SELECT * FROM Sales.SalesOrderHeader; -- (soh)
SELECT * FROM Purchasing.ShipMethod; -- (sm)

SELECT * FROM Sales.SalesOrderHeader soh JOIN Purchasing.ShipMethod sm ON soh.ShipMethodID = sm.ShipMethodID

SELECT sm.[Name] AS ShippingMethodName,
       ROUND(SUM(soh.Freight), 2) AS TotalFreightCost,
       COUNT(CASE WHEN DATEDIFF(DAY, DueDate, ShipDate) > 5 THEN 1 END) AS CriticalDelayCount
FROM Sales.SalesOrderHeader soh 
JOIN Purchasing.ShipMethod sm ON soh.ShipMethodID = sm.ShipMethodID
GROUP BY sm.[Name]
HAVING COUNT(CASE WHEN DATEDIFF(DAY, DueDate, ShipDate) > 5 THEN 1 END) > 0
ORDER BY TotalFreightCost DESC;

/* LOGIC EXPLANATION:
   1. JOIN: Successfully linked Sales and Purchasing tables using ShipMethodID 
      to associate delivery methods with their respective costs and dates.
   2. AGGREGATION: Grouped results by Shipping Method Name to provide a summarized 
      view of freight expenses.
   3. CONDITIONAL METRICS: Implemented a CASE statement within a COUNT function to 
      isolate specific operational failures (delays > 5 days) without 
      filtering out the financial totals.
   4. DATA FILTERING: Used HAVING to exclude high-performing shipping methods, 
      focusing the report exclusively on problematic areas.
*/
