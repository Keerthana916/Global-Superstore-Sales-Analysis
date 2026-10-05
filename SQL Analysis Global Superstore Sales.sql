/*
								SUPERSTORE SALES ANALYSIS - SQL
								=================================

Project Overview : 
This analysis explores the Superstore dataset using MySQL to identify trends and patterns in sales, profit, customers, products, discounts, segements, and geographical performance.

*/
-- ============================
-- 1. DATABASE & DATA OVERVIEW
-- ============================
create database superstore_analysis;

use superstore_analysis;

create table superstore (
Category varchar(50), City varchar(10), Country varchar(100),
Customer_ID varchar(50), Customer_Name varchar(150), Discount decimal(10,4),
Market varchar(50), Order_Date date, Order_ID varchar(50),
Order_Priority varchar(20), Product_ID varchar(50), Product_Name varchar(255),
Profit decimal(12,4), Quantity int, Region varchar(100),
Row_ID int, Sales decimal(12,2), Segment varchar(50),
Ship_Date date, Ship_Mode varchar(50), Shipping_Cost decimal(12,4),
State varchar(100), Sub_Category varchar(100), Year int,
Market2 varchar(50), Month int 
);

show tables;

describe superstore;

ALTER TABLE superstore
MODIFY Category VARCHAR(50),
MODIFY City VARCHAR(100),
MODIFY Country VARCHAR(100),
MODIFY Customer_ID VARCHAR(30),
MODIFY Customer_Name VARCHAR(100),
MODIFY Market VARCHAR(50),
MODIFY Order_ID VARCHAR(30),
MODIFY Order_Priority VARCHAR(30),
MODIFY Product_ID VARCHAR(30),
MODIFY Product_Name VARCHAR(255),
MODIFY Region VARCHAR(100),
MODIFY Segment VARCHAR(50),
MODIFY Ship_Mode VARCHAR(50),
MODIFY State VARCHAR(100),
MODIFY Sub_Category VARCHAR(100),
MODIFY Market2 VARCHAR(100);

select count(*) as total_rows from superstore;

select * from superstore;


-- ================================
-- 2. OVERALL BUSINESS PERFORMANCE
-- ================================

-- 2.1 - Total Sales, Profit, Quantity and Orders
select 
	sum(Sales) as Total_Sales,
    sum(Profit) as Total_Profit,
    sum(Quantity) as Total_Quantity,
    count(distinct Order_ID) as Total_Orders
from superstore;

-- 2.2 - Overall Profit Margin
select 
	round(sum(Profit),2) as Total_Profit,
    round(sum(Sales),2) as Total_Sales,
    round(sum(Profit)/sum(Sales) *100, 2) as Profit_Margin
from superstore;

-- Insights:
-- The business generated approximately 12.64M in sales and 1.47M in profit.
-- The overall profit margin was 11.61%, meaning the business generated.
-- Approximately 11.61 in profit fro every 100 in sales.


-- =======================
-- 3. CATEGORY ANALYSIS
-- =======================

-- 3.1 - Sales and Profit by Category
select 
	Category, round(sum(Sales),2) as Total_Sales,
    round(sum(Profit),2) as Total_Profit
from superstore group by Category order by Total_Sales desc;

-- Insights:
-- Technology generated the highest sales (4.74 M) and profit (663.78 K).
-- Furniture generated relatively high sales (4.11 M) but considerably lower profit (285.20 K), indicating weaker profitability. 
-- Office Supplies generated lower sales than Furniture but higher profit, showing that sales volume alone does not determine profitability. 

-- 3.2 - Profit Margin by Category
select
	Category, round(sum(Sales),2) as Total_Sales,
    round(sum(Profit),2) as Total_Profit,
    round(sum(Profit)/sum(Sales)*100,2) as Profit_Margin
from superstore group by Category order by Profit_Margin desc;

-- Insights:
-- Technology has the highest profit margin at 13.99%, followed closely by Office Supplies at 13.69%. 
-- Furniture had a significantly lower profit margin of 6.94%, indicating weaker profitability despite generating relativley high sales. 


-- =========================
-- 4. SUB-CATEGORY ANALYSIS
-- =========================

-- 4.1 -  Sales and Profit by Sub-Category
select
	Sub_Category, round(sum(Sales),2) as Total_Sales,
    round(sum(Profit),2) as Total_Profit
from superstore group by Sub_Category order by Total_Profit desc;

-- Insights:
-- Copiers generated the highest profit at approximately 258.57K
-- While phones generated the highest sales approximately 1.71M.
-- Tables was the only loss-making sub-category, generating approximately 757.03K in sales and but a loss of 64.08K.
-- This indicates that high sales do not necessarily result in high profitability.

