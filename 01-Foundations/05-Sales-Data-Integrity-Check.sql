/*
===============================================================================
FILE NAME:    05-Sales-Data-Integrity-Check.sql
PROJECT:      AdventureWorks Data Quality Audit
AUTHOR:       emdej111 - Monika Jurak
DATE:         17-01-2026
DESCRIPTION:  Identifying missing sales representative assignments in store orders.
===============================================================================
1. GOAL:       Find store orders (OnlineOrderFlag = 0) missing a SalesPersonID.
2. TABLES:     Sales.SalesOrderHeader.
3. LOGIC:      Filtering for NULL values in critical relational columns.
===============================================================================
*/

-- Step 1: Count NULLs vs Non-NULLs in SalesPersonID
-- Use COUNT(*) to count total rows, including NULLs, instead of specific column values
SELECT COUNT(*) FROM Sales.SalesOrderHeader WHERE SalesPersonID IS NULL; -- 27659
-- Result: 27,959 (Represents all Online orders + potential data entry errors)

-- Count rows where a Sales Representative is assigned
SELECT COUNT(*) FROM Sales.SalesOrderHeader WHERE SalesPersonID IS NOT NULL; -- 3806
-- Result: 3,506 (Represents orders successfully linked to a salesperson)

----------------- FINAL BUSINESS REPORT -----------------
-- Hint: WHERE SalesPersonID IS NULL AND OnlineOrderFlag = 0
SELECT SalesOrderID, 
       OrderDate, 
       CustomerID, 
       SalesPersonID,    -- This will be NULL in results
       OnlineOrderFlag,  -- This will be 0 (Store Order)
       TotalDue
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IS NULL     
  AND OnlineOrderFlag = 0        
ORDER BY TotalDue DESC;          

/* LOGIC EXPLANATION:
   1. DATA QUALITY AUDIT: 
      Focused on the 'Production.Product' table to identify missing technical 
      specifications (Color, Weight) that are essential for e-commerce filters.

   2. HANDLING UNKNOWN DATA (IS NULL): 
      Used the 'IS NULL' operator to catch products where attributes were 
      never entered. Standard comparison operators (=) cannot detect NULLs 
      because NULL represents an absence of value.

   3. MULTI-COLUMN VALIDATION: 
      Applied the OR operator within the WHERE clause to flag a product if 
      EITHER its color OR its weight is missing, creating a comprehensive 
      "To-Do" list for the data entry team.

   4. DATA REFINEMENT (Filtering): 
      Used 'ProductLine' or 'Style' filters (optional) to narrow down the audit 
      to finished goods, excluding raw materials that naturally lack these attributes.

   5. SORTING FOR PRIORITY: 
      Ordered by 'Name' or 'ProductNumber' to provide an organized list for 
      the inventory managers to review and update.
*/
