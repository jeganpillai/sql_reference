-- Given a set of integers as minutes and number of orders received during that specific minute. The total number of rows will be a multiple of 6. Write a query to calculate total orders within each interval. Each interval is defined as a combination of 6 minutes.

Create table if not exists Orders(minute int, order_count int);
Truncate table Orders;
insert into Orders (minute, order_count) values 
 (1, 0)
,(2, 2)
,(3, 4)
,(4, 6)
,(5, 1)
,(6, 4)
,(7, 1)
,(8, 2)
,(9, 4)
,(10, 1)
,(11, 4)
,(12, 6);

-- Approach 1: We used MOD and DIV function to identify the bucket and aggregate based on the combination. 
select if (minute % 6 = 0, minute div 6, minute div 6 + 1) as interval_no
      ,sum(order_count) as total_orders
      from Orders
  group by 1 order by 1;

-- Approach 2: We can also use the CEIL function, which computes the smallest integer that is greater than or equal 
select ceil(minute/6) as interval_no, sum(order_count) as total_orders 
       from Orders 
   group by 1 order by 1;

