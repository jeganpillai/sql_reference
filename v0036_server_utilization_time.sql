-- Question: Display Name and Profession of Each Person

-- English Video: 
-- Tamil Video: 

Create table if not exists Servers 
(server_id int, 
 status_time timestamp, 
 session_status ENUM ('start','stop'));
Truncate table Servers;
insert into Servers (server_id, status_time, session_status) values 
 (1, '2023-11-13 03:05:31','start')
,(1, '2023-11-13 11:10:31','stop' )
,(1, '2023-11-20 00:27:11','start')
,(1, '2023-11-20 01:41:11','stop' )
,(3, '2023-11-04 16:29:47','start')  
,(3, '2023-11-04 16:41:48','stop' )
,(3, '2023-11-04 23:16:48','start')  
,(3, '2023-11-05 01:49:47','stop' )
,(3, '2023-11-25 01:37:08','start')
,(3, '2023-11-25 03:50:08','stop' )
,(4, '2023-11-20 00:31:44','start')
,(4, '2023-11-20 07:03:44','stop' )
,(4, '2023-11-25 21:09:06','start')
,(4, '2023-11-26 04:58:06','stop' )
,(4, '2023-11-29 15:11:17','start')
,(4, '2023-11-29 15:42:17','stop' )
,(4, '2023-11-30 15:09:18','start')
,(4, '2023-11-30 20:48:18','stop' )
,(5, '2023-11-16 19:42:22','start')
,(5, '2023-11-16 21:08:22','stop' );

-- Approach 1: using Self join 
with sequence_data as (
select s.server_id, s.status_time, s.session_status,
       min(e.status_time) as status_end_time
       from Servers s 
 inner join Servers e 
         on e.server_id = s.server_id 
        and s.session_status = 'start'
        and e.session_status = 'stop' 
        and e.status_time > s.status_time 
   group by 1,2,3)
select floor(sum(TIMESTAMPDIFF(second, status_time, status_end_time)/(3600 * 24))) as total_uptime_days
       from sequence_data;

-- Approach 2: Using Windows function row_number() 
with sequence_data as (
select server_id, status_time, session_status,
       row_number() over(partition by server_id, session_status order by server_id, status_time) as rnum 
       from Servers
   order by 1,4,3 )
select floor(sum(TIMESTAMPDIFF(second, s.status_time, e.status_time)/(3600 * 24))) as total_uptime_days
       from sequence_data s
 inner join sequence_data e
         on e.server_id = s.server_id 
        and e.rnum = s.rnum
        and e.session_status = 'stop'
        and s.session_status = 'start';

-- Approach 3: Using Windows function LEAD() 
with sequence_data as (
select server_id, status_time, session_status,
       lead(status_time, 1) over(partition by server_id order by server_id, status_time, session_status) as status_end
       from Servers )
select floor(sum(TIMESTAMPDIFF(second, status_time, status_end_time)/(3600 * 24))) as total_uptime_days
       from sequence_data 
      where session_status = 'start';
