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
SELECT * FROM Sales.SalesOrderHeader;

----------------- FINAL BUSINESS REPORT -----------------
-- Hint: CASE WHEN TotalDue > 10000 THEN 'High Value' ... END

SELECT ROUND(MIN(TotalDue), 2) AS [low], ROUND(MAX(TotalDue), 2) AS [high], ROUND(AVG(TotalDue), 2) AS [mid] FROM Sales.SalesOrderHeader;
-- low - 1.52
-- mid - 3916.00
-- high - 187487.83

SELECT SalesOrderID, 
       ROUND(TotalDue, 2),
    CASE 
        WHEN TotalDue > 10000 THEN 'High Value'
        WHEN TotalDue BETWEEN 2000 AND 10000 THEN 'Mid Value'
        ELSE 'Low Value'
    END AS OrderSegment
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;

/* LOGIC EXPLANATION:
   1. DATA INVESTIGATION :
      Before segmenting, I calculated the MIN ($1.52), MAX ($187,487.83), and 
      AVG ($3,916.00) of TotalDue. This confirmed that most orders are below 
      $4,000, while a few "Whales" exceed $100,000.

   2. CASE:
      - 'High Value': Set at > $10,000 to capture the top tier of revenue.
      - 'Mid Value': Set between $2,000 and $10,000, covering the area 
        around the average order value.
      - 'Low Value': All orders below $2,000, representing high-volume, 
        low-value transactions.

   3. ORDER OF EVALUATION:
      The CASE statement is written from highest to lowest. SQL stops at the 
      first "true" condition, ensuring VIP orders are correctly labeled 
      before they hit the 'Mid' or 'Low' filters.

   4. DATA CLEANING:
      Applied ROUND(TotalDue, 2) to maintain financial formatting consistency 
      in the final report.

   5. RANKING:
      Sorted by TotalDue (DESC) so the Marketing team can immediately 
      focus on the highest-priority 'High Value' customers.
*/
