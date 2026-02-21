/*
===============================================================================
FILE NAME:    01-Year-Over-Year-Sales-Growth.sql
PROJECT:      AdventureWorks Sales Analysis
AUTHOR:       emdej111 - Monika Jurak
DATE:         09-02-2026
DESCRIPTION:  Comparing monthly performance trends using CTEs to calculate growth.
===============================================================================
1. GOAL:       Identify monthly revenue growth or decline compared to the previous year.
2. TABLES:     Sales.SalesOrderHeader.
3. LOGIC:      - Create a CTE to aggregate sales by Year and Month.
               - Use a second CTE or Self-Join to pair current month data with 
                 the same month from the prior year.
               - Calculate the percentage difference (Growth %).
===============================================================================
*/

SELECT * FROM Sales.SalesOrderHeader;

-- Two CTS's
WITH MonthlySales AS (
                      SELECT YEAR(OrderDate) AS SaleYear,
                             MONTH(OrderDate) AS SaleMonth,
                             SUM(TotalDue) AS TotalRevenue
                      FROM Sales.SalesOrderHeader
                      GROUP BY YEAR(OrderDate), MONTH(OrderDate)
                     ),
      Comparison AS (
                     SELECT curr.SaleYear,
                            curr.SaleMonth,
                            curr.TotalRevenue AS CurrentRevenue,
                            prev.TotalRevenue AS PriorRevenue
                     FROM MonthlySales curr
                        JOIN MonthlySales prev ON curr.SaleMonth = prev.SaleMonth 
                            AND curr.SaleYear = prev.SaleYear + 1
                      )
SELECT *,
       ROUND(((CurrentRevenue - PriorRevenue) / PriorRevenue) * 100, 2) AS GrowthPct
FROM Comparison
ORDER BY SaleYear DESC, SaleMonth DESC;


-- Self-Join
WITH MonthlySales AS (
                      SELECT YEAR(OrderDate) AS SaleYear,
                             MONTH(OrderDate) AS SaleMonth,
                             SUM(TotalDue) AS TotalRevenue
                      FROM Sales.SalesOrderHeader
                     GROUP BY YEAR(OrderDate), MONTH(OrderDate)
                       )
SELECT curr.SaleYear,
       curr.SaleMonth,
       curr.TotalRevenue AS CurrentRevenue,
       prev.TotalRevenue AS PriorRevenue,
       ROUND(((curr.TotalRevenue - prev.TotalRevenue) / prev.TotalRevenue) * 100, 2) AS GrowthPct
FROM MonthlySales curr
    JOIN MonthlySales prev ON curr.SaleMonth = prev.SaleMonth 
        AND curr.SaleYear = prev.SaleYear + 1
ORDER BY curr.SaleYear DESC, curr.SaleMonth DESC;

/* STEPS EXPLAINED

   STEP 1: Data Preparation (First CTE)
   We aggregate individual sales into monthly totals

        WITH MonthlySales AS (
                              SELECT YEAR(OrderDate) AS SaleYear,
                                     MONTH(OrderDate) AS SaleMonth,
                                     SUM(TotalDue) AS TotalRevenue
                              FROM Sales.SalesOrderHeader
                              GROUP BY YEAR(OrderDate), MONTH(OrderDate)
                              ),

   STEP 2: Comparison Logic (Second CTE referencing the first one)
   We use a Self-Join to pair each month with the same month from the previous year
        
        Comparison AS (
                       SELECT curr.SaleYear,
                              curr.SaleMonth,
                              curr.TotalRevenue AS CurrentRevenue,
                              prev.TotalRevenue AS PriorRevenue
                       FROM MonthlySales curr
                        JOIN MonthlySales prev ON curr.SaleMonth = prev.SaleMonth 
                            AND curr.SaleYear = prev.SaleYear + 1
                       )

   STEP 3: Final Calculation and Output
   Calculate the percentage growth and format the results

        SELECT SaleYear,
               SaleMonth,
               ROUND(CurrentRevenue, 2) AS CurrentRevenue,
               ROUND(PriorRevenue, 2) AS PriorRevenue,
               -- Growth Formula: ((Current - Previous) / Previous) * 100
               ROUND(((CurrentRevenue - PriorRevenue) / PriorRevenue) * 100, 2) AS GrowthPct
        FROM Comparison
        ORDER BY SaleYear DESC, SaleMonth DESC;
*/
