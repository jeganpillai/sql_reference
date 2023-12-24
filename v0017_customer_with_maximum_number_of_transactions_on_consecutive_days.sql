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


/* 
-- additional sample data
insert into Transactions (transaction_id, customer_id, transaction_date, amount) values 
 (30 ,13,'2019-08-02',3135)
,(505,3 ,'2019-08-10',4217)
,(687,32,'2019-07-13',9375)
,(151,37,'2019-08-14',3254)
,(80 ,36,'2019-08-23',8724)
,(609,46,'2019-07-18',5190)
,(630,9 ,'2019-07-18',7493)
,(595,44,'2019-07-13',684 )
,(485,49,'2019-07-19',882 )
,(138,41,'2019-07-22',8479)
,(394,40,'2019-08-29',7310)
,(890,2 ,'2019-08-25',946 )
,(224,50,'2019-07-23',7541)
,(848,47,'2019-07-19',5713)
,(427,12,'2019-07-22',2058)
,(242,44,'2019-08-21',8310)
,(335,44,'2019-07-29',786 )
,(859,13,'2019-07-19',6123)
,(455,43,'2019-07-13',8503)
,(594,18,'2019-07-25',6695)
,(188,23,'2019-07-16',2669)
,(653,26,'2019-07-19',2590)
,(5  ,20,'2019-08-20',3877)
,(683,36,'2019-08-15',1471)
,(148,1 ,'2019-07-02',2461)
,(306,38,'2019-07-13',287 )
,(797,33,'2019-07-17',9916)
,(863,6 ,'2019-08-30',2074)
,(309,40,'2019-08-19',5514)
,(798,28,'2019-08-04',3548)
,(743,30,'2019-07-26',897 )
,(178,13,'2019-08-08',2328)
,(454,43,'2019-08-31',7672)
,(441,24,'2019-07-18',3060)
,(725,31,'2019-08-06',1806)
,(187,33,'2019-07-24',1474)
,(133,42,'2019-08-09',7509)
,(106,35,'2019-08-20',7590)
,(375,39,'2019-08-30',5554)
,(194,34,'2019-08-06',1122)
,(113,41,'2019-08-16',4875)
,(924,36,'2019-07-02',1170)
,(277,4 ,'2019-08-22',3951)
,(32 ,46,'2019-07-26',179 )
,(545,9 ,'2019-07-31',7943)
,(501,18,'2019-07-17',6303)
,(369,28,'2019-07-28',6187)
,(292,12,'2019-08-20',2405)
,(508,11,'2019-08-19',4755)
,(348,17,'2019-07-04',4526)
,(422,13,'2019-08-10',5571)
,(122,8 ,'2019-08-18',6768)
,(621,23,'2019-07-03',4520)
,(208,8 ,'2019-07-06',8309)
,(815,29,'2019-07-23',9839);
*/ 
