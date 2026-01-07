/*
===============================================================================
FILE NAME:    02-Employee-Tenure-Analysis.sql
PROJECT:      AdventureWorks HR Analysis
AUTHOR:       emdej111 - Monika Jurak
DATE:         07-01-2026
DESCRIPTION:  Calculating employee tenure and formatting HR data for newsletter.
===============================================================================
1. GOAL:       List active employees with their full names, titles, and years of service.
2. TABLES:     HumanResources.Employee, Person.Person.
3. LOGIC:      Inner Join on BusinessEntityID, string concatenation, date formatting.
===============================================================================
*/

-- Step 1: Explore Person and Employee tables
-- Step 2: Join tables to verify data alignment

----------------- FINAL BUSINESS REPORT -----------------
-- Hint: Use CONCAT, FORMAT(HireDate, 'dd.MM.yyyy') and DATEDIFF(YEAR, HireDate, '2026-01-07')
