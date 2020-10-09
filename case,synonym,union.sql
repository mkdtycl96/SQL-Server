-- subquery , union ,synonym ,case 
-- select all customers in ny who made at least one order
select [first_name],[last_name],o.order_date
from sales.customers c
inner join sales.orders o
on o.customer_id = c.customer_id
where c.customer_id in
(select  [customer_id]
from [sales].[customers]
where city = 'New York')

select [first_name],[last_name],o.order_date,count(o.order_date) as number_of_orders
from sales.customers c
inner join sales.orders o
on o.customer_id = c.customer_id
where c.customer_id in
(select  [customer_id]
from [sales].[customers]
where city = 'New York')
group by c.first_name,c.last_name


SELECT c.first_name, c.last_name, COUNT(c.customer_id) AS 'Number of Orders'
FROM sales.customers as c
JOIN sales.orders as o
ON c.customer_id = o.customer_id
WHERE c.customer_id IN (
    SELECT customer_id                           -- subquery part.
    FROM sales.customers
    WHERE city = 'New York')
GROUP BY c.first_name, c.last_name
ORDER BY 3 DESC

select [first_name], [last_name],count(c.[customer_id]) numberOforders
from [sales].[customers] c
join [sales].[orders] o
on c.customer_id = o.customer_id
where c.customer_id in
(select [customer_id]
from [sales].[customers]
where city = 'New York')
group by [first_name], [last_name]
order by 3 desc

-- select all products where list price greater than average list price of strider an trek
 select [product_name], [list_price] 
 from production.products
 where list_price >
 (select avg(list_price) from production.products

 where brand_id in
 (select [brand_id]
 from[production].[brands]
 where brand_name in ('Strider','Trek')))

 -- get the difference between the product
 -- price and the average product price

select product_name,
       list_price - ( select avg(list_price)
 from production.products) [avg_diff]
from production.products

-----------------------
-----------------------
select first_name,last_name,email,city
from sales.customers
where exists(
select c.[customer_id],[first_name],[last_name],email,city ,s.order_date
from sales.customers c
inner join  sales.orders s
on s.customer_id = c.customer_id
where year(order_date) = 2017)
-- en fazla ortalam siparis yapan personel listesi
select t.fullname,max(t.order_count) max_order_by_person
from
(select 
first_name +' '+ last_name fullname,count(order_id) order_count
from sales.orders o
inner join
sales.staffs s
on s.staff_id=o.staff_id
group by first_name + ' ' + last_name) t
group by t.fullname
order by 2 desc
----------------------------- end of subquery
-- union

select [first_name],[last_name]
from sales.staffs
union -- distinct olarak birleþtirdi
select first_name,last_name
from sales.customers

select [first_name] +' '+[last_name],'staff' [type]
from sales.staffs 
union all 
select first_name+' '+last_name ,'customer' [type]
from sales.customers
order by 1

--synonym
create synonym  orders for sales.orders 
select * from orders

--create database
create database food
on
(
Name=FoodData1,
FileName='D:\DATABASES\DATA\FoodData1.mdf',
size=10MB, --KB, MB,GB,TB
maxsize=unlimited,
filegrowth= 1GB
)
log on
(
Name=FoodLog,
FileName='D:\DATABASES\DATA\FoodLog1.ldf',
size=10MB, --KB, MB, GB,TB
maxsize=unlimited,
filegrowth= 1024MB
)
create table snack
(snack_name varchar(50),
amount int,
calories int
)

use food 
select * from dbo.snack
insert [snack]
select 'Cholote Raisins',10,100
insert [snack]
select 'Honeycomb',10,15

create database food2 

use food2
create synonym snack for food.dbo.snack

select *from [dbo].[snack]
use Bike
----------------------------
--CASE
select distinct order_status from sales.orders

select
case order_status
when 1 then 'pending'
when 2 then  'processing' 
when 3 then  'rejected'
else 'completed'
end order_status
,count(order_id) order_count
from sales.orders
where year(order_date) = 2018
group by order_status