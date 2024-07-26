-- 2.3 Enrich 2.2 query by adding ‘sales_rank’ column that ranks rows from best to worst for each country based on total amount with tax earned each month.
--  I.e. the month where the (US, Southwest) region made the highest total amount with tax earned will be ranked 1 for that region and vice versa.

WITH
  Sales AS (
  SELECT
    LAST_DAY(Date(OrderDate), MONTH) AS order_month,
    CountryRegionCode,
    Name Region,
    COUNT(*) AS number_orders,
    COUNT(DISTINCT CustomerID) AS number_customers,
    COUNT(DISTINCT SalesPersonID) AS no_salesPersons,
    CAST(SUM(TotalDue) AS INT64) AS Total_w_tax
 
  FROM 
    `adwentureworks_db.salesorderheader` sales_order
  
  JOIN 
    `adwentureworks_db.salesterritory` territory ON sales_order.TerritoryID = territory.TerritoryID
  
  GROUP BY
    CountryRegionCode,
    Name,
    order_month
)
  
  SELECT
      *,
      RANK() OVER(PARTITION BY CountryRegionCode ORDER BY Total_w_tax DESC) AS country_sales_rank,
      -- Calculates the rank of each region within its respective country based on the total sales amount (Total_w_tax), in descending order.
      SUM(Total_w_tax) OVER(PARTITION BY CountryRegionCode, Region ORDER BY order_month) AS cumulative_sum,
      -- Calculates the cumulative sum of Total_w_tax for each region within each country, ordered by order_month.
  FROM Sales
  
  --  WHERE CountryRegionCode = 'FR'(Result hint)

  ORDER BY CountryRegionCode,country_sales_rank