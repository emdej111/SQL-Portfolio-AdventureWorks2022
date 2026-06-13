/*
===============================================================================
FILE NAME:    03-Product-Inventory-Audit.sql
PROJECT:      AdventureWorks Inventory Analysis
AUTHOR:       emdej111 - Monika Jurak
DATE:         07-01-2026
DESCRIPTION:  Auditing stock levels for specific product categories (Bikes).
===============================================================================
1. GOAL:       Identify Mountain and Road bikes with stock levels between 500 and 1000.
2. TABLES:     Production.Product.
3. LOGIC:      Filtering with LIKE, BETWEEN and logical OR/AND operators.
===============================================================================
*/

-- Step 1: Explore Production.Product table
SELECT * FROM Production.Product;

----------------- FINAL BUSINESS REPORT -----------------
-- Hint: WHERE Name LIKE '%Mountain%' OR Name LIKE '%Road%'...
SELECT ProductID, 
	   Name, 
	   SafetyStockLevel
FROM Production.Product
WHERE SafetyStockLevel BETWEEN 500 AND 1000 
AND (Name LIKE '%Mountain%' OR Name LIKE '%Road%') 
ORDER BY SafetyStockLevel ASC;

/* When combining AND/OR operators, SQL server prioritizes AND. 
   Parentheses are required here to force the OR group to be evaluated 
   as a single logic unit before the AND filter is applied. */


/* LOGIC EXPLANATION:
   1. DATA SOURCE: 
      Targeted the 'Production.Product' table to audit inventory safety settings 
      for high-value bike assets.
      
   2. BETWEEN: 
      Applied a strict inventory constraint (500-1000 units) to isolate products 
      that require specific stock monitoring.
      
   3. LOGICAL GROUPING (The Parentheses): 
      Crucial step! I used parentheses around the OR conditions (Mountain OR Road). 
      This overrides SQL's default behavior where AND is processed before OR, 
      ensuring the stock filter applies to both categories equally.
      
   4. PATTERN MATCHING: 
      Used LIKE with wildcards (%) to capture all model variations within the 
      Mountain and Road bike families.
      
   5. SORTING: 
      Ordered by 'SafetyStockLevel' in ascending order to provide a clear ranking 
      starting from the lowest threshold of the audit range.
*/
