/*
===============================================================================
FILE NAME:   03-High-Value-Territory-Analysis.sql
PROJECT:     AdventureWorks Regional Strategy
AUTHOR:      emdej111 - Monika Jurak
DATE:        24-01-2026
DESCRIPTION: Identifying territories that exceed the global average order value.
===============================================================================
1. GOAL:       Filter regions based on a dynamic average order benchmark.
2. TABLES:     Sales.SalesTerritory, Sales.SalesOrderHeader.
3. LOGIC:      - Calculate the AVG(TotalDue) for each territory using GROUP BY.
               - Use a subquery in the HAVING clause that calculates the global 
                 AVG(TotalDue) of the entire SalesOrderHeader table.
===============================================================================
*/
