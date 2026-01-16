/*
===============================================================================
FILE NAME:    02-Employee-Tenure-Analysis.sql
PROJECT:      AdventureWorks HR Analysis
AUTHOR:       emdej111 - Monika Jurak
DATE:         16-01-2026
DESCRIPTION:  Calculating employee tenure and formatting HR data for newsletter.
===============================================================================
1. GOAL:       List active employees with their full names, titles, and years of service.
2. TABLES:     HumanResources.Employee, Person.Person.
3. LOGIC:      Inner Join on BusinessEntityID, string concatenation, date formatting.
===============================================================================
*/

-- Step 1: Explore Person and Employee tables
SELECT * FROM HumanResources.Employee;
SELECT * FROM Person.Person;

-- Step 2: Join tables to verify data alignment
SELECT * FROM HumanResources.Employee e 
JOIN Person.Person p 
	ON e.BusinessEntityID = p.BusinessEntityID;

----------------- FINAL BUSINESS REPORT -----------------
-- Hint: Use CONCAT, FORMAT(HireDate, 'dd.MM.yyyy') and DATEDIFF(YEAR, HireDate, '2026-01-07')
SELECT CONCAT(p.FirstName, ' ', p.LastName) AS [Full name],
	   e.JobTitle,
	   FORMAT(e.HireDate, 'dd.MM.yyyy') AS [Hire date], -- European date format
	   DATEDIFF(YEAR, HireDate, '2026-01-16') AS YearsOfService -- Calculating tenure from hire date to today
FROM HumanResources.Employee e 
JOIN Person.Person p 
	ON e.BusinessEntityID = p.BusinessEntityID
WHERE e.CurrentFlag = 1 -- Only list currently active employees
ORDER BY YearsOfService DESC;

/* LOGIC EXPLANATION:
   1. JOIN: 
      I linked the 'HumanResources.Employee' (job data) with 'Person.Person' (identity data) 
      using the 'BusinessEntityID' as the common key to retrieve full names.
      
   2. CONCAT:
      Combined 'FirstName' and 'LastName' into a single [Full Name] column 
      to create a more readable and professional format for HR purposes.
      
   3. FORMATTING:
      Used the FORMAT function to convert the standard database date format 
      into a user-friendly European date format ('dd.MM.yyyy').
      
   4. DATEDIFF:
      Calculated the total number of years an employee has been with the company 
      by measuring the difference between the 'HireDate' and the current report date.
      
   5. DATA CLEANING & IDENTIFIERS:
      Used square brackets [ ] for aliases with spaces and included a 
      WHERE filter to ensure only active employees (CurrentFlag = 1) are listed.
*/
