/* ===============================================================================
SQL BOOTCAMP: 01-FOUNDATIONS (100 CHALLENGES)
PROJECT:      AdventureWorks Mastery Lab - Part II
AUTHOR:       emdej111 - Monika Jurak
DATE:         11-01-2026
DESCRIPTION:  100 brand new, unique tasks focused on advanced filtering, 
              complex string/date manipulation, and relational joins.
=============================================================================== */

-- ============================================================================
-- LEVEL 1: DATA EXPLORATION & FILTERING (01 - 20)
-- ============================================================================

-- 01. Retrieve all records from the Purchasing.Vendor table.
SELECT * FROM Purchasing.Vendor;

-- 02. Find vendors with a CreditRating greater than 1.
SELECT * FROM Purchasing.Vendor WHERE CreditRating > 1;

-- 03. Display the Name and GroupName of all departments in HumanResources.Department.
SELECT Name, GroupName FROM HumanResources.Department;

-- 04. List all addresses in Person.Address where AddressLine2 is NULL.
SELECT * FROM Person.Address WHERE AddressLine2 IS NULL;

-- 05. Find sales orders in Sales.SalesOrderHeader where the Freight cost exceeds 500.
SELECT * FROM Sales.SalesOrderHeader WHERE Freight > 500;

-- 06. Retrieve all currencies from Sales.Currency that contain the word 'Dollar' in their name.
SELECT * FROM Sales.Currency WHERE Name LIKE '%dollar%';

-- 07. Find employees in HumanResources.Employee who have exactly 0 SickLeaveHours.
SELECT * FROM HumanResources.Employee WHERE SickLeaveHours = 0;

-- 08. Display all unique (DISTINCT) Titles from the Person.Person table.
SELECT DISTINCT(Title) FROM Person.Person;

-- 09. Find all purchase orders in Purchasing.PurchaseOrderHeader with a Status of 3 (Rejected).
SELECT * FROM Purchasing.PurchaseOrderHeader WHERE Status = 3;

-- 10. List the top 10 products with the highest Weight in Production.Product.
SELECT TOP 10 * FROM Production.Product ORDER BY Weight DESC;

-- 11. Find all credit cards in Sales.CreditCard with the CardType 'Vista'.
SELECT * FROM Sales.CreditCard WHERE CardType = 'Vista';

-- 12. Retrieve tax rates from Sales.SalesTaxRate that are between 5% and 10%.
SELECT * FROM Sales.SalesTaxRate WHERE TaxRate BETWEEN 5 AND 10;

-- 13. Find products where the ProductNumber contains a hyphen '-'.
SELECT * FROM Production.Product WHERE ProductNumber LIKE '%-%';

-- 14. Find employees who are 'Single' (MaritalStatus) and 'F' (Gender).
SELECT * FROM HumanResources.Employee WHERE MaritalStatus = 'S' AND Gender = 'F';

-- 15. Sort all vendors by Name in descending order (Z-A).
SELECT * FROM Purchasing.Vendor ORDER BY Name DESC;

-- 16. Find all cities in Person.Address that start with the letter 'B'.
SELECT * FROM Person.Address WHERE City LIKE 'B%';

-- 17. Retrieve all sales orders where the SubTotal is greater than 10,000.
SELECT * FROM Sales.SalesOrderHeader WHERE SubTotal > 10000;

-- 18. Find locations in Production.Location with a CostRate greater than 0.
SELECT * FROM Production.Location WHERE CostRate > 0;

-- 19. Display the first 50 rows from the Sales.SpecialOffer table.
SELECT TOP 50 * FROM Sales.SpecialOffer;

-- 20. Find persons whose MiddleName is recorded as a single initial (e.g., 'J.').
SELECT * FROM Person.Person WHERE MiddleName LIKE '_.';

-- ============================================================================
-- LEVEL 2: STRING & NUMERIC MANIPULATION (21 - 40)
-- ============================================================================

-- 21. Concatenate FirstName, MiddleName, and LastName (handle NULLs using COALESCE).
SELECT * FROM Person.Person;
SELECT FirstName + ' ' + COALESCE(MiddleName + ' ', '') + LastName AS FullName FROM Person.Person;
-- MiddleName is wrapped in COALESCE because it is the only NULLable column. FirstName and LastName are mandatory (NOT NULL), so they don't need protection.
-- Adding a space inside COALESCE ensures we don't get double spaces when the MiddleName is missing (NULL).
/*
The COALESCE function evaluates a list of arguments in order and returns the first non-null value it encounters. If all arguments in the list are NULL, the function returns NULL.
Syntax: SELECT COALESCE(expression\_1, expression\_2, ..., expression\_n) AS ... 
*/

-- 22. Calculate the price margin (ListPrice minus StandardCost) for every product.
SELECT Name, 
       ListPrice, 
       StandardCost,
       (ListPrice - StandardCost) AS Profit -- Ovdje se odvija oduzimanje
