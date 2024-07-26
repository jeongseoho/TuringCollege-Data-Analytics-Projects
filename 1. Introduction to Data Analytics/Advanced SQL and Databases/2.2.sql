-- 2.2 Enrich 2.1 query with the cumulative_sum of the total amount with tax earned per country & region.


 -- The WITH clause defines a Common Table Expression (CTE) named Sales
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
    
SELECT -- The main query selects all columns from the Sales CTE and calculates a cumulative sum.
  *,
  SUM(Total_w_tax) OVER(PARTITION BY CountryRegionCode, Region ORDER BY order_month) as cumulative_sum
  -- Calculates a cumulative sum of Total_w_tax for each 'CountryRegionCode' and 'Region' partitioned by these columns and ordered by order_month. 
  -- This cumulative sum shows the ongoing total of sales amounts as you progress through the months.
FROM
  Sales