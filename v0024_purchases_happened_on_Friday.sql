-- Question: Write a solution to calculate the total spending by users on each Friday of every week in November 2023. Output only weeks that include at least one purchase on a Friday.
-- Extension of the Question: Write a solution to calculate the total spending by users on each Friday of every week in November 2023. If there are no purchases on a particular Friday of a week, it will be considered as 0.

-- Video: https://www.youtube.com/watch?v=myGEiN25Pdg

Create Table Purchases( user_id int, purchase_date date, amount_spend int);
Truncate table Purchases;
insert into Purchases (user_id, purchase_date, amount_spend) values 
 (11, '2023-11-07', 1126)
,(15, '2023-11-30', 7473)
,(17, '2023-11-14', 2414)
,(12, '2023-11-24', 9692)
,(8, '2023-11-03', 5117)
,(1, '2023-11-16', 5241)
,(10, '2023-11-12', 8266)
,(13, '2023-11-24', 12000);

-- Approach for Question 1: 
select ceil(dayofmonth(purchase_date)/7) as week_of_month 
      ,purchase_date 
      ,sum(amount_spend) as total_amount 
      from Purchases 
     where dayofweek(purchase_date) = 6 
  group by 1,2 order by 1 ; 

-- Approach for Question 2: 
with all_sale_date as (
select '2023-11-03' as sale_date 
union all 
select '2023-11-10' as sale_date 
union all 
select '2023-11-17' as sale_date 
union all 
select '2023-11-24' as sale_date ) 
select ceil(dayofmonth(d.sale_date)/7) as week_of_month
      ,d.sale_date as purchase_date
      ,coalesce(sum(p.amount_spend),0) as total_amount 
      from all_sale_date d 
 left join Purchases p 
        on p.purchase_date = d.sale_date
  group by 1,2 order by 1,2;

-- or use Recursive table 
WITH RECURSIVE DateRange AS (
    SELECT DATE('2023-11-01') AS sale_date
    UNION ALL
    SELECT sale_date + INTERVAL 1 DAY
    FROM DateRange
    WHERE sale_date < '2023-11-30'
)
select ceil(dayofmonth(d.sale_date)/7) as week_of_month 
      ,d.sale_date as purchase_date
      ,coalesce(sum(p.amount_spend),0) as total_amount 
      from DateRange d 
 left join Purchases p 
        on p.purchase_date = d.sale_date
     where dayofweek(d.sale_date) = 6
  group by 1,2 order by 1;
