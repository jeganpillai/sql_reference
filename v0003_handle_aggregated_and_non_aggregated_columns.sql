-- Question: if there are more than one client connected to a product then display the count of customers else display the client_name 

create table grouping_customers 
(product_id int 
,client_name varchar(25)
,revenue decimal(18,0));
 
insert into grouping_customers (product_id, client_name,revenue)  values 
(101,'Mark',5000),
(101,'Terri',6500),
(101,'Roberto',4000),
(102,'Penny',3000),
(102,'Chris',3500), -- 2500
(102,'Kane',2500),
(102,'Shane',4000),
(103,'David',3500),
(104,'Navab',2800);
/*
-- Expected Output: 
+------+-------+
| id   | cnt   |
+------+-------+
|  101 | 3     |
|  102 | 4     |
|  103 | David |
|  104 | Navab |
+------+-------+
*/
-- simple aggregation function   
select product_id
      ,case when count(*) > 1 then count(*) else max(client_name) end as cnt 
      from grouping_customers group by 1;

-- Learn windows function 
select product_id
      ,count(*) over (partition by product_id) as cnt
      ,rank() over (partition by product_id order by revenue) as cnt
      ,dense_rank() over (partition by product_id order by revenue) as cnt
      from grouping_customers;