FROM Production.Product;

-- 23. Display JobTitle and replace the word 'Production' with 'Manufacturing'.
SELECT JobTitle,
       REPLACE(JobTitle, 'Production', 'Manufacturing') AS NewJobTitle 
FROM HumanResources.Employee

-- 24. Extract the first 15 characters of the Comment column in Production.ProductReview.
SELECT LEFT(Comments, 15) AS fifteen FROM Production.ProductReview;

-- 25. Find the length of the longest PasswordHash in the Person.Password table.
SELECT PasswordHash,
       LEN(PasswordHash) AS passLength
FROM Person.Password;

-- 26. Convert the AccountNumber in Sales.Customer to lowercase.
SELECT LOWER(AccountNumber) AS lowcaseAccNum
FROM Sales.Customer;

-- 27. Round the Freight amount to the nearest ten (e.g., 123.45 becomes 120).
SELECT Freight,
       ROUND(Freight, -1) AS RoundedFreight
FROM Sales.SalesOrderHeader;

-- 28. Display the first 6 digits of CardNumber followed by 'XXXX-XXXX'.
SELECT * FROM Sales.CreditCard;
SELECT CardNumber,
       LEFT(CardNumber, 6) + 'XXXX-XXXX' AS MaskedCardNumber
FROM Sales.CreditCard;

-- 29. Calculate the Square (SQUARE) of the ListPrice for all products.
SELECT * FROM Production.Product;
SELECT ProductID,
       Name,
       SQUARE(ListPrice) AS aquarePrice
FROM Production.Product;

-- 30. Display LastName and the lowercase version of LastName side-by-side.
SELECT * FROM Person.Person;
SELECT LastName,
       LOWER(LastName) AS LastNameLowercase
FROM Person.Person;

-- 31. Find the index position of the '@' symbol in Person.EmailAddress.
SELECT * FROM Person.EmailAddress;
SELECT EmailAddress,
       CHARINDEX('@', EmailAddress) AS AtSymbolPosition
FROM Person.EmailAddress;
/*
The CHARINDEX function searches for a specific substring (or character) inside another string and returns its starting position as an integer.
CHARINDEX(substring, string, [start\_location])
substring: The characters you are looking for (e.g., '@').
string: The column or text you are searching within.
start_location (Optional): The position where the search starts. If omitted, it starts at the beginning.
*/

-- 32. Create an "Employee Code": First 2 letters of JobTitle + Last 3 digits of BusinessEntityID.
SELECT * FROM HumanResources.Employee;
SELECT CONCAT(LEFT(JobTitle, 2), RIGHT(BusinessEntityID, 3)) AS EmployeeCode 
FROM HumanResources.Employee;

-- 33. Divide ListPrice by 2 and round the result to 4 decimal places.
SELECT * FROM Production.Product;
SELECT ListPrice,
       ROUND(ListPrice / 2.0, 4) AS DividedAndRoundedPrice -- best to divide with decimal number so we gat a decimal too
FROM Production.Product;

-- 34. Use REVERSE on the Name column of the Production.Product table.
SELECT * FROM Production.Product;
SELECT Name,
       REVERSE(Name) AS ReversedName
FROM Production.Product;

-- 35. Display StandardCost plus a fixed "Processing Fee" of $15.00 for all items.
SELECT StandardCost,
       (StandardCost + 15.00) AS TotalWithFee
FROM Production.Product;

-- 36. Find all people whose FirstName contains two consecutive 'a' letters (e.g., 'Isaac').
SELECT * FROM Person.Person WHERE FirstName LIKE '%aa%';

-- 37. Trim all trailing spaces (RTRIM) from the ProductNumber column.
SELECT * FROM Production.Product;
SELECT ProductNumber,
       RTRIM(ProductNumber) AS CleanedProductNumber 
FROM Production.Product;

-- 38. Extract the Year from HireDate using SUBSTRING (treat date as string).
SELECT HireDate,
       SUBSTRING(CAST(HireDate AS VARCHAR), 1, 4) AS YearFromSubstring        
FROM HumanResources.Employee;
/*
The CAST function is used to convert a value of one data type (like a Number or Date) into another data type (like String/Text). This is necessary when you want to use a function that only accepts a specific type of data.
Syntax: CAST(expression\ AS\ target\_data\_type)
expression: The column or value you want to change.
target_data_type: The new type you want (e.g., VARCHAR for text, INT for whole numbers, DECIMAL for numbers with dots).
*/

-- 39. Calculate the Absolute (ABS) difference between the Bonus and CommissionPct.
SELECT ABS(CommissionPct - Bonus) AS AbsoluteDifference FROM Sales.SalesPerson;

-- 40. Create a label: "Vendor: [Name] - Rating: [CreditRating]".
SELECT * FROM Purchasing.Vendor;
SELECT Name, 
       CreditRating, 
       'Vendor: ' + Name + ' - Rating: ' + CAST(CreditRating AS VARCHAR) AS VendorLabel
