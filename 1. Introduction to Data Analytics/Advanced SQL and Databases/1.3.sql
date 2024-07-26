-- 1.3 Enrich your original 1.1 SELECT by creating a new column in the view that marks active & inactive customers 
--     based on whether they have ordered anything during the last 365 days.
-- Copy only the top 500 rows from your written select ordered by CustomerId desc.



WITH LatestOrderDate AS (
    SELECT MAX(OrderDate) AS MaxOrderDate
    FROM tc-da-1.adwentureworks_db.salesorderheader     -- Same as 1.2.sql 
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
        MAX(sales.OrderDate) AS date_last_order,
        CASE
            WHEN MAX(sales.OrderDate) >= (SELECT DATE_SUB(MaxOrderDate, INTERVAL 365 DAY) FROM LatestOrderDate) THEN 'Active'
            ELSE 'Inactive'     -- Use 'CASE WHEN' to create CustomerStatus based on whether they have ordered anything during the last 365 days.
        END AS CustomerStatus   -- If the last order date is within the last 365 days from the latest order date, the customer is 'Active'; otherwise, they are 'Inactive'.
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


SELECT *        -- This is the main query that selects all columns from the TopCustomers CTE. 
FROM TopCustomers
ORDER BY CustomerID DESC
LIMIT 500;      -- It orders the results by CustomerID in descending order and limits the output to the top 500 customers.

