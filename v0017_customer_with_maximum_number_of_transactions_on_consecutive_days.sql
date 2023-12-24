-- Question: Get the customer with maximum number of transactions on consecutive days
-- Video: https://www.youtube.com/watch?v=z9tsTUPvzYQ

Create table Transactions (transaction_id int, customer_id int, transaction_date date, amount int);
Truncate table Transactions;
insert into Transactions (transaction_id, customer_id, transaction_date, amount) values 
 (1, 101, '2023-05-01', 100)
,(2, 101, '2023-05-02', 150)
,(3, 101, '2023-05-03', 200)
,(4, 102, '2023-05-01', 50)
,(5, 102, '2023-05-03', 100)
,(6, 102, '2023-05-04', 200)
,(7, 105, '2023-05-01', 100)
,(8, 105, '2023-05-02', 150)
,(9, 105, '2023-05-03', 200);

-- Self Join
with all_data as (
SELECT t1.customer_id
      ,t1.transaction_date
      ,count(t1.transaction_date) AS txn_seq 
      FROM Transactions t1
INNER JOIN Transactions t2 
        ON t1.customer_id = t2.customer_id 
        AND t1.transaction_date >= t2.transaction_date
   GROUP BY t1.customer_id, t1.transaction_date)
,transaction_seq as (
select t.customer_id 
      ,date_add(t.transaction_date, interval -txn_seq day) as diff 
      ,count(*) as cnt 
      from all_data t
      group by 1,2 )
select distinct customer_id 
from transaction_seq 
where cnt = (select max(cnt) from transaction_seq)
order by 1;

-- Windows function 
with all_data as (
SELECT t1.customer_id
      ,t1.transaction_date
      ,row_number() over(partition by t1.customer_id order by t1.customer_id, t1.transaction_date) AS txn_seq 
      FROM Transactions t1)
,transaction_seq as (
select t.customer_id 
      ,date_add(t.transaction_date, interval -txn_seq day) as diff 
      ,count(*) as cnt 
      from all_data t
      group by 1,2 )
select distinct customer_id 
from transaction_seq 
where cnt = (select max(cnt) from transaction_seq)
order by 1;
