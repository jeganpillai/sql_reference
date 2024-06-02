-- Question : Find Records With Duplicate email, in other words, find emails which connects multiple users

-- English Video: https://www.youtube.com/watch?v=cB_YA9ZHeg8
-- Tamil Video: Pending 

CREATE TABLE IF NOT EXISTS Users (user_id INT, email VARCHAR(255));
TRUNCATE TABLE Users;
INSERT INTO Users (user_id, email) VALUES 
 (1001, 'grow@growwithdata.co')
,(2001, 'with@growwithdata.co')
,(3001, 'data@growwithdata.co')
,(1002, 'grow@growwithdata.co');

-- approach 1: bruteforce method using self join 
with duplicate_email as (
select a.email, a.user_id
from Users a 
inner join Users b 
on b.email = a.email 
and b.user_id <> a.user_id
and b.user_id < a.user_id)
select u.user_id, u.email 
from Users u 
inner join (select distinct email as email from duplicate_email) a
on a.email = u.email ;
-- where u.email in (select distinct email from duplicate_email where cnt > 1);

-- approach 2: aggregate function with having clause as filter 
with duplicate_email as (
select a.email 
from Users a 
group by 1 having count(*) > 1)
select a.user_id, a.email 
from Users a 
-- where a.email in (select email from duplicate_email);
inner join duplicate_email b 
on b.email = a.email ;

-- approach 3: windows function using count(*) 
with duplicate_email as (
select u.user_id, u.email 
,count(*) over(partition by u.email order by u.user_id ) as cnt 
from Users u )
select u.user_id, u.email 
from Users u 
where u.email in (select distinct email from duplicate_email where cnt > 1);
