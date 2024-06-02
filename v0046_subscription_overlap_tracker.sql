-- Question: Subscription Overlap Finder

-- English Video: https://www.youtube.com/watch?v=MVUa_3rJUDU
-- Tamil Video: https://www.youtube.com/watch?v=YJCyTPYtbWc

create table subscriptions(
  user_id int,
  sub_start_date date,
  sub_end_date date);

insert into subscriptions (user_id, sub_start_date, sub_end_date) values 
 (1,'2024-04-01','2024-04-30')
,(2,'2024-04-15','2024-04-17')
,(3,'2024-04-29','2024-05-04')
,(4,'2024-05-05','2024-05-10')
,(5,'2024-03-31',NULL)
,(6,'2024-04-30',NULL);

/*
for the given data
 (1,'2024-04-01','2024-04-31') -- yes => 2, 3, 
,(2,'2024-04-15','2024-04-17') -- yes => 1, 3
,(3,'2024-04-29','2024-05-04') -- yes => 4
,(4,'2024-05-05','2024-05-10') -- no
,(5,'2024-03-31',NULL)
,(6,'2024-04-40',NULL);

So, the expected output is 

+---------+---------+
| user_id | overlap |
+---------+---------+
| 1	      | 1       |
| 2	      | 1       |
| 3	      | 1       |
| 4	      | 0       |
+---------+---------+
*/

-- Approach 1: Using Date Range as Filter
select s.user_id, 
       max(case when ss.user_id is null then 0 else 1 end) as overlap
      from subscriptions s 
 left join subscriptions ss 
        on s.user_id <> ss.user_id
       and (   s.sub_start_date between ss.sub_start_date and ss.sub_end_date
            or s.sub_end_date between ss.sub_start_date and ss.sub_end_date)
       and ss.sub_end_date is not null  
     where s.sub_end_date is not null 
  group by 1;

-- Approach 2: Simplified Date Filter
select s.user_id, 
       max(case when ss.user_id is null then 0 else 1 end) as overlap
       from subscriptions s 
  left join subscriptions ss 
         on s.user_id <> ss.user_id
        and s.sub_start_date <= ss.sub_end_date
        and s.sub_end_date >= ss.sub_start_date
        and ss.sub_end_date is not null  
      where s.sub_end_date is not null 
   group by 1;

-- Approach 3: Correlated Subquery
select s.user_id, 
       case when exists (select 1 from subscriptions ss 
                          where s.user_id <> ss.user_id
                            and s.sub_start_date <= ss.sub_end_date
                            and s.sub_end_date >= ss.sub_start_date
                            and ss.sub_end_date is not null  ) then 1 else 0 end as overlap
from subscriptions s 
  where s.sub_end_date is not null ;
