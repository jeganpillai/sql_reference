-- Top Three Wineries - Fill in the blanks too
/* 
conditions 
1. If you see output, its at country level. For every country, we have only one record. Even this, we have talked about it before.
2. If you see the wineary name, its the actual wineary name and the points next to it. 
3. If you see the input data, one wineary have more than one record. 
4. If there is more than one wineary with same points, then you sort based on points and then by wineary name
5. If there is no second or third wineary, then replace with "No second wineary" and 'No third wineary'
*/ 
-- Video: https://youtu.be/M45ubdAk5b8

-- Approach 1: using Windows function
with ranking_winery as (
select country, winery, sum(points) as points
,rank() over(partition by country order by country, sum(points) desc, winery) as rnk 
from Wineries
group by 1,2 )
select w.country
,max(case when w.rnk = 1 then concat(w.winery,' (',w.points,')') end) as top_winery
,coalesce(max(case when w.rnk = 2 then concat(w.winery,' (',w.points,')') end), 'No second winery')  as second_winery
,coalesce(max(case when w.rnk = 3 then concat(w.winery,' (',w.points,')') end), 'No third winery') as third_winery
from ranking_winery w 
group by 1;

-- Approach 2: using Self Join (Incomplete - Work in Progress)
with total_points as (
select country, winery, sum(points) as points
       from Wineries
   group by 1,2)
,ranking_winery as (
select a.country, a.winery, a.points 
      ,count(b.winery) as rnk
      from total_points a 
inner join total_points b 
        on b.country = a.country 
       and a.points <= b.points
  group by 1,2,3)
select w.country
      ,max(case when w.rnk = 1 then w.winery end) as top_winery
      ,coalesce(max(case when w.rnk = 2 then w.winery end), 'No second winery')  as second_winery
      ,coalesce(max(case when w.rnk = 3 then w.winery end), 'No third winery') as third_winery
      from ranking_winery w 
  group by 1 order by 1;

