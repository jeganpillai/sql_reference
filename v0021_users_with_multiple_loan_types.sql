-- Question: Users With Multiple Loan Types

-- English Video: https://www.youtube.com/watch?v=ddMdDDB87AI
-- Tamil Video: Pending 

-- Approach 1: Multiple Subquery Approach
select a.user_id 
from (select 'a' as flg, user_id from Loans where loan_type = 'Mortgage') a 
inner join (select 'b' as flg, user_id from Loans where loan_type ='Refinance')b 
on b.user_id = a.user_id; 

-- Approach 2: CTE Table Strategy
with all_data as (
select distinct user_id, loan_type from Loans where loan_type in ('Mortgage', 'Refinance') )
select user_id 
from all_data 
group by 1 having count(*) = 2;

-- Approach 3: Utilizing Multiple HAVING Clauses
select user_id from Loans 
group by 1 
having SUM(CASE WHEN loan_type = 'Refinance' THEN 1 ELSE 0 END) >= 1
   AND SUM(CASE WHEN loan_type = 'Mortgage' THEN 1 ELSE 0 END) >= 1;

-- Approach 4: Simple Aggregation with HAVING Clause Filter 
select user_id from Loans where loan_type in ('Mortgage', 'Refinance') 
group by 1 having count(distinct loan_type) = 2;
