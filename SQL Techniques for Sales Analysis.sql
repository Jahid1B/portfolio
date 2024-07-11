01. Create Database
02. Create table & data insert.
03.Setting not null for data
04. In which city is each branch?
05.How many unique cities does the data have?
06. Column adding on Time_of_day, day_name, month_name.

Product-
01.How many unique product lines does the data have?
02.What is the most selling product line?
03.What is the total revenue by month?
04.What month had the largest COGS?
05.What product line had the largest revenue?
06.What is the city with the largest revenue?
07.What product line had the largest VAT?
08.Which branch sold more products than average product sold?
09.What is the most common product line by gender?
10.What is the average rating of each product line?

Sales  -

01.Number of sales made in each time of the day per weekday.
02.Which of the customer types brings the most revenue?
03.Which city has the largest tax percent/ VAT (Value Added Tax)?
04.Which customer type pays the most in VAT?=

Customer- 
01.How many unique customer types does the data have?
02.How many unique payment methods does the data have?
03.Which customer type buys the most?
04.What is the gender of most of the customers?
05.What is the gender distribution per branch?


create database IF NOT exists ProductsalesData;

salescreate table if not exists sales(
	invoice_id varchar (30) not null primary key,
    branch varchar (5) not null,
    city varchar (30) not null,
    coustomer_type varchar (30) not null,
	gender varchar (10) not null,
    product_line varchar (100) not null,
    unit_price decimal (10,2) not null,
    quantity int not null,
    VAT float (6,4) not null,
    total decimal (12, 4) not null,
    date datetime not null,
    time TIME not null,
    payment_method varchar (15) not null,
    cogs decimal (10 , 2) not null,
    gross_margine_pct float (10,9),
    gross_income decimal (12,4) not null,
    rating float(2, 1)
    );



--  ----------------------------------------------------------------------------
-- ----------------Feature Engineering -----------------------------------------
-- time_of_day
select
	time,
    (case
		when `time` between "00:00:00" and	"12:00:00" then "Morning"
        when `time` between "12:01:00" and	"16:00:00" then "Afternoon"
        else "Evening"
    end ) as time_of_date
from sales;

alter table sales add column time_of_day varchar (20) ;

update sales 
set time_of_day = (
	case
			when `time` between "00:00:00" and	"12:00:00" then "Morning"
			when `time` between "12:01:00" and	"16:00:00" then "Afternoon"
			else "Evening"
    end
);

-- day_name
select
	date,
    dayname (DATE)
from sales;

alter table sales add column day_name varchar(10);

update sales
set day_name = dayname(date);

-- month_name

select 
	date,
    monthname(date)
from sales;

alter table sales add column month_name varchar (10);

update sales
set month_name = monthname(date);

-- ----------------------------------------------------------------------------
-- --------------------------- Generic Questions ------------------------------
-- ----------------------------------------------------------------------------
-- How many unique cities does the data have?
select
	distinct city
from sales;

select
	distinct branch
from sales;

-- In which city is each branch?

select
	distinct city,
    branch
from sales;

-- -----------------------------------------------------------------------------
-- --------------------------------------Product -------------------------------
-- -----------------------------------------------------------------------------

-- How many unique product lines does the data have?

select
	count(distinct product_line)
from sales;

-- What is the most common payment method?

select  
	payment_method,
	count(payment_method) as cnt 
from sales
group by payment_method
order by cnt desc;

-- What is the most selling product line?

select  
	product_line,
	count(product_line) as cnt 
from sales
group by product_line
order by cnt desc;

-- What is the total revenue by month?
select
	month_name as month,
    sum(total) as total_revenue 
from sales
group by month_name
order by total_revenue desc;

-- What month had the largest COGS?
select 
	month_name as month,
    sum(cogs) as cogs
from sales
group by month_name
order by cogs;

-- What product line had the largest revenue?
select
	product_line,
    sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

-- What is the city with the largest revenue?
select
	branch,
	city,
    sum(total) as total_revenue
from sales
group by city,branch
order by total_revenue desc;

-- What product line had the largest VAT?
select
	product_line,
    avg (VAT) as avg_tax
from sales
group by product_line
order by avg_tax desc;

-- Which branch sold more products than average product sold?
select
	branch,
    sum(quantity) as qty
from sales
group by branch
having sum(quantity) > (select avg (quantity) from sales);

-- What is the most common product line by gender?
select
	gender,
    product_line,
    count(gender) as total_cnt
from sales
group by gender,product_line
order by total_cnt desc;

-- What is the average rating of each product line?
select 
	round(avg(rating),2 )as avg_rating,
    product_line
from sales
group by product_line
order by avg_rating desc;


-- -----------------------------------------------------------------------------
-- -------------------------------------- Sales  -------------------------------
-- -----------------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday
select
	time_of_day,
    count(*) as total_sales 
from sales
where day_name = "monday"
group by time_of_day
order by total_sales desc;

-- Which of the customer types brings the most revenue?
select
	coustomer_type,
    sum(total) as total_rev
from sales
group by coustomer_type
order by total_rev desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select
	city,
    avg(vat) as vat
from sales
group by city
order by vat desc;

-- Which customer type pays the most in VAT?

select
	coustomer_type,
    avg(vat) as vat
from sales
group by coustomer_type
order by vat desc;


-- -----------------------------------------------------------------------------
-- -------------------------------------- Customer  -------------------------------
-- -----------------------------------------------------------------------------
    
-- How many unique customer types does the data have?
select
	distinct coustomer_type
from sales;

-- How many unique payment methods does the data have?

select 
	distinct payment_method 
from sales;

-- Which customer type buys the most?
select
	coustomer_type,
    count(*) as cstm_cnt
from sales
group by coustomer_type;

-- What is the gender of most of the customers?
select 
	gender,
    count(*) as gender_cnt
from sales
group by gender
order by gender_cnt;

-- What is the gender distribution per branch?
select 
	gender,
    count(*) as gender_cnt
from sales
where branch = "c"
group by gender
order by gender_cnt;


