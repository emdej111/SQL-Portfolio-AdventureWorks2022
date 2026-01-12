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
-- 22. Calculate the price margin (ListPrice minus StandardCost) for every product.
-- 23. Display JobTitle and replace the word 'Production' with 'Manufacturing'.
-- 24. Extract the first 15 characters of the Comment column in Production.ProductReview.
-- 25. Find the length of the longest PasswordHash in the Person.Password table.
-- 26. Convert the AccountNumber in Sales.Customer to lowercase.
-- 27. Round the Freight amount to the nearest ten (e.g., 123.45 becomes 120).
-- 28. Display the first 6 digits of CardNumber followed by 'XXXX-XXXX'.
-- 29. Calculate the Square (SQUARE) of the ListPrice for all products.
-- 30. Display LastName and the lowercase version of LastName side-by-side.
-- 31. Find the index position of the '@' symbol in Person.EmailAddress.
-- 32. Create an "Employee Code": First 2 letters of JobTitle + Last 3 digits of BusinessEntityID.
-- 33. Divide ListPrice by 2 and round the result to 4 decimal places.
-- 34. Use REVERSE on the Name column of the Production.Product table.
-- 35. Display StandardCost plus a fixed "Processing Fee" of $15.00 for all items.
-- 36. Find all people whose FirstName contains two consecutive 'a' letters (e.g., 'Isaac').
-- 37. Trim all trailing spaces (RTRIM) from the ProductNumber column.
-- 38. Extract the Year from HireDate using SUBSTRING (treat date as string).
-- 39. Calculate the Absolute (ABS) difference between the Bonus and CommissionPct.
-- 40. Create a label: "Vendor: [Name] - Rating: [CreditRating]".

-- ============================================================================
-- LEVEL 3: ADVANCED DATES & TIME (41 - 60)
-- ============================================================================

-- 41. Find the exact number of minutes between OrderDate and ShipDate.
-- 42. Retrieve all sales orders that were placed on a Friday (DATENAME).
-- 43. Add exactly 100 days to the current system date (GETDATE).
-- 44. Extract only the Hour (DATEPART) from the ModifiedDate column in Person.Person.
-- 45. Find employees who were hired more than 15 years ago.
-- 46. Format ListPrice as currency using the German culture ('de-DE').
-- 47. Retrieve all sales orders that were placed at exactly 12:00 PM (Noon).
-- 48. Find employees born in leap years (e.g., 1980, 1984, 1988).
-- 49. Calculate the age of an employee at the time they were hired (HireDate - BirthDate).
-- 50. Display the last day of the month (EOMONTH) for every SalesOrder.
-- 51. Find orders that were placed during the weekend (Saturday or Sunday).
-- 52. Format BirthDate to look like: 'Monday, 15. June 1982'.
-- 53. Extract the Week Number (DATEPART) for every order in 2013.
-- 54. Calculate the difference in hours between OrderDate and DueDate.
-- 55. Find all persons who last updated their data (ModifiedDate) in 2014.
-- 56. Calculate how many days are left until a CreditCard expires from today's date.
-- 57. Find orders placed in the 2nd Quarter of any year (April, May, June).
-- 58. Display the HireDate and move it to the "Next Monday" (DATEADD logic).
-- 59. Extract the Birth Year of employees as a numeric value (YEAR).
-- 60. Find all sales orders placed in the afternoon (after 12:00 PM).

-- ============================================================================
-- LEVEL 4: ANALYTICS, AGGREGATIONS & HAVING (61 - 80)
-- ============================================================================

-- 61. Find the total Quantity of stock in Production.ProductInventory grouped by LocationID.
-- 62. Count how many unique CardTypes exist for each expiration year.
-- 63. Calculate the average Freight cost per ShipMethodID.
-- 64. Display the Minimum and Maximum SubTotal for each SalesPersonID.
-- 65. Sum the total Weight of products for each Class (H, M, L).
-- 66. Find Departments that have an average VacationHours greater than 50.
-- 67. Count how many products belong to each Style (W, M, U).
-- 68. Calculate the total TaxAmt for each year.
-- 69. Find the CustomerID who has placed the highest number of orders (Top 1).
-- 70. Display only those Cities that have exactly 1 address registered.
-- 71. Sum the Bonus amounts for each JobTitle in HumanResources.Employee.
-- 72. Count how many products are stored on each Shelf in the warehouse.
-- 73. Find the average TaxRate for each StateProvinceID.
-- 74. Sum all DiscountPct values by the Discount Type in Sales.SpecialOffer.
-- 75. List the years in which more than 5,000 orders were placed.
-- 76. Find the lowest ListPrice for each ProductModelID.
-- 77. Count the total number of Male (M) vs Female (F) employees.
-- 78. Calculate the average SickLeaveHours per Department.
-- 79. Find the total sales (TotalDue) for each Quarter of 2013.
-- 80. Display CustomerIDs that have spent a grand total of more than $100,000.

-- ============================================================================
-- LEVEL 5: RELATIONAL JOINS & DATA MAPPING (81 - 100)
-- ============================================================================

-- 81. Join Product and ProductModel to show the Product Name and Model Name.
-- 82. Join Person and EmailAddress to list FirstName, LastName, and Email.
-- 83. Join Customer and Store to see the CustomerID and the Store Name.
-- 84. Use a LEFT JOIN between Employee and JobCandidate.
-- 85. Join SalesOrderHeader and CurrencyRate to see the Order and EndOfDayRate.
-- 86. Join Product and Document via the ProductDocument table.
-- 87. Join Person.Person and Person.Password to see names and PasswordHashes.
-- 88. Display the Customer's FirstName and their Credit Card Type.
-- 89. SELF JOIN: Match Employees to their Managers (ManagerID = BusinessEntityID).
-- 90. Join Product and Vendor via the Purchasing.ProductVendor table.
-- 91. LEFT JOIN: Find Products that have no records in Production.ProductInventory.
-- 92. Join ShipMethod and SalesOrderHeader to show Order IDs and Shipping Names.
-- 93. Join StateProvince and CountryRegion to show the Full Country and Province names.
-- 94. Join Product and ProductCostHistory to show price changes over time.
-- 95. Join Department and EmployeeDepartmentHistory to show all names in the 'IT' department.
-- 96. Join SalesTaxRate and StateProvince to show the Tax Rate for each State name.
-- 97. Join Product and ProductPhoto via the ProductProductPhoto table.
-- 98. Join Store and SalesPerson to see which salesperson is assigned to which store.
-- 99. Join BillOfMaterials and Product to see the component parts of an assembly.
-- 100. Join Person, EmailAddress, and PersonPhone for a complete contact overview.
