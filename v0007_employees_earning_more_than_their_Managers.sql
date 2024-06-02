-- Question 1: The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id. Given the Employee table, write a SQL query that finds out employees who earn more than their managers. 

-- English Video: https://www.youtube.com/watch?v=cznPQmH482c
-- Tamil Video: Pending 

Create table If Not Exists Employee 
(Id int, Name varchar(255), Salary int, ManagerId int);
Truncate table Employee;
insert into Employee (Id, Name, Salary, ManagerId) values 
(1, 'Joe', '70000', '3'),
(2, 'Henry', '80000', '4'),
(3, 'Sam', '60000', Null),
(4, 'Max', '90000', Null),
(5, 'Mark', 40000, 3),
(6, 'Jack', 30000, 3);

-- sql for Question 1: 
-- select e.id, e.name, m.name, e.salary as emp_salary, m.salary as mgr_salary
select e.id, e.name
from Employee m 
inner join Employee e 
on e.managerid = m.id 
and e.salary > m.salary;

-- Question 2: get all the Managers and their reportees salary
select m.id, m.name, sum(e.salary) as total_emp_salary
from Employee m 
inner join Employee e 
on e.managerid = m.id 
group by 1,2 ;

-- Question 3: now we have the total reportees salary. it I want to know the total salary of all the reportees and the manager's salary, then how will you do that? 
select m.id, m.name, sum(e.salary) + max(m.salary) as total_emp_salary
from Employee m 
inner join Employee e 
on e.managerid = m.id 
group by 1,2 ;