FROM Purchasing.Vendor;

-- ============================================================================
-- LEVEL 3: ADVANCED DATES & TIME (41 - 60)
-- ============================================================================

-- 41. Find the exact number of minutes between OrderDate and ShipDate.
SELECT * FROM Sales.SalesOrderHeader;
SELECT OrderDate,
	   ShipDate,
	   DATEDIFF(minute, OrderDate, ShipDate) AS MinutesToShip
FROM Sales.SalesOrderHeader;

-- 42. Retrieve all sales orders that were placed on a Friday (DATENAME).
SELECT SalesOrderID, 
       OrderDate,
       DATENAME(weekday, OrderDate) AS DayName
FROM Sales.SalesOrderHeader
WHERE DATENAME(weekday, OrderDate) = 'Friday';

-- 43. Add exactly 100 days to the current system date (GETDATE).
SELECT DATEADD(day, 100, GETDATE()) AS DateIn100Days;

-- 44. Extract only the Hour (DATEPART) from the ModifiedDate column in Person.Person.
SELECT * FROM Person.Person;
SELECT FirstName, 
	   LastName, 
	   DATEPART(hour, ModifiedDate) AS hours
FROM Person.Person;

-- 45. Find employees who were hired more than 15 years ago.
SELECT * FROM HumanResources.Employee;
SELECT BusinessEntityID, 
       HireDate,
       DATEDIFF(year, HireDate, GETDATE()) AS YearsEmployed
FROM HumanResources.Employee
WHERE DATEDIFF(year, HireDate, GETDATE()) > 15;

-- 46. Format ListPrice as currency using the German culture ('de-DE').
SELECT ProductID,
       Name,
       ListPrice AS OriginalPrice,
       FORMAT(ListPrice, 'C', 'de-DE') AS GermanPriceFormat -- C = standard numeric format string for valute
FROM Production.Product
WHERE ListPrice > 0;

-- 47. Retrieve all sales orders that were placed at exactly 12:00 PM (Noon).
SELECT SalesOrderID, 
       OrderDate 
FROM Sales.SalesOrderHeader
WHERE CAST(OrderDate AS TIME) = '12:00:00';
/*
To find a specific time in a DATETIME column, we can use the CAST function to isolate the TIME portion or use DATEPART to check the specific hour and minute.
*/

-- 48. Find employees born in leap years (e.g., 1980, 1984, 1988).
SELECT BusinessEntityID, 
       BirthDate,
       YEAR(BirthDate) AS BirthYear
FROM HumanResources.Employee
WHERE (YEAR(BirthDate) % 4 = 0 AND YEAR(BirthDate) % 100 <> 0) 
   OR (YEAR(BirthDate) % 400 = 0);
/*
1. YEAR(BirthDate): Extracts the 4-digit year from the date.
2. MODULO OPERATOR (%): Used to check for divisibility.
3. LEAP YEAR ALGORITHM: 
   - A year is a leap year if it is divisible by 4.
   - However, years divisible by 100 are NOT leap years, unless they are also divisible by 400.
4. FILTERING: The WHERE clause applies these rules to isolate birth years with 366 days.
*/

-- 49. Calculate the age of an employee at the time they were hired (HireDate - BirthDate).
SELECT * FROM HumanResources.Employee;
SELECT BusinessEntityID, 
       DATEDIFF(year, BirthDate, HireDate) AS AgeWhenHired
FROM HumanResources.Employee;

-- 50. Display the last day of the month (EOMONTH) for every SalesOrder.
SELECT * FROM Sales.SalesOrderHeader;
SELECT SalesOrderID,
       OrderDate,
       EOMONTH(OrderDate) AS EndOfMonth
FROM Sales.SalesOrderHeader;
/*
The EOMONTH function returns the last day of the month that contains a specified date. It is extremely useful for financial reporting and calculating deadlines that fall at the end of a month.
Syntax: EOMONTH(startDate, [mnthToAdd])
start_date: The date you are checking (e.g., OrderDate).
month_to_add (Optional): An integer representing the number of months to add to the start date before finding the last day. If you put 1, it gives you the last day of the next month.
*/

-- 51. Find orders that were placed during the weekend (Saturday or Sunday).
SELECT * FROM Sales.SalesOrderHeader;
SELECT SalesOrderID, 
       OrderDate,
       DATENAME(weekday, OrderDate) AS DayPlaced
FROM Sales.SalesOrderHeader
WHERE DATENAME(weekday, OrderDate) IN ('Saturday', 'Sunday');

-- 52. Format BirthDate to look like: 'Monday, 15. June 1982'.
SELECT BusinessEntityID,
       BirthDate,
       FORMAT(BirthDate, 'dddd, dd. MMMM yyyy', 'en-US') AS FormattedBirthDate
FROM HumanResources.Employee;

