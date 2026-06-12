/* ===============================================================================
SQL BOOTCAMP: 01-FOUNDATIONS (100 CHALLENGES + 20 ADVANCED)
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
-- Here we use 'IS NULL' because NULL represents the absence of a value. We cannot use '=' because an unknown value cannot be equal to another unknown.

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
/* We use 'ORDER BY Weight DESC' to sort products from heaviest to lightest.
   Without 'ORDER BY', the 'TOP' clause would simply return the first 10 random rows it encounters, rather than the actual heaviest items.
   'ORDER BY' is used to rank the results from the highest to the lowest count (DESC),

   ORDER BY is a clause used to sort the result set of a query in either ascending (ASC) or descending (DESC) order. 
   It is essential because SQL tables are based on set theory, meaning rows have no inherent order. 
   Beyond simple sorting, it is used for:
      1. Presentation: Making data readable for end-users.
      2. Logic: It is required for 'TOP' or 'OFFSET/FETCH' to yield meaningful results.
      3. Analytics: It defines the sequence for Window Functions (e.g., Running Totals).*/

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
SELECT CONCAT(FirstName, ' ', COALESCE(MiddleName, ''), ' ', LastName) AS FullDisplayName
FROM Person.Person;
/* DEFINITIONS:
   1. CONCATENATION (+): 
	  In T-SQL, the '+' operator joins strings together. 
      In SQL Server, 'String + NULL' always results in NULL. 
      This is why one missing MiddleName can "break" the entire full name string.

   2. COALESCE: This function evaluates a list of arguments and returns the 
      FIRST non-null value it finds. It acts as a safety net for optional data.

   LOGIC EXPLANATION:
      * 'FirstName' and 'LastName' are NOT NULL (mandatory), so they are safe to use directly.
      * 'MiddleName' is NULLable (optional). We wrap it in COALESCE to provide an empty string ('') if the data is missing, preventing the entire result from becoming NULL.

   SMART SPACING: We place the space INSIDE the COALESCE: COALESCE(MiddleName + ' ', '').
      * IF MiddleName exists: It prints "MiddleName " (with a space).
      * IF MiddleName is NULL: It prints nothing (''), avoiding a double space between First and Last name. */

-- 22. Calculate the price margin (ListPrice minus StandardCost) for every product.
SELECT Name, 
       ListPrice, 
       StandardCost,
       (ListPrice - StandardCost) AS Profit 
FROM Production.Product;

-- 23. Display JobTitle and replace the word 'Production' with 'Manufacturing'.
SELECT JobTitle,
       REPLACE(JobTitle, 'Production', 'Manufacturing') AS NewJobTitle 
FROM HumanResources.Employee
/* The REPLACE function is used to swap a specific substring within a string with a new value. It is case-sensitive depending on the database collation.
   
   SYNTAX:
   REPLACE(string_expression, string_pattern, string_replacement)
    1. string_expression: The column or text we want to search (e.g., JobTitle).
    2. string_pattern: The specific text we want to find (e.g., 'Production').
    3. string_replacement: The new text that will replace the pattern (e.g., 'Manufacturing') */

-- 24. Extract the first 15 characters of the Comment column in Production.ProductReview.
SELECT LEFT(Comments, 15) AS fifteen FROM Production.ProductReview;

-- 25. Find the length of the longest PasswordHash in the Person.Password table.
SELECT MAX(LEN(PasswordHash)) AS passLength 
FROM Person.Password;

-- or

SELECT PasswordHash,
	   MAX(LEN(PasswordHash)) AS passLength 
FROM Person.Password
GROUP By PasswordHash;

/* ===============================================================================
   THE GOLDEN RULE OF AGGREGATION ("Mixed Company" Rule)
   ===============================================================================
   When writing a SELECT statement with aggregate functions, look at the columns:
   
   1. PURE AGGREGATES (No GROUP BY needed):
      If the SELECT list contains ONLY aggregate functions (e.g., SUM, AVG, MAX), 
      the SQL engine treats the entire table as one single group. No GROUP BY is required.
      
   2. MIXED COMPANY (GROUP BY is MANDATORY):
      The exact moment we add a regular row/column (like PatientID or City) alongside 
      an aggregate function, ywe create a conflict of detail levels. 
      To resolve this, that regular column MUST be placed inside the GROUP BY clause. 
      It tells SQL exactly how to slice and dice the data into categorized buckets.
   =============================================================================== */

-- 26. Convert the AccountNumber in Sales.Customer to lowercase.
SELECT LOWER(AccountNumber) AS lowcaseAccNum
FROM Sales.Customer;

-- 27. Round the Freight amount to the nearest ten (e.g., 123.45 becomes 120).
SELECT Freight,
       ROUND(Freight, -1) AS RoundedFreight
FROM Sales.SalesOrderHeader;
/* ===============================================================================
   THE "COUNTING ZEROS" RULE FOR NEGATIVE ROUNDING
   ===============================================================================
   The ROUND(value, precision) function uses the decimal point as the baseline (0).
   
   1. POSITIVE PRECISION (Right of decimal):
      Rounds into fractional data (cents/decimals). 
      E.g., ROUND(123.456, 2) -> 123.46
      
   2. NEGATIVE PRECISION (Left of decimal):
      Rounds into whole, macro numbers (tens, hundreds, thousands).
      
   MEMORY TRICK - "Count the Zeros":
   WE have to Think of the negative number as the number of trailing zeros we want to force 
   at the end of our integer:
   
   * To the nearest 10    (1 zero  -> '10')   -> Use -1  (e.g., 123.45 becomes 120)
   * To the nearest 100   (2 zeros -> '100')  -> Use -2  (e.g., 123.45 becomes 100)
   * To the nearest 1000  (3 zeros -> '1000') -> Use -3  (e.g., 1234.5 becomes 1000)
   =============================================================================== */

-- 28. Display the first 6 digits of CardNumber followed by 'XXXX-XXXX'.
SELECT * FROM Sales.CreditCard;
SELECT CardNumber,
       LEFT(CardNumber, 6) + 'XXXX-XXXX' AS MaskedCardNumber
FROM Sales.CreditCard;

-- 29. Calculate the Square (SQUARE) of the ListPrice for all products.
SELECT * FROM Production.Product;
SELECT ProductID,
       Name,
       SQUARE(ListPrice) AS squarePrice
FROM Production.Product;
/* The SQUARE function mu tiplies a number by itself (e.g., 5 squared is 5 x 5 = 25). */

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
/* The CHARINDEX function searches for a specific substring (or character) inside another string and returns its starting position as an integer.
   CHARINDEX(substring, string, [start\_location]):
     * substring: The characters you are looking for (e.g., '@').
     * string: The column or text you are searching within.
     * start_location (Optional): The position where the search starts. If omitted, it starts at the beginning */

-- 32. Create an "Employee Code": First 2 letters of JobTitle + Last 3 digits of BusinessEntityID.
SELECT * FROM HumanResources.Employee;
SELECT CONCAT(LEFT(JobTitle, 2), RIGHT(BusinessEntityID, 3)) AS EmployeeCode 
FROM HumanResources.Employee;

-- 33. Divide ListPrice by 2 and round the result to 4 decimal places.
SELECT * FROM Production.Product;
SELECT ListPrice,
       ROUND(ListPrice / 2.0, 4) AS DividedAndRoundedPrice -- best to divide with decimal number so we gat a decimal too
FROM Production.Product;
/* We divide by '2.0' instead of '2' to force "Implicit Conversion" to a decimal type.
   Using a decimal divisor ensures we maintain precision before rounding */

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
/* To understand why we need RTRIM, we must look at how SQL stores text:
   
   1. VARCHAR(10) [Variable Character]: 
      Dynamic storage. If we input 'HR', it takes exactly 2 spaces. 
      No wasted space, no hidden characters.
      
   2. CHAR(10) [Fixed Character]: 
      Fixed-size storage. If we input 'HR', SQL Server MANDATORILY pads the remaining 
      8 spaces with invisible blanks to fill the definition. 
      The database literally stores it as 'HR        '.
      
   THE PROBLEM:
   If we try to filter a CHAR(10) column using: WHERE CountryCode = 'HR'
   The query will FAIL because 'HR' is mathematically not equal to 'HR        '.
   
   THE SOLUTION:
   We use RTRIM(CountryCode) to temporarily "shave off" those database-generated 
   trailing spaces so our string comparisons work perfectly.

   - LTRIM cuts the left side.
   - RTRIM cuts the right side.
   - TRIM cuts both sides at once
 */

