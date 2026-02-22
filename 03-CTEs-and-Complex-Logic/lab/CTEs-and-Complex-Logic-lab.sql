8333
	/*
===============================================================================
SQL BOOTCAMP: 03-CTEs & COMPLEX LOGIC (40 CHALLENGES)
PROJECT:       AdventureWorks Mastery Lab
AUTHOR:        emdej111 - Monika Jurak
DATE:          09-02-2026
DESCRIPTION:   Mastering Common Table Expressions (CTEs) and Window Functions.
INSTRUCTIONS:  Solve each task below the comment.
===============================================================================
*/

-- ============================================================================
-- LEVEL 7: COMMON TABLE EXPRESSIONS (CTEs) - (20 TASKS)
-- ============================================================================
-- 01. Create a CTE that finds the average product price, then use it in the main query to filter products above that average.
SELECT * FROM Production.Product;

WITH avgPrice AS (
                  SELECT AVG(ListPrice) AS GlobalAvg
                  FROM Production.Product
                  )
SELECT ProductID, 
       Name, 
       ListPrice
FROM Production.Product
WHERE ListPrice > (SELECT GlobalAvg FROM avgPrice);

-- 02. Write a CTE to calculate total sales per customer, then find customers with more than $50,000 in sales.
SELECT * FROM Sales.SalesOrderHeader;

WITH totalSalesPerCustomer AS (
                                SELECT CustomerID, 
                                       SUM(TotalDue) AS totalOrdNum
                                FROM Sales.SalesOrderHeader
                                GROUP BY CustomerID
                              )
SELECT CustomerID, 
       totalOrdNum 
FROM totalSalesPerCustomer 
WHERE totalOrdNum > 50000
ORDER BY totalOrdNum DESC;

-- 03. Use a CTE to join Person and Employee, then select only managers from that result.
SELECT * FROM Person.Person;
SELECT * FROM HumanResources.Employee;

WITH joinEmpPer AS (
                     SELECT p.FirstName,
                            p.LastName,
                            e.JobTitle
                     FROM Person.Person p
                     JOIN HumanResources.Employee e
                        ON p.BusinessEntityID = e.BusinessEntityID
                   )
SELECT CONCAT(FirstName, ' ', LastName, ' - ', JobTitle) AS ManagerProfile
FROM joinEmpPer
WHERE JobTitle LIKE '%Manager%';

-- 04. Create two CTEs: one for 'Red' products and one for 'Black' products. JOIN them on a common column (like size or category).
SELECT * FROM Production.Product;
WITH redProducts AS (
                     SELECT ProductID, Size
                     FROM Production.Product
                     WHERE Color = 'Red'
                    ),
   blackProducts AS (
                     SELECT ProductID, Size
                     FROM Production.Product
                     WHERE Color = 'Black'
                    )
SELECT r.ProductID AS RedProductID,
       b.ProductID AS BlackProductID,
       r.Size
FROM redProducts r
    JOIN blackProducts b ON r.Size = b.Size
WHERE r.Size IS NOT NULL;

-- 05. Use a CTE to calculate monthly sales for 2011, then find the month with the highest revenue.
SELECT * FROM Sales.SalesOrderHeader;

WITH mnthSales AS ( 
                   SELECT MONTH(OrderDate) AS SaleMonth,
                          SUM(TotalDue) AS TotalRevenue
                   FROM Sales.SalesOrderHeader
                   WHERE YEAR(OrderDate) = 2011       
                   GROUP BY MONTH(OrderDate)     
                  )
SELECT TOP 1 SaleMonth, 
             TotalRevenue
FROM mnthSales
ORDER BY TotalRevenue DESC;  

-- 06. Create a CTE for all employees hired in 2008 and use it to find their department names.
SELECT * FROM HumanResources.Employee;
SELECT * FROM HumanResources.EmployeeDepartmentHistory;
SELECT * FROM HumanResources.Department;

WITH hireYear AS (
                  SELECT BusinessEntityID, 
                         HireDate
                  FROM HumanResources.Employee
                  WHERE YEAR(HireDate) = 2008
                 )
SELECT hy.BusinessEntityID,
       d.Name AS DepartmentName
FROM hireYear hy 
JOIN HumanResources.EmployeeDepartmentHistory edh 
    ON hy.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department d 
    ON edh.DepartmentID = d.DepartmentID
