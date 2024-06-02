-- Question: Immediate Food Delivery Percentage

-- English Video: https://www.youtube.com/watch?v=Q17bFGNDW6Y
-- Tamil Video: https://www.youtube.com/watch?v=Z-x4vxZL_Qs

Create table Delivery 
(delivery_id int, 
 customer_id int, 
 order_date date, 
 customer_pref_delivery_date date);
Truncate table Delivery;

insert into Delivery 
(delivery_id, customer_id, order_date, customer_pref_delivery_date) values 
 ( 1, 1, '2024-05-14', '2024-05-15')
,( 2, 2, '2024-05-14', '2024-05-14')
,( 3, 1, '2024-05-14', '2024-05-14')
,( 4, 3, '2024-05-15', '2024-05-20')
,( 5, 3, '2024-05-15', '2024-05-15')
,( 6, 2, '2024-05-15', '2024-05-15')
,( 7, 4, '2024-05-16', '2024-05-16')
,( 8, 1, '2024-05-16', '2024-05-16')
,( 9, 5, '2024-05-17', '2024-05-19')
,(10, 2, '2024-05-17', '2024-05-21');

/*
-- Analysis
 ( 1, 1, '2024-05-14', '2024-05-15') -- scheduled
,( 2, 2, '2024-05-14', '2024-05-14')
,( 3, 1, '2024-05-14', '2024-05-14')

,( 4, 3, '2024-05-15', '2024-05-20') -- scheduled
,( 5, 3, '2024-05-15', '2024-05-15')
,( 6, 2, '2024-05-15', '2024-05-15')

,( 7, 4, '2024-05-16', '2024-05-16')
,( 8, 1, '2024-05-16', '2024-05-16')

,( 9, 5, '2024-05-17', '2024-05-19') -- scheduled
,(10, 2, '2024-05-17', '2024-05-21') -- scheduled

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

-- Approach 2: Using Simple CASE and COUNT function 
select order_date, 
       round(count(case when order_date = customer_pref_delivery_date then delivery_id end) * 100 / count(delivery_id),2) as immediate_percentage 
       from Delivery 
   group by 1;

-- Approach 3: Using Simple CASE and SUM function
select order_date, 
       round(sum(case when order_date = customer_pref_delivery_date then 1 else 0 end) * 100 / count(delivery_id),2) as immediate_percentage 
       from Delivery 
   group by 1;
