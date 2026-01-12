USE AdventureWorks2017;

/* 
This query answers:
Q: How have total sales changed year over year?
Tables used: Sales.SalesOrderHeader
Fields: OrderDate, TotalDue
*/
SELECT 
    YEAR(OrderDate) AS SalesYear,
    SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY SalesYear;

/* 
This query answers:
Q: Who are the top 10 customers driving sales?
Tables used: 
- Sales.SalesOrderHeader (order totals and CustomerID)
- Sales.Customer (connects CustomerID to PersonID)
- Person.Person (customer names)
Fields: TotalDue, CustomerID, PersonID, FirstName, LastName
*/
SELECT TOP 10
    p.FirstName + ' ' + p.LastName AS CustomerName,
    SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.Customer AS c
    ON soh.CustomerID = c.CustomerID
INNER JOIN Person.Person AS p
    ON c.PersonID = p.BusinessEntityID
GROUP BY p.FirstName, p.LastName
ORDER BY TotalSales DESC;

/* 
This query answers:
Q: Which product categories generate the most revenue?
Tables used:
- Sales.SalesOrderDetail (LineTotal for each product sold)
- Production.Product (connects ProductID to Subcategory)
- Production.ProductSubcategory (connects Subcategory to Category)
- Production.ProductCategory (category names like Bikes, Clothing, etc.)
Fields: LineTotal, ProductID, ProductSubcategoryID, ProductCategoryID, Name
Notes: Requires multiple joins to roll up revenue from 
       individual sales lines → products → subcategories → categories.
*/
SELECT 
    pc.Name AS ProductCategory,
    SUM(sod.LineTotal) AS TotalSales
FROM Sales.SalesOrderDetail AS sod
INNER JOIN Production.Product AS p
    ON sod.ProductID = p.ProductID
INNER JOIN Production.ProductSubcategory AS psc
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
INNER JOIN Production.ProductCategory AS pc
    ON psc.ProductCategoryID = pc.ProductCategoryID
GROUP BY pc.Name
ORDER BY TotalSales DESC;

/* 
This query answers:
Q: Which regions or countries contribute the most to sales?
Tables used:
- Sales.SalesOrderHeader (contains TotalDue and TerritoryID)
- Sales.SalesTerritory (contains TerritoryID, Name, CountryRegionCode, and Group)
Fields: TotalDue, TerritoryID, Name, CountryRegionCode, Group
Notes:
Joins sales orders to territory data to summarize revenue by each region/country.
This supports the Power BI map visualization for geographic insights.
*/
SELECT 
    st.Name AS TerritoryName,
    st.CountryRegionCode AS Country,
    st.[Group] AS RegionGroup,
    SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesTerritory AS st
    ON soh.TerritoryID = st.TerritoryID
GROUP BY 
    st.Name, 
    st.CountryRegionCode, 
    st.[Group]
ORDER BY TotalSales DESC;

/*
This query answers:
Q: Which sales representatives contribute the highest total sales?
Tables used:
- Sales.SalesOrderHeader (contains TotalDue and SalesPersonID)
- Sales.SalesPerson (connects to BusinessEntityID)
- HumanResources.Employee (employee details)
- Person.Person (names of sales reps)
Fields: TotalDue, SalesPersonID, BusinessEntityID, FirstName, LastName
Notes:
Joins orders to their assigned salespeople, then summarizes total revenue by rep.
Perfect for a bar chart visualization showing top performers 🩷
*/
SELECT 
    p.FirstName + ' ' + p.LastName AS SalesRep,
    SUM(soh.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesPerson AS sp
    ON soh.SalesPersonID = sp.BusinessEntityID
INNER JOIN HumanResources.Employee AS e
    ON sp.BusinessEntityID = e.BusinessEntityID
INNER JOIN Person.Person AS p
    ON e.BusinessEntityID = p.BusinessEntityID
GROUP BY p.FirstName, p.LastName
ORDER BY TotalSales DESC;

/*
This query answers:
Q: What is the average order value, and how does it vary across regions?
Tables used:
- Sales.SalesOrderHeader (contains TotalDue and TerritoryID)
- Sales.SalesTerritory (contains TerritoryID, Name, CountryRegionCode, Group)
Fields: TotalDue, TerritoryID, Name, CountryRegionCode, Group
Notes:
Calculates both the overall average order value (AOV) and a breakdown by region.
This supports the KPI card (AOV) and the bar chart (AOV by Region) visuals.
*/
-- Average Order Value by Region
SELECT 
    st.[Group] AS RegionGroup,
    st.Name AS TerritoryName,
    AVG(soh.TotalDue) AS AverageOrderValue
FROM Sales.SalesOrderHeader AS soh
INNER JOIN Sales.SalesTerritory AS st
    ON soh.TerritoryID = st.TerritoryID
GROUP BY st.[Group], st.Name
ORDER BY AverageOrderValue DESC;

-- Overall Average Order Value
SELECT 
    AVG(TotalDue) AS OverallAverageOrderValue
FROM Sales.SalesOrderHeader;
