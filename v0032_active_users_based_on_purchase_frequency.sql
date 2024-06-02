-- Question: Find Active Users based on Purchase frequency

-- English Video: https://www.youtube.com/watch?v=bj4htPZY500
-- Tamil Video: Pending 

Create table If Not Exists Users 
(user_id int, item varchar(100),created_at date,amount int);
Truncate table Users;
insert into Users (user_id, item, created_at, amount) values 
 (5, 'Smart Crock Pot', '2021-09-18', 698882)
,(6, 'Smart Lock', '2021-09-14', 11487)
,(6, 'Smart Thermostat', '2021-09-10', 674762)
,(8, 'Smart Light Strip', '2021-09-29', 630773)
,(4, 'Smart Cat Feeder', '2021-09-02', 693545)
,(4, 'Smart Bed', '2021-09-13', 170249);

-- *** Approach 1: Using Correlated Subquery *** 
insert into Users (user_id, item, created_at, amount) values 
 (9,'Smart Cat Feeder','2021-09-02',693545)
,(9,'Smart Cat Feeder','2021-09-02',693546);

select distinct user_id 
       from Users u1
      where exists (select 1 
                           from Users u2 
                          where u2.user_id = u1.user_id 
                            and u1.created_at < u2.created_at 
                            and datediff(u2.created_at, u1.created_at) <= 7)
union 
select distinct user_id 
       from Users 
   group by user_id, created_at
     having count(*) > 1;

-- *** Approach 2: Using Windows Function *** 
with next_purchase_link as (
select user_id
      ,created_at 
      ,LEAD(created_at, 1) over(partition by user_id order by user_id, created_at) as next_purchase_at 
      from Users )
select distinct user_id 
       from next_purchase_link
      where datediff(next_purchase_at, created_at) <= 7
   order by 1; 
