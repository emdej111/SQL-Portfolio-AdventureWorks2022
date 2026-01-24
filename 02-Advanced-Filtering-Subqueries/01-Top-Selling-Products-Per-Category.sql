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

SELECT * FROM Production.Product
SELECT * FROM Production.ProductSubcategory;
SELECT * FROM Production.ProductCategory;
SELECT * FROM Sales.SalesOrderDetail;

SELECT c.Name AS CategoryName,
       p.Name AS ProductName,
       SUM(sod.LineTotal) AS TotalRevenue
FROM Production.Product p
JOIN Production.ProductSubcategory sc ON p.ProductSubcategoryID = sc.ProductSubcategoryID
JOIN Production.ProductCategory c ON sc.ProductCategoryID = c.ProductCategoryID
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
GROUP BY c.Name, p.Name, c.ProductCategoryID
HAVING SUM(sod.LineTotal) = (SELECT MAX(ProductRevenue) FROM (SELECT SUM(sod2.LineTotal) AS ProductRevenue
                                                              FROM Production.Product AS p2
                                                              JOIN Production.ProductSubcategory AS sc2 ON p2.ProductSubcategoryID = sc2.ProductSubcategoryID
                                                              JOIN Sales.SalesOrderDetail AS sod2 ON p2.ProductID = sod2.ProductID
                                                              WHERE sc2.ProductCategoryID = c.ProductCategoryID
                                                              GROUP BY p2.ProductID) AS SubTable)
ORDER BY CategoryName;

/* ===============================================================================
COMPREHENSIVE TECHNICAL DOCUMENTATION: CATEGORY PERFORMANCE ANALYSIS
===============================================================================

OBJECTIVE:
Identify the single most successful product (by revenue) within each category. 
This requires comparing an individual product's sum against a dynamically 
calculated group maximum.

CORE ARCHITECTURAL CONCEPTS:
1. Multi-Stage Aggregation: Solving the "MAX of SUM" limitation.
2. Row-by-Row Execution: Understanding the Correlated Subquery lifecycle.
3. Logical Scoping: Using table aliases to prevent namespace collisions.

-------------------------------------------------------------------------------
DETAILED STEP-BY-STEP EXECUTION FLOW:
-------------------------------------------------------------------------------

STEP 1: THE DATA SOURCE & JOIN LADDER
The query traverses four relational levels:
- SalesOrderDetail (Transaction level data) -> Production.Product (Item info) 
  -> Subcategory -> Category (Reporting hierarchy).
This "Ladder" allows us to group granular sales by top-level categories.

STEP 2: THE "OUTER" AGGREGATION (Grouping Phase)
The SELECT statement and GROUP BY clause create a summarized result set. 
Each row represents a unique combination of Category + Product. 
At this point, the SQL Engine calculates: 
TotalRevenue = SUM(LineTotal) for that specific item.

STEP 3: THE "HAVING" GATEKEEPER
Unlike the WHERE clause (which filters raw rows), the HAVING clause filters 
already grouped data. Here, we set a condition: 
"Keep this product only if its Revenue equals the Maximum Revenue in its Category."

STEP 4: THE CORRELATED SUBQUERY (The Dynamic Benchmark)
This is the heart of the logic. For every row in the Outer Query, 
the Subquery triggers a localized search:
- It uses a 'SubTable' to calculate the SUM(LineTotal) for EVERY product 
  inside the CURRENT category.
- It then applies MAX() to find the highest value among them.
- THE CORRELATION: The link 'sc2.ProductCategoryID = c.ProductCategoryID' 
  ensures the subquery doesn't look at all categories, but "locks" onto the 
  one category currently being evaluated by the outer loop.

STEP 5: EQUALITY COMPARISON & FINAL OUTPUT
The engine takes the Outer Product's revenue (e.g., $1.2M) and the Subquery's 
calculated maximum for that category (e.g., $1.2M). 
If the values match (1.2M = 1.2M), the product is returned as the "Category Champion".

-------------------------------------------------------------------------------
WHY THIS METHOD?
Using this correlated approach instead of a simple JOIN ensures that even if 
categories have vastly different sales volumes, the report remains accurate 
by recalculating the benchmark for every category dynamically.
===============================================================================
*/


