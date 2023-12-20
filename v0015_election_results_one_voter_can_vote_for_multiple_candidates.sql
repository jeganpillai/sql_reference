-- Question : We are given a Votes table where we have Voter and Candidate. The Voters can vote for one or more candidates or choose not to vote. Each person has 1 vote so if they vote for multiple candidates, their vote gets equally split across them. 

-- Video: https://www.youtube.com/watch?v=ovjaQuwrfis
Create table Votes(voter varchar(30), candidate varchar(30));
Truncate table Votes;
insert into Votes (voter, candidate) values 
 ('Kathy', 'None')
,('Charles', 'Ryan')
,('Charles', 'Christine')
,('Charles', 'Kathy')
,('Benjamin', 'Christine')
,('Anthony', 'Ryan')
,('Edward', 'Ryan')
,('Terry', 'None')
,('Evelyn', 'Kathy')
,('Arthur', 'Christine');

-- Approach 1: General Aggregation 
with all_voters as (
select voter, 1/count(*) as cnt 
       from Votes
   group by 1) 
,all_votes as (
select v.candidate 
       ,sum(case when v.candidate ='None' then 0 else a.cnt end) as total_votes 
       from Votes v 
  left join all_voters a 
         on a.voter = v.voter
   group by 1)
select v.candidate 
       from all_votes v 
       where total_votes = (select max(total_votes) from all_votes) 
    order by 1 ;

-- Windows Function 
with all_data as (
select voter, candidate
      ,case when candidate = 'None' then 0 else 1/count(*) over(partition by voter) end as cnt 
      from Votes)
,max_votes as (
select candidate, sum(cnt) as total_votes 
       from all_data
  group by 1 )
select candidate
       from max_votes 
      where total_votes = (select max(total_votes) from max_votes)
   order by 1; 
