-- Question: finding the overlapping events booked in a music hall
-- Video: https://www.youtube.com/watch?v=7dEqAyV6Yg0

Create table If Not Exists HallEvents 
(hall_id int, start_day date, end_day date);
Truncate table HallEvents;
insert into HallEvents (hall_id, start_day, end_day) values 
 (1, '2023-01-13', '2023-01-14')
,(1, '2023-01-14', '2023-01-17')
,(1, '2023-01-18', '2023-01-25')
,(2, '2022-12-09', '2022-12-23')
,(2, '2022-12-13', '2022-12-17')
,(3, '2022-12-01', '2023-01-30');


-- SQL 
with flag_overlaps as (
select hall_id
      ,start_day
      ,end_day
      ,case when start_day > 
      max(end_day) over(partition by hall_id order by start_day, end_day rows between unbounded preceding and 1 preceding)
      or
      max(end_day) over(partition by hall_id order by start_day, end_day rows between unbounded preceding and 1 preceding) is null then 1 else 0 end as ind
      from HallEvents)
,grouping_overlaps as (
select hall_id 
      ,start_day 
      ,end_day 
      ,sum(ind) over(partition by hall_id order by start_day, end_day) as sum_ind 
      from flag_overlaps)
select hall_id
      ,min(start_day) as start_day
      ,max(end_day) as end_day
      from grouping_overlaps
  group by hall_id, sum_ind
  order by hall_id, start_day; 
