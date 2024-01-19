-- Question: Find the Popularity Percentage of Users in Social Media 
-- Video: https://www.youtube.com/watch?v=YUAn13_F6BY

Create table Friends (user1 int, user2 int);
Truncate table Friends;
insert into Friends (user1, user2) values 
 (2, 1)
,(1, 3)
,(4, 1)
,(2, 5)
,(1, 5)
,(1, 6)
,(2, 6)
,(7, 2)
,(8, 3)
,(2, 9)
,(3, 9);

**Approach 1: General CTE Table**
with all_users as (
select user1, count(distinct friends) as friends 
       from (select user1 as user1 
                   ,user2 as friends 
                   from Friends 
            union all 
            select user2 as user1
                  ,user1 as freinds 
                  from Friends )a 
  group by 1)
select user1 
      ,round(friends/(select count(*) from all_users) * 100,2) as percentage_popularity
      from all_users  
order by 1 ;

**Approach 2: Using Windows Function**
with all_users as (
select user1
      ,count(distinct friends) as friends 
      ,count(*) over() as total_users
      from (select user1 as user1 , user2 as friends 
                   from Friends 
            union all 
            select user2 as user1, user1 as freinds 
                   from Friends )a 
 group by 1)
select user1 
      ,round(friends/total_users * 100,2) as percentage_popularity
      from all_users  
  order by 1 ;

**Approach 3: Simple Calculation**
with all_friends as (
select user1 as user1 , user2 as friends from Friends 
union all 
select user2 as user1, user1 as freinds from Friends )
select user1
      ,round(count(distinct friends)/(select count(distinct user1) from all_friends) * 100,2) as percentage_popularity 
      from all_friends 
  group by 1 order by 1;