-- 38. Extract the Year from HireDate using SUBSTRING (treat date as string).
SELECT HireDate,
       SUBSTRING(CAST(HireDate AS VARCHAR), 1, 4) AS YearFromSubstring        
FROM HumanResources.Employee;
/* ===============================================================================
   THE SUBSTRING() "TEXT SCISSORS" RULE
   ===============================================================================
   What it is:
   SUBSTRING is a string-slicing tool. It functions like a pair of precise scissors 
   designed to cut out a specific piece of text and discard the rest.
   
   How the parameters work:
   SUBSTRING(text_source, start_position, length_to_cut)
   
   * text_source:    The string we want to slice (e.g., '2026-06-10').
   * start_position: The exact character index where the scissors start cutting (1 = first letter).
   * length_to_cut:  How many characters to move and keep to the right from the starting point.
   
   Why CAST is used here:
   Because SUBSTRING only knows how to cut text (VARCHAR). Since HireDate is a native 
   DATE object, CAST(HireDate AS VARCHAR) must first convert the calendar object into 
   the text format '2026-06-10' so the scissors can safely do their job and extract '2026' */

-- 39. Calculate the Absolute (ABS) difference between the Bonus and CommissionPct.
SELECT ABS(CommissionPct - Bonus) AS AbsoluteDifference FROM Sales.SalesPerson;
/* ===============================================================================
   THE ABS() FUNCTION (The Minus Destroyer)
   ===============================================================================
   1. WHAT IT DOES:
      ABS stands for Absolute Value. It simply deletes the minus sign from any 
      negative number, turning it positive. Positive numbers remain unchanged.
      E.g., ABS(-25) -> 25  and  ABS(25) -> 25.
      
   2. WHY WE USE IT (The Distance Concept):
      We use ABS when we only care about the "distance" or "gap" between two numbers, 
      regardless of which one is bigger */

-- 40. Create a label: "Vendor: [Name] - Rating: [CreditRating]".
SELECT * FROM Purchasing.Vendor;
SELECT CONCAT('Vendor: ', Name, ' - Rating: ', CreditRating) FROM Purchasing.Vendor;
-- or
SELECT Name, 
       CreditRating, 
       'Vendor: ' + Name + ' - Rating: ' + CAST(CreditRating AS VARCHAR) AS VendorLabel
FROM Purchasing.Vendor;
/* To combine text (VARCHAR) with a number (INT), we MUST use the CAST function to convert the numeric value into text first.

   Without 'CAST(CreditRating AS VARCHAR)', SQL Server would try to mathematically add the string 'Vendor: ' to the number, resulting in a Conversion Error */

-- ============================================================================
-- LEVEL 3: ADVANCED DATES & TIME (41 - 60)
-- ============================================================================

-- 41. Find the exact number of minutes between OrderDate and ShipDate.
SELECT * FROM Sales.SalesOrderHeader;
SELECT OrderDate,
	   ShipDate,
	   DATEDIFF(minute, OrderDate, ShipDate) AS MinutesToShip
FROM Sales.SalesOrderHeader;
/* WHAT IT DOES:
      DATEDIFF stands for Date Difference. It acts as a digital stopwatch that 
      calculates the exact temporal distance between two timestamps.
      
   SYNTAX STRUCTURE:
      DATEDIFF(unit, start_date, end_date)
      * unit: The measurement unit we want (year, month, day, hour, minute, second).
      * start_date: When the stopwatch starts.
      * end_date: When the stopwatch stops */

-- 42. Retrieve all sales orders that were placed on a Friday (DATENAME).
SELECT SalesOrderID, 
       OrderDate,
       DATENAME(weekday, OrderDate) AS DayName
FROM Sales.SalesOrderHeader
WHERE DATENAME(weekday, OrderDate) = 'Friday';
-- The DATENAME(interval, date) function returns a character string that represents the specified part of a date (e.g., Year, Month, Weekday)
/* WHAT IT DOES:
      DATENAME extracts a specific part of a date and returns it as a localized 
      text string (a word) rather than a number.
      E.g., DATENAME(weekday, '2026-06-12') -> 'Friday'
            DATENAME(month, '2026-06-12')   -> 'June'
            
   THE WHERE CLAUSE TIMING TRAP:
      We cannot write: WHERE DayName = 'Friday'. 
      Why? Because SQL executes the WHERE filter BEFORE it executes the SELECT list. 
      Since the alias 'DayName' does not exist yet when the database is filtering, 
      we must repeat the full DATENAME() function inside the WHERE clause */

-- 43. Add exactly 100 days to the current system date (GETDATE). 
SELECT DATEADD(day, 100, GETDATE()) AS DateIn100Days;
/* 1. WHAT IT DOES:
      DATEADD allows us to step forward into the future (positive numbers) or 
      backward into the past (negative numbers) along a calendar timeline.
      
   2. SYNTAX STRUCTURE:
      DATEADD(datepart, number, date)
      
   3. FLEXIBLE INTERVALS (Moving Months and Years):
      You can easily change the first parameter to target different time horizons:
      * DATEADD(day, 100, GETDATE())   -> Adds 100 days to today.
      * DATEADD(month, 3, GETDATE())   -> Adds 3 months to today.
      * DATEADD(year, 5, GETDATE())    -> Adds 5 years to today. */

-- 44. Extract only the Hour (DATEPART) from the ModifiedDate column in Person.Person.
SELECT * FROM Person.Person;
SELECT FirstName, 
	   LastName, 
	   DATEPART(hour, ModifiedDate) AS hours 
FROM Person.Person;
/* 1. WHAT IT DOES:
      DATEPART acts like a laser scalpel, slicing into a DATETIME object and 
      extracting a single component as a pure, raw integer (INT).
      
   2. HIGH-PRECISION INTERVALS:
      Unlike DATENAME, it never returns words—only numbers. It is fully compatible 
      with micro-time units where no shortcut functions exist:
      * DATEPART(hour, ModifiedDate)        -> Returns 0 to 23
      * DATEPART(minute, ModifiedDate)      -> Returns 0 to 59
      * DATEPART(second, ModifiedDate)      -> Returns 0 to 59
      * DATEPART(millisecond, ModifiedDate) -> Returns 0 to 999
      
   3. WHY IT MATTERS (No Shorthands for Time):
      While SQL Server offers shorthand functions for dates (YEAR(), MONTH(), DAY()), 
      it DOES NOT provide HOUR() or MINUTE() functions. For time-tracking, DATEPART 
      is our mandatory tool. */

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
       FORMAT(ListPrice, 'C', 'de-DE') AS GermanPriceFormat -- C = standard numeric format string for currency
FROM Production.Product
WHERE ListPrice > 0;
/* 1. WHAT IT DOES:
      FORMAT acts as a visual stylist. It takes a raw, ugly database number and 
      dresses it up according to the linguistic and cultural laws of a specific country.
      Syntax: FORMAT(value, type_of_data, culture_code)
      
   2. THE PARAMETERS DECODED:
      * 'C' (The Type): Short for "Currency". It tells SQL: "Treat this number as money."
      * 'de-DE' (The Culture): 
         - 'de' (lowercase) = The Language (Deutsch)
         - 'DE' (uppercase) = The Country (Deutschland/Germany)
         
   3. THE REGIONAL TRANSFORMATION:
      When we combine 'C' and 'de-DE', SQL automatically applies German financial rules:
      - It appends the Euro symbol (€) to the right side of the string.
      - It swaps commas and periods (using dots for thousands, and commas for decimals).
        Example: Raw 1234.56 becomes text string '1.234,56 €'

	LETTER   NAME         WHAT IT DOES                            EXAMPLE (1234.5)
	   -------------------------------------------------------------------------------
	   'C'      Currency     Adds currency symbol + 2 decimals       1.234,50 €
	   'P'      Percentage   Multiplies by 100 + adds % sign         123.450,00 %
	   'N'      Number       Adds thousands separators + 2 decs      1.234,50
	   'F'      Fixed-point  Enforces exact decimals, NO thousands   1234,50
	   'D'      Decimal      Pads integers with leading zeros        (Only for INTs)
	   
	   THE PRECISION TRICK:
	   We can aslo append a number directly to the letter to override the default 2 decimals:
	   * 'P0' -> Percentage with ZERO decimals (e.g., 8%)
	   * 'C3' -> Currency with THREE decimals (e.g., 1.234,500 €)
	   * 'D6' -> Forces an integer to be 6 digits long (e.g., 45 becomes 000045) */

