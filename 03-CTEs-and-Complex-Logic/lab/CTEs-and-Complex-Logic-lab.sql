/*
===============================================================================
SQL BOOTCAMP: 03-CTEs & COMPLEX LOGIC (40 CHALLENGES)
PROJECT:       AdventureWorks Mastery Lab
AUTHOR:        emdej111 - Monika Jurak
DATE:          07-01-2026
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

SELECT p.ProductID, 
       p.Name,
       p.ListPrice
FROM Production.Product p, avgPrice a
WHERE p.ListPrice > a.GlobalAvg
ORDER BY p.ListPrice DESC; 

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

-- 07. Write a CTE that lists all unique cities, then use it to count how many customers live in each city.
SELECT * FROM Person.Address;
SELECT * FROM Sales.Customer;
SELECT * FROM Person.BusinessEntityAddress;

-- 08. Use a CTE to pre-calculate the total weight of orders, then filter for orders over 500kg.
SELECT * FROM Sales.SalesOrderDetail;
SELECT * FROM Production.Product;

-- 09. Create a CTE that identifies products with no sales, then use it to list their current stock levels.
SELECT * FROM Production.Product;
SELECT * FROM Sales.SalesOrderDetail;
SELECT * FROM Production.ProductInventory;

-- 10. Write a "Recursive CTE" to show all management levels starting from the CEO (BusinessEntityID = 1).
SELECT * FROM HumanResources.Employee;

-- 11. Create a CTE for product prices with tax (10%), then find products where the taxed price is > $2000.
SELECT * FROM Production.Product;

-- 12. Use a CTE to rank territories by sales, then select only the top-performing territory.
SELECT * FROM Sales.SalesTerritory;
SELECT * FROM Sales.SalesOrderHeader;

-- 13. Write a CTE that simplifies the join of 4 tables (Sales, Person, Address, Territory).
SELECT * FROM Sales.SalesOrderHeader;
SELECT * FROM Person.Person;
SELECT * FROM Person.Address;
SELECT * FROM Sales.SalesTerritory;

-- 14. Create a CTE to find the last order date for each customer, then find customers who haven't ordered in 2 years.
SELECT * FROM Sales.SalesOrderHeader;
SELECT * FROM Sales.Customer;

-- 15. Use multiple CTEs (separated by commas) to build a complex sales report comparing 2011 and 2012.
SELECT * FROM Sales.SalesOrderHeader;

-- 16. Create a CTE to find the average weight per category, then find products heavier than their category average.
SELECT * FROM Production.Product;
SELECT * FROM Production.ProductSubcategory;

-- 17. Use a CTE to list all employees and their age, then group them by 10-year age buckets.
SELECT * FROM HumanResources.Employee;

-- 18. Write a CTE that finds duplicate email addresses (if any) in the system.
SELECT * FROM Person.EmailAddress;

-- 19. Create a CTE for sales performance by salesperson, then find those who achieved > 120% of their bonus.
SELECT * FROM Sales.SalesPerson;
SELECT * FROM Sales.SalesOrderHeader;

-- 20. Use a CTE to clean data: format phone numbers before selecting them in the main query.
SELECT * FROM Person.PersonPhone;

-- ============================================================================
-- LEVEL 8: WINDOW FUNCTIONS & ANALYTICAL LOGIC (20 TASKS)
-- ============================================================================

-- 21. Use ROW_NUMBER() to number every product within its category based on price.
-- 22. Use RANK() to rank salespersons by their bonus amount.
-- 23. Use DENSE_RANK() to rank products by price and notice how it differs from RANK().
-- 24. Calculate a "Running Total" of Sales (TotalDue) using SUM() OVER (ORDER BY OrderDate).
-- 25. Calculate a "Running Total" of sales per Territory (use PARTITION BY).
-- 26. Use LEAD() to show the TotalDue of the next order in the same row as the current order.
-- 27. Use LAG() to compare today's order value with the previous order's value.
-- 28. Use FIRST_VALUE() to show the first hire in each department alongside every employee.
-- 29. Use LAST_VALUE() to find the most expensive product in each category.
-- 30. Calculate a 3-month "Moving Average" of sales revenue.
-- 31. Divide products into 4 price quartiles using NTILE(4).
-- 32. Find the percentage of total sales each territory contributes using SUM() OVER().
-- 33. Use ROW_NUMBER() to find only the most recent order for every customer without using a subquery.
-- 34. Calculate the difference in days between the current and previous order for each customer (LAG).
-- 35. Rank employees by their length of service within each department.
-- 36. Use AVG() OVER() to compare each product's price to the overall company average in the same row.
-- 37. Find the gap between a salesperson's sales and the salesperson ranked immediately above them.
-- 38. Use NTILE(10) to find the top 10% of customers by spending.
-- 39. Combine CTEs and Window Functions: Rank monthly sales growth year-over-year.
-- 40. Calculate the "Percent Rank" of products by weight within their subcategory.
