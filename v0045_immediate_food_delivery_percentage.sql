-- Question: Immediate Food Delivery Percentage

-- English Video: 
-- Tamil Video: 

Create table Delivery 
(delivery_id int, 
 customer_id int, 
 order_date date, 
 customer_pref_delivery_date date);
Truncate table Delivery;

insert into Delivery 
(delivery_id, customer_id, order_date, customer_pref_delivery_date) values 
 ( 1, 1, '2019-08-01', '2019-08-02')
,( 2, 2, '2019-08-01', '2019-08-01')
,( 3, 1, '2019-08-01', '2019-08-01')
,( 4, 3, '2019-08-02', '2019-08-13')
,( 5, 3, '2019-08-02', '2019-08-02')
,( 6, 2, '2019-08-02', '2019-08-02')
,( 7, 4, '2019-08-03', '2019-08-03')
,( 8, 1, '2019-08-03', '2019-08-03')
,( 9, 5, '2019-08-04', '2019-08-18')
,(10, 2, '2019-08-04', '2019-08-18');

/*
-- Analysis
 ( 1, 1, '2024-05-14', '2019-08-02') -- scheduled
,( 2, 2, '2024-05-14', '2019-08-01')
,( 3, 1, '2024-05-14', '2019-08-01')

,( 4, 3, '2024-05-15', '2019-08-13') -- scheduled
,( 5, 3, '2024-05-15', '2019-08-02')
,( 6, 2, '2024-05-15', '2019-08-02')

,( 7, 4, '2024-05-16', '2019-08-03')
,( 8, 1, '2024-05-16', '2019-08-03')

,( 9, 5, '2024-05-17', '2019-08-18') -- scheduled
,(10, 2, '2024-05-17', '2019-08-18') -- scheduled

The expected output is 
+------------+----------------------+
| order_date | immediate_percentage |
+------------+----------------------+
| 2024-05-01 | 66.67                |
| 2024-05-02 | 66.67                |
| 2024-05-03 | 100.00               |
| 2024-05-04 | 0.00                 |
+------------+----------------------+
*/

-- Approach 1: Brute force method 
with all_delivery as (
select order_date, count(delivery_id) as all_del 
       from Delivery 
   group by 1)
,immediate_delivery as (
select order_date, count(delivery_id) as imm_del 
       from Delivery 
      where order_date = customer_pref_delivery_date
   group by 1)
select a.order_date,
       round(coalesce(i.imm_del,0) * 100 / a.all_del, 2) as immediate_percentage;
       from all_delivery a
  left join immediate_delivery i 
         on i.order_date = a.order_date;

-- Approach 2: Using Simple CASE statement 
select order_date, 
       round(count(case when order_date = customer_pref_delivery_date then delivery_id end) * 100 / count(delivery_id),2) as immediate_percentage 
       from Delivery 
   group by 1;