-- 4.2 - Profit Margin by Sub-Category
select
	Sub_Category, round(sum(Sales),2) as Total_Sales,
    round(sum(Profit),2) as Total_Profit,
    round(sum(Profit)/sum(Sales)*100,2) as Profit_Margin
from superstore group by Sub_Category order by Profit_Margin desc;

-- Insights:
-- Paper had the highest profit margin at 24.23%, followed by Labels at 20.44%.
-- Copiers generated the highest total profit, but the Paper had the highest profit margin, showing that total profit and profitability are different measures.
-- Tables had a negative profit margin of -8.47%, making it the major profitability concern among sub-categories.

-- 4.3 Loss-Making Sub-Category
select
	Sub_Category,
    round(sum(Sales),2) as Total_Sales,
    round(sum(Profit),2) as Total_Profit,
    round(sum(Profit)/sum(Sales) *100, 2) as Profit_Margin,
    round(avg(Discount)*100,2) as Average_Discount_Percentage
from superstore
group by Sub_Category
having Total_Profit<0
order by Total_Profit asc;

-- Insights:
-- Tables was the only loss-making sub-category , generating 757.03K in sales but incurring a loss of 64.08K. 
-- It had a negative profit margin of -8.47% and the highest average discount among the sub-categories at 29.07%. 
-- Therefore, Table is a key area for further investigation and potential profitability improvement. 

-- 4.4 -  Tables: Discount vs Profit
select
	Discount, count(*) as Transaction_Count,
    round(sum(Sales),2) as Total_Sales,
    round(sum(Profit),2) as total_Profit,
    round(avg(Profit),2) as Average_Profit
from superstore
where Sub_Category='Tables'
group by Discount
order by Discount;

-- Insights:
-- Tables remained profitable at discounts up to 20%, generating 60.45K profit at 0% discount and 7.22K at 20% discount. 
-- At a 30% discount, the sub-category become loss-making with a loss of 11.96K. 
-- A higher discount level were generally associated with increasingly negative profitability, with the largest loss of 34.28K occurring at a 70% discount. 
-- Therefore, in this dataset, high discount level appear to be a major contributor to the negative profitability of Tables. 


-- =====================
-- 5. DISCOUNT ANALYSIS
-- =====================

-- 5.1 - Discount vs Sales and Profit
select 
	Discount, count(*) as Transaction_Count,
    round(sum(Sales),2) as Total_Sales,
    round(sum(Profit),2) as Total_Profit,
    round(avg(Profit),2) as Average_Profit
from superstore group by Discount order by Discount;

-- Insights:
-- Profitability generally declines as the discount increases. 
-- Total profit becomes negative at the 27% discount level and remains negative at higher discount levels. 
-- Higher discounts such as 40%, 50%, 60% and 70% are associated with substantial losses. 
-- This suggests that aggressive discounting can significantly reduce profitability and should be carefully controlled. 

-- 5.2 - Discount vs Profit by Sub-Category
select
	Sub_Category, round(avg(Discount)*100,2) as Avg_Discount_Percentage,
    round(sum(Sales),2) as Total_Sales,
    round(sum(Profit),2) as Total_Profit,
    round(sum(Profit)/sum(Sales)*100,2) as Profit_Margin
from superstore group by Sub_Category order by Total_Profit asc;

-- Insights:
-- Tables had the highest average discount at 29.07% and was the only loss-making sub-category, with a profit margin of -8.47%. 
-- In contrast, Copiers and Papers had relatively low average discount of 11.71% and 10.95% and achieved strong profitability. 
-- This suggests that discount may be an important factor contributing to weak profitability in certain sub-categories, particularly Tables. 


-- ====================
-- 6. SEGMENT ANALYSIS
-- ====================

-- 6.1 - Sales, Profit, and Profit Margin by Segment
select
	Segment, round(sum(Sales),2) as Total_Sales,
    round(sum(Profit),2) as Total_Profit,
    round(sum(Profit)/sum(Sales)*100,2) as Profit_Margin
from superstore group by Segment order by Total_Profit desc;

-- Insights:
-- Consumer generated the highest sales (6.51M) and total profit (749.24K). 
-- Home Office had the highest profit margin at 11.99%, despite hiaving the lowest sales among the three segments. 
-- Profit margins were relatively close across all segments, ranging from 11.51% to 11.99%. 


-- ====================
-- 7. COUNTRY ANALYSIS
-- ====================

-- 7.1 - Sales and Profit by Country
select
	Country, round(sum(Sales),2) as Total_Sales,
    round(sum(Profit),2) as Total_Profit
