/*
===============================================================================
FILE NAME:    01-vw_ExecutiveSalesDashboard.sql
PROJECT:      AdventureWorks Business Intelligence
AUTHOR:       emdej111 - Monika Jurak
DATE:         24-01-2026
DESCRIPTION:  A high-level view summarizing annual sales performance per region.
===============================================================================
1. GOAL:       Provide a simplified "One-Stop-Shop" for executive reporting.
2. TABLES:     Sales.SalesOrderHeader, Sales.SalesTerritory, Person.CountryRegion.
3. LOGIC:      - Create a VIEW that aggregates TotalDue, TaxAmt, and Freight.
               - Group data by Year and Country Name.
               - This object abstracts the complexity of joins from end-users.
===============================================================================
*/

SELECT * FROM Sales.SalesOrderHeader;
SELECT * FROM Sales.SalesTerritory;
