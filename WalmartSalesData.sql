-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;
-- ---------------------------------------------------------------------------------------------------------
-- Create table
CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);
-- ---------------------------------------------------------------------------------------------------------
SELECT * FROM walmartsales.sales;
-- ---------------------------------------------------------------------------------------------------------

-- ---------------------------------------------Feature Engineering-----------------------------------------
 
-- time_of_day
SELECT 
  time,(
   CASE
    WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
    WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
    ELSE "Evening"
    END
  )AS time_of_date
  FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
UPDATE sales SET time_of_day = (
CASE
    WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
    WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
    ELSE "Evening"
    END
);
-- ---------------------------------------------------------------------------------------------------------
-- day_name 
SELECT 
  date,DAYNAME(date)
 FROM sales;
 
ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);
UPDATE sales SET day_name = DAYNAME(date);
-- ---------------------------------------------------------------------------------------------------------
-- month_name
SELECT 
  date,MONTHNAME(date)
  FROM sales;
 ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
 UPDATE sales SET month_name = MONTHNAME(date);
-- ---------------------------------------------------------------------------------------------------------
 
 -- -----------------------------------------Exploring Data Analysis----------------------------------------
 
 -- Generic Questions 
 -- How many unique cities does the data have?
 SELECT DISTINCT city FROM  sales;
 
 -- In which city is each branch?
 SELECT DISTINCT city ,branch FROM sales;
 -- ---------------------------------------------------------------------------------------------------------

 -- Product
-- How many unique product lines does the data have?
  SELECT COUNT(DISTINCT  product_line) FROM sales;
  
-- What is the most common payment method?
  SELECT MAX(payment) from sales;
  
-- What is the most selling product line?
    SELECT product_line,COUNT(product_line) AS cnt from sales GROUP BY product_line ORDER BY cnt DESC;
    
-- What is the total revenue by month?
SELECT month_name AS month , SUM(total) AS total_revenue FROM sales GROUP BY month_name ORDER BY total_revenue DESC;
    
-- What month had the largest COGS?
SELECT month_name AS month , SUM(cogs) AS largest_cogs FROM sales GROUP BY month_name ORDER BY largest_cogs DESC;

-- What product line had the largest revenue?
SELECT product_line AS ProductLine , SUM(total) AS largest_revenue FROM sales GROUP BY product_line ORDER BY largest_revenue DESC; 

-- What is the city with the largest revenue?
SELECT city AS City , SUM(total) as total_revenue FROM sales GROUP BY city ORDER BY total_revenue DESC ;

-- What product line had the largest VAT?
SELECT product_line , AVG(tax_pct) AS VAT FROM sales GROUP BY product_line ORDER BY VAT DESC;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;

-- Which branch sold more products than average product sold?
SELECT branch , SUM(quantity) AS qtn FROM sales GROUP BY branch HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- What is the most common product line by gender?
 SELECT gender, product_line, COUNT(gender) AS total_cnt FROM sales GROUP BY gender,product_line ORDER BY total_cnt DESC;
 
 -- What is the average rating of each product line
 SELECT product_line , AVG(rating) AS avg_rating FROM sales GROUP BY product_line ORDER BY avg_rating DESC;
 
 -- ---------------------------------------------------------------------------------------------------------
-- Sales 

-- Number of sales made in each time of the day per weekday
SELECT time_of_day, COUNT(*) AS total_sales FROM sales WHERE day_name ="MONDAY" GROUP BY time_of_day ORDER BY total_sales DESC;
 
 -- Which of the customer types brings the most revenue?
SELECT customer_type , SUM(total) AS total_rev FROM sales GROUP BY customer_type ORDER BY total_rev DESC;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city, SUM(tax_pct) AS largest_tax FROM sales GROUP BY city ORDER BY largest_tax DESC;

-- Which customer type pays the most in VAT?
SELECT customer_type, SUM(tax_pct) AS vat FROM sales GROUP BY customer_type ORDER BY vat DESC;

-- ---------------------------------------------------------------------------------------------------------
-- Customer 

-- How many unique customer types does the data have?
SELECT DISTINCT(customer_type) FROM sales;

-- How many unique payment method does the data have?
SELECT DISTINCT(payment) FROM sales;

-- What is the most common customer type?
SELECT customer_type, COUNT(*) AS cnt FROM sales GROUP BY customer_type ORDER BY cnt DESC;

-- Which customer type buys the most?
SELECT customer_type , SUM(quantity) AS buy_more FROM sales GROUP BY customer_type ORDER BY buy_more DESC ;

-- What is the gender of most of the customers?
SELECT gender,COUNT(*) AS  cnt  FROM sales GROUP BY gender ORDER BY cnt DESC;

-- What is the gender distribution per branch?
SELECT gender,COUNT(*) AS  cnt  FROM sales WHERE branch = "C" GROUP BY gender ORDER BY cnt DESC;

-- Which time of the day do customers give most ratings?
SELECT time_of_day , AVG(rating) as most_rating  FROM sales GROUP BY time_of_day ORDER BY most_rating DESC ;

-- Which time of the day do customers give most ratings per branch?
SELECT time_of_day , AVG(rating) as most_rating  FROM sales WHERE branch="A" GROUP BY time_of_day ORDER BY most_rating DESC ;

-- Which day of the week has the best avg ratings?
SELECT day_name , AVG(rating) AS avg_rating  FROM sales GROUP BY day_name ORDER BY avg_rating DESC;

-- Which day of the week has the best average ratings per branch?
SELECT day_name , AVG(rating) AS avg_rating  FROM sales WHERE branch="A" GROUP BY day_name ORDER BY avg_rating DESC;