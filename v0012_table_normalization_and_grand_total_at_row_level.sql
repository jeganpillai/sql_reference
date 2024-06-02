-- Question 1: Given denormalized table, we have to normaliae the values to single row. 

-- English Video: https://www.youtube.com/watch?v=_XOHS3wdwFw
-- Tamil Video: Pending 

create table city_normalize 
(city varchar(255)
,region_type varchar(255)   
,region_name varchar(255)
);
truncate table city_normalize;
insert into city_normalize values 
('Chennai','County','Guindy')
,('Chennai','State','TamilNadu')
,('Chennai','Country','India')
,('Mumbai','County','Dharavi')
,('Mumbai','State','Maharashtra')
,('Mumbai','Country','India')
,('Oakland','County','Alameda')
,('Oakland','State','California')
,('Oakland','Country','USA')
,('Sunnyvale','County','Santa Clara')
,('Sunnyvale','State','California')
,('Sunnyvale','Country','USA')
,('Los Angeles','County','Orange')   
,('Los Angeles','State','California')  
,('Los Angeles','Country','USA');

-- Output:
-- City         County       State          Country
-- Chennai      Guindy       TamilNadu      India
-- Mumbai       Dharavi      Maharashtra    India
-- Oakland      Alameda      California     USA  
-- Sunnyvale    Santa Clara  California     USA
-- Los Angeles  Orange       California     USA

-- sql
select city 
      ,max(case when region_type = 'County' then region_name end) as County 
      ,max(case when region_type = 'State' then region_name end) as State 
      ,max(case when region_type = 'Country' then region_name end) as Country 
      from city_normalize
  group by 1;


-- Question 2: How to show the grand total at row level
create table employee 
(emp_name varchar(100)
,department varchar(100)
,salary integer);

truncate table employee;
insert into employee values 
('Kumar','Data Engineering',10000) 
,('John','Data Engineering',12000) 
,('Krish','Data Science',10500)
,('Sam','Data Science',10000);

-- case 1: grand total 
select emp_name, salary, s.total_salary 
      from employee e 
inner join (select sum(salary) as total_salary from employee) s 
        on 1=1;

-- case 2: grand total at department level 
select emp_name, salary, s.total_salary 
      from employee e 
inner join (select department, sum(salary) as total_salary from employee group by 1) s 
        on e.department = s.department;

-- case 3: grand total using windows function 
select emp_name, salary
      ,sum(salary) over() as total_salary 
      from employee e ;

-- case 4: grand total at department level, using windows function 
select emp_name, salary
      ,sum(salary) over(partition by department ) as total_salary 
      from employee e 