-- 47. Retrieve all sales orders that were placed at exactly 12:00 PM (Noon).
SELECT SalesOrderID, 
       OrderDate 
FROM Sales.SalesOrderHeader
WHERE CAST(OrderDate AS TIME) = '12:00:00';
/* To find a specific time in a DATETIME column, we can use the CAST function to isolate the TIME portion or use DATEPART to check the specific hour and minute */

-- 48. Find employees born in leap years (e.g., 1980, 1984, 1988).
SELECT BusinessEntityID, 
       BirthDate,
       YEAR(BirthDate) AS BirthYear
FROM HumanResources.Employee
WHERE (YEAR(BirthDate) % 4 = 0 AND YEAR(BirthDate) % 100 <> 0) 
   OR (YEAR(BirthDate) % 400 = 0);
/* A Leap Year occurs every 4 years to keep our calendar in alignment with Earth's revolutions around the Sun. However, the rule has specific exceptions.
   
   Modulo Operator %:
     * The '%' operator returns the remainder of a division
     * 'Year % 4 = 0' means the year is perfectly divisible by 4

   THE LEAP YEAR ALGORITHM EXPLAINED:
   1. (YEAR % 4 = 0 AND YEAR % 100 <> 0): Most leap years are divisible by 4 but centuries (like 1900) are NOT, even though they are divisible by 4.
   2. OR (YEAR % 400 = 0): Centuries ARE leap years ONLY if they are divisible by 400 (e.g., 2000 was a leap year)
   WHY THIS MATTERS: 
   This demonstrates the ability to implement complex business rules and mathematical algorithms directly within a SQL filter */

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
/* The EOMONTH function returns the last day of the month that contains a specified date. It is extremely useful for financial reporting and calculating deadlines that fall at the end of a month.
   Syntax: EOMONTH(startDate, [mnthToAdd])
     * start_date: The date you are checking (e.g., OrderDate).
     * month_to_add (Optional): An integer representing the number of months to add to the start date before finding the last day. If you put 1, it gives you the last day of the next month */

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
/* The FORMAT function allows for highly specific date representations using tokens like 'dddd', 'MMMM', and 'yyyy'

   SYNTAX:
   1. VALUE: The column or data you want to format (e.g., ListPrice, HireDate)
   2. FORMAT_STRING: A pattern that defines how the data should look
      * 'C' = Currency (adds symbols, thousand separators, and decimals)
      * 'D' = Long Date pattern
      * 'dd/MM/yyyy' = Custom date pattern (day/month/year)
   3. CULTURE (Optional): A string that specifies the language/region (e.g., 'en-US', 'de-DE')
   
   FORMAT TOKENS EXPLAINED:
     1. 'dddd': Returns the full name of the day (e.g., 'Monday')
     2. 'dd.': Returns the day of the month as two digits followed by a dot
     3. 'MMMM': Returns the full name of the month (e.g., 'June')
     4. 'yyyy': Returns the full 4-digit year (e.g., '1982') */

-- 53. Extract the Week Number (DATEPART) for every order in 2013.
SELECT SalesOrderID,
       DATEPART(week, OrderDate) AS weekNumber
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2013;
-- The DATEPART(week, date) function returns an integer that represents the week of the year (1 to 53)

-- 54. Calculate the difference in hours between OrderDate and DueDate.
SELECT SalesOrderID, 
       OrderDate,
       DATEDIFF(hour, OrderDate, DueDate) AS differenceInHours
FROM Sales.SalesOrderHeader;

-- 55. Find all persons who last updated their data (ModifiedDate) in 2014.
SELECT BusinessEntityID, 
	   FirstName, 
	   LastName, 
	   ModifiedDate 
FROM Person.Person
WHERE YEAR(ModifiedDate) = 2014;

-- or

SELECT BusinessEntityID, 
	   FirstName, 
	   LastName, 
	   ModifiedDate 
FROM Person.Person
WHERE DATEPART(year, ModifiedDate) = 2014;

/* 1. YEAR() is a specialized shortcut function. Because its entire purpose is 
      hardcoded to extract ONLY the year, it does not need a 'unit' parameter 
      like DATEPART() or DATENAME() do. It only needs the date column itself.
      
   2. The Date Shortcuts:
      SQL Server provides exactly three fast shortcuts for basic calendar dates:
      * YEAR(ModifiedDate)  -> Equal to DATEPART(year, ModifiedDate)
      * MONTH(ModifiedDate) -> Equal to DATEPART(month, ModifiedDate)
      * DAY(ModifiedDate)   -> Equal to DATEPART(day, ModifiedDate) */

-- 56. Calculate how many days are left until a CreditCard expires from today's date.
SELECT CreditCardID,
       ExpMonth,
       ExpYear,
       DATEDIFF(day, GETDATE(), EOMONTH(DATEFROMPARTS(ExpYear, ExpMonth, 1))) AS DaysUntilExpiry
FROM Sales.CreditCard;
/* We do not try to write this whole line at once. We build it like a puzzle from 
   the inside out:
   
   1. THE PROBLEM:
      We need to find the days until expiry using DATEDIFF(day, GETDATE(), EndDate).
      But we don't have an 'EndDate' column—only raw numbers for Month and Year.
      
   2. STEP-BY-STEP CONSTRUTION:
      * STEP 1: We use DATEFROMPARTS(ExpYear, ExpMonth, 1) to glue the 
        numbers into a valid calendar object. We use '1' (the 1st of the month) 
        as a mandatory placeholder because the function demands a day.
      * STEP 2: Credit cards expire on the LAST day of the month, 
        not the first. We wrap our new date inside EOMONTH() to automatically 
        push the date to the final day (e.g., changing Oct 1st to Oct 31st).
      * STEP 3: Now that we have a perfect end-date, we drop the whole 
        package into our DATEDIFF stopwatch to count the days left from today. */

-- 57. Find orders placed in the 2nd Quarter of any year (April, May, June).
SELECT SalesOrderID, 
       OrderDate,
       DATENAME(month, OrderDate) AS MonthName, -- Added for visual confirmation
       DATEPART(quarter, OrderDate) AS QuarterNumber
FROM Sales.SalesOrderHeader
WHERE DATEPART(quarter, OrderDate) = 2;
/* 1. WHAT IT IS:
      The calendar is not just years and months. SQL Server has hardcoded built-in 
      knowledge of business and seasonal cycles. The 'quarter' parameter splits 
      any year into 4 equal segments of 3 months each.
      
   2. THE FOUR SEGMENTS:
      * Quarter 1 = January, February, March
      * Quarter 2 = April, May, June (Targeted in this challenge)
      * Quarter 3 = July, August, September
      * Quarter 4 = October, November, December
      
3. THE MASTER INTERVAL REFERENCE SHEET:
      Interval     | What it extracts     | DATEPART() Output | DATENAME() Output
      ----------------------------------------------------------------------------
      year         | Year                 | 2026 (INT)        | '2026' (TEXT)
      quarter      | Quarter of the year  | 1 to 4 (INT)      | '1' to '4' (TEXT)
      month        | Month of the year    | 1 to 12 (INT)     | 'June', 'January'
      day          | Day of the month     | 1 to 31 (INT)     | '1' to '31' (TEXT)
      dayofyear    | Day of year (Day No) | 1 to 366 (INT)    | '1' to '366' (TEXT)
      week         | Week of the year     | 1 to 53 (INT)     | '1' to '53' (TEXT)
      weekday      | Day of the week      | 1 to 7 (INT)      | 'Friday', 'Monday'
      

   =============================================================================== */

