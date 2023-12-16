-- Question: Calculate The Highest Salary Difference Between Two Departments

Create table Salaries(emp_name varchar(30), department varchar(30),salary int);
insert into Salaries (emp_name, department, salary) values 
('Kathy', 'Engineering', '50000')
,('Roy', 'Marketing', '30000')
,('Charles', 'Engineering', '45000')
,('Jack', 'Engineering', '85000')
,('Benjamin', 'Marketing', '34000')
,('Anthony', 'Marketing', '42000')
,('Edward', 'Engineering', '102000')
,('Terry', 'Engineering', '44000')
,('Evelyn', 'Marketing', '53000')
,('Arthur', 'Engineering', '32000');

-- Approach 1:  General approach 
with all_data as (select department, max(salary) as salary from Salaries group by 1 )
select abs(sum(case when department = 'Engineering' then salary else 0 end )
         - sum(case when department = 'Marketing' then salary else 0 end) ) as salary_difference
       from all_data;

-- Approach 2: Windows function 
with all_data as (
select department , salary
      ,row_number() over(partition by department order by salary desc) as rnum
      from Salaries )
select abs(max(case when department = 'Engineering' and rnum = 1 then salary end)
         - max(case when department = 'Marketing' and rnum = 1 then salary end)) as salary_difference
from all_data;

-- Approach 3: smarter way 
select abs(max(case when department = 'Engineering' then salary else 0 end )
         - max(case when department = 'Marketing' then salary else 0 end)) as salary_difference
from Salaries

