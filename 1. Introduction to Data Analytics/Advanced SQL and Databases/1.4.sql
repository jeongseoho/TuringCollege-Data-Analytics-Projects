-- 1.4 Business would like to extract data on all active customers from North America. 
-- Only customers that have either ordered no less than 2500 in total amount (with Tax) or ordered 5 + times should be presented.
-- In the output for these customers divide their address line into two columns
-- Order the output by country, state and date_last_order.

WITH LatestOrderDate AS (
    SELECT MAX(OrderDate) AS MaxOrderDate
    FROM `tc-da-1.adwentureworks_db.salesorderheader`       -- Get the latest order date from the salesorderheader table
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
        SUBSTR(add.AddressLine1, 1, STRPOS(add.AddressLine1, ' ') - 1) AS address_no,  -- Use 'SUBSTR' and 'STRPOS' to divide their address line into 'address_no' and 'Address_st'
        SUBSTR(add.AddressLine1, STRPOS(add.AddressLine1, ' ') + 1) AS address_st,  
        -- 'address_no' captures everything before the first space
        -- 'address_st' captures everything after the first space.

        sta_pro.Name AS State,
        ctr_reg.Name AS Country,
        COUNT(sales.SalesOrderID) AS number_orders,
        ROUND(SUM(sales.TotalDue), 3) AS total_amount,
        MAX(sales.OrderDate) AS date_last_order,
        CASE
            WHEN MAX(sales.OrderDate) >= DATE_SUB((SELECT MaxOrderDate FROM LatestOrderDate), INTERVAL 365 DAY) THEN 'Active'
            ELSE 'Inactive'
        END AS customer_status
    FROM 
        `tc-da-1.adwentureworks_db.individual` ind
    JOIN 
        `tc-da-1.adwentureworks_db.contact` con ON ind.ContactID = con.ContactID
    JOIN 
        `tc-da-1.adwentureworks_db.customer` cus ON ind.CustomerID = cus.CustomerID
    JOIN 
        (
            SELECT CustomerID, MAX(AddressID) AS LatestAddressID
            FROM `tc-da-1.adwentureworks_db.customeraddress`
            GROUP BY CustomerID
        ) latest_add ON cus.CustomerID = latest_add.CustomerID
    JOIN 
        `tc-da-1.adwentureworks_db.address` add ON latest_add.LatestAddressID = add.AddressID
    JOIN 
        `tc-da-1.adwentureworks_db.stateprovince` sta_pro ON add.StateProvinceID = sta_pro.StateProvinceID
    JOIN 
        `tc-da-1.adwentureworks_db.countryregion` ctr_reg ON sta_pro.CountryRegionCode = ctr_reg.CountryRegionCode
    LEFT JOIN 
        `tc-da-1.adwentureworks_db.salesorderheader` sales ON cus.CustomerID = sales.CustomerID
    WHERE 
        cus.CustomerType = 'I'
        AND (ctr_reg.Name = 'United States' OR ctr_reg.Name = 'Canada') -- To find all active customers from North America
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
        sta_pro.Name,
        ctr_reg.Name
    HAVING  -- This HAVING clause filters the grouped results to include only 'Active' customers who meet at least one of the following criteria:
        customer_status = 'Active'
        AND (SUM(sales.TotalDue) >= 2500 OR COUNT(sales.SalesOrderID) >= 5)
)

SELECT *
FROM TopCustomers
ORDER BY Country, State, date_last_order;