-- 53. Extract the Week Number (DATEPART) for every order in 2013.
SELECT SalesOrderID,
       DATEPART(week, OrderDate) AS weekNumber
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2013;

-- 54. Calculate the difference in hours between OrderDate and DueDate.
SELECT SalesOrderID, 
       OrderDate,
       DATEDIFF(hour, OrderDate, DueDate) AS differenceInHours
FROM Sales.SalesOrderHeader;

-- 55. Find all persons who last updated their data (ModifiedDate) in 2014.
SELECT BusinessEntityID, FirstName, LastName, ModifiedDate FROM Person.Person
WHERE YEAR(ModifiedDate) = 2014;

-- 56. Calculate how many days are left until a CreditCard expires from today's date.
SELECT CreditCardID,
       ExpMonth,
       ExpYear,
       DATEDIFF(day, GETDATE(), EOMONTH(DATEFROMPARTS(ExpYear, ExpMonth, 1))) AS DaysUntilExpiry
FROM Sales.CreditCard;
/*
The DATEFROMPARTS function returns a date value from the specified year, month, and day. It is much safer and cleaner than trying to combine strings with plus signs or slashes.
Syntax: DATEFROMPARTS(year, month, day)
year: A 4-digit integer (e.g., 2024).
month: An integer from 1 to 12.
day: An integer from 1 to 31 (depending on the month).
*/

-- 57. Find orders placed in the 2nd Quarter of any year (April, May, June).
SELECT SalesOrderID, 
       OrderDate,
       DATENAME(month, OrderDate) AS MonthName, -- Added for visual confirmation
       DATEPART(quarter, OrderDate) AS QuarterNumber
FROM Sales.SalesOrderHeader
WHERE DATEPART(quarter, OrderDate) = 2;
-- DATEPART(quarter, DateColumn) returns an integer (1, 2, 3, or 4) based on the month of the date.

-- 58. Display the HireDate and move it to the "Next Monday" (DATEADD logic).
SELECT BusinessEntityID, 
       HireDate,
       DATENAME(weekday, HireDate) AS HireDay,
       DATEADD(week, DATEDIFF(week, 0, HireDate) + 1, 0) AS NextMonday
FROM HumanResources.Employee;
/*
1. DATEDIFF(day, 0, HireDate) calculates days since 1900-01-01 (a Monday).
2. Dividing by 7 and adding 1 finds the start of the NEXT week.
3. DATEADD then reconstructs that specific Monday.
*/

-- 59. Extract the Birth Year of employees as a numeric value (YEAR).
SELECT BusinessEntityID, 
       BirthDate, 
       YEAR(BirthDate) AS BirthYear
FROM HumanResources.Employee;

-- 60. Find all sales orders placed in the afternoon (after 12:00 PM).
SELECT SalesOrderID, 
       OrderDate, 
       DATEPART(hour, OrderDate) AS OrderHour
FROM Sales.SalesOrderHeader
WHERE DATEPART(hour, OrderDate) >= 12
ORDER BY OrderHour;

-- ============================================================================
-- LEVEL 4: ANALYTICS, AGGREGATIONS & HAVING (61 - 80)
-- ============================================================================

-- 61. Find the total Quantity of stock in Production.ProductInventory grouped by LocationID.
SELECT LocationID,
       SUM(Quantity) AS TotalStock
FROM Production.ProductInventory
GROUP BY LocationID;

-- 62. Count how many unique CardTypes exist for each expiration year.
SELECT ExpYear,
	   COUNT(DISTINCT CardType) AS UniqueCardTypesCount    
FROM Sales.CreditCard
GROUP BY ExpYear
ORDER BY ExpYear;
/*
   LOGIC: 
   1. GROUP BY ExpYear: Groups all credit cards by their expiry year.
   2. COUNT(DISTINCT CardType): Counts only the different types of cards within that year.
*/

-- 63. Calculate the average Freight cost per ShipMethodID.
SELECT ShipMethodID, 
       AVG(Freight) AS AvgFreight
FROM Sales.SalesOrderHeader
GROUP BY ShipMethodID;
/* 
   LOGIC: 
   1. SELECT ShipMethodID: To show which shipping method we are looking at.
   2. AVG(Freight): To calculate the average cost for that group.
   3. GROUP BY ShipMethodID: To separate the calculations by each shipping method.
*/

-- 64. Display the Minimum and Maximum SubTotal for each SalesPersonID.
SELECT SalesPersonID,
       MIN(SubTotal) AS MinSub,
       MAX(SubTotal) AS MaxSub
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IS NOT NULL
GROUP BY SalesPersonID;
/*
   LOGIC: 
   1. GROUP BY SalesPersonID: Creates a bucket for each salesperson.
   2. MIN(SubTotal): Finds the smallest order amount for that person.
   3. MAX(SubTotal): Finds the largest order amount for that person.

When using aggregate functions (like MIN, MAX, SUM), any column in the SELECT list that is not inside a function must be included in the GROUP BY clause.
Why? SQL cannot display a specific SalesOrderID (which changes for every row) alongside a MIN(SubTotal) that is calculated for a whole group of people. It would be like trying to list every student's ID next to the entire class's average grade—it doesn't fit in one row!
*/

