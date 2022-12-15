use onlinesales_analysis


select * from Online_store

---Revenue by customer
select Customer_Name,
		sum(sales)Revenue
from dbo.Online_store
group by Customer_Name
order by 2 desc

---Sales by product category 
select Product_category,
		sum(sales) Revenue
from dbo.Online_store
group by Product_Category
order by 2 desc

---Sales per State

select customer_name,
		state_or_province
from dbo.Online_store
where State_or_Province = 'Wisconsin'
group by State_or_Province,Customer_Name
order by 2 desc



---Sales by product sun category
select product_sub_category,
		sum(sales) Revenue
from dbo.Online_store
group by Product_Sub_Category
order by 2 desc


select Order_Priority,
		sum(sales) revenue
from dbo.Online_store
group by Order_Priority


select ship_mode,
		sum(sales) revenue
from dbo.online_store
group by Ship_Mode
order by 2 desc

		
      

---Sales by product container
Select Product_Container,
	sum(sales) Revenue
from dbo.Online_store
group by Product_Container
order by 2 desc

select unit_price-discount Discountprice
from dbo.Online_store

--- Customers Who buy frequently
select customer_name, count(quantity_ordered_new) Quantity
from dbo.Online_store
group by Customer_Name
order by 2 desc



select max(order_date) lastorderdate
from dbo.Online_store

select max(unit_price) from dbo.Online_store

drop  table if  exists rfm_1

;with onlinesale as
(
select customer_name,
		sum(sales) Montaryvalue,
		count(quantity_ordered_new) frequency,
		max(order_date) lastorder,
		(select max(order_date) from dbo.Online_store)max_order,
		datediff(day,max(order_date),(select max(order_date) from dbo.Online_store))recency
from dbo.Online_store
group by Customer_Name
),
rfm_analysis1 as 
(

select *,
	ntile(4) over(order by recency desc) rfm_recency,
	ntile(4) over(order by frequency) rfm_frequency,
	ntile(4) over (order by montaryvalue) rfm_montary
from onlinesale
)
select *, cast(rfm_recency as varchar) + cast(rfm_frequency as varchar )+ cast(rfm_montary as varchar ) rfmstring
into rfm_1
from  rfm_analysis1
select * from dbo.rfm_1

select customer_name,rfm_recency,rfm_frequency,rfm_montary,
	case
		 when rfmstring in(111,121,122,113,114,211,212,141) then 'lost_customer'
		 when rfmstring in (222,221,233,234,244,243,241) then 'at the adge of losing them'
		 when rfmstring in (311,321,412,411,322,422,431,421) then 'new customer'
		 when rfmstring in (333,314,323,314,344) then 'potential customer'
		 when rfmstring in (444,434,441,433,432) then 'loyal customer'
	 end rfm_segment 
from dbo.rfm_1

select sum(profit) profit_1
from dbo.Online_store









