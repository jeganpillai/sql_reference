-- Question: Find the Purchase numbers happened on Month of May 2024 and by specific Member type

-- English Video: 
-- Tamil Video: 

Create Table if Not Exists Purchases ( user_id int, purchase_date date, amount_spend int);
Truncate table Purchases;
insert into Purchases (user_id, purchase_date, amount_spend) values 
 (11, '2024-05-03',   1126)
,(15, '2024-05-03',   1100)
,(15, '2024-05-10',   7473)
,(17, '2024-05-17',   2414)
,(13, '2024-05-21',  12000)
,(10, '2024-05-22',   8266)
,(12, '2024-05-24',   9692)
,( 8, '2024-05-24',   5117)
,( 1, '2024-05-24',   5241);

Create Table if Not Exists Users (user_id int, membership enum('Standard', 'Premium', 'VIP'));
Truncate table Users;
insert into Users (user_id, membership) values 
 (11, 'Premium' )
,(15, 'VIP'     )
,(17, 'Standard')
,(12, 'VIP'     )
,( 8, 'Premium' )
,( 1, 'VIP'     )
,(10, 'Standard')
,(13, 'Premium' );

-- Purchase tracker for the month of May 2024
with RECURSIVE date_cte as 
(select date '2024-05-01' as date_ 
union all 
select date_ + INTERVAL 1 day 
       from date_cte 
      where date_ < date '2024-05-31')
,template_dataset as (
select d.date_ as purchase_date,
       dayofmonth(d.date_) DIV 7 + 1 as week_of_month, 
       b.membership 
       from date_cte d 
 inner join (select 'VIP' as membership
          union all
             select 'Premium' as membership) b 
         on 1 = 1 
      where dayname(d.date_) = 'Friday' )
,purchase_details as (
select p.purchase_date, 
       u.membership,
       sum(p.amount_spend) as total_amount 
       from Purchases p 
 inner join Users u 
         on u.user_id = p.user_id
   group by 1,2 )
select t.purchase_date,
       t.week_of_month,
       t.membership,
       coalesce(p.total_amount,0) as total_amount 
       from template_dataset t 
  left join purchase_details p 
         on p.purchase_date = t.purchase_date
        and p.membership = t.membership;
