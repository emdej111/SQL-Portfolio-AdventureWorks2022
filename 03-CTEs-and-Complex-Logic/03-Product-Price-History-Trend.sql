/*
===============================================================================
FILE NAME:    03-Product-Price-History-Trend.sql
PROJECT:      AdventureWorks Inventory Strategy
AUTHOR:       emdej111 - Monika Jurak
DATE:         09-02-2026
DESCRIPTION:  Tracking price changes over time using Window Functions.
===============================================================================
1. GOAL:       Display every price change for products and the delta from the last price.
2. TABLES:     Production.Product, Production.ProductCostHistory.
3. LOGIC:      - Join product names with their cost history.
               - Use the LAG() window function to pull the "Previous Cost" into 
                 the current row.
               - Calculate the price difference (Current - Previous).
===============================================================================
*/

SELECT * FROM Production.Product;
SELECT * FROM Production.ProductCostHistory;
