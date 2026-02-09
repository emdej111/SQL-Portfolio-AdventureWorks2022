/*
===============================================================================
SQL BOOTCAMP: 02-ADVANCED FILTERING & SUBQUERIES (40 CHALLENGES)
PROJECT:       AdventureWorks Mastery Lab
AUTHOR:        emdej111 - Monika Jurak
DATE:          07-01-2026
DESCRIPTION:   Mastering nested queries, set operators, and complex filtering.
INSTRUCTIONS:  Solve each task below the comment.
===============================================================================
*/

-- ============================================================================
-- LEVEL 5: SUBQUERIES (NESTED SELECTS) - (20 TASKS)
-- ============================================================================

-- 01. Find all products whose ListPrice is greater than the average ListPrice of all products.
SELECT * FROM Production.Product;
SELECT ProductID, 
	   Name, 
	   ProductNumber 
FROM Production.Product
WHERE ListPrice > (SELECT AVG(ListPrice) FROM Production.Product);

-- 02. List names of products that have been sold at least once (Use IN with a subquery on SalesOrderDetail).
SELECT * FROM Production.Product;
SELECT * FROM Sales.SalesOrderDetail;

SELECT Name FROM Production.Product WHERE ProductID IN (SELECT ProductID FROM Sales.SalesOrderDetail);
/* LOGIC EXPLANATION:
   1. IN Operator: 
      Used the 'IN' operator to check if a ProductID exists within the 
      collection of IDs returned by the SalesOrderDetail subquery.
      
   2. RELATIONAL ACCURACY: 
      Mapped ProductID to ProductID. This ensures the filter is comparing 
      identical attributes (Product Identifiers) rather than mixing 
      IDs with Quantities.
      
   3. DATA MINIMIZATION: 
      This approach is efficient because the subquery only needs to 
      return a list of IDs, allowing the outer query to handle the 
      final formatting of Product Names.
*/

-- 03. Find the names of employees who have the same JobTitle as 'Ken Sanchez' (BusinessEntityID = 1).
SELECT * FROM HumanResources.Employee;
SELECT * FROM Person.Person;

SELECT BusinessEntityID, FirstName, LastName FROM Person.Person 
WHERE BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee
                           WHERE JobTitle = (SELECT JobTitle FROM HumanResources.Employee 
                                             WHERE BusinessEntityID = 1));

-- 04. Use a subquery in the SELECT clause to show each product's price vs. the maximum price in the table.
SELECT * FROM Production.Product;

SELECT ProductID, 
       Name,
       StandardCost,
       (SELECT Max(StandardCost) FROM Production.Product) AS MaxPrice
FROM Production.Product;

-- 05. Find customers who have placed more than 10 orders (Use a subquery in the WHERE clause).
SELECT * FROM Sales.Customer;
SELECT * FROM Sales.SalesOrderHeader;

SELECT CustomerID FROM Sales.Customer
WHERE CustomerID IN (
        SELECT CustomerID 
        FROM Sales.SalesOrderHeader
        GROUP BY CustomerID
        HAVING COUNT(*) > 10);

/* LOGIC EXPLANATION:
   1. DATA AGGREGATION: 
      The subquery processes the sales history by grouping rows based on 
      CustomerID. This transforms individual transaction data into 
      customer-level summaries.
      
   2. HAVING: 
      Used the HAVING clause to filter the grouped data. Unlike WHERE, 
      HAVING allows us to apply conditions to the result of an aggregate 
      function (COUNT).
      
   3. IDENTIFIER MATCHING: 
      The 'IN' operator compares the primary key (CustomerID) of the Customer 
      table with the list of foreign keys filtered by the subquery.
*/

-- 06. Find products that have never been ordered (Use NOT IN with a subquery on SalesOrderDetail).
SELECT * FROM Production.Product;
SELECT * FROM Sales.SalesOrderDetail;

SELECT ProductID, Name FROM Production.Product
WHERE ProductID NOT IN (SELECT ProductID FROM Sales.SalesOrderDetail);

