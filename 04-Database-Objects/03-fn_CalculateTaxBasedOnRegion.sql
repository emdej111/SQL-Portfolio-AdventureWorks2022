/*
===============================================================================
FILE NAME:    03-fn_CalculateTaxBasedOnRegion.sql
PROJECT:      AdventureWorks Financial Logic
AUTHOR:       emdej111 - Monika Jurak
DATE:         24-01-2026
DESCRIPTION:  Custom function for localized tax calculations based on country codes.
===============================================================================
1. GOAL:       Encapsulate tax logic in a reusable function for all financial reports.
2. TABLES:     None (Input driven calculation).
3. LOGIC:      - Create a FUNCTION that takes @BasePrice and @CountryCode.
               - Use a CASE statement to apply different tax rates.
               - Returns the calculated Total Price.
===============================================================================
*/

SELECT ListPrice, 
       CASE WHEN ProductNumber LIKE 'CA%' THEN ListPrice * 1.15 ELSE ListPrice * 1.10 END AS TaxTest
FROM Production.Product;