from superstore group by Country order by Total_Sales desc
limit 10;

-- Insights:
-- The United States ranked first in both sales (2.30M) and profit (286.4K). 
-- China generated relatively high profit (150.68K) despite lower sales than Australia and France.
-- Indonesia generated 404.89K in sales but only 15.61K in profit, indicating relatively weak profitability. 
-- Overall, Country ranking by sales and profit differ, showing that sales volume alone is not sufficient to evaluate market performance. 

-- 7.2 - Profit Margin by Country
select
	Country, round(sum(Sales),2) as Total_Sales,
    round(sum(Profit),2) as Total_Profit,
    round(sum(Profit)/sum(Sales)*100,2) as Profit_Margin
from superstore group by Country order by Profit_Margin desc
limit 10;

-- Insights:
-- Countries with the highest profit margin do not necessarily generate the highest total profit or sales. 
-- Foe example, Armenia had the highest profit margin at 44.29%, but only generated 69.09 in total profit. 
-- Therefore, both profit margin and total profit should be considered when evaluating country-level performance. 

-- 7.3 - Profit Margin by Country : Considering countries with meaningful sales volume
select
	Country, round(sum(Sales),2) as Total_Sales,
    round(sum(Profit),2) as Total_Profit,
    round(sum(Profit)/sum(Sales)*100,2) as Profit_Margin
from superstore group by Country
having sum(Sales)>=100000
order by Profit_Margin desc limit 10;

-- Insights:
-- Among countries with at least 100K in sales, Cuba has the highest profit margin at 24.14%. 
-- India and China showed strong profitability, with profit margi of 21.89% and 21.51%, respectively. 
-- Applying a minimum sales threshold provides a more meaningful comparison by reducing the influence of countries with very low sales volume. 


-- ===================
-- 8. REGION ANALYSIS
-- ===================

-- 8.1 - Sales, Profit and Profit Margin by Region
select
	Region, round(sum(Sales),2) as Total_Sales,
    round(sum(Profit),2) as Total_Profit,
    round(sum(Profit)/sum(Sales)*100,2) as Total_Margin
from superstore group by Region order by Total_Profit desc;

-- Insights:
-- Central generated the highest total sales (2.82M) and total profit (311.40K), making it the strongest region by overall contributions. 
-- North Asia showed strong profitability with a 19.52% profit margin and 165.58K in total profit. 
-- Canada had the highest profit margin at 26.62%, but its sales volume was relatively small at 66.93K. 
-- Southeast Asia had a low profit margin of only 2.02% despite generating 884.44K in sales, indicating a potential profitability concern in the region. 


-- =======================
-- 9. TIME BASED ANALYSIS
-- =======================

-- 9.1 - Yearly Sales, Profit and Profit Margin
select
	Year, round(sum(Sales),2) as Total_Sales,
    round(sum(Profit),2) as Total_Profit,
    round(sum(Profit)/sum(Sales)*100,2) as Profit_Margin
from superstore group by Year order by Year;

-- Insights:
-- Sales and profit increased consistently from 2011 to 2014. 
-- Sales increased from 2.26M in 2011 to 4.30M in 2014, while profit increased from 248.94K to 504.17K. 
-- 2014 recorded the highest sales and total profit. 
-- However, 2013 had the highest profit margin at 11.95%. 
-- Overall, the business demostrated strong growth whilemaintaining a relativley stable profit margin of around 11-12%. 

-- 9.2 - Monthly Sales and Profit
select 
	Month, round(sum(sales),2) as Total_Sales,
    round(sum(Profit),2) as Total_Profit
from superstore group by Month order by Month;

-- Insights:
-- December recorded the highest sales at approximately 1.58M, while November generated the highest profit at approximately 175.45K. 
-- Febraury had the lowest sales and profit. 
-- Overall, business perormance was generally stronger during the later months of the year, particularly from August to December. 
-- December's sales were the highest, but November generated slightly higher profit, highlighting that higher sales do not always result in the highest profit. 

-- 9.3 - Monthly Profit Margin
select
	Month, round(sum(Sales),2) as Total_Sales,
    round(sum(Profit),2) as Total_Profit,
    round(sum(Profit)/sum(Sales)*100,2) as Profit_Margin
from superstore group by Month order by Profit_Margin desc;

-- Insights:
-- October recorded the highest profit margin at 13.46%, despite having lower sales than several later months. 
-- December generated the highest sales at 1.58M, but its profit margin was only 10.80%. 
-- November generated the highest total profit at 175.45K. 
-- July had the lowest profit margin at 10.42%. 
-- Overall, high sales volume does not necessarily result in the highest profit margin, highlighting the importance of evaluating both volume and profitability. 

