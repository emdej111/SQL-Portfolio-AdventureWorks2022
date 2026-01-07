/*
===============================================================================
FILE NAME:    05-Sales-Data-Integrity-Check.sql
PROJECT:      AdventureWorks Data Quality Audit
AUTHOR:       emdej111 - Monika Jurak
DATE:         07-01-2026
DESCRIPTION:  Identifying missing sales representative assignments in store orders.
===============================================================================
1. GOAL:       Find store orders (OnlineOrderFlag = 0) missing a SalesPersonID.
2. TABLES:     Sales.SalesOrderHeader.
3. LOGIC:      Filtering for NULL values in critical relational columns.
===============================================================================
*/

-- Step 1: Count NULLs vs Non-NULLs in SalesPersonID

----------------- FINAL BUSINESS REPORT -----------------
-- Hint: WHERE SalesPersonID IS NULL AND OnlineOrderFlag = 0
