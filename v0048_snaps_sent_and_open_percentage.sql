-- Question: Snaps Sent and Open Percentage

-- English Video: https://www.youtube.com/watch?v=dQ_xqBm_-HI
-- Tamil Video: https://www.youtube.com/watch?v=mXg2d4JJGpo

Create table Activities(
  activity_id int, 
  user_id int, 
  activity_type ENUM('send', 'open'), 
  time_spent decimal(5,2));
Truncate table Activities;
insert into Activities (activity_id, user_id, activity_type, time_spent) values 
 (7274, 123, 'open', 4.50)
,(2425, 123, 'send', 3.50)
,(1413, 456, 'send', 5.67)
,(2536, 456, 'open', 3.00)
,(8564, 456, 'send', 8.24)
,(5235, 789, 'send', 6.24)
,(4251, 123, 'open', 1.25)
,(1435, 789, 'open', 5.25);

Create table Age( user_id int, age_bucket ENUM('21-25','26-30','31-35'));
Truncate table Age;
insert into Age (user_id, age_bucket) values 
 (123, '31-35')
,(789, '21-25')
,(456, '26-30');

-- Approach 1: Brute Force Method
WITH ActivityAge AS (
    SELECT a.activity_id, a.user_id, a.activity_type, a.time_spent, ag.age_bucket
    FROM Activities a
    INNER JOIN Age ag ON a.user_id = ag.user_id
),
TotalTimeSpent AS (
    SELECT age_bucket,
           SUM(CASE WHEN activity_type = 'send' THEN time_spent ELSE 0 END) AS send_time,
           SUM(CASE WHEN activity_type = 'open' THEN time_spent ELSE 0 END) AS open_time,
           SUM(time_spent) AS total_time
    FROM ActivityAge
    GROUP BY age_bucket
)
SELECT age_bucket,
       ROUND(send_time / total_time * 100, 2) AS send_perc,
       ROUND(open_time / total_time * 100, 2) AS open_perc
FROM TotalTimeSpent
ORDER BY age_bucket;

-- Approach 2: Simple SQL integrating all three steps 
SELECT ag.age_bucket,
       round(sum(case when a.activity_type = 'send' then a.time_spent else 0 end) * 100.0 / sum(a.time_spent),2) as send_pct,
       round(sum(case when a.activity_type = 'open' then a.time_spent else 0 end) * 100.0 / sum(a.time_spent), 2) as open_pct
FROM Activities a
INNER JOIN Age ag ON a.user_id = ag.user_id
GROUP BY 1;
