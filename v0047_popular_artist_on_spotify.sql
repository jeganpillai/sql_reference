-- Question: v0047_popular_artist_on_spotify

-- English Video: 
-- Tamil Video: 

Create table Spotify (id int,track_name varchar(100),artist varchar(100));
Truncate table Spotify;
insert into Spotify (id, track_name, artist) values 
 (1046089, 'Shape of you'      , 'Sia'       )
,(33445  , 'Im the one'        , 'DJ Khalid' )
,(811266 , 'Young Dumb & Broke', 'DJ Khalid' )
,(303651 , 'Heart Wont Forget' , 'Ed Sheeran')
,(505727 , 'Happier'           , 'Ed Sheeran');

-- Approach 1: Simple aggragate function 
select artist, count(*) as occurrences 
       from Spotify
   group by 1 order by 2 desc, 1;

-- Approach 2: Using Windows function 
select distinct artist,
       count(*) over(partition by artist) as occurrences 
from Spotify
order by 2 desc, 1;

-- Approach 3: Correlated Subquery
select distinct artist,
       (select count(*) from Spotify ss where ss.artist = s.artist)  as occurrences 
from Spotify s
order by 2 desc, 1;
