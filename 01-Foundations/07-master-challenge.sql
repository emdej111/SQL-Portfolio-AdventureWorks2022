/*
===============================================================================
FILE NAME:    07-Master-Logistics-Audit.sql
PROJECT:      AdventureWorks Foundations Capstone
AUTHOR:       emdej111 - Monika Jurak
DATE:         17-01-2026
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
