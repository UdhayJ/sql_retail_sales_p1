-- SQL Retail Sales analysi - P1
Create Database sql_project_p1;

-- Create TABLE
DROP TABLE IF EXISTS Retail_sales;
Create 	TABLE Retail_sales(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);
--DAta cleaning
select * from retail_sales;

Select count(*) From retail_sales;

-- CHECKING FOR NULL VALUES
select * from retail_sales
WHERE transactions_id IS NULL

select * from retail_sales
WHERE retail_sales.sale_date IS NULL

-- IF YOU WANT TO CHECK THE WHOLE TABLE

select * from retail_sales
WHERE 
	 transactions_id IS NULL
	OR
     sale_date IS NULL
	OR
     sale_time IS NULL
    OR
     GENDER IS NULL
    OR
     CATEGORY IS NULL
    OR
     QUANTITY IS NULL
	or
     COGS IS NULL
	or
     TOTAL_SALE IS null;

--
Delete from retail_sales
where
transactions_id IS NULL
	OR
     sale_date IS NULL
	OR
     sale_time IS NULL
    OR
     GENDER IS NULL
    OR
     CATEGORY IS NULL
    OR
     QUANTITY IS NULL
	or
     COGS IS NULL
	or
     TOTAL_SALE IS null;

-- Data Exploration

-- How many sales we have

Select count(*) as total_sale from retail_sales;

-- How many customers we have

Select count(customer_id) as total_sale from retail_sales;

-- How many unique customers we have

Select count(Distinct customer_id) as total_sale from retail_sales;

-- how many unique category we have

Select Distinct category from retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * from retail_sales
where sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

Select 
	category,
	sum(total_sale) as net_sale,
	count(*) as total_orders
	from retail_sales
group by 1


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select 
    Round(avg(age), 2) as avg_age
from retail_sales
where category = 'Beauty'

--since we are getting ans in long decimal we used Round function limits to 2 decimal points

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select 
* 
from retail_sales
where total_sale > '1000'

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select
	category,
	gender,
count(transactions_id)
from retail_sales
group by 1,2
order by 1

-- i used orderby in above coz just to show it in order, can ignore if not needed

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

Select 
	year,
	month,
	average_sale
from (
Select 
	extract (YEAR FROM sale_date) as year,
	extract (MONTH FROM sale_date) as month,
	avg(total_sale) as average_sale,
	RANK() OVER(PARTITION BY extract (YEAR FROM sale_date) ORDER BY avg(total_sale) DESC) AS RANK
	from retail_sales
group by 1,2
) AS t1
where rank = 1

-- first run the subquery and understand it and run the whole query

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

--select * from retail_sales

select 
    customer_id,
    sum(total_sale)
from retail_sales
group by 1
order by 2 desc
limit 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select 
category,
count(Distinct customer_id) as Unique_customers
from retail_sales
group by 1

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- here we dont have a table that mentions any shifts so we gonna create an temporary table usint WITH and CASE WHEN

WITH hourly_sale
as
(select *,
    case
       WHEN EXTRACT(HOUR FROM sale_time) < 12 then 'MORNING'
       WHEN EXTRACT(HOUR FROM sale_time) between 12 and 17 then 'AFTERNOON'
       Else 'Evening'
    End as shift
From retail_sales
)
SELECT
    shift,
    count(*) as total_orders
FROM
hourly_sale 
group by shift

-- we used extract because we are differentiating based on hour so we extraced hour
-- we cannot use group by on the above case so we brought 'with' function and made it as imaginary table and used group by on that table







