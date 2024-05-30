-- Question: Trending Hashtag From Tweeets

-- English Video: 
-- Tamil Video: 

Create table If Not Exists Tweets 
(user_id int, 
 tweet_id int,  
 tweet_date date, 
 tweet varchar(100));

Truncate table Tweets;
insert into Tweets (user_id, tweet_id, tweet_date, tweet) values 
 (100,  1, '2024-06-08','#WorkLife')
,(101,  2, '2024-06-14','#Learning')
,(102,  3, '2024-06-04','#Travel'  )
,(103,  4, '2024-06-05','#Foodie'  )
,(104,  5, '2024-06-29','#TechLife')
,(105,  6, '2024-06-23','#HappyDay')
,(106,  7, '2024-06-18','#TechLife')
,(107,  8, '2024-06-17','#WorkLife')
,(108,  9, '2024-06-13','#Travel'  )
,(109, 10, '2024-06-22','#Learning')
,(110, 11, '2024-06-16','#Travel'  )
,(111, 12, '2024-06-18','#HappyDay')
,(112, 13, '2024-06-21','#WorkLife')
,(113, 14, '2024-06-07','#Fitness' )
,(114, 15, '2024-06-12','#Foodie'  )
,(115, 16, '2024-06-28','#Travel'  )
,(116, 17, '2024-06-22','#Fitness' );

-- Approach 1: Simple aggregate SQL
select tweet as hashtag, count(*) as count 
       from Tweets 
   group by 1 
   order by 2 desc, 1 desc limit 3 ;

-- Approach 2: Using Windows function  
with tweet_ranked as (
select tweet as hashtag, count(*) as count,
       row_number() over(order by count(*) desc, tweet desc) as rnk 
       from Tweets 
   group by 1 )
select hashtag, count 
       from tweet_ranked 
      where rnk <= 3
   order by 2 desc, 1 desc;

Truncate table Tweets;
insert into Tweets (user_id, tweet_id, tweet, tweet_date) values 
 (135, 13, 'Enjoying a great start to the day. #HappyDay', '2024-02-01')
,(136, 14, 'Another #HappyDay with good '                , '2024-02-03')
,(137, 15, 'Productivity peaks! #WorkLife'               , '2024-02-04')
,(138, 16, 'Exploring new tech frontiers. #TechLife'     , '2024-02-04')
,(139, 17, 'Gratitude for todays moments. #HappyDay'     , '2024-02-05')
,(140, 18, 'Innovation drives us. #TechLife'             , '2024-02-07')
,(141, 19, 'Connecting with natures serenity. #Nature'   , '2024-02-09');

-- Approach 3: Using Substring_index function 
select substring_index(substring_index(tweet, '#',-1),' ',1) as hashtag,
       count(*) as count 
from Tweets 
group by 1 order by 2 desc, 1 desc limit 3;

-- Approach 4: Using Regular Expression 
select regexp_substr(tweet, '#[^\\s]+') as hashtag,
       count(*) as hashtag_count
       from Tweets
   group by 1 
   order by 2 desc, 1 desc limit 3;
