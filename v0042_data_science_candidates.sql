-- Question: Find the candidates best suited for a Data Scientist position. The candidate must be proficient in Python, Tableau, and PostgreSQL.

-- English Video: https://www.youtube.com/watch?v=DYX1DmFRTg0
-- Tamil Video: https://www.youtube.com/watch?v=a6fyVEGkdQA

Create table Candidates (candidate_id int, skill varchar(30));
Truncate table Candidates;
insert into Candidates (candidate_id, skill) values 
 (102, 'DataAnalysis')
,(123, 'Python')
,(123, 'Tableau')
,(123, 'PostgreSQL')
,(147, 'Python')
,(147, 'Tableau')
,(147, 'Java')
,(147, 'PostgreSQL')
,(234, 'R')
,(234, 'PowerBI')
,(234, 'SQL Server')
,(256, 'Tableau');

-- Approach 1: Brute Force Method 
select distinct candidate_id 
       from Candidates
      where candidate_id in (select candidate_id from Candidates where skill = 'Python')
        and candidate_id in (select candidate_id from Candidates where skill = 'Tableau')
        and candidate_id in (select candidate_id from Candidates where skill = 'PostgreSQL')
   order by 1;

-- Approach 2: Correlated Subquery 
select distinct candidate_id 
       from Candidates c 
      where 3 = (select count(distinct cc.skill) from Candidates cc 
                        where cc.candidate_id = c.candidate_id
                          and cc.skill in ('Python','Tableau','PostgreSQL'));

-- Approach 3: Aggregate Format 
select candidate_id
       from Candidates 
      where skill in ('Python','Tableau','PostgreSQL')
   group by 1 having count(distinct skill) = 3
   order by 1;

-- Approach 4: one more different approach
SELECT candidate_id
       FROM Candidates
   GROUP BY candidate_id
     HAVING COUNT(DISTINCT skill) >= 3
        AND MAX(skill = 'Python') = 1
        AND MAX(skill = 'Tableau') = 1
        AND MAX(skill = 'PostgreSQL') = 1
   ORDER BY candidate_id ASC;
