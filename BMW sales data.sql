CREATE DATABASE [BMW Dataset]
USE [BMW Dataset]

---- query -- 
-- Retrieve all record from the table
SELECT * FROM [BMW Dataset]

---1.Select model, year, region, sales_volume
SELECT 
	Year,
	Model,
	Region,
	Sales_Volume
FROM [BMW Dataset]

--2. Select model, year, region, sales_volume, Price_USD, and choose sales_volume >= 8000
SELECT 
	Year,
	Model,
	Region,
	Price_USD,
	Sales_Volume
FROM [BMW Dataset]
WHERE Sales_Volume >= 8000  
GROUP BY Year,  Model, Region, Sales_volume, Price_USD
ORDER BY Sales_Volume, Price_USD DESC;

--3.Find all cars sold in 2022

-- SELECT *(
SELECT
	Model, 
	Year,
	Region
FROM [BMW Dataset]
WHERE Year  = 2022
GROUP BY Model, Year, Region
-- ) SELECT COUNT(Year) partition by Year ORDER BY Region;

--4. Get all Petrol cars

SELECT 
	Model,
	Fuel_Type
FROM [BMW Dataset]
WHERE Fuel_Type = 'Petrol' 
	--AND Fuel_Type = 'Diesel'
	--AND Fuel_Type = 'Hybird' -- check it is wrong
GROUP BY Model, Fuel_Type;

-- 5. Cars with price greater than 50,000

SELECT 
	Model,
	Year,
	Price_USD,
	Fuel_Type
FROM [BMW Dataset]
WHERE Price_USD >= 50000
GROUP BY Model, Year, Price_USD, Fuel_Type;

		
-- 6. Total sales_volume for each model

SELECT
	Model,
	SUM(Sales_Volume) AS Total_sales_volume
FROM [BMW Dataset]
GROUP BY Model
ORDER BY Total_sales_volume;

--7. Average price for each price usd with model, fuel_type
SELECT
    Model,
    Fuel_Type,
    AVG(Price_usd) AS Avg_price
FROM [BMW Dataset]
GROUP BY Model, Fuel_Type
ORDER BY Avg_price DESC;

--ALTER TABLE [BMW Dataset]
--ALTER COLUMN Fuel_Type NVARCHAR(50);

-- 8. Total sales by region
SELECT 
	Region,
	SUM(Sales_Volume) as Total_sales
FROM [BMW Dataset]
GROUP BY Region
ORDER BY Total_sales DESC;

--9. Max and Min price
SELECT 
	Model,
	ROUND(MAX(Price_USD), 2) as Maximun_price,
	ROUND(MIN(Price_USD), 2) as Minimum_price
FROM [BMW Dataset]
GROUP BY Model
ORDER BY Maximun_price, Minimum_price DESC;

--10. Count cars per transmission
SELECT 
	Model,
	Transmission,
	COUNT(Model) as CNT_OF_CARS
FROM [BMW Dataset]
-- WHERE Transmission = 'Manual'
GROUP BY Model, Transmission
ORDER BY CNT_OF_CARS DESC;

-- 11. Models with sales_volume > 1000
SELECT
	Model,
	SUM(Sales_Volume) as Total_sales
FROM [BMW Dataset]
GROUP BY Model
HAVING SUM(Sales_Volume) > 1000
ORDER BY Total_sales DESC;

--12. Total revenue per model Hint: Revenue = price_usd * sales_volume, use SUM()
SELECT 
    Model,
    Year,
    SUM(Price_usd * Sales_Volume) AS Revenue_sales
FROM [BMW Dataset]
GROUP BY Model, Year
ORDER BY Model, Year;


--13. Top 5 models by sales_volume
SELECT TOP 5
	Model,
	SUM(Sales_Volume) as Total_sales
FROM [BMW Dataset]
GROUP BY Model
ORDER BY Total_sales DESC;

--14. Top 3 regions by revenue
-- Hint: Calculate revenue first, then sort + limit
SELECT TOP 3
	Region,
	SUM(Price_usd * Sales_Volume) AS Revenue_sales
FROM [BMW Dataset]
GROUP BY Region
ORDER BY Revenue_sales DESC;


--15. Year-wise total sales
SELECT
	Year,
	SUM(Sales_Volume) as Total_Sales
FROM [BMW Dataset]
GROUP BY Year
ORDER BY Year,Total_Sales DESC;

--16. Most popular fuel_type
SELECT
	Fuel_Type,
	SUM(Sales_Volume) as Total_Sales
FROM [BMW Dataset]
GROUP BY Fuel_Type
ORDER BY Total_Sales DESC;

-- 17. Model with highest average price
SELECT
	Model,
	ROUND(AVG(Price_USD), 2) as Average_price
FROM [BMW Dataset]
GROUP BY Model
ORDER BY Average_price DESC;

--18. Cars above average mileage
--Hint: Use a subquery with AVG(mileage_km)
SELECT 
	Model,
	AVG(Mileage_KM) as Average_mileage
FROM [BMW Dataset]
GROUP BY Model
ORDER BY Average_mileage;

--19. Rank models by sales_volume
--Hint: Use window function like RANK() or DENSE_RANK()
SELECT
    Model,
    SUM(Sales_Volume) AS Total_Sales,
    RANK() OVER (ORDER BY SUM(Sales_Volume) DESC) AS Ranking_models
FROM [BMW Dataset]
GROUP BY Model
ORDER BY Ranking_models;

--20. Cumulative sales over years
--Hint: Use SUM() OVER (PARTITION BY model ORDER BY year)
SELECT
    Year,
    SUM(Sales_Volume) AS Yearly_Sales,
    SUM(SUM(Sales_Volume)) OVER (ORDER BY Year) AS Cumulative_Sales
