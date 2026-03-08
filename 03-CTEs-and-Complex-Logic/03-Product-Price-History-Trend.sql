/*
===============================================================================
FILE NAME:    03-Product-Price-History-Trend.sql
PROJECT:      AdventureWorks Inventory Strategy
AUTHOR:       emdej111 - Monika Jurak
DATE:         08-03-2026
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

SELECT p.Name AS ProductName,
       pch.StandardCost AS CurrentCost,
       pch.StartDate,
       -- LAG() pulls data from a previous row without needing a complex self-join
       -- Syntax: LAG (scalar_expression [,offset] [,default]) OVER ([PARTITION BY partition_expression] ORDER BY sort_expression)
       LAG(pch.StandardCost) OVER (PARTITION BY pch.ProductID ORDER BY pch.StartDate) AS PreviousCost,
       pch.StandardCost - LAG(pch.StandardCost) OVER (PARTITION BY pch.ProductID ORDER BY pch.StartDate) AS PriceDelta,
       CAST((pch.StandardCost - LAG(pch.StandardCost) OVER (PARTITION BY pch.ProductID ORDER BY pch.StartDate)) 
        / NULLIF(LAG(pch.StandardCost) OVER (PARTITION BY pch.ProductID ORDER BY pch.StartDate), 0) * 100 AS DECIMAL(10,2)) AS PercentChange
FROM Production.Product p
JOIN Production.ProductCostHistory pch ON p.ProductID = pch.ProductID
ORDER BY p.Name, pch.StartDate;
