# Adventureworks 2005 Database SQL Project

## Overview
This project involves creating SQL queries to address specific business questions using the Adventureworks 2005 database. It is designed as a mid-way check-in for learning SQL.

## Objectives
* Explore the Adventureworks 2005 database.
* Identify and merge the necessary data from various tables.
* Create queries to solve specified business questions.
* Document results and queries in a structured format.

## Project Tasks

### 1. Overview of Products
#### 1.1 Extract Product Data
* Query the Product table for products with a subcategory.
* Include columns: ProductId, Name, ProductNumber, Size, Color, ProductSubcategoryId, Subcategory name.
* Order results by Subcategory name.
#### 1.2 Include Product Category Name
* Modify the query from 1.1 to include the product category name.
* Order results by Category name.
#### 1.3 Most Expensive Active Bikes
* Select bikes priced over $2000 that are actively sold.
* Order results from most to least expensive.

### 2. Reviewing Work Orders
#### 2.1 Aggregated Work Order Data
* Query workorderrouting table for January 2004.
* Include: number of unique work orders, number of unique products, total actual cost for each location Id.
#### 2.2 Enhance Aggregated Data
* Include the location name and average days between actual start and end dates for each location.
#### 2.3 Expensive Work Orders
* Select work orders with actual cost above $300 from January 2004.

## Evaluation Criteria
- Effort & creativity in finding solutions.
- Code formatting & readability.
- Ability to explain the logic behind the code and validate results.
- General understanding of SQL.

### 3. Query Validation
#### 3.1 Fix Colleague's Query (Special Offers)
* Investigate and correct a query listing orders connected to special offers.
#### 3.2 Fix Colleague's Query (Vendor Information)
* Correct and improve readability of a query collecting basic vendor information.
