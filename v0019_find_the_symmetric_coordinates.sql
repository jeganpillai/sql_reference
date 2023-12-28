-- Question : Find The Symmetric Coordinates
-- Video: 

-- What is Symmetric Coordinates? 
-- Two coordindates (X1, Y1) and (X2, Y2) are said to be symmetric coordintes if X1 == Y2 and X2 == Y1.
-- The solution we are looking at is, among those Symmetric coordinates, get those unique coordinats that satisfy the condition X1 <= Y1.

-- The conditions we have to check: 
-- 1. X1 == Y2 
-- 2. X2 == Y1
-- 3. X1 <= Y1

-- Approach 1: Normal Approach
SELECT x, y 
      FROM Coordinates WHERE x = y
  GROUP BY x
    HAVING count(x) > 1
union all 
SELECT DISTINCT c1.x, c1.y 
      FROM Coordinates c1 
INNER JOIN Coordinates c2
        ON c1.x = c2.y and c1.y = c2.x and c1.x < c1.y
  ORDER BY 1,2;

-- Approach 2: WINDOWS function 
with all_data as (
select x, y
      ,row_number() over() as rnum 
      from Coordinates)
select distinct c1.x, c1.y
      from all_data c1 
inner join all_data c2 
        on c1.x = c2.y 
       and c2.x = c1.y
       and c1.x <= c1.y
       and c1.rnum <> c2.rnum 
  order by 1,2; 

/*
Truncate table Coordinates;
insert into Coordinates (X, Y) values
 (6, 7)
,(5, 2)
,(5, 4)
,(6, 6)
,(6, 9)
,(10, 9)
,(3, 1)
,(7, 7)
,(1, 9)
,(1, 4)
,(7, 1)
,(7, 4)
,(10, 2)
,(9, 4)
,(3, 2)
,(5, 1)
,(7, 5)
,(8, 6)
,(10, 1)
,(9, 8)
,(6, 4)
,(6, 5)
,(8, 8);

Expected
| x | y |
| - | - |
*/