WHERE edh.EndDate IS NULL;

-- 07. Write a CTE that lists all unique cities, then use it to count how many customers live in each city.
SELECT * FROM Person.Address;
SELECT * FROM Sales.Customer;
SELECT * FROM Person.BusinessEntityAddress;

WITH unqCity AS (
                 SELECT DISTINCT(City) 
                 FROM Person.Address
                ) --uc

SELECT uc.City,
       COUNT(c.CustomerID) AS CustomerCount
FROM unqCity uc
    JOIN Person.Address a ON uc.City = a.City
    JOIN Person.BusinessEntityAddress bea ON a.AddressID = bea.AddressID
    JOIN Sales.Customer c ON bea.BusinessEntityID = c.PersonID 
GROUP BY uc.City
ORDER BY CustomerCount DESC;

-- 08. Use a CTE to pre-calculate the total weight of orders, then filter for orders over 500kg.
SELECT * FROM Sales.SalesOrderDetail;
SELECT * FROM Production.Product;

WITH OrderWeights AS (
                      SELECT sd.SalesOrderID,
                             SUM(sd.OrderQty * ISNULL(p.Weight, 0)) AS TotalOrderWeight
                      FROM Sales.SalesOrderDetail sd
                          JOIN Production.Product p ON sd.ProductID = p.ProductID
                      GROUP BY sd.SalesOrderID
                     )
SELECT SalesOrderID, 
       TotalOrderWeight
FROM OrderWeights
WHERE TotalOrderWeight > 500
ORDER BY TotalOrderWeight DESC;

-- 09. Create a CTE that identifies products with no sales, then use it to list their current stock levels.
SELECT * FROM Production.Product;
SELECT * FROM Sales.SalesOrderDetail;
SELECT * FROM Production.ProductInventory;

WITH UnsoldProducts AS (
                        SELECT ProductID, 
                               Name
                        FROM Production.Product
                        WHERE ProductID NOT IN (
                                                SELECT DISTINCT ProductID 
                                                FROM Sales.SalesOrderDetail
                                               ) --up
                       )
SELECT up.Name AS ProductName,
       pi.Quantity AS StockLevel,
       pi.Shelf,
       pi.Bin
FROM UnsoldProducts up
    JOIN Production.ProductInventory pi ON up.ProductID = pi.ProductID
ORDER BY pi.Quantity DESC;

-- 10. Write a "Recursive CTE" to show all management levels starting from the CEO (BusinessEntityID = 1).
SELECT * FROM HumanResources.Employee;

WITH mngLevel AS (
                  SELECT BusinessEntityID, 
                         OrganizationNode,
                         JobTitle, 
                         1 AS HierarchyLevel
                  FROM HumanResources.Employee
                  WHERE BusinessEntityID = 1

                  UNION ALL

                  SELECT e.BusinessEntityID, 
                         e.OrganizationNode,
                         e.JobTitle, 
                         m.HierarchyLevel + 1
                  FROM HumanResources.Employee e
                    INNER JOIN mngLevel m ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode
                 )
SELECT HierarchyLevel,
       JobTitle,
       BusinessEntityID
FROM mngLevel
ORDER BY HierarchyLevel;

-- 11. Create a CTE for product prices with tax (10%), then find products where the taxed price is > $2000.
SELECT * FROM Production.Product;

WITH TaxedProducts AS (
                       SELECT Name,
                              ListPrice,
                              (ListPrice * 1.10) AS PriceWithTax
                       FROM Production.Product
                       WHERE ListPrice > 0 
                      )
SELECT Name, 
       ListPrice, 
       PriceWithTax
FROM TaxedProducts
WHERE PriceWithTax > 2000
ORDER BY PriceWithTax DESC;

-- 12. Use a CTE to rank territories by sales, then select only the top-performing territory.
SELECT * FROM Sales.SalesTerritory;
SELECT * FROM Sales.SalesOrderHeader;

WITH territoryBySale AS (
                         SELECT TerritoryID, 
                                Name, 
                                SalesYTD
                         FROM Sales.SalesTerritory
                        )
SELECT TOP 1 TerritoryID, 
             Name, 
             SalesYTD
FROM territoryBySale
ORDER BY SalesYTD DESC;