-- 07. Find the salesperson(s) with the highest bonus (Use a subquery to find MAX bonus).
SELECT * FROM Sales.SalesPerson;

SELECT BusinessEntityID FROM Sales.SalesPerson
WHERE Bonus = (SELECT MAX(Bonus) FROM Sales.SalesPerson);
/* TECHNICAL NOTE: 
   - Used the '=' operator because 'Bonus' is a numeric (Money) data type. 
   - The '=' operator is precise and faster for exact numeric matches.
   - 'LIKE' is reserved for pattern matching in text (Strings) and should 
     be avoided for financial or numerical comparisons to prevent 
     unnecessary data type conversion.
*/

-- 08. List products that belong to the 'Bikes' category (Get CategoryID via subquery from ProductCategory).
SELECT * FROM Production.Product;
SELECT * FROM Production.ProductCategory;
SELECT * FROM Production.ProductSubcategory;

SELECT Name, 
       ProductNumber
FROM Production.Product
WHERE ProductSubcategoryID IN ( SELECT ProductSubcategoryID 
                                FROM Production.ProductSubcategory
                                WHERE ProductCategoryID = (SELECT ProductCategoryID 
                                                           FROM Production.ProductCategory 
                                                           WHERE Name = 'Bikes'));

-- 09. Find orders where the TotalDue is higher than the average TotalDue for that specific year.
SELECT * FROM Sales.SalesOrderHeader;

SELECT SalesOrderID, OrderDate, TotalDue
FROM Sales.SalesOrderHeader AS O
WHERE TotalDue > (SELECT AVG(TotalDue) FROM Sales.SalesOrderHeader
                  WHERE YEAR(OrderDate) = YEAR(O.OrderDate));

/* LOGIC EXPLANATION:
   1. CORRELATED SUBQUERY: The subquery is linked to the outer query via the 
      alias 'O'. It calculates the average 'TotalDue' dynamically for 
      each year.

   2. ROW-BY-ROW VALIDATION: Instead of one global average, this query 
      compares each order against the average of its own specific year.

   3. ALIASING: Using 'O' as an alias prevents the database from confusing 
      the 'OrderDate' of the current row with the 'OrderDate' of the 
      entire table being averaged.
*/

-- 10. List all persons who are also recorded as Employees (Use IN with BusinessEntityID).
SELECT * FROM Person.Person;
SELECT * FROM HumanResources.Employee;

SELECT CONCAT(FirstName, ' ', LastName) AS Name FROM Person.Person 
WHERE BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.Employee);

-- 11. Find products whose price is higher than the average price of products in subcategory 1.
SELECT * FROM Production.Product;

SELECT ProductID, Name, ListPrice FROM Production.Product 
WHERE ListPrice > (SELECT AVG(ListPrice) FROM Production.Product 
                   WHERE ProductSubcategoryID = 1);

-- 12. Show the Name of the product and its total quantity sold (Use a subquery in the SELECT clause).
SELECT * FROM Production.Product;
SELECT * FROM Sales.SalesOrderDetail;

SELECT ProductID, 
       Name,
       (SELECT SUM(OrderQty) FROM Sales.SalesOrderDetail WHERE ProductID = p.ProductID ) AS TotalQuantitySold
FROM Production.Product AS p;

/* LOGIC EXPLANATION:
   1. CORRELATED SELECT SUBQUERY: 
      The subquery is linked to the outer query via 'p.ProductID'. This 
      ensures that for every product row, SQL calculates a custom sum 
      based only on that specific product's sales history.
      
   2. SCALAR RESULT: 
      By using SUM(OrderQty) inside the parentheses, the subquery returns 
       a single numeric value for each row, making it compatible with 
      the SELECT list.
      
   3. NULL HANDLING: 
      Note that products that were never sold will return 'NULL' here. 
      In a real-world scenario, we might use ISNULL(..., 0) to show 0 
      instead of NULL for unsold items.
*/

