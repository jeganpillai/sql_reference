-- Question: Find all unique email domains ending with .com and count the number of individuals associated with each domain

-- English Video: https://www.youtube.com/watch?v=o2jRhl345lU
-- Tamil Video: https://www.youtube.com/watch?v=Bd-s01xwCk8

Create table Emails (id int, email varchar(255));
Truncate table Emails;
insert into Emails (id, email) values 
 (336, 'hwkiy@test.edu'       )
,(489, 'adcmaf@outlook.com'   )
,(449, 'vrzmwyum@yahoo.com'   )
,(95 , 'tof@test.edu'         )
,(320, 'jxhbagkpm@example.org')
,(411, 'zxcf@outlook.com'     );

select substr(email, instr(email, '@')+1) as email_domain,
       count(id) as count 
from Emails  
where right(email,4) = '.com'
group by 1 
order by 1 ;

--       position('@' in email) as chk1, 
--       instr(email, '@') as chk2,
--       locate('@',email) as chk3,

--       right(email, length(email) - locate('@',email)) as email_domain,
--       substr(email, locate('@', email)+1) as email_domain,
--       substring_index(email, '@', -1) as email_domain,
--       substr(email, instr(email, '@')+1) as email_domain

--       where email like '%.com'
--       where right(email,4) = '.com'
