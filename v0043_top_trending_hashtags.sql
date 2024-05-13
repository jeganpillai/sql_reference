-- Question: Find the top trending tweets

-- English Video: 
-- Tamil Video: 

Create table Tweets (
  user_id int, tweet_id int,  tweet_date date, tweet varchar(100));
Truncate table Tweets;
insert into Tweets (user_id, tweet_id, tweet, tweet_date) values 
 (135, 13, 'Enjoying a great start to the day. #HappyDay #MorningVibes', '2024-05-01')
,(136, 14, 'Another #HappyDay with good vibes! #FeelGood'              , '2024-05-03')
,(137, 15, 'Productivity peaks! #WorkLife #ProductiveDay'              , '2024-05-04')
,(138, 16, 'Exploring new tech frontiers. #TechLife #Innovation'       , '2024-05-04')
,(139, 17, 'Gratitude for todays moments. #HappyDay #Thankful'         , '2024-05-05')
,(140, 18, 'Innovation drives us. #TechLife #FutureTech'               , '2024-05-07')
,(141, 19, 'Connecting with natures serenity. #Nature #Peaceful'       , '2024-05-09');

with RECURSIVE tags as (
select user_id, tweet_id, tweet_date,
       regexp_substr(tweet, '#[^\\s]+') as hashtag,
       regexp_replace(tweet, '#[^\\s]+','?',1,1) as new_tweet
       from Tweets
union all 
select user_id, tweet_id, tweet_date,
       regexp_substr(new_tweet, '#[^\\s]+') as hashtag,
       regexp_replace(new_tweet, '#[^\\s]+','?',1,1) as new_tweet
       from tags
       where hashtag is not null )
,all_tags as (
select hashtag
       ,count(*) as count 
       ,dense_rank() over (order by count(*) desc, hashtag desc) as rnk 
       from tags 
      where hashtag is not null 
   group by 1)
select hashtag, count from all_tags 
       where rnk <= 3
    order by 2 desc, 1 desc;
