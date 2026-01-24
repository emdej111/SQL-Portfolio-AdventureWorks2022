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
