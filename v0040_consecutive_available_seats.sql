-- Question: Find the length of the longest consecutive sequence of available seats in the cinema

-- English Video: 
-- Tamil Video: 

CREATE TABLE Cinema (seat_id INT,
                     free BOOLEAN);
Truncate table Cinema;
insert into Cinema (seat_id, free) values 
 (1, 1)
,(2, 0)
,(3, 1)
,(4, 1)
,(5, 0);
/*
,(6, 1)
,(7, 0)
,(8, 0)
,(9, 1)
,(10, 1)
,(11, 1)
,(12, 1);
*/

-- Approach 1: Using Self join 
with sorted_dataset as (
select min(c1.seat_id) as first_seat_id,
       max(c2.seat_id) as last_seat_id,
      count(*) as consecutive_seats_len
      from Cinema c1
inner join Cinema c2 
        on c1.seat_id <= c2.seat_id 
 left join Cinema c3 
        on c3.seat_id between c1.seat_id and c2.seat_id 
       and c3.free = 0
     where c1.free = 1 
       and c3.seat_id is null 
  group by c1.seat_id)
select first_seat_id,
       last_seat_id,
       consecutive_seats_len
       from sorted_dataset 
      where consecutive_seats_len = (select max(consecutive_seats_len) from sorted_dataset ); 

-- Approach 2: Using Windows Function 
with rank_data as (
select seat_id, free,
       row_number() over(order by seat_id) as rnum, 
       row_number() over(partition by free order by seat_id) as rchk
       from Cinema )
,sorted_list as (
select seat_id, free, rnum, rchk,
       rnum - rchk as grp
       from rank_data )
,final_dataset as (
select min(seat_id) as first_seat_id,
       max(seat_id) as last_seat_id,
       count(*) as consecutive_seat_len
       from sorted_list
       where free = 1 
       group by grp)
select first_seat_id,
       last_seat_id,
       consecutive_seat_len
       from final_dataset
      where consecutive_seat_len = (select max(consecutive_seat_len) from final_dataset);

-- Approach 3: Simplified version using Windows function 
with rank_data as (
select seat_id, free,
       row_number() over(order by seat_id) - row_number() over(partition by free order by seat_id) as grp
from Cinema )
,final_dataset as (
select min(seat_id) as first_seat_id,
       max(seat_id) as last_seat_id,
       count(*) as consecutive_seat_len
       from rank_data 
       where free = 1 
       group by grp)
select first_seat_id,
       last_seat_id,
       consecutive_seat_len
       from final_dataset
      where consecutive_seat_len = (select max(consecutive_seat_len) from final_dataset) ;


