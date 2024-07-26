-- 1.1 You’ve been tasked to create a detailed overview of all individual customers (these are defined by customerType = ‘I’ and/or stored in an individual table). 
-- Write a query that provides:
-- (1) Identity information : CustomerId, Firstname, Last Name, FullName (First Name & Last Name).
-- (2) An Extra column called addressing_title i.e. (Mr. Achong), if the title is missing - Dear Achong.
-- (3) Contact information : Email, phone, account number, CustomerType.
-- (4) Location information : City, State & Country, address.
-- (5) Sales: number of orders, total amount (with Tax), date of the last order.
-- (6) Copy only the top 200 rows from your written select ordered by total amount (with tax).


SELECT 
  ind.CustomerID,       
  con.FirstName,        
  con.LastName,            
  CONCAT(con.FirstName, " ", con.LastName) AS FullName,         -- (1) Concatenate(CONCAT) 'FirstName' and 'LastName' to create a 'FullName' column.
  CASE 
    WHEN con.Title IS NULL THEN CONCAT("Dear ", con.LastName)   -- (2) Use 'CASE WHEN' to create an addressing_title column based on whether Title is NULL or not.
    ELSE CONCAT(con.Title, " ", con.LastName)                   --     Also use CONCAT to concatenate 'Title' and 'LastName'   
  END AS addressing_title,
  con.EmailAddress AS EmailAddress,   -- (3)
  con.Phone,  -- (3)
  cus.AccountNumber,  -- (3)
  cus.CustomerType,   -- (3)
  add.City, -- (4)
  add.AddressLine1, -- (4)
  add.AddressLine2, -- (4)
  sta_pro.Name AS State,  -- (4)
  ctr_reg.Name AS Country,  -- (4)
  COUNT(sales.SalesOrderID) AS number_orders,   -- (5)
  ROUND(SUM(sales.TotalDue),3) AS total_amount, -- (5)
  MAX(sales.OrderDate) AS date_last_order,      -- (5)
FROM 
  tc-da-1.adwentureworks_db.individual ind
JOIN 
  tc-da-1.adwentureworks_db.contact con ON ind.ContactID = con.ContactID
JOIN 
  tc-da-1.adwentureworks_db.customer cus ON ind.CustomerID = cus.CustomerID

JOIN (
  SELECT CustomerID, MAX(AddressID) AS LatestAddressID  -- To avoid duplicate data take their latest available address by choosing max(AddressId)
  FROM tc-da-1.adwentureworks_db.customeraddress
  GROUP BY CustomerID
) latest_add

ON cus.CustomerID = latest_add.CustomerID
JOIN 
  tc-da-1.adwentureworks_db.address add ON latest_add.LatestAddressID = add.AddressID
JOIN 
  tc-da-1.adwentureworks_db.stateprovince sta_pro ON add.StateProvinceID = sta_pro.StateProvinceID
JOIN 
  tc-da-1.adwentureworks_db.countryregion ctr_reg ON sta_pro.CountryRegionCode = ctr_reg.CountryRegionCode
LEFT JOIN 
  tc-da-1.adwentureworks_db.salesorderheader sales ON cus.CustomerID = sales.CustomerID    
  -- A LEFT JOIN is used to include all customers from the cus table, even if they don't have matching sales records in the sales table. 
  -- This ensures that all customer information is displayed, with NULL values for those without corresponding sales data.
WHERE cus.CustomerType = 'I'

GROUP BY -- The GROUP BY clause groups the results by customer ID and other personal and address details to aggregate the order statistics.
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
ORDER BY total_amount DESC -- (6)
LIMIT 200;  -- (6)