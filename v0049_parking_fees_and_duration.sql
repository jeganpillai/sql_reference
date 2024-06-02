-- Question: Parking Fees and Duration

-- English Video: https://www.youtube.com/watch?v=oBiwnYdAvqU
-- Tamil Video: https://www.youtube.com/watch?v=Lxby4NdG6AE

CREATE TABLE If not exists ParkingTransactions (
    lot_id INT,
    car_id INT,
    entry_time DATETIME,
    exit_time DATETIME,
    fee_paid DECIMAL(10, 2)
);
Truncate table ParkingTransactions;
insert into ParkingTransactions (lot_id, car_id, entry_time, exit_time, fee_paid) values 
 (1, 1001, '2023-06-01 08:00:00', '2023-06-01 10:30:00', 5.0)
,(2, 1001, '2023-06-01 10:45:00', '2023-06-01 12:00:00', 6.0)
,(1, 1001, '2023-06-02 11:00:00', '2023-06-02 12:45:00', 3.0)
,(3, 1001, '2023-06-03 07:00:00', '2023-06-03 09:00:00', 4.0)
,(2, 1002, '2023-06-01 09:00:00', '2023-06-01 11:30:00', 4.0)
,(3, 1002, '2023-06-02 12:00:00', '2023-06-02 14:00:00', 2.0);

/*
-- The expected output is 
+--------+----------------+----------------+---------------+
| car_id | total_fee_paid | avg_hourly_fee | most_time_lot |
+--------+----------------+----------------+---------------+
| 1001   | 18.00          | 2.40           | 1             |
| 1002   | 6.00           | 1.33           | 2             |
+--------+----------------+----------------+---------------+
*/

-- Approach 1: Subquery in Select statement
with all_data as (
select car_id, 
       lot_id,
       sum(timestampdiff(minute, entry_time, exit_time)/60) as hours_spent,
       sum(fee_paid) as fee_paid 
       from ParkingTransactions
   group by 1,2)
select car_id,
       sum(fee_paid) as total_fee_paid,
       round(sum(fee_paid)/sum(hours_spent),2) as avg_hourly_fee,
       (select max(lot_id) from all_data dd 
                          where dd.car_id = d.car_id 
                            and hours_spent = (select max(hours_spent) 
                                                      from all_data ddd 
                                                     where ddd.car_id = dd.car_id)) as most_time_lot
from all_data d 
group by 1 ;

-- Approach 2: Multiple CTE table 
with all_data as (
select car_id, 
       lot_id,
       sum(timestampdiff(minute, entry_time, exit_time)/60) as hours_spent,
       sum(fee_paid) as fee_paid 
       from ParkingTransactions
   group by 1,2)
,max_hours_spent as (
select car_id, max(hours_spent) as max_hours_spent
       from all_data 
   group by 1 )
select d.car_id,
       sum(d.fee_paid) as total_fee_paid,
       round(sum(d.fee_paid)/sum(d.hours_spent),2) as avg_hourly_fee,
       max(case when m.max_hours_spent = d.hours_spent then d.lot_id end) as most_time_lot
       from all_data d 
 inner join max_hours_spent as m 
         on m.car_id = d.car_id 
   group by 1
   order by 1;

-- Approach 3: Using Windows Function 
with all_data as (
select car_id, 
       lot_id,
       sum(fee_paid) as fee_paid,
       sum(timestampdiff(minute, entry_time, exit_time)/60) as hours_spent,
       row_number() over(partition by car_id order by sum(timestampdiff(minute, entry_time, exit_time)/60) desc) as rnk   
from ParkingTransactions
group by 1,2)
select car_id,
       sum(fee_paid) as total_fee_paid,
       round(sum(fee_paid)/sum(hours_spent),2) as avg_hourly_fee,
       max(case when rnk = 1 then d.lot_id end) as most_time_lot
from all_data d 
group by 1 ;
