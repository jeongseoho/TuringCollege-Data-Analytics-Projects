-- 2.4 Enrich 2.3 query by adding taxes on a country level:
-- As taxes can vary in country based on province, the needed column is ‘mean_tax_rate’ -> average tax rate in a country.
-- Also, as not all regions have data on taxes, you also want to be transparent and show the ‘perc_provinces_w_tax’ -> a column representing the percentage of provinces with available tax rates for each country (i.e. If US has 53 provinces, and 10 of them have tax rates, then for US it should show 0,19)

-- Hint: If a state has multiple tax rates, choose the higher one. Do not double count a state in country average rate calculation if it has multiple tax rates.
-- Hint: Ignore the isonlystateprovinceFlag rate mechanic, it is beyond the scope of this exercise. Treat all tax rates as equal.



WITH
  Sales AS (

    SELECT
      LAST_DAY(Date(OrderDate), MONTH) AS order_month,
      territory.CountryRegionCode AS CountryRegionCode,
      territory.Name AS Region,
      COUNT(SalesOrderID) AS number_orders,
      COUNT(DISTINCT CustomerID) AS number_customers,
      COUNT(DISTINCT SalesPersonID) AS no_salesPersons,
      CAST(SUM(TotalDue) AS INT64) AS Total_w_tax,
  
    FROM 
      `adwentureworks_db.salesorderheader` sales_order
    JOIN 
      `adwentureworks_db.salesterritory`  territory  ON sales_order.TerritoryID = territory.TerritoryID
    
    GROUP BY
      CountryRegionCode,
      Region,
      order_month
),


  TaxRatePerCountry AS (
    
  SELECT
    stateprovince.CountryRegionCode,
    ROUND (AVG (TaxRate), 1) AS mean_tax_rate,
    -- Computes the average tax rate for each country.
    IFNULL(ROUND (COUNT (DISTINCT salestaxrate.StateProvinceID) / COUNT (DISTINCT stateprovince.StateProvinceID), 2),0) AS perc_provinces_w_tax
    -- Calculates the percentage of provinces that have a tax rate.
    -- Uses IFNULL to handle cases where there might be no tax rates recorded, setting the percentage to 0 if needed.
  FROM 
    `adwentureworks_db.stateprovince` stateprovince
  LEFT JOIN 
    `adwentureworks_db.salestaxrate` salestaxrate ON stateprovince.StateProvinceID = salestaxrate.StateProvinceID 
  GROUP BY stateprovince.CountryRegionCode 
) 


  SELECT
    order_month,
    sales.CountryRegionCode,
    Region,
    number_orders,
    number_customers,
    no_salesPersons,
    Total_w_tax,
    RANK() OVER (PARTITION BY Region ORDER BY Total_w_tax DESC) AS country_sales_rank,
    --  Ranks regions within each country based on the total sales amount (Total_w_tax), in descending order.
    SUM(Total_w_tax) OVER(PARTITION BY sales.CountryRegionCode, Region ORDER BY order_month) AS cumulative_sum,
    -- Computes the cumulative sum of Total_w_tax for each region within each country, ordered by order_month.
    mean_tax_rate,
    perc_provinces_w_tax
  
  FROM 
    Sales

  JOIN 
    TaxRatePerCountry ON Sales.CountryRegionCode = TaxRatePerCountry.CountryRegionCode
    -- Joins the sales data with tax rate data based on CountryRegionCode.
  
  -- WHERE Sales.CountryRegionCode = 'US' (Result hint)
  
  ORDER BY  -- Orders the final results first by country code, then by region (in descending order), and finally by the sales rank within each region.
      CountryRegionCode,
      region DESC,
      country_sales_rank