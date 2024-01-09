-- Question: Class performance based on highest and lowest score of the Students in class
-- Video: https://www.youtube.com/watch?v=gDSp9rCpirc

Create Table Scores 
(student_id int, student_name varchar(40), assignment1 int
,assignment2 int, assignment3 int);
Truncate table Scores;
insert into Scores (student_id, student_name, assignment1, assignment2, assignment3) values
 (309, 'Owen', 88, 47, 87)
,(321, 'Claire', 98, 95, 37)
,(338, 'Julian', 100, 64, 43)
,(423, 'Peyton', 60, 44, 47)
,(896, 'David', 32, 37, 50)
,(235, 'Camila', 31, 53, 69);

-- Approach 1: 
with total_scores as (
select student_id, assignment1 + assignment2 + assignment3 as total_score
from Scores ) 
,score_boundaries as (
select max(total_score) as highest_score
      ,min(total_score) as lowest_score
      from total_scores )
select highest_score - lowest_score as difference_in_score
from score_boundaries;


-- Approach 2: 
with total_scores as (
select max(assignment1 + assignment2 + assignment3) as highest_score
      ,min(assignment1 + assignment2 + assignment3) as lowest_score
      from Scores )
select highest_score - lowest_score as difference_in_score
from total_scores;

-- Approach 3: 
select max(assignment1 + assignment2+assignment3) - min(assignment1 + assignment2+assignment3) as difference_in_score
      from Scores

-- Approach 4: 
SELECT 
(SELECT MAX(assignment1+assignment2+assignment3) FROM Scores) -
(SELECT MIN(assignment1+assignment2+assignment3) FROM Scores) AS 'difference_in_score'


-- Using WINDOWS function 
-- Approach 1: 
with overall_score as (
select student_id, sum(assignment1 + assignment2+assignment3) as assignment_score
from Scores group by 1)
,score_limit as (
select assignment_score 
,rank() over(order by assignment_score desc) as top_score 
,rank() over(order by assignment_score) as bottom_score 
from overall_score)
select max(case when top_score = 1 then assignment_score end) - max(case when bottom_score = 1 then assignment_score end) as bottom_score
from score_limit;


-- Approach 2: 
with score_limit as (
select student_id, sum(assignment1 + assignment2+assignment3) as assignment_score 
,rank() over(order by sum(assignment1 + assignment2+assignment3) desc) as top_score 
,rank() over(order by sum(assignment1 + assignment2+assignment3)) as bottom_score 
from Scores group by 1
)
select max(case when top_score = 1 then assignment_score end) - max(case when bottom_score = 1 then assignment_score end) as difference_in_score
from score_limit;


-- Different output expectation: 
/* 
+ ---------- + ----------- + ------------------- +
| student_id | total_score | difference_in_score |
+ ---------- + ----------- + ------------------- +
| 309        | 222         | 111                 |
| 321        | 230         | 111                 |
| 338        | 207         | 111                 |
| 423        | 151         | 111                 |
| 896        | 119         | 111                 |
| 235        | 153         | 111                 |
+ ---------- + ----------- + ------------------- +
*/ 
SELECT student_id, total_score, MAX(total_score) over()- MIN(total_score) over() AS difference_in_score
FROM (
    SELECT student_id, assignment1 + assignment2 + assignment3 AS total_score
    FROM Scores
) AS total_scores;
