-- Question: Find the Manager Of The Largest Department

-- English Video: https://www.youtube.com/watch?v=TEiPds9514Q
-- Tamil Video: Pending 

-- Approach 1: General CTE Logic
with total_emp as (
select dep_id, count(emp_id) as emp_cnt from Employees group by 1)
select e.emp_name as manager_name
      ,e.dep_id 
      from Employees e 
inner join total_emp t 
        on t.dep_id = e.dep_id 
     where e.position = 'Manager'
       and t.emp_cnt = (select max(emp_cnt) from total_emp)
  order by 1;

-- Approach 2: Using WINDOWS Function
with total_emp as (
select emp_id, emp_name, dep_id, position, count(*) over(partition by dep_id) as emp_cnt
from Employees )
select e.emp_name as manager_name
      ,e.dep_id 
      from total_emp e 
     where e.position = 'Manager'
       and e.emp_cnt = (select max(emp_cnt) from total_emp)
  order by 1;
