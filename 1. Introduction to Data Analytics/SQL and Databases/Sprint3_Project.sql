# 1.1 
You’ve been asked to extract the data on products from the Product table where there exists a product subcategory. 
And also include the name of the ProductSubcategory.
- Columns needed: ProductId, Name, ProductNumber, size, color, ProductSubcategoryId, Subcategory name.
- Order results by SubCategory name.
    
SELECT 
    pro.ProductId, 
    pro.Name, 
    pro.ProductNumber, 
    pro.Size, 
    pro.Color, 
    pro.ProductSubcategoryID, 
    sub_cat.Name as SubCategory

FROM `tc-da-1.adwentureworks_db.product` pro

JOIN `tc-da-1.adwentureworks_db.productsubcategory` sub_cat
ON pro.ProductSubcategoryID = sub_cat.ProductSubcategoryID

ORDER BY SubCategory;

# 1.2
In 1.1 query you have a product subcategory but see that you could use the category name.
- Find and add the product category name.
- Afterwards order the results by Category name.

SELECT 
    pro.ProductId, 
    pro.Name, 
    pro.ProductNumber, 
    pro.Size, 
    pro.Color, 
    pro.ProductSubcategoryID, 
    sub.Name as SubCategory, 
    cat.Name as Category

FROM `tc-da-1.adwentureworks_db.product` pro

JOIN `tc-da-1.adwentureworks_db.productsubcategory` sub
ON pro.ProductSubcategoryID = sub.ProductSubcategoryID

JOIN `tc-da-1.adwentureworks_db.productcategory` cat
ON sub.ProductCategoryID = cat.ProductCategoryID

ORDER BY Category;

# 1.3
Use the established query to select the most expensive (price listed over 2000) bikes that are still actively sold (does not have a sales end date)
- Order the results from most to least expensive bike.
    
SELECT 
    pro.ProductId, 
    pro.Name, 
    pro.ProductNumber, 
    pro.Size, 
    pro.Color, 
    pro.ProductSubcategoryID, 
    sub.Name as SubCategory, 
    cat.Name as Category
    pro.ListPrice

FROM `tc-da-1.adwentureworks_db.product` pro

JOIN `tc-da-1.adwentureworks_db.productsubcategory` sub
ON pro.ProductSubcategoryID = sub.ProductSubcategoryID

JOIN `tc-da-1.adwentureworks_db.productcategory` cat
ON sub.ProductCategoryID = cat.ProductCategoryID

WHERE
    pro.SellEndDate is NULL 
    AND cat.Name ='Bikes'
    AND pro.ListPrice > 2000

ORDER BY pro.ListPrice DESC;

# 2.1
Create an aggregated query to select the:
1) Number of unique work orders.
2) Number of unique products.
3) Total actual cost.
For each location Id from the 'workoderrouting' table for orders in January 2004.
    
SELECT
    LocationID,
    COUNT(DISTINCT(WorkOrderID)) AS no_work_orders,
    COUNT(DISTINCT(ProductID)) AS no_unique_products,
    SUM(ActualCost) AS actual_cost

FROM `tc-da-1.adwentureworks_db.workorderrouting`

WHERE
    EXTRACT(YEAR FROM ActualStartDate) = 2004
    AND EXTRACT(MONTH FROM ActualStartDate) = 1

GROUP BY LocationID;

# 2.2
Update your 2.1 query by adding the name of the location and 
also add the average days amount between actual start date and actual end date per each location.
    
SELECT
    ord.LocationID,
    loc.name AS Location,
    COUNT(DISTINCT(WorkOrderID)) AS no_work_orders,
    COUNT(DISTINCT(ProductID)) AS no_unique_products,
    SUM(ord.ActualCost) AS actual_cost,
    ROUND(AVG(DATE_DIFF(ord.ActualEndDate, ord.ActualStartDate, DAY)), 2) AS avg_days_diff

FROM `tc-da-1.adwentureworks_db.workorderrouting` ord

JOIN `tc-da-1.adwentureworks_db.location` loc
ON ord.LocationID = loc.LocationID

WHERE
    EXTRACT(YEAR FROM ord.ActualStartDate) = 2004
    AND EXTRACT(MONTH FROM ord.ActualStartDate) = 1

GROUP BY ord.LocationID, loc.name;

# 2.3
Select all the expensive work Orders (above 300 actual cost) that happened throught January 2004.
    
SELECT
    WorkOrderID,
    SUM(ActualCost) AS actual_cost

FROM `tc-da-1.adwentureworks_db.workorderrouting`

WHERE 
    ActualStartDate BETWEEN '2004-01-01' AND '2004-01-31'

GROUP BY WorkOrderID

HAVING actual_cost > 300;

# 3.1
SELECT 
    sales_detail.SalesOrderId,
    sales_detail.OrderQty,
    sales_detail.UnitPrice,
    sales_detail.LineTotal,
    sales_detail.ProductId,
    sales_detail.SpecialOfferID,
    spec_offer_product.ModifiedDate,
    spec_offer.Category,
    spec_offer.Description

FROM `tc-da-1.adwentureworks_db.salesorderdetail`  as sales_detail

LEFT JOIN `tc-da-1.adwentureworks_db.specialofferproduct` as spec_offer_product
ON sales_detail.productId = spec_offer_product.ProductID
AND sales_detail.SpecialOfferID = spec_offer_product.SpecialOfferID

LEFT JOIN `tc-da-1.adwentureworks_db.specialoffer` as spec_offer
ON sales_detail.SpecialOfferID = spec_offer.SpecialOfferID

ORDER BY LineTotal DESC

# 3.2
SELECT 
  ven.VendorId as Id,
  ven_con.ContactId, 
  ven_con.ContactTypeId, 
  ven.Name, 
  ven.CreditRating, 
  ven.ActiveFlag, 
  ven_add.AddressId,
  add.City

FROM `tc-da-1.adwentureworks_db.vendor` as ven

LEFT JOIN `tc-da-1.adwentureworks_db.vendorcontact` as ven_con 
ON ven.VendorId = ven_con.VendorId 

LEFT JOIN `tc-da-1.adwentureworks_db.vendoraddress` as ven_add
ON ven.VendorId = ven_add.VendorId

LEFT JOIN `tc-da-1.adwentureworks_db.address` as add
ON ven_add.AddressID = add.AddressID;
