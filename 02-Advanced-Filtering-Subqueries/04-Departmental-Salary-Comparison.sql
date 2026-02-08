/*
===============================================================================
FILE NAME:   04-Departmental-Salary-Comparison.sql
PROJECT:     AdventureWorks HR Audit
AUTHOR:      emdej111 - Monika Jurak
DATE:        24-01-2026
DESCRIPTION: Comparing individual pay rates against departmental averages.
===============================================================================
1. GOAL:       Show employee salaries side-by-side with their department's mean.
2. TABLES:     HumanResources.EmployeePayHistory, 
               HumanResources.EmployeeDepartmentHistory.
3. LOGIC:      - Select the employee ID and their Rate.
               - Create a subquery in the SELECT list (correlated subquery) 
                 that calculates the average rate for the department the 
                 current employee belongs to.
               - Filter for only current employees (EndDate IS NULL).
===============================================================================
*/

SELECT 
    eph.BusinessEntityID,
    eph.Rate AS EmployeeRate,
    edh.DepartmentID,
    (
        SELECT AVG(eph2.Rate)
        FROM HumanResources.EmployeePayHistory AS eph2
        JOIN HumanResources.EmployeeDepartmentHistory AS edh2 
            ON eph2.BusinessEntityID = edh2.BusinessEntityID
        WHERE edh2.DepartmentID = edh.DepartmentID  -- The Correlation
          AND edh2.EndDate IS NULL
    ) AS DepartmentAverage
FROM HumanResources.EmployeePayHistory AS eph
JOIN HumanResources.EmployeeDepartmentHistory AS edh 
    ON eph.BusinessEntityID = edh.BusinessEntityID
WHERE edh.EndDate IS NULL;
