/*
===============================================================================
FILE NAME:    04-Customer-Order-Segmentation.sql
PROJECT:      AdventureWorks Marketing Analysis
AUTHOR:       emdej111 - Monika Jurak
DATE:         07-01-2026
DESCRIPTION:  Categorizing customer orders based on their total monetary value.
===============================================================================
1. GOAL:       Label orders as 'High', 'Mid', or 'Low' value for marketing targeting.
2. TABLES:     Sales.SalesOrderHeader.
3. LOGIC:      Conditional logic using CASE statements based on TotalDue.
===============================================================================
*/

-- Step 1: Explore SalesOrderHeader ranges

----------------- FINAL BUSINESS REPORT -----------------
-- Hint: CASE WHEN TotalDue > 10000 THEN 'High Value' ... END
