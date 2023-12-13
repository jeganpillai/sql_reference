-- Question: Given the Users steps for multiple days, find the rolling three day average of steps for each user. If there is any missing rows, then skip that date.

Create table Steps(user_id int, steps_date date, steps_count int);
Truncate table Steps;
insert into Steps (user_id, steps_date, steps_count) values 
 (1, '2021-09-02', 687)
,(1, '2021-09-04', 395)
,(1, '2021-09-05', 499)
,(1, '2021-09-06', 712)
,(1, '2021-09-07', 576)
,(2, '2021-09-06', 153)
,(2, '2021-09-07', 171)
,(2, '2021-09-08', 530)
,(3, '2021-09-04', 945)
,(3, '2021-09-07', 120)
,(3, '2021-09-08', 557)
,(3, '2021-09-09', 840)
,(3, '2021-09-10', 627)
,(5, '2021-09-05', 382)
,(6, '2021-09-01', 480)
,(6, '2021-09-02', 191)
,(6, '2021-09-05', 303);

-- Approach 1: Aggregate function 
select a.user_id, a.steps_date
      ,round(sum(b.steps_count)/count(*),2) as rolling_average 
      from Steps a 
 left join Steps b 
        on b.user_id = a.user_id 
       and datediff(a.steps_date, b.steps_date) between 0 and 2 
  group by 1,2 having count(*) = 3 order by 1,2;

-- Approach 2: Windows function 
with three_rows_check as (
select user_id, steps_date
      ,lag(steps_date, 2) over (partition by user_id order by steps_date) as prev_two_rows
      ,round(avg(steps_count) over (partition by user_id order by steps_date rows between 2 preceding and current row), 2) as rolling_average
      from Steps)
select user_id, steps_date, rolling_average 
      from three_rows_check
     where datediff(steps_date, prev_two_rows) = 2
  order by 1,2;