-- 65. Sum the total Weight of products for each Class (H, M, L).
SELECT Class, 
       SUM(Weight) AS TotalClassWeight
FROM Production.Product
WHERE Weight IS NOT NULL AND Class IS NOT NULL
GROUP BY Class;
/* 
   LOGIC: 
   1. GROUP BY Class: Segregates products into High, Medium, and Low categories.
   2. SUM(Weight): Calculates the total combined weight for all products in that class.
   3. WHERE Class IS NOT NULL: Removes products that don't have a defined class.
*/

-- 66. Find Departments that have an average VacationHours greater than 50.
SELECT d.Name AS DepartmentName, 
       AVG(e.VacationHours) AS AverageVacation
FROM HumanResources.Employee e
JOIN HumanResources.EmployeeDepartmentHistory edh 
    ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department d 
    ON edh.DepartmentID = d.DepartmentID
WHERE edh.EndDate IS NULL
GROUP BY d.Name
HAVING AVG(e.VacationHours) > 50;
/*
   LOGIC: 
   1. JOIN three tables to connect Employees to their Department names.
   2. GROUP BY Department Name.
   3. Use HAVING to filter groups where the calculated average is > 50.
*/

-- 67. Count how many products belong to each Style (W, M, U).
SELECT Style, 
       COUNT(*) AS ProductCount
FROM Production.Product
WHERE Style IS NOT NULL
GROUP BY Style;
/* 
   LOGIC: 
   1. SELECT Style: The category we want to see.
   2. COUNT(*): Counts all products in each category.
   3. GROUP BY Style: Necessary to collapse individual products into groups.
*/

-- 68. Calculate the total TaxAmt for each year.
SELECT YEAR(OrderDate) AS OrderYear, 
       SUM(TaxAmt) AS TotalTaxCollected
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;
/* 
   LOGIC: 
   1. YEAR(OrderDate): Extracts the year from the full date.
   2. SUM(TaxAmt): Adds up all tax amounts for each year group.
   3. GROUP BY YEAR(OrderDate): Collapses all orders into yearly buckets.
*/

