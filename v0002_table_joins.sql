-- Question: Table Joins
-- English Video: 
-- Tamil Video: Pending 

create table rooms (room_number decimal(18,0), number_of_beds int);
insert into rooms(room_number, number_of_beds) values 
(101, 2),(102, 3),(103, 3),(201, 2),(202, 2),(203, 3);

create table customer (room_number decimal(18,0)
,id decimal(18,0)
,names varchar(50));

insert into customer (room_number, id, names) values 
 (101, 50001, 'Andrew')
,(102, 50002, 'Thomas')
,(103, 50003, 'Kumar')
,(201, 50004, 'Philip')
,(203, 50005, 'Bhanu');


create table customer_info (customer_id decimal(18,0)
,phone_number varchar(25));
insert into customer_info (customer_id,phone_number) values 
 (50001, '617-885-1321')
,(50002, '435-643-3455')
,(50003, '543-321-4567')
,(50004, '654-432-5643')
,(50005, '556-234-7654');

create table room_rent (room_number decimal(18,0), rate decimal(18,2));
insert into room_rent (room_number, rate) values 
(101, 2500),(102, 2650)
,(103, 2500),(201, 3000)
,(202, 2500),(203, 3000);
    
select * from rooms;
select * from customer;
select * from customer_info;

-- sql 1
select c.id as customer_id, c.names as customer_name
,i.phone_number 
from customer c 
inner join customer_info i 
on i.customer_id = c.id 
order by 1;

-- sql 2
select r.room_number, c.id as customer_id, c.names as customer_name 
from rooms r 
inner join customer c 
on c.room_number = r.room_number
order by 1;

-- sql 3
select r.room_number, c.id as customer_id, c.names as customer_name
,i.phone_number 
from rooms r 
left join customer c 
on c.room_number = r.room_number
left join customer_info i 
on i.customer_id = c.id
order by 1;

-- sql 4
select r.room_number, rr.rate 
, c.id as customer_id, c.names as customer_name
,i.phone_number 
from rooms r 
inner join room_rent rr 
on rr.room_number = r.room_number 
left join customer c 
on c.room_number = r.room_number
left join customer_info i 
on i.customer_id = c.id
order by 1;
  
