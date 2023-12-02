-- Question: Given a dataset of messages between users, get the count of messages shared between two users 

create table if not exists messages 
(id int
,sndr varchar(25) 
,rcvr varchar(25)
,messages varchar(25));
truncate table messages;
insert into messages values 
(1, 'A','B','abc'),
(2, 'B','A','XYZ'),
(3, 'C','B','PQR'),
(4, 'B','A','SAT'),
(5, 'D','C','HAS');
select * from messages;

/*
-- Expected output 
users    # of messages
AB        3
BC        1
DC        1
*/

with source_data as (
select id, sndr as user1, rcvr as user2, messages from messages 
union all 
select id, rcvr as user1, sndr as user2, messages from messages )
select concat(user1, user2) as users
,count(messages) as "# of messages"
from source_data 
where user1 < user2
group by 1 ;