-- 13. Write a CTE that simplifies the join of 4 tables (Sales, Person, Address, Territory).
SELECT * FROM Sales.SalesOrderHeader;
SELECT * FROM Person.Person;
SELECT * FROM Person.Address;
SELECT * FROM Sales.SalesTerritory;

WITH DetailedOrders AS (
                        SELECT soh.SalesOrderID,
                               p.FirstName + ' ' + p.LastName AS CustomerName,
                               a.City,
                               st.Name AS TerritoryName,
                               soh.TotalDue
                        FROM Sales.SalesOrderHeader soh
                            JOIN Person.Person p ON soh.CustomerID = p.BusinessEntityID
                            JOIN Person.Address a ON soh.BillToAddressID = a.AddressID
                            JOIN Sales.SalesTerritory st ON soh.TerritoryID = st.TerritoryID
                        )
SELECT SalesOrderID,
       CustomerName,
       City,
       TerritoryName,
       TotalDue
FROM DetailedOrders
WHERE TotalDue > 5000
ORDER BY TotalDue DESC;

-- 14. Create a CTE to find the last order date for each customer, then find customers who haven't ordered in 2 years.
SELECT * FROM Sales.SalesOrderHeader;
SELECT * FROM Sales.Customer;

WITH lastCustomerOrder AS (
                           SELECT CustomerID, 
                                  MAX(OrderDate) AS LastDate 
                           FROM Sales.SalesOrderHeader
                           GROUP BY CustomerID
                          )
SELECT c.CustomerID, 
       lco.LastDate,
       DATEDIFF(YEAR, lco.LastDate, GETDATE()) AS YearsSinceLastOrder
FROM Sales.Customer c
    JOIN lastCustomerOrder lco ON c.CustomerID = lco.CustomerID
WHERE DATEDIFF(YEAR, lco.LastDate, GETDATE()) >= 2
ORDER BY lco.LastDate ASC;

-- 15. Use multiple CTEs (separated by commas) to build a complex sales report comparing 2011 and 2012.
SELECT * FROM Sales.SalesOrderHeader;

WITH Sales2011 AS (
                   SELECT TerritoryID, 
                          SUM(TotalDue) AS TotalSales2011
                   FROM Sales.SalesOrderHeader
                   WHERE YEAR(OrderDate) = 2011
                   GROUP BY TerritoryID
                  ),
    Sales2012 AS (
                  SELECT TerritoryID, 
                         SUM(TotalDue) AS TotalSales2012
                  FROM Sales.SalesOrderHeader
                  WHERE YEAR(OrderDate) = 2012
                  GROUP BY TerritoryID
                 )
SELECT st.Name AS TerritoryName,
       ISNULL(s11.TotalSales2011, 0) AS Sales2011,
       ISNULL(s12.TotalSales2012, 0) AS Sales2012,
       ISNULL(s12.TotalSales2012, 0) - ISNULL(s11.TotalSales2011, 0) AS Difference
FROM Sales.SalesTerritory st
    LEFT JOIN Sales2011 s11 ON st.TerritoryID = s11.TerritoryID
    LEFT JOIN Sales2012 s12 ON st.TerritoryID = s12.TerritoryID
ORDER BY Difference DESC;

-- 16. Create a CTE to find the average weight per category, then find products heavier than their category average.
SELECT * FROM Production.Product;
SELECT * FROM Production.ProductSubcategory;

WITH CategoryAvgWeight AS (
                           SELECT ProductSubcategoryID, 
                                  AVG(Weight) AS AvgWeight
                           FROM Production.Product
                           WHERE Weight IS NOT NULL
                           GROUP BY ProductSubcategoryID
                          )
SELECT p.Name AS ProductName,
       p.Weight AS ProductWeight,
       caw.AvgWeight AS CategoryAverage,
       p.ProductSubcategoryID
FROM Production.Product p
    JOIN CategoryAvgWeight caw ON p.ProductSubcategoryID = caw.ProductSubcategoryID
WHERE p.Weight > caw.AvgWeight 
ORDER BY p.ProductSubcategoryID, p.Weight DESC;

-- 17. Use a CTE to list all employees and their age, then group them by 10-year age buckets.
SELECT * FROM HumanResources.Employee;

