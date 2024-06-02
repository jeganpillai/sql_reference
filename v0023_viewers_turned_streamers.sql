-- Question: Find users who started as Viewers and Became Streamers, get those users and total sessions as Streamer.

-- English Video: https://www.youtube.com/watch?v=RIDgrV37ew8
-- Tamil Video: Pending 

Create table Sessions 
(user_id int, session_start datetime, session_end datetime, session_id int, session_type varchar(25));
Truncate table Sessions;
insert into Sessions (user_id, session_start, session_end, session_id, session_type) values 
('101', '2023-11-06 13:53:42', '2023-11-06 14:05:42', '375', 'Viewer')
,('101', '2023-11-22 16:45:21', '2023-11-22 20:39:21', '594', 'Streamer')
,('102', '2023-11-16 13:23:09', '2023-11-16 16:10:09', '777', 'Streamer')
,('102', '2023-11-17 13:23:09', '2023-11-17 16:10:09', '778', 'Streamer')
,('101', '2023-11-20 07:16:06', '2023-11-20 08:33:06', '315', 'Streamer')
,('104', '2023-11-27 03:10:49', '2023-11-27 03:30:49', '797', 'Viewer')
,('103', '2023-11-27 03:10:49', '2023-11-27 03:30:49', '798', 'Streamer');

-- Approach 1: General Subquery
with first_session as (
select user_id, min(session_start) as session_start 
       from Sessions group by user_id )
,started_viewer as (
select s.user_id 
      from Sessions s 
inner join first_session f 
        on f.user_id = s.user_id 
       and f.session_start = s.session_start 
      and s.session_type = 'Viewer') 
select v.user_id , count(case when s.session_type = 'Streamer' then session_id end) as sessions_count
      from started_viewer v 
inner join Sessions s 
        on s.user_id = v.user_id 
  group by v.user_id 
having count(distinct s.session_type) = 2 
order by 2 desc, 1 desc;

-- Approach 2: Utilizing Windows Function
with first_session as (
select user_id, session_type 
      ,rank() over(partition by user_id order by user_id, session_start) as rnum
      from Sessions )
select f.user_id, count(*) as sessions_count 
       from first_session f 
      where user_id in (select user_id from first_session where rnum = 1 and session_type = 'Viewer')
        and session_type = 'Streamer'
   group by 1 order by 2 desc, 1 desc ;