-- 9.4 - Yearly Order Volume
select
	Year, count(distinct Order_ID) as Total_Orders,
    sum(Quantity) as Total_Quantity,
    round(sum(Sales),2) as Total_Sales,
    round(sum(Profit),2) as Total_Profit
from superstore group by Year order by Year;

-- Insights:
-- Total Orders and Total Quantity increased consistently from 2011 to 2014. 
-- Orders inncreased from 4,440 in 2011 to 8,531 in 2014, while quantity increased from 31,443 to 60,622. 
-- The growth in order volume and quantity was accompanied by consistent increase in sales and profit. 
-- 2014 recorded the highest order, quantity, sales, and profit.

-- 9.5 - Average Sales and Profit per Order
select
	Year, count(distinct Order_ID) as Total_Orders,
    round(sum(Sales)/count(distinct Order_ID),2) as Avg_Sales_per_Order,
    round(sum(Profit)/count(distinct Order_ID),2) as Avg_Profit_per_Order
from superstore group by Year order by Year;

-- Insights:
-- Average sales per order remained relativly stable between 2011 and 2014, ranging from approximately 501 to 509. 
-- Therefore, the growth in total sales was primarily driven by the increases in the number of orders rather than a significant increase in average order value. 
-- Average profit per order also remained relatively satble, increasing from 56.07 in 2011 to 59.10 in 2014. 


-- ======================
-- 10. SHIPPING ANALYSIS
-- ======================

-- 10.1 - Average Shipping Time by Ship Mode
select
	Ship_Mode, count(*) as Total_Orders,
    round(avg(datediff(Ship_Date, Order_Date)),2) as Avg_Shipping_Days
from superstore group by Ship_Mode
order by Avg_Shipping_Days;

-- Insights:
-- Same Day had the shortest average shipping time at 0.04 days, while Standard Class had the longest at 5 days. 
-- Standard Class was also the most frequently used shipping mode, with 30,775 orders. 
-- Overall, faster shipping modes were associated with shorter delivery time, while Standard Class had the longest average shipping duration. 

-- 10.2 - Average Shipping Cost by Ship Mode
select 
	Ship_Mode, count(*) as Total_Orders,
    round(avg(Shipping_Cost),2) as Avg_Shipping_Cost,
    round(sum(Shipping_Cost),2) as Total_Shipping_Cost
from superstore group by Ship_Mode order by Avg_Shipping_Cost;

-- Insights:
-- Same Day had the highest average shipping cost at 42.94, while Standard Class had the lowest at 19.97. 
-- Shipping cost generally increased as the shipping mode become faster. 
-- However, Standard Class had the highest total shipping cost at 614.63K because it accounted for the largest number of orders. 
-- Therefore, average shipping cost and total shipping cost provide different perspective on shipping expenses. 

-- 10.3 - Shipping Cost vs Profit by Ship Mode
select
	Ship_Mode, round(avg(Shipping_Cost),2) as Avg_Shipping_Cost,
    round(sum(Profit),2) as Total_Profit,
    round(sum(Profit)/sum(Sales)*100 ,2) as Profit_Margin
from superstore group by Ship_Mode order by Profit_Margin;

-- Insights:
-- Standard Class had the lowest average shipping cost (19.97) and the highest profit margin (11.75%). 
-- Same Day had the highest average shipping cost (42.94), but its profit margin remained similar at 11.42%. 
-- Profit margin across all shipping modes were relatively close, ranging from 11.37% to 11.75%. 
-- Therefore, shipping mode appears to have limited impact on overall profit margin in this dataset. 


-- ======================
-- 11. CUSTOMER ANALYSIS
-- ======================

-- 11.1 - Top 10 Customers by Sales
select
	Customer_Name, round(sum(Sales),2) as Total_Sales,
    round(sum(Profit),2) as Total_Profit,
    count(distinct Order_ID) as Total_Orders
from superstore group by Customer_Name
order by Total_Sales desc limit 10;

-- Insights:
-- Tom Ashbrook generated the highest sales among the top 10 custoemrs at 40.49K, while Tamara Chand generated the highest profit at 8.67K. 
-- Sean Miller generated 35.17K in sales but incurred a loss of 409.71. 
-- This demostates that the high sales do not necessarily translate into high profit, so the customer performance should be evaluated using both sales and profit. 

-- 11.2 - High-Sales Customers with Negative Profit
select
	Customer_Name, round(sum(Sales),2) as Total_Sales,
    round(sum(Profit),2) as Total_Profit,
    count(distinct Order_ID) as Total_Orders
