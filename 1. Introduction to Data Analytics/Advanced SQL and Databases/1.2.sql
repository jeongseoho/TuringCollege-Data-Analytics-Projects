-- 1.2 Business finds the original query valuable to analyze customers and now want to get the data from the first query 
-- for the top 200 customers with the highest total amount (with tax) who have not ordered for the last 365 days. 
-- How would you identify this segment?

-- Hints: You can use temp table, cte and/or subquery of the 1.1 select. Note that the database is old and the current date should be defined by finding the latest order date in the orders table.


WITH LatestOrderDate AS (
    SELECT MAX(OrderDate) AS MaxOrderDate   -- Calculates the latest order date from the salesorderheader table and stores it in the alias 'MaxOrderDate'.
    FROM tc-da-1.adwentureworks_db.salesorderheader     -- This date will be used later to filter customers based on their last order date.
),  

TopCustomers AS (
    SELECT 
        ind.CustomerID,
        con.FirstName,
        con.LastName,
        CONCAT(con.FirstName, " ", con.LastName) AS FullName, 
        CASE 
            WHEN con.Title IS NULL THEN CONCAT("Dear ", con.LastName)
            ELSE CONCAT(con.Title, " ", con.LastName)
        END AS addressing_title,
        con.EmailAddress AS EmailAddress,
        con.Phone,
        cus.AccountNumber,
        cus.CustomerType,
        add.City,
        add.AddressLine1,
        add.AddressLine2,
        sta_pro.Name AS State,
        ctr_reg.Name AS Country,
        COUNT(sales.SalesOrderID) AS number_orders,
        ROUND(SUM(sales.TotalDue), 3) AS total_amount,
        MAX(sales.OrderDate) AS date_last_order
    FROM 
        tc-da-1.adwentureworks_db.individual ind
    JOIN 
        tc-da-1.adwentureworks_db.contact con ON ind.ContactID = con.ContactID
    JOIN 
        tc-da-1.adwentureworks_db.customer cus ON ind.CustomerID = cus.CustomerID
    JOIN 
        (
            SELECT CustomerID, MAX(AddressID) AS LatestAddressID
            FROM tc-da-1.adwentureworks_db.customeraddress
            GROUP BY CustomerID
        ) latest_add ON cus.CustomerID = latest_add.CustomerID
    JOIN 
        tc-da-1.adwentureworks_db.address add ON latest_add.LatestAddressID = add.AddressID
    JOIN 
        tc-da-1.adwentureworks_db.stateprovince sta_pro ON add.StateProvinceID = sta_pro.StateProvinceID
    JOIN 
        tc-da-1.adwentureworks_db.countryregion ctr_reg ON sta_pro.CountryRegionCode = ctr_reg.CountryRegionCode
    LEFT JOIN 
        tc-da-1.adwentureworks_db.salesorderheader sales ON cus.CustomerID = sales.CustomerID
    WHERE 
        cus.CustomerType = 'I'
    GROUP BY 
        ind.CustomerID,
        con.FirstName,
        con.LastName,
        con.Title,
        con.EmailAddress,
        con.Phone,
        cus.AccountNumber,
        cus.CustomerType,
        add.City,
        add.AddressLine1,
        add.AddressLine2,
        sta_pro.Name,
        ctr_reg.Name
)

SELECT *   
FROM TopCustomers
WHERE date_last_order < (SELECT DATE_SUB(MaxOrderDate, INTERVAL 365 DAY) FROM LatestOrderDate) -- Filter customers who have not ordered for the last 365 days 
ORDER BY total_amount DESC -- Ensure that the customers with the highest total amount spent are listed first
LIMIT 200;