-- 58. Display the HireDate and move it to the "Next Monday" (DATEADD logic).
SELECT BusinessEntityID, 
       HireDate,
       DATENAME(weekday, HireDate) AS HireDay,
       DATEADD(week, DATEDIFF(week, 0, HireDate) + 1, 0) AS NextMonday
FROM HumanResources.Employee;
/* 1. PURPOSE:
      Adds or subtracts a specified time interval (days, months, years) to/from 
      a starting date. SQL automatically handles varying month lengths and leap years.
      
   2. SYNTAX:
      DATEADD(datepart, number, start_date)
      
   3. DIRECTION CONTROL:
      * Positive numbers move FORWARD into the future: DATEADD(day, 30, GETDATE())
      * Negative numbers move BACKWARD into the past:   DATEADD(month, -6, GETDATE())
      
   4. COMMON INTERVALS (datepart):
      * year, quarter, month, day, week, hour, minute, second
   =============================================================================== */

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
-- It can be executed without ORDER BY as well. 

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
/* 1. GROUP BY ExpYear: This is a data-processing step. It collapses multiple rows into single buckets based on the year, allowing us to perform calculations (like COUNT) on each group.
   2. ORDER BY ExpYear: This is a presentation-level step. It sorts the already grouped results in ascending order so the report is easy to read */

-- 63. Calculate the average Freight cost per ShipMethodID.
SELECT ShipMethodID, 
       AVG(Freight) AS AvgFreight
FROM Sales.SalesOrderHeader
GROUP BY ShipMethodID;
/* LOGIC: 
     1. SELECT ShipMethodID: To show which shipping method we are looking at
     2. AVG(Freight): To calculate the average cost for that group
     3. GROUP BY ShipMethodID: To separate the calculations by each shipping method */

-- 64. Display the Minimum and Maximum SubTotal for each SalesPersonID.
SELECT SalesPersonID,
       MIN(SubTotal) AS MinSub,
       MAX(SubTotal) AS MaxSub
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IS NOT NULL
GROUP BY SalesPersonID;
/* LOGIC: 
      1. GROUP BY SalesPersonID: Creates a bucket for each salesperson.
      2. MIN(SubTotal): Finds the smallest order amount for that person.
      3. MAX(SubTotal): Finds the largest order amount for that person.

   When using aggregate functions (like MIN, MAX, SUM), any column in the SELECT list that is not inside a function must be included in the GROUP BY clause.
   Why? SQL cannot display a specific SalesOrderID (which changes for every row) alongside a MIN(SubTotal) that is calculated for a whole group of people. 
   It would be like trying to list every student's ID next to the entire class's average grade—it doesn't fit in one row */

-- 65. Sum the total Weight of products for each Class (H, M, L).
SELECT Class, 
       SUM(Weight) AS TotalClassWeight
FROM Production.Product
WHERE Weight IS NOT NULL AND Class IS NOT NULL
GROUP BY Class;
/* LOGIC: 
     1. GROUP BY Class: Segregates products into High, Medium, and Low categories
     2. SUM(Weight): Calculates the total combined weight for all products in that class
     3. WHERE Class IS NOT NULL: Removes products that don't have a defined class */

-- 66. Find Departments that have an average VacationHours greater than 50.
SELECT * FROM HumanResources.Employee;
SELECT * FROM HumanResources.Department;
SELECT * FROM HumanResources.EmployeeDepartmentHistory;

-- 1.step 
SELECT * FROM HumanResources.Employee e
JOIN HumanResources.EmployeeDepartmentHistory edh 
    ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department d 
    ON edh.DepartmentID = d.DepartmentID;
 
-- 2.step 
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

/* LOGIC: 
     1. JOIN three tables to connect Employees to their Department names
     2. GROUP BY Department Name
     3. Use HAVING to filter groups where the calculated average is > 50 */

-- 67. Count how many products belong to each Style (W, M, U).
SELECT Style, 
       COUNT(*) AS ProductCount
FROM Production.Product
WHERE Style IS NOT NULL
GROUP BY Style;
/* LOGIC: 
     1. SELECT Style: The category we want to see
     2. COUNT(*): Counts all products in each category
     3. GROUP BY Style: Necessary to collapse individual products into groups */

-- 68. Calculate the total TaxAmt for each year.
SELECT YEAR(OrderDate) AS OrderYear, 
       SUM(TaxAmt) AS TotalTaxCollected
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY OrderYear;
/* LOGIC: 
     1. YEAR(OrderDate): Extracts the year from the full date
     2. SUM(TaxAmt): Adds up all tax amounts for each year group
     3. GROUP BY YEAR(OrderDate): Collapses all orders into yearly buckets */