from superstore group by Customer_Name
having sum(Profit)<0
order by Total_Sales desc limit 10;

-- Insights:
-- Several high-sales customers generated total negative profit. 
-- Sean Miller had the highest sales among loss-making customers at 35.17K, while Grant Thornton recorded the largest loss at approximately 3.58K. 
-- Denise Monton also generated 22.05K in sales but incurred a loss of approximately 2.60K. 
-- This demostrates that customer sales volume alone is not sufficient to evaluate customer value and profitability. 

-- 11.3 - Discount and Profitability of Loss-making Customers
select
	Customer_Name, round(sum(Sales),2) as Total_Sales,
    round(avg(Discount)*100,2) as Avg_Discount_Percentage,
    round(Sum(Profit),2) as Total_Profit
from superstore group by Customer_Name
having sum(Profit)<0 order by Total_Profit
asc limit 10;

-- Insights:
-- Several loss-making customers had relatively high average discount, suggesting that higher discounts may contribute to reduced profitability. 
-- However, Cindy Stewart recoded the largest loss of 6.15K despite an average discount of only 9.95%. 
-- Therefore, discount level alone does not explain customer losses, and other factors such as product mix and shipping costs may also influence profitability. 

-- 11.4 -  Top 10 Customers by Profit
select
	Customer_Name,
    round(sum(Sales),2) as Total_Sales,
    round(sum(Profit),2) as Total_Profit
from superstore
group by Customer_Name
order by Total_Profit desc
limit 10;

-- Insights:
-- Tamara Chand is the most profitable customer, generating 8,672 in profit, followed by Raymond Buch and Sanjit Chand. 
-- Interestingly, Tom Ashbrook had the highest sales among these customers but ranks 10th in the profit, showing that the higher sales do not necessarily result in higher profitability. 


-- ===========================
-- 12. PRODUCT LEVEL ANALYSIS
-- ===========================

-- 12.1 - Product-level Profitability Analysis
select
	Product_Name, Sub_Category,
    round(sum(Sales),2) as Total_Sales,
    round(sum(Profit),2) as Total_Profit,
    round(avg(Discount)*100,2) as Avg_Discount_Percentage
from superstore 
group by Product_Name, Sub_Category
having sum(Profit)<0 
order by Total_Profit asc limit 10;

-- Insights:
-- Product-level analysis identified several significantly loss-making products, particularly within the Machines and Tables sub-categories.
-- Several of these products have high average discount levels, suggesting that excessive discounting may contribute to their losses. 
-- However, some prodcuts with moderate discounts are also loss-making, indicating that other factors may influence product profitability. 


-- ==========================
-- 13. ADVANCED SQL ANALYSIS
-- ==========================

-- 13.1 - Product Profit Ranking within each Sub-Category
with Product_Profit as(
	select 
		Product_Name, Sub_Category,
        sum(Sales) as Total_Sales,
        sum(Profit) as Total_Profit
	from superstore
    group by Product_Name, Sub_Category
)
select 
	Product_Name, Sub_Category,
    round(Total_Sales,2) as Total_Sales,
    round(Total_Profit,2) as Total_Profit,
    rank() over (
		partition by Sub_Category
        order by Total_Profit desc)
	as Profit_Rank
    from Product_Profit
    order by Sub_Category, Profit_Rank;
    
-- 13.2 -  Year Over Year Sales Growth
with Yearly_Sales as(
	select
		Year, sum(Sales) as Total_Sales
	from superstore
	group by Year
)
select
	Year, round(Total_Sales,2) as Total_Sales,
    lag(Total_Sales) over(order by Year) as Previous_Year_Sales,
    round(
		(Total_Sales - lag(Total_Sales) over (order by Year))
        /lag(Total_Sales) over (order by Year) * 100, 2
	) as Sales_Growth_Percentage
from Yearly_Sales
order by Year;

-- Insights:
-- Sales showed consistent year-over-year growth from 2011 to 2014, with the highest growth of 27.20% recorded in 2013. 
-- Growth remained strong at 26.25% in 2014, indicating sustained sales expansion. 

-- 13.3 - Year-over-Year Profit Growth
with Yearly_Profit as (
	select 
		Year, sum(Profit) as Total_Profit
	from superstore
    group by Year
)
select 
	Year, round(Total_Profit,2) as Total_Profit,
    lag(Total_Profit) over (order by Year) as Previous_Year_Profit,
    round(
		(Total_Profit - lag(Total_Profit) over (order by Year))
        /lag(Total_Profit) over (order by Year) * 100, 2
	) as Profit_Growth_Percentage 
from Yearly_Profit
order by Year;

