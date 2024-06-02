-- Question: Flight Occupancy And Waitlist Analysis

-- English Video: https://www.youtube.com/watch?v=AQtLC6BKdls
-- Tamil Video: Pending 

-- Approach 1: Using Common Table Expressions (CTE)
with booking_data as (
select flight_id, count(passenger_id) as total_bookings
from Passengers 
group by 1 )
select f.flight_id 
,COALESCE(case when f.capacity >= b.total_bookings then b.total_bookings
      when f.capacity < b.total_bookings then f.capacity end,0) as booked_cnt 
,COALESCE(case when f.capacity >= b.total_bookings then 0
      when f.capacity < b.total_bookings then b.total_bookings - f.capacity end,0) as waitlist_cnt
from Flights f 
left join booking_data b  
on b.flight_id = f.flight_id
order by 1;

-- Approach 2: Employing IF() Condition
select f.flight_id
,if(count(p.passenger_id) > max(f.capacity), max(f.capacity), count(p.passenger_id)) as booked_cnt 
,if (count(p.passenger_id) > max(f.capacity), count(p.passenger_id) - max(f.capacity), 0) as waitlist_cnt 
from Flights f 
left join Passengers p 
on p.flight_id = f.flight_id 
group by 1 order by 1;


-- Approach 3: Leveraging MySQL Functions
select f.flight_id
,LEAST(max(f.capacity), count(p.passenger_id)) as booked_cnt 
,GREATEST(0, count(p.passenger_id) - max(f.capacity)) as waitlist_cnt 
from Flights f 
left join Passengers p 
on p.flight_id = f.flight_id 
group by 1 order by 1;