-- 69. Find the CustomerID who has placed the highest number of orders (Top 1).
SELECT TOP 1 CustomerID, 
       COUNT(SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY OrderCount DESC;
/* LOGIC: 
     1. SELECT TOP 1: Filters the final result to show only the single highest row
     2. COUNT(SalesOrderID): Counts how many orders each customer has made
     3. GROUP BY CustomerID: Aggregates the orders for each individual customer
     4. ORDER BY Count DESC: Places the person with the most orders at the very top*/

-- 70. Display only those Cities that have exactly 1 address registered.
SELECT City, 
       COUNT(*) AS AddressCount
FROM Person.Address
GROUP BY City
HAVING COUNT(*) = 1;
/* 1. THE CRITICAL DIFFERENCE (WHERE vs. HAVING):
      * WHERE filters raw, individual rows BEFORE they are grouped. It cannot see 
        or filter aggregated math like COUNT(*), SUM(), or AVG().
      * HAVING filters aggregated groups AFTER the GROUP BY clause has successfully 
        collapsed the rows into buckets.
        
   2. WHY WHERE FAILS HERE:
      If we try to write: WHERE COUNT(*) = 1, SQL Server will crash. At the 
      WHERE stage, the database is looking at single addresses and does not yet 
      know how many total addresses exist per city.
      
   3. THE PIPELINE EXECUTION:
      * STEP 1: GROUP BY City -> Groups all raw addresses into city-specific buckets.
      * STEP 2: COUNT(*) -> Counts the total number of records inside each finished bucket.
      * STEP 3: HAVING COUNT(*) = 1 -> Acts as a post-processing filter, inspecting 
        the final count of each bucket and throwing away any city that doesn't have 
        exactly 1 address. */

-- 71. Sum the Bonus amounts for each JobTitle in HumanResources.Employee.
SELECT e.JobTitle, 
       SUM(sp.Bonus) AS TotalBonus
FROM HumanResources.Employee AS e
JOIN Sales.SalesPerson AS sp ON e.BusinessEntityID = sp.BusinessEntityID
GROUP BY e.JobTitle;
/* LOGIC: 
     1. JOIN Employee & SalesPerson: Links job titles to their respective bonus data
     2. SUM(Bonus): Adds up the total bonus money for each category
     3. GROUP BY JobTitle: Collapses the results based on the employee's role */

-- 72. Count how many products are stored on each Shelf in the warehouse.
SELECT Shelf, 
       COUNT(*) AS ProductCount
FROM Production.ProductInventory
GROUP BY Shelf;
/* LOGIC: 
     1. SELECT Shelf, COUNT(*): Selects the shelf identifier and counts items on it
     2. FROM Production.ProductInventory: The table where stock locations are stored
     3. GROUP BY Shelf: Groups the inventory records by their physical shelf location */

-- 73. Find the average TaxRate for each StateProvinceID.
SELECT StateProvinceID, 
       AVG(TaxRate) AS AvgTax
FROM Sales.SalesTaxRate
GROUP BY StateProvinceID;
/* LOGIC: 
     1. AVG(TaxRate): Calculates the mathematical average of the tax percentages
     2. GROUP BY StateProvinceID: Groups the tax data by state/province code */

-- 74. Sum all DiscountPct values by the Discount Type in Sales.SpecialOffer.
SELECT [Type], 
       SUM(DiscountPct) AS TotalDiscount
FROM Sales.SpecialOffer
GROUP BY [Type];
/* LOGIC: 
     1. SUM(DiscountPct): Totals all discount percentages for a specific category
     2. GROUP BY [Type]: Groups the offers by their classification (e.g., 'No Discount', 'Volume Discount') */

-- 75. List the years in which more than 5,000 orders were placed.
SELECT YEAR(OrderDate) AS OrderYear, 
       COUNT(*) AS OrderCount
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
HAVING COUNT(*) > 5000;
/* LOGIC: 
     1. YEAR(OrderDate): Extracts the year to create yearly groups
     2. COUNT(*): Counts the total number of orders placed in each year
     3. HAVING COUNT(*) > 5000: Filters the years to only show those with high order volume */

-- 76. Find the lowest ListPrice for each ProductModelID.
SELECT ProductModelID, 
       MIN(ListPrice) AS MinPrice
FROM Production.Product
WHERE ProductModelID IS NOT NULL
GROUP BY ProductModelID;
/* LOGIC: 
     1. MIN(ListPrice): Finds the lowest price within a specific group
     2. WHERE ProductModelID IS NOT NULL: Removes products that don't belong to a specific model
     3. GROUP BY ProductModelID: Aggregates the prices based on the product model */

-- 77. Count the total number of Male (M) vs Female (F) employees.
SELECT Gender, 
       COUNT(*) AS EmployeeCount
FROM HumanResources.Employee
GROUP BY Gender;
/* LOGIC: 
     1. SELECT Gender, COUNT(*): Identifies the gender and counts the people in that group
     2. GROUP BY Gender: Separates the employee table into 'M' and 'F' buckets */

-- 78. Calculate the average SickLeaveHours per Department.
SELECT d.Name, 
       AVG(e.SickLeaveHours) AS AvgSickHours
FROM HumanResources.Employee AS e
JOIN HumanResources.EmployeeDepartmentHistory AS edh ON e.BusinessEntityID = edh.BusinessEntityID
JOIN HumanResources.Department AS d ON edh.DepartmentID = d.DepartmentID
WHERE edh.EndDate IS NULL
GROUP BY d.Name;
/* LOGIC: 
     1. JOIN Employee, EmployeeDepartmentHistory, and Department: Connects hours to names
     2. AVG(SickLeaveHours): Calculates the average sick leave for the whole department
     3. GROUP BY d.Name: Groups the results by the actual name of the department */

-- 79. Find the total sales (TotalDue) for each Quarter of 2013.
SELECT DATEPART(quarter, OrderDate) AS Quarter, 
       SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2013
GROUP BY DATEPART(quarter, OrderDate);
/* LOGIC: 
     1. WHERE YEAR(OrderDate) = 2013: Limits the data to the specific year
     2. DATEPART(quarter, OrderDate): Extracts the quarter (1, 2, 3, or 4)
     3. SUM(TotalDue): Totals the revenue for each quarter
     4. GROUP BY DATEPART(quarter, OrderDate): Groups the results chronologically by quarter */

-- 80. Display CustomerIDs that have spent a grand total of more than $100,000.
SELECT CustomerID, 
       SUM(TotalDue) AS TotalSpent
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING SUM(TotalDue) > 100000;
/* LOGIC: 
     1. SUM(TotalDue): Adds up every dollar a customer has ever spent
     2. GROUP BY CustomerID: Aggregates all orders for each unique customer
     3. HAVING SUM(TotalDue) > 100000: Filters for "VIP" customers who exceeded the threshold */
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
/* LOGIC: 
     1. FROM HumanResources.Employee AS e (This represents the SUBORDINATE)
     2. JOIN HumanResources.Employee AS m (This represents the MANAGER)
     3. ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode (Finds the person whose position is exactly one level above this employee using HierarchyID)

   GetAncestor(n) Function
     * DATA TYPE: Works specifically with the 'HierarchyID' data type
     * PURPOSE: It is used to navigate tree-like structures (e.g., Company Org Charts)
     * LOGIC:
        - It returns a hierarchy node that is 'n' levels above the current node
        - GetAncestor(1) = The immediate parent/manager
        - GetAncestor(2) = The grandparent/director
     * USAGE IN SELF JOIN: 
        By setting 'Employee.GetAncestor(1) = Manager.Node', we are essentially saying:
        "Find the person whose position is exactly one level above this employee" */

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
     1. SELECT p.Name: To know which product we are looking at
     2. SELECT pch.StandardCost and pch.StartDate: To see the cost and when it began
     3. JOIN on ProductID: Links the product to its historical cost records */

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
     1. JOIN Department (d) and EmployeeDepartmentHistory (edh) on DepartmentID
     2. FILTER by Department Name = 'Information Services'
     3. FILTER for Current Employees where EndDate IS NULL */

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
   * Goal: Connect Products to their images.
   * The Problem: A Product can have many photos, and a Photo could potentially be used for many products. They cannot be linked directly.
   * The Solution: We use a "Bridge" (Junction) table called 'ProductProductPhoto'.
   * The Chain:
       1. Product (p) links to Bridge (ppp) via [ProductID].
       2. Bridge (ppp) links to ProductPhoto (pp) via [ProductPhotoID].
   * Key Detail: We use [Primary] in brackets because 'Primary' is a reserved SQL keyword */

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

/*
===============================================================================
ADVENTUREWORKS ADVANCED CHALLENGES (101 - 120)
Focus: JOINS + AGGREGATIONS (SUM, COUNT, AVG) + GROUP BY + HAVING
===============================================================================
*/

-- 101. The Million Dollar Sellers
-- Display the FirstName and LastName of sales persons and their total sales (TotalDue). 
-- Only include those whose total sales exceed 2,000,000.
-- Tables: Person.Person (p), Sales.SalesOrderHeader (soh)
SELECT * FROM Person.Person;
SELECT * FROM Sales.SalesOrderHeader;

SELECT * FROM Person.Person p JOIN Sales.SalesOrderHeader soh ON p.BusinessEntityID = soh.SalesPersonID;

SELECT p.FirstName, 
       p.LastName, 
       SUM(soh.TotalDue) AS TotalSales 
FROM Person.Person p
JOIN Sales.SalesOrderHeader soh 
    ON p.BusinessEntityID = soh.SalesPersonID 
GROUP BY p.FirstName, 
         p.LastName 
HAVING SUM(soh.TotalDue) > 2000000;

/* 1. GROUP BY vs. WHERE (The Timing Rule):
        * WHERE filters individual rows BEFORE they are summed up. It doesn't know the TotalSales yet
        * HAVING filters the "Buckets" AFTER SQL has calculated the SUM()
        GOLDEN RULE: we use WHERE for raw data, and HAVING for aggregated results (like SUM > 2M)

   2. THE LEVEL OF DETAIL (Why SELECT columns must be in GROUP BY):
        * If we ask for FirstName and LastName but don't Group By them, SQL gets confused
        * It wouldn't know which name to attach the single TotalSales number to
        * By adding them to GROUP BY, we tell SQL "Create exactly one row for every unique combination of name and surname."

   3. THE CATEGORY vs. CALCULATION RULE:
        * GROUP BY = The "Buckets" (Categories like Name, ID, or City)
        * SUM/SELECT/HAVING = The "Action" (What we do inside those buckets)
        * We cannot group by a SUM because the sum doesn't exist until the grouping is finished */


-- 102. Most Popular Products by Category
-- Display the Product Category Name and the total number of items sold (OrderQty).
-- Tables: Production.ProductCategory, Production.ProductSubcategory, Production.Product, Sales.SalesOrderDetail
SELECT * FROM Production.ProductCategory;
SELECT * FROM Production.ProductSubcategory;
SELECT * FROM Production.Product;
SELECT * FROM Sales.SalesOrderDetail;

SELECT pc.Name AS CategoryName, 
       SUM(sod.OrderQty) AS TotalQuantitySold
FROM Production.ProductCategory pc
JOIN Production.ProductSubcategory ps 
    ON pc.ProductCategoryID = ps.ProductCategoryID
JOIN Production.Product p 
    ON ps.ProductSubcategoryID = p.ProductSubcategoryID
JOIN Sales.SalesOrderDetail sod 
    ON p.ProductID = sod.ProductID
GROUP BY pc.Name
ORDER BY TotalQuantitySold DESC;
/* 1. THE CHAIN JOIN (Connecting the Dots):
        * We start at 'ProductCategory' but the sales data is far away in 'SalesOrderDetail'
        * Like a bridge, we must cross through 'Subcategory' and 'Product' to get there
        RULE: Each JOIN must have a matching ID (PK/FK) to keep the data integrity

   2. THE LEVEL OF DETAIL (Group By Name):
        * We want to see the Name of the Category, so that is our "Bucket"
        * Even though we crossed 4 tables, SQL only cares about the final bucket we defined: 'pc.Name'. All products from all subcategories will be thrown into this one bucket

   3. THE CALCULATION (Summing the Quantity):
        * Once the buckets are ready, we use SUM(OrderQty) to count every item sold
        * ORDER BY: Finally, we sort by 'TotalQuantitySold' DESC to put the best-selling categories at the very top */


-- 103. Average Freight Cost per Country
-- Calculate the average freight cost (Freight) for each country (CountryRegion).
-- Tables: Sales.SalesOrderHeader, Sales.SalesTerritory, Person.CountryRegion
SELECT cr.Name AS Country, 
       AVG(soh.Freight) AS AvgFreight
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st 
    ON soh.TerritoryID = st.TerritoryID
JOIN Person.CountryRegion cr 
    ON st.CountryRegionCode = cr.CountryRegionCode
GROUP BY cr.Name;
/* 1. THE GEOGRAPHIC BRIDGE (Why these joins?):
       * 'SalesOrderHeader' knows the cost (Freight), but it doesn't know the Country Name
       * It only knows the 'TerritoryID'. So we jump to 'SalesTerritory'
       * 'SalesTerritory' knows the 'CountryRegionCode', but still not the full Name
       * Finally, we join 'CountryRegion' to get the human-readable Country Name

   2. BUCKETS & LEVEL OF DETAIL (Group By Country Name):
       * We want the average per Country, so 'cr.Name' is our "Bucket"
       * SQL takes thousands of individual orders, looks at which country they belong to, and throws them into the corresponding country bucket
       * RULE: Since 'cr.Name' is what we want to see in the final list, it MUST be in GROUP BY

   3. THE CALCULATION (Avg vs. Each Row):
       * WHERE vs AVG: SQL doesn't use 'WHERE' here because we aren't filtering single shipping costs. We are calculating the "Average" (AVG) of all costs found inside each country's bucket AFTER the grouping is done */

-- 104. High-Value Customers
-- Find the CustomerID of customers who have placed more than 25 orders.
-- Table: Sales.SalesOrderHeader
SELECT CustomerID, 
       COUNT(SalesOrderID) AS OrderCount
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING COUNT(SalesOrderID) > 25;
/* 1. THE "BUCKET" LOGIC (GROUP BY):
      * We want to analyze data per customer, so 'CustomerID' is our "Bucket"
      * Every single order in the table is thrown into a bucket labeled with its CustomerID
     RULE: Since 'CustomerID' is what we want to display, it must be in GROUP BY to define the level of detail.

  2. THE "TIMING" RULE (WHERE vs. HAVING):
     * We CANNOT use 'WHERE' to filter the order count. Why? 
         Because 'WHERE' acts on individual rows before they are counted
     * 'HAVING' is the filter for the buckets AFTER SQL has finished counting
     * Think of it as: "Only keep the buckets that ended up with more than 25 items"

  3. THE CALCULATION (COUNT):
     Inside each bucket, SQL performs the action: counting the SalesOrderIDs */

-- 105. Inventory Value by Location
-- Display the Warehouse Location Name and the total value of stock (Quantity * StandardCost).
-- Tables: Production.Location, Production.ProductInventory, Production.Product
SELECT l.Name AS LocationName, 
       SUM(pi.Quantity * p.StandardCost) AS TotalStockValue
FROM Production.Location l
JOIN Production.ProductInventory pi 
    ON l.LocationID = pi.LocationID
JOIN Production.Product p 
    ON pi.ProductID = p.ProductID
GROUP BY l.Name;
/* 1. THE MULTI-JOIN BRIDGE (Connecting Data):
     * We start with 'Location' (l) to get the human-readable Warehouse names
     * We join 'ProductInventory' (pi) to see HOW MANY items are in those locations
     * We join 'Product' (p) to find out the COST of each item
     * RULE: Without this bridge, we would have quantities without prices, or names without stock data.

  2. BUCKETS & LEVEL OF DETAIL (GROUP BY):
     - We want to see the total value "per location", so 'l.Name' is our "Bucket"
     - Every product found in the inventory is thrown into the bucket of the warehouse it currently sits in
     - RULE: Since 'l.Name' is our label in the SELECT list, it MUST be in the GROUP BY clause to define our rows

  3. THE CALCULATION (SUM & Math):
     - Inside each bucket, SQL performs a row-by-row calculation: (Quantity * StandardCost)
     - Once all items in the bucket are calculated, SUM() adds them all together to give us the 'TotalStockValue'
     - WHY NOT WHERE? We can't use WHERE to filter the total value because the math happens during the grouping process, not before */

-- 106. Employee Count by Department
-- Display each Department Name and the number of employees currently working there (EndDate IS NULL).
-- Tables: HumanResources.Department, HumanResources.EmployeeDepartmentHistory
SELECT d.Name AS Department, 
       COUNT(edh.BusinessEntityID) AS EmployeeCount
FROM HumanResources.Department d
JOIN HumanResources.EmployeeDepartmentHistory edh 
    ON d.DepartmentID = edh.DepartmentID
WHERE edh.EndDate IS NULL
GROUP BY d.Name;
/* 1. THE HR BRIDGE (Connecting Departments to People):
     * 'Department' (d) contains the human-readable names of the sectors
     * 'EmployeeDepartmentHistory' (edh) is the mapping table that links employees to those departments
     * RULE: We join them on 'DepartmentID' to align names with the actual staff records

  2. THE "WHERE" VS. "HAVING" TIMING (Filtering before Grouping):
     * 'WHERE edh.EndDate IS NULL': This is our "Current Status" filter
     * It acts BEFORE the grouping. SQL looks at every historical record and immediately discards anyone who has already left a department (where EndDate is filled)
     * Only "active" records (where EndDate is NULL) are allowed to proceed to the buckets

  3. BUCKETS & LEVEL OF DETAIL (GROUP BY):
     * We want the count "per department", so 'd.Name' is our "Bucket"
     * Every active employee record is thrown into the bucket corresponding to their department
     * RULE: Since 'd.Name' is in our SELECT list, it MUST be in the GROUP BY clause

  4. THE CALCULATION (COUNT):
     * Inside each department bucket, SQL counts the 'BusinessEntityID' (the unique ID for each person)
     * The result is a clean list of how many people currently occupy desks in each sector */

-- 107. Vacation Hours vs. Seniority
-- Display the JobTitle and the average vacation hours for each position, 
-- but only where the average is greater than 40 hours.
-- Table: HumanResources.Employee
SELECT JobTitle, 
       AVG(VacationHours) AS AvgVacation
FROM HumanResources.Employee
GROUP BY JobTitle
HAVING AVG(VacationHours) > 40;
/* 1. BUCKETS & LEVEL OF DETAIL (GROUP BY):
     * Our goal is to see data "per JobTitle", so 'JobTitle' becomes our "Bucket"
     * Every employee in the table is sorted into a bucket based on their specific role (e.g., 'Accountant', 'Production Technician', 'Design Engineer')
     * RULE: Since 'JobTitle' is the descriptive label in our SELECT, it must be present in the GROUP BY to define the rows of our report

  2. THE CALCULATION (AVG):
     * Inside each job title bucket, SQL looks at all the 'VacationHours' of employees in that role and calculates the mean value (Average)
     * This tells us the "typical" vacation balance for that specific seniority level

  3. THE "TIMING" FILTER (HAVING vs. WHERE):
     * We CANNOT use 'WHERE' to filter the 40-hour limit
     * Why? Because 'WHERE' filters individual employees BEFORE we know the average
     * 'HAVING' is our "After-the-Fact" filter. It looks at the finished buckets and only keeps those where the calculated Average is higher than 40
     * RULE: If we are filtering the result of an aggregate function (AVG, SUM, COUNT), we MUST use HAVING */

-- 108. Vendor Product Count
-- Display the Vendor Name and the number of different products they supply to us.
-- Tables: Purchasing.Vendor, Purchasing.ProductVendor
SELECT v.Name AS VendorName, 
       COUNT(pv.ProductID) AS ProductCount
FROM Purchasing.Vendor v
JOIN Purchasing.ProductVendor pv 
    ON v.BusinessEntityID = pv.BusinessEntityID
GROUP BY v.Name;
/* 1. THE PROCUREMENT BRIDGE (Connecting Vendors to Products):
     * 'Vendor' (v) holds the business names of our suppliers.
     * 'ProductVendor' (pv) is the link table that tells us exactly 
       which products are supplied by which vendor.
     * RULE: We join them on 'BusinessEntityID' to match the names with 
       their catalog of items.

  2. BUCKETS & LEVEL OF DETAIL (GROUP BY):
     * We want to see the diversity of products "per vendor", so 'v.Name' is our "Bucket". 
     * Every product record found in the catalog is sorted into the bucket belonging to its supplier
     * RULE: Since 'v.Name' is the descriptive label in our SELECT, it must be in the GROUP BY clause to define the rows of our report

  3. THE CALCULATION (COUNT):
     * Inside each vendor bucket, SQL counts the 'ProductID' entries
     * This gives us a clear metric: How many different items can we buy from this specific vendor?
     * WHY NOT WHERE? We are not filtering individual products; we are counting them AFTER they are grouped, so no row-level filter is needed here */

-- 109. Orders by Year and Month
-- Display the Year and Month of the order and the total number of orders for that period.
-- Use YEAR(OrderDate) and MONTH(OrderDate) functions.
-- Table: Sales.SalesOrderHeader
SELECT YEAR(OrderDate) AS OrderYear, 
       MONTH(OrderDate) AS OrderMonth, 
       COUNT(SalesOrderID) AS TotalOrders
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY OrderYear, OrderMonth;
/* 1. THE "BUCKET" LOGIC (GROUP BY):
     * Here, we aren't grouping by a simple column like 'Name', but by the RESULTS of functions: YEAR() and MONTH()
     * Every order is sorted into a "Time Bucket" (e.g., Year 2013, Month 5)
     RULE: Any function used in the SELECT list that isn't part of the calculation (the COUNT) MUST be repeated in the GROUP BY to define our buckets

  2. THE "TIMING" RULE (WHERE vs. GROUP BY):
     * If we wanted only orders from 2014, we would use 'WHERE' before grouping
     * But since we want the count for ALL available periods, we skip WHERE and let SQL create buckets for every unique Year/Month combination found

  3. THE CALCULATION (COUNT):
     * Inside each Year/Month bucket, SQL counts the individual SalesOrderIDs
     * This gives us the total transaction volume for that specific month

  4. THE PRESENTATION (ORDER BY):
     * Without ORDER BY, the months might appear randomly (e.g., Month 12 before Month 1)
     * By ordering by Year first, then Month, we create a chronological timeline that is easy for humans to read */

-- 110. Subcategory Price Comparison
-- Display the Subcategory Name along with its MAX and MIN ListPrice.
-- Tables: Production.ProductSubcategory, Production.Product
SELECT ps.Name AS Subcategory, 
       MAX(p.ListPrice) AS MaxPrice, 
       MIN(p.ListPrice) AS MinPrice
FROM Production.ProductSubcategory ps
JOIN Production.Product p 
    ON ps.ProductSubcategoryID = p.ProductSubcategoryID
GROUP BY ps.Name;
/* 1. THE PRODUCT BRIDGE (Connecting Names to Prices):
     * 'ProductSubcategory' (ps) contains the names (e.g., 'Mountain Bikes', 'Helmets')
     * 'Product' (p) contains the actual price tags ('ListPrice')
     * RULE: We join them on 'ProductSubcategoryID' so we can attach each price to its correct category name

  2. BUCKETS & LEVEL OF DETAIL (GROUP BY):
     * We want to see the price range "per subcategory", so 'ps.Name' is our "Bucket"
     * SQL takes every product and throws it into the bucket belonging to its subcategory name
     * RULE: Since 'ps.Name' is the label we want to display, it must be in the GROUP BY clause

  3. THE CALCULATION (MAX & MIN):
     * Inside each bucket, SQL performs two actions:
       - MAX(): Finds the single highest price in that group
       - MIN(): Finds the single lowest price in that group
     * This defines the "Price Ceiling" and "Price Floor" for each subcategory

  4. WHY NOT WHERE?
     * If we used WHERE p.ListPrice > 100, we would be filtering out products BEFORE calculating the range. By skipping WHERE, we ensure our MIN and MAX look at every available product in the bucket */

-- 111. Sales Reason Impact
-- Which Sales Reason is the most common? Display the Reason Name and the count of associated orders.
-- Tables: Sales.SalesReason, Sales.SalesOrderHeaderSalesReason
SELECT sr.Name AS Reason, 
       COUNT(osr.SalesOrderID) AS OrderCount
FROM Sales.SalesReason sr
JOIN Sales.SalesOrderHeaderSalesReason osr 
    ON sr.SalesReasonID = osr.SalesReasonID
GROUP BY sr.Name
ORDER BY OrderCount DESC;
/* 1. THE MARKETING BRIDGE (Linking Reasons to Orders):
     - 'SalesReason' (sr) contains the descriptions (e.g., 'Price', 'Review', 'Television Advertisement')
     - 'SalesOrderHeaderSalesReason' (osr) is a mapping table. Since one order can have multiple reasons, this table links each OrderID to a specific ReasonID
     - RULE: We join them on 'SalesReasonID' to see which "Reason Name" is attached to which actual sales transaction

  2. BUCKETS & LEVEL OF DETAIL (GROUP BY):
     - We want to see the frequency "per reason", so 'sr.Name' is our "Bucket"
     - Every time an order is linked to a reason, that record is thrown into the bucket of that specific reason name
     - RULE: Any column in the SELECT that isn't part of the COUNT (like sr.Name) MUST be in the GROUP BY to define the rows of our summary

  3. THE CALCULATION (COUNT):
     - Inside each reason bucket, SQL counts the 'SalesOrderID' entries
     - This tells us exactly how many times a specific reason was cited for a sale

  4. THE INSIGHT (ORDER BY):
     - By sorting 'OrderCount' in DESC (descending) order, we immediately see the most influential sales drivers at the very top */

-- 112. Customers with Multiple Credit Cards
-- Find the names of people who have more than one credit card registered in the system.
-- Tables: Person.Person, Sales.PersonCreditCard
SELECT p.FirstName, 
       p.LastName, 
       COUNT(pcc.CreditCardID) AS CardCount
FROM Person.Person p
JOIN Sales.PersonCreditCard pcc 
    ON p.BusinessEntityID = pcc.BusinessEntityID
GROUP BY p.FirstName, p.LastName, p.BusinessEntityID
HAVING COUNT(pcc.CreditCardID) > 1;
/* 1. THE IDENTITY TRAP (Why use BusinessEntityID in GROUP BY?):
     * Imaagine we have two different people named "John Smith". They have different IDs, but the same Name.
     * If we ONLY group by 'FirstName' and 'LastName', SQL will shove BOTH John Smiths into the SAME BUCKET
     * It would look like one John Smith has 4 cards, even if they each have 2
     * By adding 'BusinessEntityID' to the GROUP BY, we ensure that every bucket is unique to the ACTUAL person, even if they share a common name

  2. THE JOIN BRIDGE:
     * We connect 'Person' (p) with 'PersonCreditCard' (pcc) to see which names own which cards
     RULE: This is a 1-to-many relationship, as one person can have multiple cards

  3. BUCKETS & TIMING (HAVING vs. WHERE):
     * GROUP BY: Creates the buckets for each unique person (ID + Name)
     * COUNT: Counts the cards inside each individual's bucket
     * HAVING: This is our filter AFTER the counting is done. It discards everyone who has only 1 card, leaving only the "power users" with 2 or more */

-- 113. Total Quantity sold per Color
-- Calculate the total quantity sold grouped by product color. Ignore NULL colors.
-- Tables: Production.Product, Sales.SalesOrderDetail
SELECT p.Color, 
       SUM(sod.OrderQty) AS TotalQty
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod 
    ON p.ProductID = sod.ProductID
WHERE p.Color IS NOT NULL
GROUP BY p.Color;

-- 114. Most Expensive Order per Customer
-- Display the CustomerID and the amount of the single largest order (TotalDue) they ever made.
-- Table: Sales.SalesOrderHeader
SELECT CustomerID, 
       MAX(TotalDue) AS MaxOrderAmount
FROM Sales.SalesOrderHeader
GROUP BY CustomerID;

-- 115. Shipping Method Popularity
-- Display the Shipping Method Name (ShipMethod) and the total revenue generated through it.
-- Tables: Purchasing.ShipMethod, Sales.SalesOrderHeader
SELECT sm.Name AS ShipMethod, 
       SUM(soh.TotalDue) AS TotalRevenue
FROM Purchasing.ShipMethod sm
JOIN Sales.SalesOrderHeader soh 
    ON sm.ShipMethodID = soh.ShipMethodID
GROUP BY sm.Name;

-- 116. Late Deliveries by Territory
-- Count how many orders were delivered late (DueDate < ShipDate) for each Territory Name.
-- Tables: Sales.SalesOrderHeader, Sales.SalesTerritory
SELECT st.Name AS Territory, 
       COUNT(soh.SalesOrderID) AS LateOrderCount
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st 
    ON soh.TerritoryID = st.TerritoryID
WHERE soh.ShipDate > soh.DueDate
GROUP BY st.Name;
/* 1. THE LOGISTICS BRIDGE (Connecting Orders to Regions):
     * 'SalesOrderHeader' (soh) contains the dates (ShipDate, DueDate), but it only uses a 'TerritoryID' code
     * 'SalesTerritory' (st) provides the human-readable names (e.g., 'Northwest', 'France')
     * RULE: We join them on 'TerritoryID' so we can see which specific regions are struggling with late shipments

  2. THE "WHERE" TIMING (Filtering for Lateness):
     * 'WHERE soh.ShipDate > soh.DueDate': This filter is the most important part
     * It acts BEFORE the grouping. SQL checks every order and only lets the "Late" ones pass through to the buckets
     * Orders that were on time are discarded immediately and never counted

  3. BUCKETS & LEVEL OF DETAIL (GROUP BY):
     * We want the count "per territory", so 'st.Name' is our "Bucket"
     * Only the late orders are thrown into the bucket corresponding to their region
     * RULE: Since 'st.Name' is our label in the SELECT list, it MUST be in the GROUP BY

  4. THE CALCULATION (COUNT):
     * Inside each territory bucket, SQL counts the 'SalesOrderID' entries
     * This gives us a clear KPI: How many times did we fail to meet our deadline in this specific territory? */

-- 117. Revenue per Product Model
-- Display the Product Model Name and the total revenue (LineTotal) generated by that model.
-- Tables: Production.ProductModel, Production.Product, Sales.SalesOrderDetail
SELECT pm.Name AS ModelName, 
       SUM(sod.LineTotal) AS TotalRevenue
FROM Production.ProductModel pm
JOIN Production.Product p 
    ON pm.ProductModelID = p.ProductModelID
JOIN Sales.SalesOrderDetail sod 
    ON p.ProductID = sod.ProductID
GROUP BY pm.Name;

-- 118. Monthly Revenue in 2011
-- Display the total revenue (TotalDue) for each month specifically for the year 2011.
-- Table: Sales.SalesOrderHeader
SELECT MONTH(OrderDate) AS Month, 
       SUM(TotalDue) AS MonthlyRevenue
FROM Sales.SalesOrderHeader
WHERE YEAR(OrderDate) = 2011
GROUP BY MONTH(OrderDate)
ORDER BY Month;
/* 1. THE "WHERE" TIMING (Filtering the Year):
     * 'WHERE YEAR(OrderDate) = 2011': This filter is applied FIRST
     * SQL looks at the entire table and immediately throws away any orders that didn't happen in 2011
     * This makes the grouping much faster because the engine only works with a smaller subset of data

  2. BUCKETS & LEVEL OF DETAIL (GROUP BY):
     * We want the total revenue "per month", so 'MONTH(OrderDate)' is our "Bucket"
     * SQL takes every order from 2011 and places it into one of 12 buckets based on its month number (1 to 12)
     * RULE: Since we used 'MONTH(OrderDate)' in our SELECT list, it must be present in the GROUP BY clause to define our rows

  3. THE CALCULATION (SUM):
     * Inside each monthly bucket, SQL adds up the 'TotalDue' from every order
     * The result is the 'MonthlyRevenue' for that specific time period

  4. THE PRESENTATION (ORDER BY):
     * We order by 'Month' to ensure the report flows chronologically (Jan, Feb, Mar...)
     * Without this, SQL might show the months in a random order (e.g., May, then August) */

-- 119. Top 3 Selling Subcategories
-- Find the Top 3 subcategories with the highest total quantity of items sold.
-- Use SELECT TOP 3... ORDER BY ... DESC
SELECT TOP 3 ps.Name AS Subcategory, 
       SUM(sod.OrderQty) AS TotalQtySold
FROM Production.ProductSubcategory ps
JOIN Production.Product p 
    ON ps.ProductSubcategoryID = p.ProductSubcategoryID
JOIN Sales.SalesOrderDetail sod 
    ON p.ProductID = sod.ProductID
GROUP BY ps.Name
ORDER BY TotalQtySold DESC;

-- 120. FINAL BOSS: Comprehensive Sales Summary
-- Display the Year, the Country Name, and the Total Sales. 
-- Sort the results by Year (ASC) and then by Total Sales (DESC).
-- Tables: Sales.SalesOrderHeader, Sales.SalesTerritory, Person.CountryRegion
SELECT YEAR(soh.OrderDate) AS OrderYear, 
       cr.Name AS Country, 
       SUM(soh.TotalDue) AS AnnualSales
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesTerritory st 
    ON soh.TerritoryID = st.TerritoryID
JOIN Person.CountryRegion cr 
    ON st.CountryRegionCode = cr.CountryRegionCode
GROUP BY YEAR(soh.OrderDate), cr.Name
ORDER BY OrderYear ASC, AnnualSales DESC;
/* 1. THE GLOBAL BRIDGE (Joining 3 Tables):
     * We start with 'SalesOrderHeader' (soh) for the money and dates
     * We jump to 'SalesTerritory' (st) to find out which region code the sales belong to
     * We finally arrive at 'CountryRegion' (cr) to get the actual Country Names
     * RULE: Without this chain, we'd have money tied to codes, but we wouldn't know which country (e.g., 'United States' or 'France') is performing best

  2. THE TIME & SPACE BUCKETS (Double Grouping):
     * This is a "Multi-Level Bucket". We aren't just grouping by Country, and we aren't just grouping by Year. We are grouping by BOTH
     * SQL creates a unique bucket for every 'Year + Country' combination (e.g., [2011, France], [2011, USA], [2012, France]...)
     * RULE: Any column/function in the SELECT that isn't summed (Year and Country Name) MUST be in the GROUP BY to define these specific rows

  3. THE CALCULATION (SUM):
     * Inside each Year/Country bucket, SQL adds up all the 'TotalDue' amounts
     * This gives us the final 'AnnualSales' figure for that specific territory in that year

  4. THE STRATEGIC SORTING (Double Order By):
     * ORDER BY OrderYear ASC: We first organize the report chronologically
     * AnnualSales DESC: Within each year, we put the most profitable country at the top
     * This allows us to see at a glance who was the "Sales King" of each year */
