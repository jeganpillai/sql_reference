-- Question: Find third transaction of every users where the spending on the preceding two transactions is lower than the spending on the third transaction.
-- Video: https://www.youtube.com/watch?v=JWUda4bSzds

Create Table Transactions (user_id int, spend decimal(5,2), transaction_date datetime);
Truncate table Transactions;
insert into Transactions (user_id, spend, transaction_date) values 
 (1,   7.44, '2023-11-02 12:15:23')
,(1,  49.78, '2023-11-12 00:13:46')
,(1,  65.56, '2023-11-18 13:49:42') -- *
,(1,  96.0 , '2023-11-30 02:47:26')
,(2, 100.44, '2023-11-20 07:39:34')
,(2,  40.89, '2023-11-21 04:39:15')
,(3,  37.33, '2023-11-03 06:22:02')
,(3,  13.89, '2023-11-11 16:00:14')
,(3,   7.0 , '2023-11-29 22:32:36')
,(5,  23.11, '2023-11-06 08:16:27')
,(5,  59.89, '2023-11-11 18:24:33')
,(5,  71.78, '2023-11-16 21:17:43') -- *
,(5,  87.78, '2023-11-19 22:19:54')
,(5,   3.44, '2023-11-21 23:09:45')
,(5,  78.44, '2023-11-24 22:17:55')
,(8,  21.56, '2023-11-04 20:14:36')
,(8,   2.11, '2023-11-10 09:26:55')
,(8,  85   , '2023-11-12 20:39:30') -- *
,(8,  86.78, '2023-11-16 00:37:30')
,(8,  16.33, '2023-11-23 16:49:24');

-- Approach 1: Utilizing the RANK() Function
with order_details as (
select user_id, spend, transaction_date
      ,row_number() over(partition by user_id order by user_id, transaction_date) as order_rnk
from Transactions)
select set3.user_id
      ,set3.spend as third_transaction_spend
      ,set3.transaction_date as third_transaction_date
      from order_details set3 
inner join  order_details set2 
        on set2.user_id = set3.user_id 
       and set2.order_rnk = 2 
       and set3.order_rnk = 3
       and set3.spend > set2.spend
inner join order_details set1 
        on set1.user_id = set3.user_id 
       and set1.order_rnk = 1 
       and set3.spend > set1.spend
order by 1 ;

-- Approach 2: Combining RANK() and LAG() Functions
with order_details as (
select user_id, spend, transaction_date
      ,row_number() over(partition by user_id order by user_id, transaction_date) as order_rnk
      ,LAG(spend, 1) OVER (PARTITION BY user_id ORDER BY transaction_date) AS spend_2
      ,LAG(spend, 2) OVER (PARTITION BY user_id ORDER BY transaction_date) AS spend_1
from Transactions)
select user_id
      ,spend as third_transaction_spend
      ,transaction_date as third_transaction_date
      from order_details 
     where order_rnk = 3 
       and spend > spend_1 and spend > spend_2 
  order by 1; 
