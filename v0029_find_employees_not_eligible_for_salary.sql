-- Question: Find employees who are not eligible to get their salary

-- English Video: https://www.youtube.com/watch?v=qvpX0Ch2ck8
-- Tamil Video: Pending 

-- Approach 1: CTE Table Logic
select employee_id 
      ,sum(time_to_sec(timediff(out_time, in_time))/3600) as worked_hours 
      from Logs 
  group by 1)
select emp.employee_id
       from Employees emp
  left join employee_working_hr wrk
         on emp.employee_id = wrk.employee_id
      where ( emp.needed_hours > wrk.worked_hours or wrk.employee_id is null);

-- Approach 2: Direct Left Join
select emp.employee_id
      from Employees emp 
 left join Logs l 
        on l.employee_id = emp.employee_id
  group by 1 
    having max(emp.needed_hours) > coalesce(sum(time_to_sec(timediff(out_time, in_time))/3600),0);
