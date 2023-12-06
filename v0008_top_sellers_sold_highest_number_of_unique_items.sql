-- Question: We have a set of tables and we are asked to find the top sellers who sold Highest Number of Unique Items, with the different brand than their favorite brand. If there are more than one seller, then we have to bring in all those top sellers
Create table If Not Exists Users (seller_id int, join_date date, favorite_brand varchar(10));
Truncate table Users;
insert into Users values 
(1,'2024-12-01','Lenovo')
,(2,'2024-12-09','Samsung')
,(3,'2024-12-19','LG')
,(4,'2014-12-21','HP');

Create table If Not Exists Orders (order_id int, order_date date, item_id int, seller_id int);
Truncate table Orders; 
insert into Orders values
(1,'2024-12-01',4,2)
,(2,'2024-12-02',2,3)
,(2,'2024-12-05',4,3)
,(3,'2024-12-03',3,3)
,(4,'2024-12-04',1,2)
,(5,'2024-12-04',1,4)
,(6,'2024-12-05',2,4)
,(7,'2024-12-05',3,1)
,(8,'2024-12-06',2,1);

Create table If Not Exists Items (item_id int, item_brand varchar(10));
Truncate table Items;
insert into Items values 
(1,'Samsung')
,(2,'Lenovo')
,(3,'LG')
,(4,'HP'); 

-- General SQL 
with all_sales as (
select o.seller_id, count(distinct o.item_id) as total_items 
from Orders o 
inner join Items i 
on i.item_id = o.item_id 
inner join Users u 
on u.seller_id = o.seller_id 
and i.item_brand <> u.favorite_brand 
group by 1)
select a.seller_id, a.total_items 
from all_sales a 
-- where total_items = (select max(total_items) from all_sales)
inner join (select max(total_items) as total_items from all_sales) m 
on m.total_items = a.total_items 
;

-- use WIndows function 
with all_sales as (
select o.seller_id, count(distinct o.item_id) as total_items 
from Orders o 
inner join Items i 
on i.item_id = o.item_id 
inner join Users u 
on u.seller_id = o.seller_id 
and i.item_brand <> u.favorite_brand 
group by 1)
select seller_id, total_items from (
select o.seller_id 
,o.total_items 
,dense_rank() over(order by total_items desc) as rnk 
from all_sales o) o where o.rnk = 1