-- 13. Find the most recent order date for each customer (Use a correlated subquery).
SELECT * FROM Sales.Customer;
SELECT * FROM Sales.SalesOrderHeader;

SELECT c.CustomerID,
      (SELECT MAX(OrderDate) FROM Sales.SalesOrderHeader WHERE CustomerID = c.CustomerID) AS MostRecentOrderDate
FROM Sales.Customer AS c;

/* LOGIC EXPLANATION:
   1. CORRELATED AGGREGATION: 
      The subquery runs for every customer in the 'Sales.Customer' table. 
      It "looks out" to the main query using 'c.CustomerID' to filter the 
      orders for that specific individual.
      
   2. SCALAR LIMITATION: 
      A subquery inside a SELECT clause must return a single value. Using 
      'MAX(OrderDate)' ensures we get one date per customer, avoiding errors.
      
   3. DATA COVERAGE: 
      This query includes all customers, even those without orders. For 
      customers with no purchase history, the result will be NULL, which 
      accurately reflects the lack of data in 'SalesOrderHeader'.
*/

-- 14. List departments that have more than 5 employees (Subquery on EmployeeDepartmentHistory).
SELECT * FROM HumanResources.Department;
SELECT * FROM HumanResources.EmployeeDepartmentHistory;

SELECT DepartmentID, Name 
FROM HumanResources.Department
WHERE SUM(DepartmentID) > (SELECT DepartmentID FROM HumanResources.EmployeeDepartmentHistory);

SELECT DepartmentID, Name FROM HumanResources.Department
WHERE DepartmentID IN ( SELECT DepartmentID FROM HumanResources.EmployeeDepartmentHistory
                        GROUP BY DepartmentID HAVING COUNT(*) > 5);

/* LOGIC EXPLANATION:
   1. IN: 
      The outer query only selects Departments whose ID exists in the 
      filtered list generated by the subquery.
      
   2. AGGREGATION IN SUBQUERY: 
      We used 'GROUP BY DepartmentID' inside the subquery to collect 
      employees into their respective departments before counting them.
      
   3. HAVING: 
      The 'HAVING COUNT(*) > 5' clause is used instead of WHERE because 
      we are filtering based on a calculation (the number of employees) 
      rather than a raw column value.
*/

-- 15. Find employees who earn more than the average rate in their specific department.
SELECT * FROM HumanResources.EmployeePayHistory;
SELECT * FROM HumanResources.EmployeeDepartmentHistory;

SELECT BusinessEntityID, Rate
FROM HumanResources.EmployeePayHistory AS MainTable
WHERE Rate > (SELECT AVG(Rate) FROM HumanResources.EmployeePayHistory AS Subquery
              WHERE Subquery.BusinessEntityID IN (SELECT BusinessEntityID FROM HumanResources.EmployeeDepartmentHistory 
                                                  WHERE DepartmentID = 1));
/* LOGIC SUMMARY:
   1. The outer query picks one person at a time.
   2. The inner query calculates the average 
      ONLY for that person's specific department.
   3. The 'WHERE outer.ID = inner.ID' is the link 
      that makes the calculation dynamic for every row.
*/

-- 16. Find the name of the territory with the lowest total sales.
SELECT * FROM Sales.SalesTerritory;
SELECT * FROM Sales.SalesOrderHeader;

SELECT Name FROM Sales.SalesTerritory
WHERE TerritoryID IN (SELECT TOP 1 TerritoryID FROM Sales.SalesOrderHeader
                      GROUP BY TerritoryID
                      ORDER BY SUM(TotalDue) ASC);

/* LOGIC EXPLANATION:
   1. Inside the subquery, we group all orders by 'TerritoryID' and sum their 
      'TotalDue'. By ordering them in ascending order (ASC), the territory 
      with the lowest sales rises to the top.
      
   2. The 'TOP 1' clause isolates the single "worst-performing" TerritoryID 
      based on the sum of sales.
      
   3. The outer query takes that specific ID and looks up its human-readable 
      'Name' in the SalesTerritory table.
*/

