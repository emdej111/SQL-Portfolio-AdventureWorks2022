/*
===============================================================================
FILE NAME:   01-Top-Selling-Products-Per-Category.sql
PROJECT:     AdventureWorks Sales Analysis
AUTHOR:      emdej111 - Monika Jurak
DATE:        24-01-2026
DESCRIPTION: Identifying the highest-grossing product within each category.
===============================================================================
1. GOAL:       Find the best-selling product for every category based on revenue.
2. TABLES:     Production.Product, Production.ProductSubcategory, 
               Production.ProductCategory, Sales.SalesOrderDetail.
3. LOGIC:      - Join categories with products and sales details.
               - Group by Category Name and Product Name.
               - Use a HAVING clause with a correlated subquery to find the 
                 MAX revenue for each specific category.
===============================================================================
*/

