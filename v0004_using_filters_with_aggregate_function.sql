-- Question: Number of customers who placed 2+ orders in 2022 and customers who placed 3+ orders in 2023
-- Get the clarification
-- clear version of question: Number of customers who placed 2+ orders in 2022 and also placed 3+ orders in 2023

-- English Video: https://www.youtube.com/watch?v=owM6VB3qkgc
-- Tamil Video: Pending 

create table orders 
(order_id int 
,customer_id int 
,order_date date 
,revenue decimal(18,0)
,qty int 
,category varchar(25) );

insert into orders values 
(1,10,'2022-02-03',25,1,'Toys')
,(2,10,'2022-05-02',300,5,'Home')
,(3,10,'2023-06-01',100,10,'Furniture')
,(4,10,'2023-11-01',50,1,'Home')
,(5,10,'2023-05-01',200,1,'Furniture')
,(6,20,'2022-11-12',1600,5,'Toys')
,(6,20,'2023-01-02',1000,2,'Home')
,(7,20,'2023-07-05',4000,6,'Toys')
,(8,20,'2024-01-05',50,4,'Furniture')
,(9,20,'2024-04-15',30,1,'Home')
,(10,20,'2024-05-12',20,2,'Toys')
;

-- brute force method 
with all_data as (
select customer_id, year(order_date) yr, count(*) as cnt from orders
where year(order_date) between 2022 and 2023
group by 1,2)
select count(*) as total_customers from (
select customer_id
from all_data 
where case when yr = 2022 and cnt >= 2 then 1 
           when yr = 2023 and cnt >= 3 then 1 end = 1
 group by 1 having count(*) > 1
) a ;

-- better version 
with all_customers as (
select customer_id 
from orders 
group by 1 
having count(distinct case when year(order_date) = 2022 then order_id end) >= 2 
 and count(distinct case when year(order_date) = 2023 then order_id end) >= 3)
 select count(*) as total_customers from all_customers ;