-- 17. List products that have a standard cost lower than the product with ProductID = 707.
SELECT * FROM Production.Product;

SELECT ProductID, Name, StandardCost FROM Production.Product
WHERE StandardCost < (SELECT StandardCost FROM Production.Product 
                      WHERE ProductID = 707);

/* LOGIC EXPLANATION:
   1. The subquery acts as a dynamic reference point. Instead of manually 
      typing a number (e.g., WHERE StandardCost < 12.50), we let SQL 
      find the current cost of Product 707.
      
   2. Because the inner query returns exactly one value (the cost of one ID), 
      we can use the standard less-than operator (<).
      
   3. If the cost of Product 707 changes in the database tomorrow, this 
      query will automatically adjust its results without any code changes.
*/

-- 18. Find the top 3 selling products for each territory (Harder - requires thinking about correlated subqueries).
SELECT * FROM Sales.SalesTerritory;
SELECT * FROM Sales.SalesOrderHeader;
SELECT * FROM Sales.SalesOrderDetail;

SELECT ST.Name AS TerritoryName,
       P.Name AS ProductName,
      (SELECT SUM(SOD.OrderQty) FROM Sales.SalesOrderDetail AS SOD
            JOIN Sales.SalesOrderHeader AS SOH ON SOD.SalesOrderID = SOH.SalesOrderID
            WHERE SOH.TerritoryID = ST.TerritoryID AND SOD.ProductID = P.ProductID) AS TotalSold
FROM Sales.SalesTerritory AS ST 
    CROSS JOIN Production.Product AS P
    WHERE P.ProductID IN (SELECT TOP 3 InnerSOD.ProductID
                          FROM Sales.SalesOrderDetail AS InnerSOD
                                JOIN Sales.SalesOrderHeader AS InnerSOH ON InnerSOD.SalesOrderID = InnerSOH.SalesOrderID
                                WHERE InnerSOH.TerritoryID = ST.TerritoryID
                                GROUP BY InnerSOD.ProductID
                                ORDER BY SUM(InnerSOD.OrderQty) DESC)
ORDER BY ST.Name, TotalSold DESC;

/* DETAILED LOGIC STEP-BY-STEP:
   1. TERRITORY ITERATION: 
      The outer query iterates through each record in Sales.SalesTerritory. 
      For every territory, it initiates a fresh search.
      
   2. LOCALIZED AGGREGATION: 
      The subquery performs a heavy calculation: it joins SalesOrderHeader 
      and SalesOrderDetail to sum up 'OrderQty' specifically for the 
      TerritoryID currently provided by the outer query.
      
   3. THE "TOP 3" BUCKET: 
      By using 'ORDER BY SUM(...) DESC' and 'TOP 3' inside the subquery, 
      we create a dynamic "winners list" that changes every time the 
      outer query moves to a new territory.
      
   4. DATA LINKAGE: 
      The 'IN' operator compares each product from the main list against 
      the "winners list" of the current territory. If the product is not 
      among the top 3 sellers for THAT specific area, it is discarded 
      from the final result.
      
   5. PERFORMANCE NOTE: 
      This is a "row-by-row" logic (O(N*M)). While readable and logically 
      sound for learning subqueries, in production environments with 
      millions of rows, this would be replaced by Window Functions 
      (RANK/ROW_NUMBER) for better performance.
*/

-- 19. Show each SalesOrderID and the name of the person who placed it (Subquery on Person).
SELECT * FROM Sales.SalesOrderHeader;
SELECT * FROM Person.Person;

SELECT SalesOrderID, 
       OrderDate,
      (SELECT FirstName + ' ' + LastName FROM Person.Person WHERE BusinessEntityID = SOH.CustomerID) AS CustomerName
FROM Sales.SalesOrderHeader AS SOH;

