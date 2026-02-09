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
