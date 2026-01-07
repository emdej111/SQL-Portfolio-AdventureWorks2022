/*
===============================================================================
FILE NAME:    06-Shipping-Efficiency-Report.sql
PROJECT:      AdventureWorks Logistics Analysis
AUTHOR:       emdej111 - Monika Jurak
DATE:         07-01-2026
DESCRIPTION:  Analyzing shipping delays by comparing DueDate and ShipDate.
===============================================================================
1. GOAL:       Calculate shipping delays in days and list overdue shipments.
2. TABLES:     Sales.SalesOrderHeader.
3. LOGIC:      Date subtraction and filtering where ShipDate > DueDate.
===============================================================================
*/

-- Step 1: Compare DueDate and ShipDate samples

----------------- FINAL BUSINESS REPORT -----------------
-- Hint: DATEDIFF(DAY, DueDate, ShipDate) AS DaysDelayed