/* LOGIC EXPLANATION:
   1. The subquery acts like a "VLOOKUP" in Excel. For every SalesOrderID, 
      it executes a search in the Person table.
      
   2. The 'WHERE BusinessEntityID = SOH.CustomerID' is the bridge. It tells 
      SQL: "Find the person whose ID matches the CustomerID of THIS 
      specific order."
      
   3. Because the subquery is in the SELECT clause, it must return exactly 
      one value (the concatenated Name) to fit into the result grid.
*/

-- 20. Find customers who placed an order in 2011 but NOT in 2012.
SELECT * FROM Sales.Customer;
SELECT * FROM Sales.SalesOrderHeader;

SELECT DISTINCT CustomerID FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2011
AND CustomerID NOT IN (SELECT CustomerID FROM Sales.SalesOrderHeader WHERE YEAR(OrderDate) = 2012);

/* LOGIC EXPLANATION:
   1. The outer query defines our starting set: everyone who was active 
      during the year 2011.
      
   2. The 'NOT IN' subquery creates a "blacklist" of IDs. If a customer 
      appears in the 2012 sales data, they are disqualified from the 
      final result, even if they bought something in 2011.
      
   3. This is a classic way to identify "churned" customers—people who 
      used to buy from us but stopped in the following period.
*/

-- ============================================================================
-- LEVEL 6: SET OPERATORS & EXISTENCE CHECKS (20 TASKS)
-- ============================================================================
-- 21. Use UNION to combine a list of all Product Names and all Category Names into one column.
SELECT Name FROM Production.Product
UNION
SELECT Name FROM Production.ProductCategory;

-- 22. Use UNION ALL to combine the same list and notice the difference in record count.
SELECT Name FROM Production.Product
UNION ALL
SELECT Name FROM Production.ProductCategory;

-- 23. Use INTERSECT to find BusinessEntityIDs that appear in both the Employee and SalesPerson tables.
SELECT BusinessEntityID FROM HumanResources.Employee
INTERSECT
SELECT BusinessEntityID FROM Sales.SalesPerson;

-- 24. Use EXCEPT to find BusinessEntityIDs that are Employees but NOT SalesPersons.
SELECT BusinessEntityID FROM HumanResources.Employee
EXCEPT
SELECT BusinessEntityID FROM Sales.SalesPerson;

-- 25. Use EXISTS to find all products that have a recorded inventory level in Production.ProductInventory.
SELECT ProductID, Name 
FROM Production.Product AS p
WHERE EXISTS (SELECT 1 FROM Production.ProductInventory AS i WHERE i.ProductID = p.ProductID);

-- 26. Use NOT EXISTS to find products that have NO inventory records.
SELECT p.ProductID, p.Name 
FROM Production.Product AS p
WHERE NOT EXISTS (SELECT 1 FROM Production.ProductInventory AS i WHERE i.ProductID = p.ProductID);

-- 27. Combine a list of FirstNames from Person and JobTitles from Employee into one result set (UNION).
SELECT FirstName AS CombinedData FROM Person.Person
UNION
SELECT JobTitle FROM HumanResources.Employee;

-- 28. Find cities where both a Customer and a Vendor are located (INTERSECT on Address/City).
SELECT City FROM Person.Address WHERE AddressID IN (SELECT AddressID FROM Person.BusinessEntityAddress WHERE BusinessEntityID IN (SELECT BusinessEntityID FROM Sales.Customer))
INTERSECT
SELECT City FROM Person.Address WHERE AddressID IN (SELECT AddressID FROM Person.BusinessEntityAddress WHERE BusinessEntityID IN (SELECT BusinessEntityID FROM Purchasing.Vendor));

-- 29. List all products that are NOT 'Red' and also NOT 'Black' (Using EXCEPT).
SELECT Name FROM Production.Product
EXCEPT
SELECT Name FROM Production.Product WHERE Color IN ('Red', 'Black');

-- 30. Use EXISTS to find customers who have placed at least one order with a TotalDue > 10000.
SELECT CustomerID FROM Sales.Customer AS C
WHERE EXISTS (SELECT 1 FROM Sales.SalesOrderHeader AS SOH WHERE SOH.CustomerID = C.CustomerID AND SOH.TotalDue > 10000);

