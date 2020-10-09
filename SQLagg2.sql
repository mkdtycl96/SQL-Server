use Bike
-- COUNT
select COUNT(*)
from production.products where list_price > 500;

create table tab(
val int

);

insert into tab(val)
values(1),(2),(3),(null),(4),(5)

select * from tab

select count(*) from tab

select COUNT(distinct val) from tab

select count(val) from tab --6

select * 
from
production.products p
inner join production.categories c
on p.category_id = c.category_id
order by p.category_id


select category_name,AVG(list_price)
from
production.products p
inner join production.categories c
on p.category_id = c.category_id
group by category_name

select category_name,count(*)
from
production.products p
inner join production.categories c
on p.category_id = c.category_id
group by category_name

select category_name,count(*) product_count
from
production.products p
inner join production.categories c
on p.category_id = c.category_id
group by category_name
having count(*) > 30 
order by product_count

select brand_name, count(*)
from production.products p
inner join production.brands b
on p.brand_id = b.brand_id
where brand_name = 'Electra'
group by brand_name
having count(*) > 20
order by COUNT(*)

-- MAX
SELECT max(list_price) max_price
FROM production.products

SELECT *
FROM production.products
where list_price = 11999.99


SELECT *
FROM production.products
where list_price=(SELECT max(list_price) max_price
FROM production.products)

select brand_name , max(list_price)
from production.products p
inner join production.brands b
on b.brand_id = p.brand_id
group by brand_name
having max(list_price) > 1000


select min(list_price) from production.products

select * from production.products p
where p.list_price = (select min(list_price) from production.products)

select category_name , min(list_price)
from production.products p
inner join production.categories c
on p.category_id = c.category_id
group by category_name

-- SUM
select * from production.products

select sum(quantity) from production.stocks
select sum(quantity) from sales.inventory

select store_id,product_id,sum(quantity) -- satýlan ürün miktarý
from production.stocks
group by product_id,store_id

select store_id , sum(quantity)
from production.stocks
group by store_id

select quantity
from production.stocks

select store_name , sum(quantity)
from production.stocks s
inner join sales.stores a
on a.store_id = s.store_id
group by store_name

select order_id, sum(quantity*list_price*(1-discount))
from sales.order_items
group by order_id

select * from sales.order_items


-- AVG
SELECT AVG(list_price)
from production.products

select avg(list_price)
from production.products p
inner join production.categories c
on p.category_id=c.category_id
group by category_name

--decimal(20,2) noktadan önce 20 noktadan sonra 2 decimal
select cast(round(avg(list_price),2)as dec(10,2)) 
from production.products

select STDEV(list_price) from production.products