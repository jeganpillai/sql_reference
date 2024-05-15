-- Question: List Down the Invalid Tweets 

-- English Video: 
-- Tamil Video: 

Create table Tweets(tweet_id int, content varchar(500));
Truncate table Tweets;
insert into Tweets (tweet_id, content) values 
 ( 1, 'What an amazing meal @MaxPower @AlexJones @JohnDoe #Learning #Fitness #Love')
,( 2, 'Learning something new every day @AnnaWilson #Learning #Foodie')
,( 3, 'Never been happier about todays achievements @SaraJohnson @JohnDoe @AnnaWilson #Fashion')
,( 4, 'Traveling, exploring, and living my best life @JaneSmith @JohnDoe @ChrisAnderson @AlexJones #WorkLife #Travel')
,( 5, 'Work hard, play hard, and cherish every moment @AlexJones #Fashion #Foodie')
,( 6, 'Never been happier about todays achievements @ChrisAnderson #Fashion #WorkLife')
,( 7, 'So grateful for todays experiences @AnnaWilson @LisaTaylor @ChrisAnderson @MikeBrown #Fashion #HappyDay #WorkLife #Nature')
,( 8, 'What an amazing meal @EmilyClark @AlexJones @MikeBrown #Fitness')
,( 9, 'Learning something new every day @EmilyClark @AnnaWilson @MaxPower #Travel')
,(10, 'So grateful for todays experiences @ChrisAnderson #Nature')
,('11', 'So grateful for todays experiences @AlexJones #Art #WorkLife')
,('12', 'Learning something new every day @JaneSmith @MikeBrown #Travel')
,('13', 'What an amazing meal @EmilyClark @JohnDoe @LisaTaylor @MaxPower #Foodie #Fitness')
,('14', 'Work hard, play hard, and cherish every moment @LisaTaylor @SaraJohnson @MaxPower @ChrisAnderson #TechLife #Nature #Music')
,('15', 'What a beautiful day it is @EmilyClark @MaxPower @SaraJohnson #Fashion')
,('16', 'What a beautiful day it is @AnnaWilson @JaneSmith #Fashion #Love #TechLife');

-- Approach 1: replace the symbol to blank and compare with full 
select tweet_id 
       from Tweets 
where length(content) > 140
or length(content) - length(replace(content, '@','')) > 3 
or length(content) - length(replace(content, '#','')) > 3; 

-- Approach 2: Using substring and count the availability
select tweet_id 
       from Tweets 
      where    length(content) > 140
            or regexp_substr(content, '@', 1,4) is not null 
            or regexp_substr(content, '#', 1,4) is not null;