WITH EmployeeAges AS (
                      SELECT BusinessEntityID,
                             DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age
                      FROM HumanResources.Employee
                     )
SELECT CAST((Age / 10) * 10 AS VARCHAR) + '-' + CAST((Age / 10) * 10 + 9 AS VARCHAR) AS AgeBucket,
       COUNT(*) AS EmployeeCount
FROM EmployeeAges
GROUP BY (Age / 10) * 10
ORDER BY AgeBucket;

-- 18. Write a CTE that finds duplicate email addresses (if any) in the system.
SELECT * FROM Person.EmailAddress;

WITH EmailCounts AS (
                     SELECT EmailAddress,
                            COUNT(*) AS OccurrenceCount
                     FROM Person.EmailAddress
                     GROUP BY EmailAddress
                    )
SELECT EmailAddress, 
       OccurrenceCount
FROM EmailCounts
WHERE OccurrenceCount > 1
ORDER BY OccurrenceCount DESC;

-- 19. Create a CTE for sales performance by salesperson, then find those who achieved > 120% of their bonus.
SELECT * FROM Sales.SalesPerson;
SELECT * FROM Sales.SalesOrderHeader;

WITH SalesPerformance AS (
                          SELECT BusinessEntityID,
                                 SalesYTD,
                                 Bonus,
                                 (SalesYTD / NULLIF(Bonus, 0)) * 100 AS BonusPerformance
                          FROM Sales.SalesPerson
                         )
SELECT BusinessEntityID,
       SalesYTD,
       Bonus,
       ROUND(BonusPerformance, 2) AS [Performance %]
FROM SalesPerformance
WHERE BonusPerformance > 120
ORDER BY BonusPerformance DESC;

-- 20. Use a CTE to clean data: format phone numbers before selecting them in the main query.
SELECT * FROM Person.PersonPhone;

WITH CleanedPhones AS (
                       SELECT BusinessEntityID,
                              PhoneNumber AS RawPhone,
                              REPLACE(REPLACE(REPLACE(PhoneNumber, '(', ''), ')', ''), '-', '') AS OnlyNumbers
                       FROM Person.PersonPhone
                       )
SELECT BusinessEntityID,
       RawPhone,
       '(' + SUBSTRING(OnlyNumbers, 1, 3) + ') ' + 
       SUBSTRING(OnlyNumbers, 4, 3) + '-' + 
       SUBSTRING(OnlyNumbers, 7, 4) AS FormattedPhone
FROM CleanedPhones;

-- ============================================================================
-- LEVEL 8: WINDOW FUNCTIONS & ANALYTICAL LOGIC (20 TASKS)
-- ============================================================================

-- 21. Use ROW_NUMBER() to number every product within its category based on price.
SELECT * FROM Production.Product;

SELECT Name, ProductSubcategoryID, ListPrice, 
	ROW_NUMBER() OVER(PARTITION BY ProductSubcategoryID ORDER BY ListPrice DESC) AS productRankInCategory
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL;

-- 22. Use RANK() to rank salespersons by their bonus amount.
SELECT * FROM Sales.SalesPerson;

SELECT BusinessEntityID, Bonus,
	RANK() OVER(ORDER BY Bonus DESC) AS bonusAmountPerSalsperson
FROM Sales.SalesPerson;

-- 23. Use DENSE_RANK() to rank products by price and notice how it differs from RANK().
SELECT * FROM Production.Product;

SELECT ProductID, Name, ListPrice,
	RANK() OVER(ORDER BY ListPrice DESC) AS NormalRank,
    DENSE_RANK() OVER(ORDER BY ListPrice DESC) AS DenseRank
FROM Production.Product;

-- 24. Calculate a "Running Total" of Sales (TotalDue) using SUM() OVER (ORDER BY OrderDate).
SELECT * FROM Sales.SalesOrderHeader;

SELECT SalesOrderID, OrderDate, TotalDue,
    SUM(TotalDue) OVER(ORDER BY OrderDate) AS RunningTotal
FROM Sales.SalesOrderHeader;

-- 25. Calculate a "Running Total" of sales per Territory (use PARTITION BY).
SELECT * FROM Sales.SalesOrderHeader;

SELECT TerritoryID, OrderDate, TotalDue,
    SUM(TotalDue) OVER(PARTITION BY TerritoryID ORDER BY OrderDate) AS totalPerTerritory
