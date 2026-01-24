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
