/*
===============================================================================
FILE NAME:   02-Customers-With-No-Orders.sql
PROJECT:     AdventureWorks CRM Analysis
AUTHOR:      emdej111 - Monika Jurak
DATE:        24-01-2026
DESCRIPTION: Identifying inactive customer accounts for marketing re-engagement.
===============================================================================
1. GOAL:       Retrieve CustomerIDs that have never placed an order.
2. TABLES:     Sales.Customer, Sales.SalesOrderHeader.
3. LOGIC:      - Use the EXCEPT operator to compare the full list of customers 
                 against the list of customers who have orders.
               - Alternatively, try solving it with NOT EXISTS.
===============================================================================
*/
-- Solution 1
SELECT CustomerID FROM Sales.Customer
EXCEPT
SELECT CustomerID FROM Sales.SalesOrderHeader;

-- Solution 2
SELECT c.CustomerID
FROM Sales.Customer c
WHERE NOT EXISTS (
    SELECT 1 
    FROM Sales.SalesOrderHeader s 
    WHERE s.CustomerID = c.CustomerID);

-- Solution 3
SELECT CustomerID
FROM Sales.Customer
WHERE CustomerID NOT IN (SELECT CustomerID FROM Sales.SalesOrderHeader WHERE CustomerID IS NOT NULL);
