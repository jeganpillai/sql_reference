-- Question: Find the Consecutive Transactions with Increasing Amount

-- English Video: https://www.youtube.com/watch?v=Iolj61j3vBs
-- Tamil Video: Pending 

Create table If Not Exists Transactions 
(transaction_id int, customer_id int, transaction_date date, amount int);
Truncate table Transactions;
insert into Transactions (transaction_id, customer_id, transaction_date, amount) values
 (1  , 101, '2023-05-01', 100 ) -- ***
,(2  , 101, '2023-05-02', 150 ) -- ***
,(3  , 101, '2023-05-03', 200 ) -- ***
,(4  , 102, '2023-05-01', 50  )
,(5  , 102, '2023-05-03', 100 )
,(6  , 102, '2023-05-04', 200 )
,(7  , 105, '2023-05-01', 100 ) -- ***
,(8  , 105, '2023-05-02', 150 ) -- ***
,(9  , 105, '2023-05-03', 200 ) -- ***
,(10 , 105, '2023-05-04', 300 ) -- ***

,(11 , 105, '2023-05-12', 250 ) -- ***
,(12 , 105, '2023-05-13', 260 ) -- ***
,(13 , 105, '2023-05-14', 270 ) -- ***

,(692, 18 , '2019-08-11', 8244)
,(214, 18 , '2019-08-12', 5205) -- ??? 
,(96 , 18 , '2019-08-13', 8503)
,(714, 18 , '2019-08-14', 460 ) -- ??? 
,(729, 18 , '2019-08-15', 7415);

*** Approach 1: Using Self Join and ROW_NUMBER() 
with all_transactions as (
SELECT t1.customer_id
      ,t1.transaction_date as start_transaction_date
      ,t2.transaction_date as end_transaction_date
      ,ROW_NUMBER() OVER(PARTITION BY t1.customer_id ORDER BY t1.customer_id, t1.transaction_date) as rnum 
      FROM Transactions t1 
INNER JOIN Transactions t2 
        ON t2.customer_id = t1.customer_id
       AND t2.amount > t1.amount 
       AND DATEDIFF(t2.transaction_date, t1.transaction_date) = 1 )
,valid_transactionas as (
SELECT customer_id 
      ,start_transaction_date 
      ,end_transaction_date 
      ,date_sub(start_transaction_date, interval rnum day) as date_group
      FROM all_transactions) 
select customer_id 
      ,min(start_transaction_date) as consecutive_start
      ,max(end_transaction_date) as consecutive_end
      from valid_transactionas
  group by 1 , date_group
    having count(*) >= 2 
  order by 1 ; 

*** Approach 2: Using LEAD() and ROW_NUMBER()
with all_transactions as (
SELECT t1.customer_id
      ,t1.transaction_date as dt -- start_transaction_date
      ,LEAD(t1.transaction_date, 1) OVER(PARTITION BY t1.customer_id ORDER BY t1.customer_id, t1.transaction_date) as end_dt -- transaction_date
      ,t1.amount 
      ,LEAD(t1.amount, 1) OVER(PARTITION BY t1.customer_id ORDER BY t1.customer_id, t1.transaction_date) as next_amount
      FROM Transactions t1 )
,valid_transactionas as (
select customer_id 
      ,dt
      ,end_dt 
      ,next_amount
      ,amount  
     ,ROW_NUMBER() OVER(PARTITION BY t1.customer_id ORDER BY t1.customer_id, t1.dt) as rnum 
     from all_transactions t1 
    where DATEDIFF(t1.end_dt, t1.dt) = 1
      and amount < next_amount ) 
select customer_id 
      ,min(dt) as consecutive_start
      ,max(end_dt) as consecutive_end
      from valid_transactionas
  group by 1 , date_sub(dt, interval rnum day)
    having count(*) >= 2 
  order by 1 ; 
