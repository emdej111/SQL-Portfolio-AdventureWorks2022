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

----------------- FINAL BUSINESS REPORT -----------------
-- Hint: WHERE Name LIKE '%Mountain%' OR Name LIKE '%Road%'...
