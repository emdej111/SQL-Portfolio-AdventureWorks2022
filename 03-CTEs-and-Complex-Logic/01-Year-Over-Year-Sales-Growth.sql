/*
===============================================================================
FILE NAME:    01-Year-Over-Year-Sales-Growth.sql
PROJECT:      AdventureWorks Sales Analysis
AUTHOR:       emdej111 - Monika Jurak
DATE:         09-02-2026
DESCRIPTION:  Comparing monthly performance trends using CTEs to calculate growth.
===============================================================================
1. GOAL:       Identify monthly revenue growth or decline compared to the previous year.
2. TABLES:     Sales.SalesOrderHeader.
3. LOGIC:      - Create a CTE to aggregate sales by Year and Month.
               - Use a second CTE or Self-Join to pair current month data with 
                 the same month from the prior year.
               - Calculate the percentage difference (Growth %).
===============================================================================
*/

SELECT * FROM Sales.SalesOrderHeader;