FROM Sales.SalesOrderHeader;

-- 26. Use LEAD() to show the TotalDue of the next order in the same row as the current order.
SELECT * FROM Sales.SalesOrderHeader;

SELECT SalesOrderID, OrderDate, TotalDue AS CurrentOrderAmount,
    LEAD(TotalDue) OVER(ORDER BY OrderDate) AS NextOrderAmount
FROM Sales.SalesOrderHeader;
	
-- 27. Use LAG() to compare today's order value with the previous order's value.
SELECT * FROM Sales.SalesOrderHeader;

SELECT SalesOrderID, OrderDate, TotalDue AS currentPrice,
    LAG(TotalDue) OVER(ORDER BY OrderDate) AS previousPrice,
    TotalDue - LAG(TotalDue) OVER(ORDER BY OrderDate) AS priceDifference
FROM Sales.SalesOrderHeader;

-- 28. Use FIRST_VALUE() to show the first hire in each department alongside every employee.
SELECT * FROM HumanResources.Employee;
SELECT * FROM HumanResources.EmployeeDepartmentHistory;

-- STEP 1
SELECT e.BusinessEntityID, edh.DepartmentID, e.HireDate
FROM HumanResources.Employee AS e
    JOIN HumanResources.EmployeeDepartmentHistory AS edh 
        ON e.BusinessEntityID = edh.BusinessEntityID
WHERE edh.EndDate IS NULL;

-- STEP 2
SELECT edh.DepartmentID, e.HireDate, e.BusinessEntityID
FROM HumanResources.Employee AS e
    JOIN HumanResources.EmployeeDepartmentHistory AS edh 
        ON e.BusinessEntityID = edh.BusinessEntityID
WHERE edh.EndDate IS NULL
ORDER BY edh.DepartmentID, e.HireDate ASC;

-- STEP 3
SELECT e.BusinessEntityID, 
       edh.DepartmentID, 
       e.HireDate AS MyHireDate,
    FIRST_VALUE(e.HireDate) OVER (PARTITION BY edh.DepartmentID ORDER BY e.HireDate ASC) AS FirstHireInDept
FROM HumanResources.Employee AS e
JOIN HumanResources.EmployeeDepartmentHistory AS edh 
    ON e.BusinessEntityID = edh.BusinessEntityID
WHERE edh.EndDate IS NULL
ORDER BY edh.DepartmentID;

-- 29. Use LAST_VALUE() to find the most expensive product in each category.
SELECT * FROM Production.Product;

SELECT ProductID, ProductSubcategoryID, ListPrice,
    FIRST_VALUE(ListPrice) OVER(PARTITION BY ProductSubcategoryID ORDER BY ListPrice DESC) AS mostExpensiveProduct
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL;

-- 30. Calculate a 3-month "Moving Average" of sales revenue.
SELECT * FROM Sales.SalesOrderHeader;

-- 31. Divide products into 4 price quartiles using NTILE(4).
SELECT * FROM Production.Product;

-- 32. Find the percentage of total sales each territory contributes using SUM() OVER().
SELECT * FROM Sales.SalesOrderHeader;

-- 33. Use ROW_NUMBER() to find only the most recent order for every customer without using a subquery.
SELECT * FROM Sales.SalesOrderHeader;

-- 34. Calculate the difference in days between the current and previous order for each customer (LAG).
SELECT * FROM Sales.SalesOrderHeader;

-- 35. Rank employees by their length of service within each department.
SELECT * FROM HumanResources.Employee;
SELECT * FROM HumanResources.EmployeeDepartmentHistory;

-- 36. Use AVG() OVER() to compare each product's price to the overall company average in the same row.
SELECT * FROM Production.Product;

-- 37. Find the gap between a salesperson's sales and the salesperson ranked immediately above them.
SELECT * FROM Sales.SalesPerson;

-- 38. Use NTILE(10) to find the top 10% of customers by spending.
SELECT * FROM Sales.SalesOrderHeader;

-- 39. Combine CTEs and Window Functions: Rank monthly sales growth year-over-year.
SELECT * FROM Sales.SalesOrderHeader;

-- 40. Calculate the "Percent Rank" of products by weight within their subcategory.
SELECT * FROM Production.Product;
