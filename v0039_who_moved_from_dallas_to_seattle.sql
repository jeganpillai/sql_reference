-- Question: Find the employees who moved from Dallas to Seattle and in last 12 months. Except Dallas employee shouldn’t have worked in any other city.

-- English Video: 
-- Tamil Video: 

create table Employees 
(eno int
,ename varchar(50)
,city varchar(50)
,joining_date date
,moveout_date date);

insert into Employees (eno, ename, city, joining_date, moveout_date) values 
(101,'Alwin Davids','San Francisco','2020-01-09','2020-12-25'),
(101,'Alwin Davids','Dallas'       ,'2020-12-30','2022-10-12'),
(101,'Alwin Davids','Seattle'      ,'2022-10-30', null       ), 
(102,'Praveen'     ,'Dallas'       ,'2019-02-01','2021-02-28'),
(102,'Praveen'     ,'Seattle'      ,'2021-03-01', null       ),
(103,'Ashok'       ,'Seattle'      ,'2019-01-01', null       ),
(104,'Kumaran'     ,'Dallas'       ,'2021-02-09','2023-12-25'),
(104,'Kumaran'     ,'Seattle'      ,'2024-01-30', null       ),
(105,'Sabu'        ,'Dallas'       ,'2010-01-01','2012-12-31'),
(105,'Sabu'        ,'New York'     ,'2013-01-01','2018-12-31'),
(105,'Sabu'        ,'Dallas'       ,'2019-01-01','2019-12-31'), 
(105,'Sabu'        ,'Seattle'      ,'2020-01-01', null       );

-- Approach 1: Using Self Join 
select s.eno, s.ename 
       from Employees s 
 inner join Employees e
         on s.eno = e.eno 
        and s.city ='Dallas'
        and e.city = 'Seattle'
        and e.moveout_date is  null 
        and e.joining_date > s.moveout_date
        and datediff(current_date, e.joining_date) <= 365
        and s.eno not in (select eno from Employees 
                                 group by 1 having count(distinct city)>2); 

-- Approach 2: Using Windows Function - row_number() 
with all_data as (
select eno, ename, city, joining_date, moveout_date ,
row_number() over(partition by eno order by joining_date desc) as e_place
from Employees)
select e.eno, e.ename
       from all_data s 
 inner join all_data e
         on e.eno = s.eno 
        and e.e_place = 1
        and s.e_place = 2 
        and s.city = 'Dallas'
        and e.city = 'Seattle'
        and datediff(current_date, e.joining_date) <= 365
        and s.eno not in(select eno from all_data 
                                group by 1 having count(distinct city) > 2);

-- Approach 3: Using Windows Function - lag()
with all_data as (
select eno, ename, city, 
       joining_date,
       moveout_date ,
       lag(city) over(partition by eno order by joining_date) as prev_place
       from Employees)
select eno, ename, city, joining_date
       from all_data 
      where moveout_date is null 
        and city = 'Seattle'
        and prev_place = 'Dallas'
        and datediff(current_date, joining_date) <= 365
        and eno not in(select eno from all_data 
                              group by 1 having count(distinct city) > 2);
