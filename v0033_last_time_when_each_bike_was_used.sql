-- Question: Find the last time when each bike was used

-- English Video: https://www.youtube.com/watch?v=3Rm8Rm0-9v4
-- Tamil Video: Pending 

-- *** Approach 1: Simple Aggregation *** 
select bike_number, max(end_time) as end_time 
       from Bikes 
group by 1 
order by 2 desc, 1; 

-- *** Approach 2: Using Window Functions ***
with all_data as (
select bike_number
      ,end_time
      ,row_number() over(partition by bike_number order by bike_number, end_time desc) as rnum 
      from Bikes )
select bike_number, end_time 
       from all_data 
      where rnum = 1 
   order by 2 desc ;
