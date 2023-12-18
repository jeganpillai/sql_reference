-- Question: calculate the distance travelled by each user. If there is a user who hasn't completed any ride, then their distance should be considered as Zero.
-- Video: 

-- SQL 
select u.user_id, u.first_name, u.last_name
      ,sum(distance) as "traveled distance"
      , sum(case when distance is null then 0 else distance end) as distance_1
      , sum(coalesce(distance,0)) as distance_2
      , coalesce(sum(distance),0) as distance_3
      , ifnull(sum(distance),0) as distance_4 
      from Users u 
 left join Rides r 
        on r.user_id = u.user_id 
  group by 1,2,3
  order by 1;

-- Other SQL discussed in the video
select u.user_id, u.first_name, u.last_name
      , avg(distance) as avg_distance
      , IFNULL(avg(distance),0) as avg_distance_1 
      , avg(coalesce(distance,0)) as avg_distance_2 
      from Users u 
 left join Rides r 
        on r.user_id = u.user_id 
  group by 1,2,3 
  order by 1;

-- SQL 3: 
select user_id, first_name, last_name
      ,concat(first_name , ', ', last_name) as name 
      ,concat(first_name , ', ', ifnull(last_name,'')) as name_fixed 
      from Users;