-- 31. Create a union of all 'Silver' products and all 'Black' products.
SELECT Name, Color FROM Production.Product WHERE Color = 'Silver'
UNION
SELECT Name, Color FROM Production.Product WHERE Color = 'Black';

-- 32. Find names of employees who have NEVER changed their department (Use NOT EXISTS on History table).
SELECT p.FirstName, p.LastName FROM Person.Person AS p
WHERE EXISTS (SELECT 1 FROM HumanResources.Employee AS e WHERE e.BusinessEntityID = p.BusinessEntityID)
AND NOT EXISTS (SELECT 1 FROM HumanResources.EmployeeDepartmentHistory AS edh 
                WHERE edh.BusinessEntityID = p.BusinessEntityID 
                GROUP BY edh.BusinessEntityID HAVING COUNT(*) > 1);

-- 33. Find territories that have sales in 2013 but had NO sales in 2011 (EXCEPT).
SELECT TerritoryID FROM Sales.SalesOrderHeader WHERE YEAR(OrderDate) = 2013
EXCEPT
SELECT TerritoryID FROM Sales.SalesOrderHeader WHERE YEAR(OrderDate) = 2011;

-- 34. Use UNION to list all distinct cities/names from Person.Address and Sales.SalesTerritory tables.
SELECT City FROM Person.Address
UNION
SELECT Name FROM Sales.SalesTerritory;

-- 35. Find products sold in territory 1 but not in territory 10 (EXCEPT).
SELECT ProductID FROM Sales.SalesOrderDetail AS SOD 
JOIN Sales.SalesOrderHeader AS SOH ON SOD.SalesOrderID = SOH.SalesOrderID WHERE SOH.TerritoryID = 1
EXCEPT
SELECT ProductID FROM Sales.SalesOrderDetail AS SOD 
JOIN Sales.SalesOrderHeader AS SOH ON SOD.SalesOrderID = SOH.SalesOrderID WHERE SOH.TerritoryID = 10;

-- 36. Use EXISTS to find products that were sold in the month of December.
SELECT p.ProductID, p.Name FROM Production.Product AS p
WHERE EXISTS (SELECT 1 FROM Sales.SalesOrderDetail AS sod 
              JOIN Sales.SalesOrderHeader AS soh ON sod.SalesOrderID = soh.SalesOrderID 
              WHERE sod.ProductID = p.ProductID AND MONTH(soh.OrderDate) = 12);

-- 37. List all managers (BusinessEntityID) who have at least one direct report (EXISTS on Employee table).
-- Note: In AdventureWorks, hierarchy is tracked via OrganizationNode.
SELECT BusinessEntityID, JobTitle FROM HumanResources.Employee AS e
WHERE EXISTS (SELECT 1 FROM HumanResources.Employee AS sub 
              WHERE sub.OrganizationNode.GetAncestor(1) = e.OrganizationNode);

-- 38. Use INTERSECT to find colors that exist in both 'Finished Goods' and 'Components'.
SELECT Color FROM Production.Product WHERE FinishedGoodsFlag = 1 AND Color IS NOT NULL
INTERSECT
SELECT Color FROM Production.Product WHERE FinishedGoodsFlag = 0 AND Color IS NOT NULL;

-- 39. Use UNION to create a master list of all unique IDs (BusinessEntityID) from Person, Employee, and Vendor.
SELECT BusinessEntityID FROM Person.Person
UNION
SELECT BusinessEntityID FROM HumanResources.Employee
UNION
SELECT BusinessEntityID FROM Purchasing.Vendor;

-- 40. Find orders where all items in the order have a unit price > 100 (Use NOT EXISTS to find orders where NO item is <= 100).
SELECT SalesOrderID FROM Sales.SalesOrderHeader AS SOH
WHERE NOT EXISTS (SELECT 1 FROM Sales.SalesOrderDetail AS SOD 
                  WHERE SOD.SalesOrderID = SOH.SalesOrderID AND SOD.UnitPrice <= 100);
