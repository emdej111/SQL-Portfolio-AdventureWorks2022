/*
===============================================================================
FILE NAME:    06-Shipping-Efficiency-Report.sql
PROJECT:      AdventureWorks Logistics Analysis
AUTHOR:       emdej111 - Monika Jurak
DATE:         17-01-2026
DESCRIPTION:  Analyzing shipping delays by comparing DueDate and ShipDate.
===============================================================================
1. GOAL:       Calculate shipping delays in days and list overdue shipments.
2. TABLES:     Sales.SalesOrderHeader.
3. LOGIC:      Date subtraction and filtering where ShipDate > DueDate.
===============================================================================
*/

-- Step 1: Compare DueDate and ShipDate samples
SELECT DueDate, ShipDate FROM Sales.SalesOrderHeader;

----------------- FINAL BUSINESS REPORT -----------------
-- Hint: DATEDIFF(DAY, DueDate, ShipDate) AS DaysDelayed
SELECT SalesOrderID,
	   OrderDate,
	   ShipDate,
	   DueDate,
	   DATEDIFF(DAY, DueDate, ShipDate) AS DaysDelayed
FROM Sales.SalesOrderHeader
WHERE ShipDate > DueDate 
ORDER BY DaysDelayed DESC;

/* LOGIC EXPLANATION:
   1. DATA SOURCE: 
      Utilized 'Sales.SalesOrderHeader' to track key logistics milestones: 
      OrderDate, DueDate (the deadline), and ShipDate (the actual fulfillment).

   2. DATEDIFF: 
      Calculated the variance in days. By placing 'DueDate' as the start and 
      'ShipDate' as the end, positive integers represent how many days 
      the shipment missed its target.

   3. LOGICAL FILTERING (The Audit): 
      Applied a WHERE clause (ShipDate > DueDate) to isolate only the 
      inefficient shipments. Orders sent on time or early are excluded 
      from this specific delay report.

   4. PERFORMANCE RANKING: 
      Ordered the results by 'DaysDelayed' in descending order. This 
      allows the logistics team to immediately identify the most 
      problematic delays for customer service follow-up.
*/
