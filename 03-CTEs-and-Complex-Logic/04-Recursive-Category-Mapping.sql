/*
===============================================================================
FILE NAME:    04-Recursive-Category-Mapping.sql
PROJECT:      AdventureWorks Catalog Management
AUTHOR:       emdej111 - Monika Jurak
DATE:         08-03-2026
DESCRIPTION:  Mapping parent-child product category relationships using CTEs.
===============================================================================
1. GOAL:       Generate a breadcrumb-style path for every subcategory (e.g., 'Bikes > Mountain Bikes').
2. TABLES:     Production.ProductCategory, Production.ProductSubcategory.
3. LOGIC:      - Use a CTE to join Categories and Subcategories.
               - Concatenate the Category Name and Subcategory Name with a ' > ' separator.
               - This simplifies the front-end display for e-commerce navigation.
===============================================================================
*/

SELECT * FROM Production.ProductCategory;
SELECT * FROM Production.ProductSubcategory;

WITH CategoryMapping_CTE AS (
                             SELECT c.Name AS CategoryName,
                                    s.Name AS SubcategoryName
                             FROM Production.ProductCategory c
                             INNER JOIN Production.ProductSubcategory s 
                             ON c.ProductCategoryID = s.ProductCategoryID
                             )
SELECT CategoryName,
       SubcategoryName,
       CategoryName + ' > ' + SubcategoryName AS CategoryBreadcrumb
FROM CategoryMapping_CTE
ORDER BY CategoryName, SubcategoryName;