-- Insights:
-- Profit increased consistently form 2011 to 2014, with the highest year-over-year growth of 32.37% in 2013. 
-- Profit growth remained strong at 23.89% in 2014, indicating over stained improvement in profitability. 

-- 13.4 - Running Total of Sales
select
	year, round(sum(Sales),2) as Total_Sales,
    round(sum(sum(Sales)) over (order by Year), 2)
    as Running_Total_Sales
from superstore
group by Year
order by Year;

-- Insights:
-- The running total sales increased consistently from 2.26 million in 2011 to 12.63 million by 2014, reflecting sustained sales growth throughout the four-year period. 

-- 13.5 - Percentage Contribution to Total Sales
select
	Category, round(sum(Sales),2) as Total_Sales,
    round(
		sum(Sales)/ sum(sum(Sales)) over() * 100, 2
        ) 
	as Sales_Contribution_Percentage
from superstore
group by Category
order by Sales_Contribution_Percentage desc;

-- Insights:
-- The Technology contributed largest share of total sales at 37.53%, followed by Furniture at 32.52% and Office Supplies at 29.06%. 
-- Technology therefore represents the largest contributor to overall sales. 

-- 13.6 - Top N-Products Within Each Sub-Category
with Product_Profit as (
	select
		Product_Name, Sub_Category,
        sum(Sales) as Total_Sales,
        Sum(Profit) as Total_Profit
	from superstore
    group by Product_Name, Sub_Category
),
Ranked_Products as (
	select 
		Product_Name, Sub_Category,
		round(Total_Sales,2) as Total_Sales,
		round(Total_Profit,2) as Total_Profit,
		rank () over( partition by Sub_Category order by Total_Profit desc)
		as Profit_Rank
	from Product_Profit
)
select
	Product_Name, Sub_Category,
    Total_Sales, Total_Profit, Profit_Rank
from Ranked_Products
where Profit_Rank<=3
order by Sub_Category, Profit_Rank;

-- Insights:
-- The Analysis identified the three most profitable products within each sub-category using the Rank() window function. 
-- This allows product performance to be compared within each sub-category rather than across the entire product catalog. 

-- 13.7 -  Customer with Above Average Sales
with Customer_Sales as(
	select
		Customer_Name, sum(Sales) as Total_Sales
	from superstore
    group by Customer_Name
)
select	
	Customer_Name,
    round(Total_Sales,2) as Total_Sales
from Customer_Sales
where Total_Sales > ( select avg(Total_Sales) from Customer_Sales)
order by Total_Sales desc;

-- Insights:
-- The analysis identifies customers whose totatl sales are above the average customer sales. 
-- Tom Ashbrook generated the highest total sales among these abive-average customers, with sale of 40,489 , followed by Tamara Cand with 37,453. 


/* 
===========================
14. SQL ANALYSIS - CONCLUSION
===========================

Overall Business Performance:
- Total Sales : 12.64M
- Total Profit : 1.47M
-Overall Profit Margin : 11.61%
- Sales and Profit increased consistently from 2011 to 2014. 

Category Performance: 
- Technology generated the highest Sales and Profit. 
- Technology also had the highest Profit Margin among the three categories. 
- Furniture generated strong Sales but had a relatively low Profit Margin. 

Product and Discount Insights:
- Tables were the major loss-making sub-category with a Profit Margin of -8.47%. 
- Higher discount levels were generally associated with lower or negative profitability.
- Several products in Tables, Machines, and Phones generated significant losses.

Geographic Performance:
- United States ranked first in both Sales and Profit. 
- India and China showed relatively strong Profit Margins compared with thier Sales rankings. 
- Profitability varied significantly across regions. 

Customer Insights:
- Consumer was the largest customer by Sales and Profit. 
- Customer level analysis showed that customers with high Sales were not always the most profitable. 
- Customer performance should therefore be evaluated using both Sales and Profit rather than Sales alone

Business Recommendations:
1. Review high-discount transactions. 
2. Investigate loss-making sub-categories, especially Tables.
3. Focus on high-margin products such as Paper, Labels, and Copiers. 
4. Evaluate customer performance using both Sales and Profit to identify high-value and high profitable customers.
5. Develop region-specific strategies based on profitability. 
6. Retain and grow high-value customers. 

Final Conclusion
- The analysis shows that high Sales do not always result in high Profit. 
- Discount levels, product mix, customer segments, and geographic regions all influence profitability. 
- The business should focus on improving pricing and dicount strategies, reducing losses from underperforming products , and prioritizing high-margin products and customers. 

*/

/*
						STAR SCHEMA
					  ===============
                      
*/

select 
	Order_ID, count(*) as Row_Count
