/*
===============================================================================
FILE NAME:    02-usp_GetCustomerOrderHistory.sql
PROJECT:      AdventureWorks CRM Tooling
AUTHOR:       emdej111 - Monika Jurak
DATE:         24-01-2026
DESCRIPTION:  Parameterized stored procedure for dynamic customer order lookups.
===============================================================================
1. GOAL:       Fetch all orders for a specific customer using an Input Parameter.
2. TABLES:     Sales.SalesOrderHeader, Sales.SalesOrderDetail.
3. LOGIC:      - Define a procedure that accepts @CustomerID (INT).
               - Use the parameter in the WHERE clause.
               - This ensures reusability and protects against SQL Injection.
===============================================================================
*/

DECLARE @TestID INT = 29844;
SELECT * FROM Sales.SalesOrderHeader WHERE CustomerID = @TestID;
