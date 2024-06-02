-- Question: Write a SQL query to find all numbers that appear at least three times consecutively.

-- English Video: https://www.youtube.com/watch?v=aInquqYlVZ4
-- Tamil Video: Pending 

Create table If Not Exists Logs (Id int, Num int);
Truncate table Logs;
insert into Logs (Id, Num) values 
 ( '1', '1')
,( '2', '1')
,( '3', '1')
,( '4', '2')
,( '5', '1')
,( '6', '2')
,( '7', '2')
,( '8', '3')
,( '9', '3')
,('10', '3')
,('11', '3');

-- brute force method 
select f.num
      from Logs f 
inner join Logs s 
        on s.Num = f.Num 
inner join Logs t 
        on t.Num = s.Num 
       and ( ( abs(f.id - s.id) = 1 AND abs(s.id - t.id) = 1 and abs(f.id - t.id) = 2) 
            or 
             ( abs(f.id - s.id) = 1 AND abs(f.id - t.id) = 1 and abs(s.id - t.id) = 2) 
           )
group by 1
order by 1;

-- windows function 
with all_data as (
select id, num
      ,row_number() over (partition by num order by num, id) as rnum 
      from Logs)
select num
    from all_data 
group by num, id-rnum 
  having count(*) >= 3
 ;