from superstore group by Order_ID
having  count(*)>1;

select 
	Order_ID, Product_ID,
    count(*) as Row_Count
from superstore
group by Order_ID, Product_ID
having count(*)>1;

select
	count(*) as Total_Rows,
    count(distinct Row_ID) as Unique_Row_id
from superstore;

select
	Row_ID, count(*) as Row_Count
from superstore group by Row_ID
having count(*)>1;

-- Creating table Dim_Customer
create table Dim_Customer as
select distinct
	Customer_ID, Customer_Name, Segment
from superstore;

-- Checking duplicate customer ids
select
	Customer_ID, count(*) as Customer_Count
from dim_customer
group by Customer_ID having count(*) >1;

-- Add Primary Key
alter table Dim_Customer
add primary key(Customer_ID);

-- Checking null customer ids
select count(*) as Null_Customer_IDs
from dim_customer
where Customer_ID is null;

-- Create table Dim_Product
create table Dim_Product as 
select distinct
	Product_ID, Product_Name, Category, Sub_Category
from superstore;

-- Check whether Product id is unique
select 
	Product_ID, count(*) as Product_Count
from dim_product
group by Product_ID
having count(*) >1;

-- Checking for null product id
select
	count(*) as null_product_ids
from dim_product
where Product_ID is null;

select
	Product_ID, 
    count(distinct Product_Name) as Name_Count,
    count(distinct Category) as Category_Count,
    count(distinct Sub_Category) as Subcategory_Count
from superstore
group by Product_ID
having count(*) >1;

select
	Product_ID, Product_Name,
    Category, Sub_Category
from superstore
where Product_ID = 'OFF-PA-10000659';

-- Column Product_ID is not unique enough to be the Primary Key for the Dim_Product table. 

select
	Product_ID, Product_Name,
    Category, Sub_Category,
    count(*) as Record_Count
from superstore
group by Product_ID, Product_Name,
		Category, Sub_Category
having count(*) > 1;

-- create Surrogate Product_Key
alter table dim_product
add column Product_Key int auto_increment primary key;

select * from dim_product limit 10;

select
	count(*) as missing_product_rows
from superstore
where Product_ID is null or Product_Name is null;

select * from dim_product where Product_ID is null;

select
	count(*) as null_product_rows
from dim_product
where Product_ID is null;

select
	Product_Key,
    count(*) as Key_Count
from dim_product
group by Product_Key
having count(*) >1;

-- Looking up dimension key and placing it into the fact table. 

-- Test the product join
select
	s.Row_ID, s.Product_ID,
    s.Product_Name, p.Product_Key
from superstore as s
join dim_product as p
	on s.Product_ID = p.Product_ID
    and s.Product_Name = p.Product_Name
    and s.Category = p.Category
    and s.Sub_Category = p.Sub_Category;
    
    select count(*) as total_rows from superstore;
    
    select count(*) as Joined_Rows
    from superstore as s
    join dim_product as p
		on s.Product_ID = p.Product_ID
        and	s.Product_Name = p.Product_Name
        and s.Category = p.Category
        and s.Sub_Category = p.Sub_Category;

-- create Fact_Sales
create table Fact_Sales as
select
		s.Row_ID, s.Order_ID, s.Customer_ID,
        p.Product_Key, s.Order_Date, s.Ship_Date,
        s.Sales, s.Quantity, s.Discount, s.Profit,
        s.Shipping_Cost, s.Order_Priority, s.Ship_Mode
from superstore as s
join dim_product as p
	on s.Product_ID = p.Product_ID
    and s.Product_Name = p.Product_Name
    and s.Category = p.Category
    and s.Sub_Category = p.Sub_Category;

select * from fact_sales;

select count(*) as Fact_Rows from fact_sales;

-- Add the Primary Key to Fact_Sales
alter table fact_sales add primary key (Row_ID);

select
	min(Order_Date) as Min_Date,
    max(Order_Date) as Max_Date
from superstore;

set session cte_max_recursion_depth=2000;

-- create date dimension table as Dim_Date
create table Dim_Date as
with recursive Dates as (
	select date ('2011-01-01') as date
    union all 
    select date_add(date, interval 1 day)
    from Dates
    where date < '2014-12-31'
)
select
	year(date)*10000
		+ month(date)*100
        + day(date) as Date_Key,
	date,
    year(date) as Year,
	quarter(date) as Quarter,
    month(date) as Month_Number,
    monthname(Date) as Month_Name
from Dates;

-- Check the number of dates
select count(*) as Total_Dates from dim_date;

-- Check the first and last date
select 
	min(date) as min_date,
    max(date) as max_date
from dim_date;

