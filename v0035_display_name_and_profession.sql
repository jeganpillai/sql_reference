-- Question: Display Name and Profession of Each Person

-- English Video: https://www.youtube.com/watch?v=g06DlkUXr0w
-- Tamil Video: https://www.youtube.com/watch?v=VXKgroxaACI

Create table Person (
 person_id int, 
 name varchar(30), 
 profession ENUM('Doctor','Singer','Actor','Player','Engineer','Lawyer'));
Truncate table Person;
insert into Person (person_id, name, profession) values 
 (1, 'Alex' , 'Singer'  )
,(2, 'Bob'  , 'Player'  )
,(3, 'Alice', 'Actor'   )
,(4, 'Messi', 'Doctor'  )
,(5, 'Meir' , 'Lawyer'  )
,(6, 'Tyson', 'Engineer');

-- Approach 1: SQL for Ideal Scenario 
select person_id, 
       name, profession,
       concat(name, '(', left(profession, 1),')') as initial  
from Person;

-- How to handle NULL values in Name or Profession? 
Truncate table Person;
insert into Person (person_id, name, profession) values 
 (1, 'Alex' , 'Singer'  )
,(2, 'Bob'  , 'Player'  )
,(3, 'Alice', 'Actor'   )
,(4, 'Messi', 'Doctor'  )
,(5, 'Meir' , 'Lawyer'  )
,(6, 'Tyson', 'Engineer')
,(7, 'Nancy', NULL      )
,(8, NULL   , 'Doctor'  );

-- Approach 2: Handling NULL Values 
select person_id, 
       name, profession,
       concat(coalesce(name,''), '(', coalesce(left(profession, 1),''),')') as initial  
from Person;

-- Approach 3: Highlighting Missing Data 
select person_id, 
       name, profession,
       concat(coalesce(name,'?'), '(', coalesce(left(profession, 1),'?'),')') as initial  
from Person;

