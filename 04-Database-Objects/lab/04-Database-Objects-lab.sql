/*
===============================================================================
SQL BOOTCAMP: 04-DATABASE OBJECTS (30 CHALLENGES)
PROJECT:       AdventureWorks Mastery Lab
AUTHOR:        emdej111 - Monika Jurak
DATE:          07-01-2026
DESCRIPTION:   Creating and managing Views, Stored Procedures, and Functions.
INSTRUCTIONS:  Solve each task below the comment. Use CREATE/ALTER/DROP statements.
===============================================================================
*/

-- ============================================================================
-- LEVEL 9: VIEWS (10 TASKS) - "Virtual Tables"
-- ============================================================================

-- 01. Create a View named 'vw_ProductFullInfo' that joins Product, Subcategory, and Category.
SELECT * FROM Production.Product;
SELECT * FROM Production.ProductSubcategory;
SELECT * FROM Production.ProductCategory;

-- 02. Create a View 'vw_ActiveEmployees' that only shows employees where CurrentFlag = 1.
SELECT * FROM HumanResources.Employee;

-- 03. Create a View that displays total sales (TotalDue) per Year and Month.
SELECT * FROM Sales.SalesOrderHeader;

-- 04. Create a View 'vw_CustomerContactList' showing CustomerID, FullName (from Person), and Email.
SELECT * FROM Sales.Customer;
SELECT * FROM Person.Person;
SELECT * FROM Person.EmailAddress;

-- 05. Create a View that calculates the current stock level for each product across all locations.
SELECT * FROM Production.ProductInventory;
SELECT * FROM Production.Product; -- (opcionalno, ako želiš i naziv proizvoda)

-- 06. Update an existing View using the 'ALTER VIEW' command to add a new column.
-- Za ovo koristim bilo koji View koji sam već napravila u zadacima 1-5

-- 07. Create a View that hides sensitive employee data (like BirthDate) but shows JobTitle and HireDate.
SELECT * FROM HumanResources.Employee;

-- 08. Use 'DROP VIEW' to remove a temporary test view you created.
-- Ovdje samo brišem neki svoj testni objekt, ne treba mi tablica

-- 09. Create a View with the 'SCHEMABINDING' option and research why it is used.
SELECT * FROM Production.Product; 

-- 10. Query one of your created Views and apply a WHERE filter on it like a regular table.
-- Ovdje radim SELECT nad View-om koji sam kreirala u zadatku 1 ili 4

-- ============================================================================
-- LEVEL 10: STORED PROCEDURES (10 TASKS) - "Automated Scripts"
-- ============================================================================

-- 11. Create a Procedure 'usp_GetProductsByColor' that accepts @Color as a parameter.
SELECT * FROM Production.Product;

-- 12. Write a Procedure that returns all orders placed by a specific CustomerID (passed as @CustID).
SELECT * FROM Sales.SalesOrderHeader;

-- 13. Create a Procedure 'usp_UpdateProductPrice' that updates a product's price based on its ID.
SELECT * FROM Production.Product;

-- 14. Write a Procedure that returns the total revenue for a specific year.
SELECT * FROM Sales.SalesOrderHeader;

-- 15. Create a Procedure with an OUTPUT parameter that returns the total count of active employees.
SELECT * FROM HumanResources.Employee;

-- 16. Write a Procedure 'usp_SearchEmployees' that uses the LIKE operator with a @SearchTerm parameter.
SELECT * FROM HumanResources.Employee;
SELECT * FROM Person.Person;

-- 17. Create a Procedure that inserts a new record into a (dummy) logging table.
-- Za ovo ću morati prvo stvoriti svoju malu testnu tablicu

-- 18. Write a Procedure that returns products with stock levels below a given @Threshold.
SELECT * FROM Production.ProductInventory;

-- 19. Create a Procedure that executes another procedure inside it (Nested Procedures).
-- Iskoristit proceduru iz zadatka 11 i proceduru iz zadatka 13, ne trebaju mi nove tablic

-- 20. Use 'EXEC' to run your procedures with different parameter values.
-- Samo pokrećem ono što sam napravila u prethodnim koracima

-- ============================================================================
-- LEVEL 11: USER DEFINED FUNCTIONS - UDFs (10 TASKS) - "Custom Logic"
-- ============================================================================

-- 21. Create a Scalar Function 'fn_CalculateTax' that takes a value and returns 10% tax.
-- Čista matematika, ne treba mi tablica, ali možgu testirati na SELECT ListPrice FROM Production.Product;

-- 22. Write a Function that takes a BirthDate and returns the current Age in years.
SELECT * FROM HumanResources.Employee;

-- 23. Create a Function 'fn_FormatDateEU' that converts a datetime to 'dd-MM-yyyy' string.
SELECT * FROM Sales.SalesOrderHeader; -- (bilo koja tablica s datumom, npr. OrderDate)

-- 24. Write a Function that returns the FullName when given FirstName, MiddleName, and LastName.
SELECT * FROM Person.Person;

-- 25. Create a Table-Valued Function (TVF) that returns all products for a specific CategoryID.
SELECT * FROM Production.Product;
SELECT * FROM Production.ProductSubcategory;
SELECT * FROM Production.ProductCategory;

-- 26. Write a Function that calculates the total days an employee has been with the company.
SELECT * FROM HumanResources.Employee;

-- 27. Create a Function that determines if a product is 'Expensive', 'Mid', or 'Cheap' based on price.
SELECT * FROM Production.Product; 

-- 28. Use one of your Scalar Functions inside a SELECT statement on a large table.
SELECT * FROM Production.Product; 

-- 29. Create a TVF that returns all orders for a specific territory.
SELECT * FROM Sales.SalesOrderHeader;

-- 30. Research and write a comment on the performance difference between Scalar and Inline Table-Valued Functions.
-- Ovo je čisti tekstualni komentar/istraživanje
