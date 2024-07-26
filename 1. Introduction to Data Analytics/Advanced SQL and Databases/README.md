# Advanced SQL and Databases Project Overview

## Project Description

This project involves creating a set of SQL queries to analyze customer and sales data from a database. The objective is to provide detailed insights into customer information, sales metrics, and reporting, with specific tasks focused on individual and business customers, sales performance, and tax rates.

## Tasks and Objectives

### 1. Customer Information and Analysis

#### 1.1 Detailed Customer Overview
- Develop a query to retrieve detailed information about individual customers (identified by `customerType = 'I'` or stored in a dedicated table). The query should include:
  - **Identity Information**: `CustomerId`, `Firstname`, `LastName`, `FullName`, and a custom `addressing_title`.
  - **Contact Information**: `Email`, `phone`, `account number`, and `CustomerType`.
  - **Location Information**: `City`, `State`, `Country`, and `address`.
  - **Sales Data**: Number of orders, total amount (including tax), and date of the last order.
  - Include only the top 200 rows, ordered by total amount (including tax).
- Solution: https://console.cloud.google.com/bigquery?sq=147855269776:d969b186c77a45928547e5f9b213edfa

#### 1.2 Inactive Customer Segmentation
- Extend the previous query to identify the top 200 customers with the highest total amount (with tax) who have not placed an order in the last 365 days. Use temp tables, CTEs, or subqueries to achieve this.
* Solution: https://console.cloud.google.com/bigquery?sq=147855269776:d769a1c72219416b91660bf1e2ae5736
#### 1.3 Customer Activity Status
- Enrich the initial query by adding a column to classify customers as active or inactive based on whether they have ordered in the last 365 days. Provide the top 500 rows, ordered by `CustomerId` in descending order.
* Solution: https://console.cloud.google.com/bigquery?sq=147855269776:1b829e2a12434868a675b4d311bc448d
#### 1.4 Active North American Customers
- Extract data on all active customers from North America who have either ordered at least $2500 in total amount (with tax) or placed 5 or more orders. Split the address into two columns (`AddressLine1` and `Address_st`) and order the results by country, state, and date of the last order.
* Solution: https://console.cloud.google.com/bigquery?sq=147855269776:5b74be64ce6f4893bd3cfda2026c4dc3
  
### 2. Sales Reporting

#### 2.1 Monthly Sales Numbers
- Create a query to report monthly sales figures for each country and region. Include metrics such as the number of orders, customers, salespersons, and total amount with tax.
* Solution: https://console.cloud.google.com/bigquery?sq=147855269776:f63dcc21526e4fe5aa84104e29739123
  
#### 2.2 Cumulative Sales Data
- Enhance the previous query by adding a cumulative sum of the total amount with tax earned per country and region.
* Solution: https://console.cloud.google.com/bigquery?sq=147855269776:6be06ce64bf94f8ab0c60cecc6bad576
  
#### 2.3 Sales Ranking
- Extend the cumulative sales query to include a `sales_rank` column, ranking the rows from best to worst based on total amount with tax earned each month for each country.
* Solution: https://console.cloud.google.com/bigquery?sq=147855269776:5d06a40a06b041a48bd2dbfe1683a5e8
  
#### 2.4 Tax Information
- Further enhance the ranking query to include country-level tax information:
  - **`mean_tax_rate`**: Average tax rate per country.
  - **`perc_provinces_w_tax`**: Percentage of provinces with available tax rates for each country.
  - Note: Use the highest tax rate for states with multiple rates and exclude the `isonlystateprovinceFlag` rate mechanic.
* Solution: https://console.cloud.google.com/bigquery?sq=147855269776:d9e1ae4f081d4c808c454ad1eb9d147d
