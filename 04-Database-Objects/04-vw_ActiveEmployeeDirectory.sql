/*
===============================================================================
FILE NAME:    04-vw_ActiveEmployeeDirectory.sql
PROJECT:      AdventureWorks Security & Compliance
AUTHOR:       emdej111 - Monika Jurak
DATE:         24-01-2026
DESCRIPTION:  Security-focused view limiting exposure of sensitive HR data.
===============================================================================
1. GOAL:       Provide a public directory of current staff for internal use.
2. TABLES:     HumanResources.Employee, Person.Person, HumanResources.Department.
3. LOGIC:      - Join name, job title, and department.
               - Filter only for current employees (CurrentFlag = 1).
               - Exclude sensitive columns (SSN, BirthDate, PayRate).
===============================================================================
*/

SELECT * FROM HumanResources.Employee;
SELECT * FROM Person.Person;