FROM [BMW Dataset]
GROUP BY Year
ORDER BY Year;
	
--Analytical / Real-World

--21. Petrol vs Diesel vs Electric sales
--Hint: GROUP BY fuel_type
SELECT
	Year,
	Fuel_Type,
	SUM(Sales_Volume) as Total_sales
FROM [BMW Dataset]
GROUP BY Year, Fuel_Type
ORDER BY Year, Fuel_Type

--22. Region with highest revenue
-- Hint: Combine SUM(price * sales_volume) + sorting
SELECT
	Region,
	MAX(Price_USD * Sales_Volume) as Maximum_revenue
FROM [BMW Dataset]
GROUP BY Region
ORDER BY Maximum_revenue

--23. Sales trend from 2020–2024
SELECT
	Model,
	Sales_Classification,
	Sales_Volume,
	Year
FROM [BMW Dataset]
GROUP BY Model, Year, Sales_Classification, Sales_Volume
ORDER BY Year DESC;

--24. Engine size vs price relationship
-- Hint: Compare using AVG(price_usd) grouped by engine_size_L

SELECT
    Engine_size_L,
    Price_usd
FROM [BMW Dataset]
WHERE Engine_size_L IS NOT NULL
  AND Price_usd IS NOT NULL;

--25. Classify sales (High/Medium/Low)  Hint: Use CASE WHEN on sales_volume
SELECT
	Cateogry,
	SUM(Sales_Volume) as Totalsales
FROM (
	SELECT
	Model,
	Year,
	Sales_Volume,
	CASE
		WHEN Sales_Volume > 7000 THEN 'High'
		WHEN Sales_Volume < 7000 THEN 'Low'
	END AS Cateogry
	FROM [BMW Dataset]
	WHERE Sales_Volume IS NOT NULL
)t
GROUP BY Cateogry
ORDER BY Totalsales DESC;


SELECT
    sales_classification,
    COUNT(*) AS Number_of_models,
    SUM(Sales_Volume) AS TotalSales
FROM [BMW Dataset]
GROUP BY sales_classification;

--26. Preferred transmission per region Hint: GROUP BY region, transmission + find highest
SELECT
    Region,
    Transmission,
    COUNT(*) AS Total_Count
FROM [BMW Dataset]
GROUP BY Region, Transmission;

--27. Underperforming models  Hint: High price + low sales → use WHERE with both conditions
SELECT
    Model,
    Price_usd,
    Sales_Volume
FROM [BMW Dataset]
WHERE Price_usd > 50000
  AND Sales_Volume < 3000
ORDER BY Price_usd DESC;

--28. Year-over-year growth
SELECT
    Model,
    Year,
    Sales_Volume,
    LAG(Sales_Volume) OVER (PARTITION BY Model ORDER BY Year) AS Previous_Sales,
	 Sales_Volume - LAG(Sales_Volume) OVER (
        PARTITION BY Model 
        ORDER BY Year
    ) AS YoY_Growth
FROM [BMW Dataset];

--Power BI Ready Queries

--29. Model-Year Sales dataset
SELECT 
	Year, 
	Model,
	SUM(Sales_Volume) as Total_sales,
	AVG(Price_USD) as Average_sales
FROM [BMW Dataset]
GROUP BY Year, Model
ORDER BY Year, Model;


--30. Region Revenue dataset
-- Hint: Include SUM(revenue) + AVG(price)
SELECT 
	Year, 
	Model,
	SUM(Sales_Volume * Price_USD) as Total_Revenue,
	SUM(Sales_Volume) as Total_sales,
	AVG(Price_USD) as Average_sales
FROM [BMW Dataset]
GROUP BY Year, Model
ORDER BY Year, Model;

--31. Fuel contribution %
--Hint: Use SUM(sales_volume) and divide by total using window function

SELECT
    Fuel_Type,
    SUM(Sales_Volume) AS Total_Sales,
    
    ROUND(SUM(Sales_Volume) * 100.0 / SUM(SUM(Sales_Volume)) OVER (), 2) AS Contribution_Percentage
FROM [BMW Dataset]
GROUP BY Fuel_Type
ORDER BY Contribution_Percentage DESC;



--Dataset 1: Model-wise Sales
--For Bar Chart

SELECT 
    model,
    SUM(sales_volume) AS total_sales
FROM BMW_Sales
GROUP BY model
ORDER BY total_sales DESC;

--Dataset 2: Year-wise Trend

-- For Line Chart

SELECT 
    year,
    SUM(sales_volume) AS total_sales
FROM BMW_Sales
GROUP BY year
ORDER BY year;
--Dataset 3: Region-wise Revenue

--For Map / Donut

SELECT 
    region,
    SUM(price_usd * sales_volume) AS total_revenue
FROM BMW_Sales
GROUP BY region
ORDER BY total_revenue DESC;
--Dataset 4: Fuel Type Contribution

--For Pie Chart

SELECT 
    fuel_type,
    SUM(sales_volume) AS total_sales
FROM BMW_Sales
GROUP BY fuel_type;
--Dataset 5: Transmission Preference

-- For Stacked Chart

SELECT 
    transmission,
    SUM(sales_volume) AS total_sales
FROM BMW_Sales
GROUP BY transmission;
--Dataset 6: KPI Cards (VERY IMPORTANT 🔥)

--For top metrics

SELECT 
    SUM(sales_volume) AS total_sales,
    SUM(price_usd * sales_volume) AS total_revenue,
    AVG(price_usd) AS avg_price
FROM BMW_Sales;