-- Check for duplicate date key
select 
	Date_Key, count(*) as Key_Count
from dim_date
group by Date_Key
having count(*) > 1;

-- Check for null date key
select count(*) null_date_key
from dim_date
where Date_Key is null;

-- Setting primary key
alter table dim_date
add primary key (Date_Key);

select distinct
	Market, Market2
from superstore
order by Market, Market2;

-- Create Dim_Geography table
create table Dim_Geography as
select distinct
	City, State,
    Country, Region,
    Market, Market2
from superstore;

select count(*) as geography_rows from dim_geography;

select
	City, State, Country,
    Region, Market, Market2,
    count(*) as row_count
from dim_geography
group by City, State, Country,
		Region, Market, Market2
having count(*) > 1;

alter table dim_geography
add column Geography_Key int auto_increment primary	key;
	
select count(*) as null_geography_keys
from dim_geography
where Geography_Key is null;

select
	geography_key, count(*) as key_count
from dim_geography
group by Geography_Key
having count(*) > 1;

-- Add Date Key to the Fact Table
alter table fact_sales
add column Date_Key int;

update fact_sales
set Date_Key = 
		year(Order_Date) * 10000
		+ month(order_Date) * 100
        + day(Order_Date)
where Row_ID >=1;

select count(*) as null_date_keys
from fact_sales
where Date_Key is null;

-- Add Geography Key to the Fact Table
alter table fact_sales
add column Geography_Key int;

select 
	count(*) as Fact_Rows,
    count(distinct Row_ID) as Unique_Fact_Rows
from fact_sales;

select count(*) as Total_Rows from superstore;

select count(*) as Joined_Rows
from superstore as s
join dim_geography as g
	on s.City = g.City
    and s.State = g.State
    and s.Country = g.Country
    and s.Region = g.Region
    and s.Market = g.Market
    and s.Market2 = g.Market2;
    
update fact_sales as f
join superstore as s
	on f.Row_ID = s.Row_ID
join dim_geography as g
	on s.City = g.City
    and s.State = g.State
    and s.Country = g.Country
    and s.Region = g.Region
    and s.Market = g.Market
    and s.Market2 = g.Market2
set f.Geography_Key = g.Geography_Key
where f.Row_ID >= 1;

select count(*) as populated_geography_keys
from fact_sales
where Geography_Key is not null;

select count(*) as total_fact_rows
from fact_sales;

-- Instead of large update create remporary mapping
create temporary table Geography_Map as
select
	s.Row_ID,
	g.Geography_Key
from superstore as s
join dim_geography as g
	on s.City = g.City
    and s.State = g.State
    and s.Country = g.Country
    and s.Region = g.Region
    and s.Market = g.Market
    and s.Market2 = g.Market2;
    
select count(*) as mapping_rows from Geography_Map;

-- Populate Geography Key
update fact_sales as f
join Geography_Map as m
	on f.Row_ID = m.Row_ID
set f.Geography_Key = m.Geography_Key
where f.Row_ID >= 1;

select count(*) as null_geography_keys
from fact_sales 
where Geography_Key is null;

-- Create Foreign Key Relationships
alter table fact_sales
add constraint fk_fact_customer
foreign key (Customer_ID)
references dim_customer(Customer_ID);

select count(*) as unmatched_customers
from Fact_Sales as f
left join Dim_Customer as c
    on f.Customer_ID = c.Customer_ID
where c.Customer_ID is null;

-- Validate product relationship
select count(*) as unmatched_products
from fact_sales as f
left join dim_product as p
	on f.Product_Key = p.Product_Key
where p.Product_Key is null;

-- Add product foreign key
alter table fact_sales
add constraint fk_fact_product
foreign key (Product_Key)
references dim_product(Product_Key);

-- Date relationship
select count(*) as unmatched_dates
from fact_sales as f
left join dim_date as d
	on f.Date_Key = d.Date_Key
where d.Date_Key is null;

-- Add date foreign key
alter table fact_sales 
add constraint fk_fact_date
foreign key (Date_Key)
references dim_date(Date_Key);

describe dim_date;
describe fact_sales;

show create table fact_sales;

alter table dim_date
modify column Date_Key int not null;

alter table fact_sales 
add constraint fk_fact_date
foreign key (Date_Key)
references dim_date(Date_Key);

-- Geography relationship
select count(*) as unmatched_geography
from fact_sales as f
left join dim_geography as g
	on f.Geography_Key = g.Geography_Key
where g.Geography_Key is null;

-- Create geography foreign key
alter table fact_sales
add constraint fk_fact_geography
foreign key (Geography_Key)
references dim_geography(Geography_Key);

show tables;

