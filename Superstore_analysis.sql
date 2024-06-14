STEP-1: Preprocessing data 
df=pd.read_csv('superstore_test.csv')
#Replace space with undescore in column names
df.columns=df.columns.str.replace(' ','_')
df.columns=df.columns.str.replace('-','_')
#Converting order date and ship date datatypes to datetime
df.Order_Date= pd.to_datetime(df.Order_Date)
df.Ship_Date= pd.to_datetime(df.Ship_Date)
#Load the processed data into csv file
df_store=df.to_csv('superstoredata.csv',index=False)
***********************************************************************************************************************
STEP-2:Database 'superstore' and table creation
CREATE TABLE superstore_Data(
	Row_ID integer,
	Order_ID varchar,
	Order_Date date,
	Ship_Date date,
	Ship_Mode   varchar,
	Customer_ID    varchar,
	Customer_Name  varchar,
	Segment       varchar,
	Country       varchar,
	City           varchar,
	State         varchar,
	Postal_Code integer,
	Region        varchar,
	Product_ID     varchar,
	Category       varchar,
	Sub_Category   varchar,
	Product_Name  varchar,
	Sales       numeric,
	Quantity   integer,
	Discount numeric);
Same to be performed for test_result.csv file as well.
*********************************************************************************************************************
STEP-3:Data analysis using PostgreSQL
Q.1. Use LEAD and LAG window functions to create new columns 'sales_next' and 'sales_previous'.
  
SELECT order_id,order_date,segment,state,sales,LEAD(sales) OVER (PARTITION BY segment ORDER BY order_id) AS sales_next,
       LAG(sales) OVER (PARTITION BY segment ORDER BY order_id) AS sales_previous
FROM superstore_data;

Q.2. Rank the data based on sales in descending order using 'RANK' function.

SELECT order_id,order_date,segment,sales,RANK() OVER( ORDER BY sales DESC)
FROM superstore_data;

Q.3. Use common SQL commands and aggregate functions to show monthly & daily sales averages and their percentage growth.

SELECT *,ROUND((((monthly_avg_sales/LAG(monthly_avg_sales) OVER(ORDER BY order_month))-1)*100),2) as monthly_sales_growth_percentage
FROM(
SELECT DATE_PART('month',order_date) AS order_month, ROUND(avg(sales),2) AS monthly_avg_sales
FROM superstore_data
GROUP BY order_month)
ORDER BY order_month;

SELECT *,ROUND((((daily_avg_sales/LAG(daily_avg_sales) OVER(ORDER BY order_day))-1)*100),2) as daily_sales_growth_percentage
FROM(
SELECT DATE_PART('day',order_date) AS order_day, ROUND(avg(sales),2) AS daily_avg_sales
FROM superstore_data
GROUP BY order_day)
ORDER BY order_day;

Q.4. Analyse discounts on two consecutive days.

SELECT order_date,discount,LAG(discount) OVER(ORDER BY order_date) AS discount_previous_day
FROM superstore_data
ORDER BY order_date;

Q.5. Evaluate moving averages in profit using window function.

SELECT s.order_date,s.quantity,s.category,t.profit,AVG(t.profit) OVER(ORDER BY s.order_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS moving_avg_profit
FROM test_result t
JOIN superstore_data s
ON s.row_id=t.row_id;

Q.6. Which is the most revenue generating category & sub_category in each region?

With total_revenue AS
(SELECT region,ROUND(SUM(sales),2)AS total_revenue,RANK() OVER(PARTITION BY region ORDER BY SUM(sales) DESC) as rank,category,sub_category
FROM superstore_data
GROUP BY region,category,sub_category)
SELECT *
FROM total_revenue
WHERE rank=1;

Q.7. Which are the top 10 products with highest average sales?

SELECT product_id,product_name,ROUND(AVG(sales),2) as avg_Sales
FROM superstore_data
GROUP BY product_id,product_name
ORDER BY avg_Sales DESC
LIMIT 10;

Q.8. Which are the bottom 10 products with lowest average sales?

SELECT product_id,product_name,ROUND(AVG(sales),2) as avg_Sales
FROM superstore_data
GROUP BY product_id,product_name
ORDER BY avg_Sales 
LIMIT 10;

Q.9. What are the top10 states with most orders including average order value & profit per order?

SELECT s.state,COUNT(*) AS no_of_orders,ROUND(AVG(s.sales),2) as avg_order_value,ROUND(AVG(t.profit),2) AS profit_per_order
FROM superstore_data s
JOIN test_result t
ON s.row_id=t.row_id
GROUP BY s.state
ORDER BY no_of_orders DESC
LIMIT 10;

Q.10. What % of orders is associated with each shipment type?

SELECT  ship_mode,COUNT(*) AS total_orders, round((COUNT(*)*100/ (SELECT COUNT(*) FROM superstore_data)),2) AS Order_percentage 
FROM superstore_data
GROUP BY  ship_mode	
ORDER BY Order_percentage desc;

Q.11. How many % orders are actually shipped on same day?

SELECT *,ROUND((SameDayShipped*100/TotalOrders),2) AS percentage_orders
FROM(
SELECT count(*) AS TotalOrders,sum(case when ship_date = order_date then 1 else 0 end) as SameDayShipped
FROM superstore_data);

Q.12. Compute average sales for each month and compares it to the same month in the previous year.

SELECT *,LAG(avg_sales, 12) OVER (ORDER BY month) AS prev_year_sales
FROM(
SELECT 
  DATE_TRUNC('month', order_date) AS month, 
  AVG(sales) AS avg_sales   
FROM superstore_data
GROUP BY month);




