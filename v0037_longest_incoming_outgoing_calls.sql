-- Question: Find the three Longest Incoming and Outgoing Calls

-- English Video: https://www.youtube.com/watch?v=ya_onht0V4w
-- Tamil Video: https://www.youtube.com/watch?v=OEG-G8rKKdk

Create table Contacts(
  id int, first_name varchar(20), last_name varchar(20));
Truncate table Contacts;
insert into Contacts (id, first_name, last_name) values 
 (1, 'John'   , 'Doe'    )
,(2, 'Jane'   , 'Smith'  )
,(3, 'Alice'  , 'Johnson')
,(4, 'Michael', 'Brown'  )
,(5, 'Emily'  , 'Davis'  );

Create table Calls(
  contact_id int, type ENUM('incoming', 'outgoing'), duration int);
Truncate table Calls;
insert into Calls (contact_id, type, duration) values 
 (1, 'incoming', 120)
,(1, 'outgoing', 180)
,(2, 'incoming', 300) 
,(2, 'outgoing', 240) 
,(3, 'incoming', 150)
,(3, 'outgoing', 360) 
,(4, 'incoming', 420) 
,(4, 'outgoing', 200)
,(5, 'incoming', 180) 
,(5, 'outgoing', 280);

-- Approach 1: Self Join 
select c.first_name,
       c1.type,
       time_format(sec_to_time(c1.duration), '%H:%i:%s') as duration_formatted
       from Calls c1 
 inner join Calls c2 
         on c1.type = c2.type 
        and c1.duration <= c2.duration 
 inner join Contacts c 
         on c.id = c1.contact_id
   group by 1,2,3 having count(distinct c2.duration) <= 3
   order by 2, 3 desc, 1;

-- Approach 2: Correlated Subquery 
select c.first_name, type, (duration) as duration_formatted 
       from Calls c1
 inner join Contacts c 
         on c.id = c1.contact_id
      where 3 >= (select count(contact_id) from Calls c2 
                         where c2.type = c1.type 
                           and c2.duration >= c1.duration )
    order by 2, 3 desc, 1;

-- Approach 3: Windows Function 
with sorted_calls as (
select contact_id, type, duration,
       dense_rank() over(partition by type order by duration desc) as drnk 
       from Calls )
select c.first_name,
       src.type,
       time_format(sec_to_time(src.duration), '%H:%i:%s') as duration_formatted 
       from sorted_calls src 
 inner join Contacts c 
         on c.id = src.contact_id 
        and src.drnk <= 3
   order by 2,3 desc,1;