-- 69. Find the CustomerID who has placed the highest number of orders (Top 1).
SELECT TOP 1 CustomerID, 
       COUNT(SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY OrderCount DESC;
/* LOGIC: 
   1. SELECT TOP 1: Filters the final result to show only the single highest row.
   2. COUNT(SalesOrderID): Counts how many orders each customer has made.
   3. GROUP BY CustomerID: Aggregates the orders for each individual customer.
   4. ORDER BY Count DESC: Places the person with the most orders at the very top.
*/

-- 70. Display only those Cities that have exactly 1 address registered.
SELECT City, 
       COUNT(*) AS AddressCount
FROM Person.Address
GROUP BY City
HAVING COUNT(*) = 1;
/* LOGIC: 
   1. GROUP BY City: Groups all addresses by their city name.
   2. COUNT(*): Counts how many address records exist in each city.
   3. HAVING COUNT(*) = 1: Filters the groups to show only those where the count is exactly one.
*/

-- 71. Sum the Bonus amounts for each JobTitle in HumanResources.Employee.
SELECT e.JobTitle, 
       SUM(sp.Bonus) AS TotalBonus
FROM HumanResources.Employee AS e
JOIN Sales.SalesPerson AS sp ON e.BusinessEntityID = sp.BusinessEntityID
GROUP BY e.JobTitle;
/* LOGIC: 
   1. JOIN Employee & SalesPerson: Links job titles to their respective bonus data.
   2. SUM(Bonus): Adds up the total bonus money for each category.
   3. GROUP BY JobTitle: Collapses the results based on the employee's role.
*/

-- 72. Count how many products are stored on each Shelf in the warehouse.
SELECT Shelf, 
       COUNT(*) AS ProductCount
FROM Production.ProductInventory
GROUP BY Shelf;
/* LOGIC: 
   1. SELECT Shelf, COUNT(*): Selects the shelf identifier and counts items on it.
   2. FROM Production.ProductInventory: The table where stock locations are stored.
   3. GROUP BY Shelf: Groups the inventory records by their physical shelf location.
*/

-- 73. Find the average TaxRate for each StateProvinceID.
SELECT StateProvinceID, 
       AVG(TaxRate) AS AvgTax
FROM Sales.SalesTaxRate
GROUP BY StateProvinceID;
/* LOGIC: 
   1. AVG(TaxRate): Calculates the mathematical average of the tax percentages.
   2. GROUP BY StateProvinceID: Groups the tax data by state/province code.
*/

-- 74. Sum all DiscountPct values by the Discount Type in Sales.SpecialOffer.
SELECT [Type], 
       SUM(DiscountPct) AS TotalDiscount
FROM Sales.SpecialOffer
GROUP BY [Type];
/* LOGIC: 
   1. SUM(DiscountPct): Totals all discount percentages for a specific category.
   2. GROUP BY [Type]: Groups the offers by their classification (e.g., 'No Discount', 'Volume Discount').
*/

-- 75. List the years in which more than 5,000 orders were placed.
SELECT YEAR(OrderDate) AS OrderYear, 
       COUNT(*) AS OrderCount
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
HAVING COUNT(*) > 5000;
/* LOGIC: 
   1. YEAR(OrderDate): Extracts the year to create yearly groups.
   2. COUNT(*): Counts the total number of orders placed in each year.
   3. HAVING COUNT(*) > 5000: Filters the years to only show those with high order volume.
*/

-- 76. Find the lowest ListPrice for each ProductModelID.
SELECT ProductModelID, 
       MIN(ListPrice) AS MinPrice
FROM Production.Product
WHERE ProductModelID IS NOT NULL
GROUP BY ProductModelID;
/* LOGIC: 
   1. MIN(ListPrice): Finds the lowest price within a specific group.
   2. WHERE ProductModelID IS NOT NULL: Removes products that don't belong to a specific model.
   3. GROUP BY ProductModelID: Aggregates the prices based on the product model.
*/

-- 77. Count the total number of Male (M) vs Female (F) employees.
SELECT Gender, 
       COUNT(*) AS EmployeeCount
FROM HumanResources.Employee
GROUP BY Gender;
/* LOGIC: 
   1. SELECT Gender, COUNT(*): Identifies the gender and counts the people in that group.
   2. GROUP BY Gender: Separates the employee table into 'M' and 'F' buckets.
*/

-- 78. Calculate the average SickLeaveHours per Department.
SELECT d.Name, 
       AVG(e.SickLeaveHours) AS AvgSickHours
FROM HumanResources.Employee AS e
JOIN HumanResources.EmployeeDepartmentHistory AS edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department AS d ON edh.DepartmentID = d.DepartmentID
WHERE edh.EndDate IS NULL
GROUP BY d.Name;
/* LOGIC: 
   1. JOIN Employee, EmployeeDepartmentHistory, and Department: Connects hours to names.
   2. AVG(SickLeaveHours): Calculates the average sick leave for the whole department.
   3. GROUP BY d.Name: Groups the results by the actual name of the department.
*/

-- 79. Find the total sales (TotalDue) for each Quarter of 2013.
SELECT DATEPART(quarter, OrderDate) AS Quarter, 
       SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2013
GROUP BY DATEPART(quarter, OrderDate);
/* LOGIC: 
   1. WHERE YEAR(OrderDate) = 2013: Limits the data to the specific year.
   2. DATEPART(quarter, OrderDate): Extracts the quarter (1, 2, 3, or 4).
   3. SUM(TotalDue): Totals the revenue for each quarter.
   4. GROUP BY DATEPART(quarter, OrderDate): Groups the results chronologically by quarter.
*/

-- 80. Display CustomerIDs that have spent a grand total of more than $100,000.
SELECT CustomerID, 
       SUM(TotalDue) AS TotalSpent
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING SUM(TotalDue) > 100000;
/* LOGIC: 
   1. SUM(TotalDue): Adds up every dollar a customer has ever spent.
   2. GROUP BY CustomerID: Aggregates all orders for each unique customer.
   3. HAVING SUM(TotalDue) > 100000: Filters for "VIP" customers who exceeded the threshold.
*/
-- ============================================================================
-- LEVEL 5: RELATIONAL JOINS & DATA MAPPING (81 - 100)
-- ============================================================================

-- 81. Join Product and ProductModel to show the Product Name and Model Name.
SELECT * FROM Production.Product;
SELECT * FROM Production.ProductModel;

SELECT pp.Name AS ProductName,
	   pm.Name AS ModelName
FROM Production.Product pp
JOIN Production.ProductModel pm 
ON pp.ProductModelID = pm.ProductModelID;

-- 82. Join Person and EmailAddress to list FirstName, LastName, and Email.
SELECT * FROM Person.Person;
SELECT * FROM Person.EmailAddress;

SELECT pp.FirstName,
	   pp.LastName,
	   pea.EmailAddress
FROM Person.Person pp JOIN Person.EmailAddress pea
ON pp.BusinessEntityID = pea.BusinessEntityID;

-- 83. Join Customer and Store to see the CustomerID and the Store Name.
SELECT * FROM Sales.Customer;
SELECT * FROM Sales.Store;

SELECT c.CustomerID, 
	   s.Name
FROM Sales.Customer c JOIN Sales.Store s 
ON c.StoreID = s.BusinessEntityID;

-- 84. Use a LEFT JOIN between Employee and JobCandidate.
SELECT * FROM HumanResources.Employee;
SELECT * FROM HumanResources.JobCandidate;

SELECT * FROM HumanResources.Employee e LEFT JOIN HumanResources.JobCandidate jc
ON e.BusinessEntityID = jc.BusinessEntityID;

-- 85. Join SalesOrderHeader and CurrencyRate to see the Order and EndOfDayRate.
SELECT * FROM Sales.SalesOrderHeader;
SELECT * FROM Sales.CurrencyRate;

SELECT soh.SalesOrderID,
	   cr.EndOfDayRate
FROM Sales.SalesOrderHeader soh JOIN Sales.CurrencyRate cr 
ON soh.CurrencyRateID = cr.CurrencyRateID;

-- 86. Join Product and Document via the ProductDocument table.
SELECT * FROM Production.Product;
SELECT * FROM Production.Document;
SELECT * FROM Production.ProductDocument;

SELECT * FROM Production.Product p 
JOIN Production.ProductDocument pd 
    ON p.ProductID = pd.ProductID
JOIN Production.Document d 
    ON pd.DocumentNode = d.DocumentNode;

-- 87. Join Person.Person and Person.Password to see names and PasswordHashes.
SELECT * FROM Person.Person;
SELECT * FROM Person.Password;

SELECT p.FirstName,
	   p.LastName,
	   pw.PasswordHash
FROM Person.Person p 
JOIN Person.Password pw
	ON p.BusinessEntityID = pw.BusinessEntityID;

-- 88. Display the Customer's FirstName and their Credit Card Type.
SELECT * FROM Person.Person;
SELECT * FROM Sales.Customer;
SELECT * FROM Sales.PersonCreditCard;
SELECT * FROM Sales.CreditCard;

SELECT p.FirstName, 
	   cc.CardType
FROM Person.Person p
JOIN Sales.PersonCreditCard pcc 
    ON p.BusinessEntityID = pcc.BusinessEntityID
JOIN Sales.CreditCard cc 
    ON pcc.CreditCardID = cc.CreditCardID;

-- 89. SELF JOIN: Match Employees to their Managers (ManagerID = BusinessEntityID).
SELECT * FROM HumanResources.Employee

SELECT e.BusinessEntityID AS EmployeeID,
       e.JobTitle AS EmployeeJob,
       m.BusinessEntityID AS ManagerID,
       m.JobTitle AS ManagerJob
FROM HumanResources.Employee e
JOIN HumanResources.Employee m 
    ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode;
/*
   Logic: 
   1. FROM HumanResources.Employee AS e (This represents the SUBORDINATE)
   2. JOIN HumanResources.Employee AS m (This represents the MANAGER)
   3. ON e.ManagerID = m.BusinessEntityID (Link the worker's manager ID to the manager's personal ID)

GetAncestor(n) Function
   1. DATA TYPE: Works specifically with the 'HierarchyID' data type.
   2. PURPOSE: It is used to navigate tree-like structures (e.g., Company Org Charts).
   3. LOGIC:
      - It returns a hierarchy node that is 'n' levels above the current node.
      - GetAncestor(1) = The immediate parent/manager.
      - GetAncestor(2) = The grandparent/director.
   4. USAGE IN SELF JOIN: 
      By setting 'Employee.GetAncestor(1) = Manager.Node', we are essentially saying:
      "Find the person whose position is exactly one level above this employee."
*/

-- 90. Join Product and Vendor via the Purchasing.ProductVendor table.
SELECT * FROM Production.Product;
SELECT * FROM Purchasing.Vendor;
SELECT * FROM Purchasing.ProductVendor;

SELECT p.Name AS ProductName, 
       v.Name AS VendorName,
       pv.StandardPrice,
       pv.OnOrderQty
FROM Production.Product p
JOIN Purchasing.ProductVendor AS pv 
    ON p.ProductID = pv.ProductID
JOIN Purchasing.Vendor v 
    ON pv.BusinessEntityID = v.BusinessEntityID;

-- 91. LEFT JOIN: Find Products that have no records in Production.ProductInventory.
SELECT * FROM Production.Product;
SELECT * FROM Production.ProductInventory;

SELECT p.ProductID, 
       p.Name AS ProductName
FROM Production.Product p
LEFT JOIN Production.ProductInventory pi 
    ON p.ProductID = pi.ProductID
WHERE pi.ProductID IS NULL;

-- 92. Join ShipMethod and SalesOrderHeader to show Order IDs and Shipping Names.
SELECT * FROM Purchasing.ShipMethod;
SELECT * FROM Sales.SalesOrderHeader;

SELECT soh.SalesOrderID, 
       sm.Name AS ShippingMethodName
FROM Sales.SalesOrderHeader soh
JOIN Purchasing.ShipMethod sm 
    ON soh.ShipMethodID = sm.ShipMethodID;

-- 93. Join StateProvince and CountryRegion to show the Full Country and Province names.
SELECT * FROM Person.StateProvince;
SELECT * FROM Person.CountryRegion;

SELECT sp.Name AS StateProvinceName, 
       cr.Name AS CountryName
FROM Person.StateProvince AS sp
JOIN Person.CountryRegion AS cr 
    ON sp.CountryRegionCode = cr.CountryRegionCode;

-- 94. Join Product and ProductCostHistory to show price changes over time.
SELECT * FROM Production.Product;
SELECT * FROM Production.ProductCostHistory;

SELECT p.Name AS ProductName, 
       pch.StartDate, 
       pch.EndDate, 
       pch.StandardCost
FROM Production.Product p
JOIN Production.ProductCostHistory pch 
    ON p.ProductID = pch.ProductID
ORDER BY p.Name, pch.StartDate;
/* LOGIC:
   1. SELECT p.Name: To know which product we are looking at.
   2. SELECT pch.StandardCost and pch.StartDate: To see the cost and when it began.
   3. JOIN on ProductID: Links the product to its historical cost records.
*/

-- 95. Join Department and EmployeeDepartmentHistory to show all names in the 'IT' department.
SELECT * FROM HumanResources.Department;
SELECT * FROM HumanResources.EmployeeDepartmentHistory;

SELECT edh.BusinessEntityID, 
       d.Name AS DepartmentName, 
       edh.StartDate
FROM HumanResources.Department d
JOIN HumanResources.EmployeeDepartmentHistory edh 
    ON d.DepartmentID = edh.DepartmentID
WHERE d.Name = 'Information Services' 
  AND edh.EndDate IS NULL;
/* LOGIC:
   1. JOIN Department (d) and EmployeeDepartmentHistory (edh) on DepartmentID.
   2. FILTER by Department Name = 'Information Services'.
   3. FILTER for Current Employees where EndDate IS NULL.
*/

-- 96. Join SalesTaxRate and StateProvince to show the Tax Rate for each State name.
SELECT * FROM Sales.SalesTaxRate;
SELECT * FROM Person.StateProvince;

SELECT sp.Name AS StateName, 
       str.TaxRate, 
       str.Name AS TaxDescription
FROM Sales.SalesTaxRate str
JOIN Person.StateProvince sp 
    ON str.StateProvinceID = sp.StateProvinceID;

-- 97. Join Product and ProductPhoto via the ProductProductPhoto table.
SELECT * FROM Production.Product;
SELECT * FROM Production.ProductPhoto;
SELECT * FROM Production.ProductProductPhoto;

SELECT p.Name AS ProductName, 
       pp.LargePhotoFileName, 
       ppp.[Primary] AS IsPrimaryPhoto
FROM Production.Product AS p
JOIN Production.ProductProductPhoto AS ppp 
    ON p.ProductID = ppp.ProductID
JOIN Production.ProductPhoto AS pp 
    ON ppp.ProductPhotoID = pp.ProductPhotoID;

/* LOGIC:
   - Goal: Connect Products to their images.
   - The Problem: A Product can have many photos, and a Photo could potentially 
     be used for many products. They cannot be linked directly.
   - The Solution: We use a "Bridge" (Junction) table called 'ProductProductPhoto'.
   - The Chain:
     1. Product (p) links to Bridge (ppp) via [ProductID].
     2. Bridge (ppp) links to ProductPhoto (pp) via [ProductPhotoID].
   - Key Detail: We use [Primary] in brackets because 'Primary' is a reserved 
     SQL keyword.
*/

-- 98. Join Store and SalesPerson to see which salesperson is assigned to which store.
SELECT * FROM Sales.Store;
SELECT * FROM Sales.SalesPerson;

SELECT s.Name AS StoreName, 
       sp.BusinessEntityID AS SalesPersonID,
       sp.SalesYTD AS SalesPersonPerformance
FROM Sales.Store s
JOIN Sales.SalesPerson sp 
    ON s.SalesPersonID = sp.BusinessEntityID;

-- 99. Join BillOfMaterials and Product to see the component parts of an assembly.
SELECT * FROM Production.BillOfMaterials;
SELECT * FROM Production.Product;

SELECT bom.ProductAssemblyID,  -- The ID of the "Finished Bike"
       p.Name AS ComponentName, -- The Name of the "Part"
       bom.PerAssemblyQty,      -- How many of these parts are needed
       bom.UnitMeasureCode
FROM Production.BillOfMaterials bom
JOIN Production.Product p 
    ON bom.ComponentID = p.ProductID;

-- 100. Join Person, EmailAddress, and PersonPhone for a complete contact overview.
SELECT * FROM Person.Person;
SELECT * FROM Person.EmailAddress;
SELECT * FROM Person.PersonPhone;

SELECT p.FirstName, 
       p.LastName, 
       ea.EmailAddress, 
       ph.PhoneNumber
FROM Person.Person p
JOIN Person.EmailAddress ea 
    ON p.BusinessEntityID = ea.BusinessEntityID
JOIN Person.PersonPhone ph 
    ON p.BusinessEntityID = ph.BusinessEntityID;
