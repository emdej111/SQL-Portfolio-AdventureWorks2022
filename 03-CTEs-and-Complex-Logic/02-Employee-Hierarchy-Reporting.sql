/*
===============================================================================
FILE NAME:    02-Employee-Hierarchy-Reporting.sql
PROJECT:      AdventureWorks HR Audit
AUTHOR:       emdej111 - Monika Jurak
DATE:         09-02-2026
DESCRIPTION:  Visualizing organizational management levels via Self-Joins.
===============================================================================
1. GOAL:       Create a flat list of all employees and their direct supervisors.
2. TABLES:     HumanResources.Employee, Person.Person.
3. LOGIC:      - Perform a Self-Join on HumanResources.Employee using 
                 OrganizationNode.GetAncestor(1).
               - Join the Person table twice: once for the employee's name 
                 and once for the manager's name.
               - Handle the CEO (top level) where no manager exists using COALESCE.
===============================================================================
*/

SELECT * FROM HumanResources.Employee;
SELECT * FROM Person.Person;

-- STEP 1: Join Employee table to itself to match Employees with Managers
WITH EmployeeBase AS (
                      SELECT e.BusinessEntityID AS EmployeeID,
                             e.JobTitle,
                             e.OrganizationNode,
                             m.BusinessEntityID AS ManagerID
                      FROM HumanResources.Employee e
                        LEFT JOIN HumanResources.Employee m 
                            ON m.OrganizationNode = e.OrganizationNode.GetAncestor(1)
                      )
-- STEP 2: Join Person table twice to get full names for both parties
SELECT eb.EmployeeID,
       p_emp.FirstName + ' ' + p_emp.LastName AS EmployeeName,
       eb.JobTitle,
       COALESCE(p_man.FirstName + ' ' + p_man.LastName, 'TOP LEVEL (CEO)') AS ManagerName
FROM EmployeeBase eb
    -- First join to Person for the Employee's name
    JOIN Person.Person p_emp 
        ON eb.EmployeeID = p_emp.BusinessEntityID
    -- Second join to Person for the Manager's name (LEFT JOIN is crucial here)
    LEFT JOIN Person.Person p_man 
        ON eb.ManagerID = p_man.BusinessEntityID
ORDER BY eb.OrganizationNode; -- Sorting by hierarchy level
