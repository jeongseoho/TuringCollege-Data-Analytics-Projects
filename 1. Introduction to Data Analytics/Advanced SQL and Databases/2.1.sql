-- 2.1 Create a query of monthly sales numbers in each Country & region. 
-- Include in the query a number of orders, customers and sales persons in each month with a total amount with tax earned. 
-- Sales numbers from all types of customers are required.

SELECT
    LAST_DAY(Date(OrderDate), MONTH) AS order_month, -- use LAST_DAY to find the last day of that month, labeled as 'order_month'.
    CountryRegionCode,
    Name Region,
    COUNT(*) AS number_orders,  -- To find total number of orders for the month and region.
    COUNT(DISTINCT CustomerID) AS number_customers, -- To find unique number of customers for the month and region.
    COUNT(DISTINCT SalesPersonID) AS no_salesPersons,   -- To find unique number of salespersons for the month and region.
    CAST(SUM(TotalDue) AS INT64) AS Total_w_tax -- Total sales amount for the month and region, cast to a 64-bit integer. 
    -- Casting to INT64 helps ensure that the total sales amount can be accurately and safely stored and manipulated,                                   
FROM                                                
    `adwentureworks_db.salesorderheader` sales_order
JOIN 
    `adwentureworks_db.salesterritory` territory ON sales_order.TerritoryID = territory.TerritoryID
    -- Joins the 'salesterritory' table on the TerritoryID field to include 'territory' information.
GROUP BY
  CountryRegionCode,
  Name,
  order_month;