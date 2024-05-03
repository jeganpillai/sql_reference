-- Question: Find the Purchase numbers happened on Month of May 2024 and by specific Member type

-- English Video: 
-- Tamil Video: 

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
