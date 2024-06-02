-- Top Three Wineries - Fill in the blanks too
/* 
conditions 
1. If you see output, its at country level. For every country, we have only one record. Even this, we have talked about it before.
2. If you see the wineary name, its the actual wineary name and the points next to it. 
3. If you see the input data, one wineary have more than one record. 
4. If there is more than one wineary with same points, then you sort based on points and then by wineary name
5. If there is no second or third wineary, then replace with "No second wineary" and 'No third wineary'
*/ 

-- English Video: https://www.youtube.com/watch?v=M45ubdAk5b8
-- Tamil Video: Pending 

Create table if Not Exists Wineries ( id int, country varchar(60), points int, winery varchar(60));

Truncate table Wineries;
insert into Wineries (id, country, points, winery) values 
 (103, 'Australia', 84, 'Whispering Pines')
,(737, 'Australia', 85, 'Grapes Galore')
,(848, 'Australia', 100, 'Harmony Hill')
,(222, 'Hungary', 60, 'Moonlit Cellars')
,(116, 'USA', 47, 'Royal Vines')
,(124, 'USA', 45, 'Eagles Nest')
,(648, 'India', 69, 'Sunset Vines')
,(894, 'USA', 39, 'Royal Vines')
,(677, 'USA', 9, 'Pacific Crest')
,(960,'Spain',91,'AzureWinery')
,(723,'Spain',73,'GoldenGrapes')
,(778,'Spain',59,'SilverOak')
,(715,'Spain',62,'VineyardA')
,(130,'Spain',73,'WineWharf');

/* 
+-----------+---------------------+-------------------+----------------------+
| country   | top_winery          | second_winery     | third_winery         |
+-----------+---------------------+-------------------+----------------------+
| Australia | Harmony Hill (100)  | Grapes Galore (85)| Whispering Pines (84)|
| Hungary   | Moonlit Cellars (60)| No second winery  | No third winery      | 
| India     | Sunset Vines (69)   | No second winery  | No third winery      |  
| Spain     | Azure Winery (91)   | Golden Grapes (73)| Wine Wharf (73)      |
| USA       | Royal Vines (86)    | Eagles Nest (45)  | Pacific Crest (9)    | 
+-----------+---------------------+-------------------+----------------------+
*/ 

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

/* 
additional data 
insert into Wineries (id, country, points, winery) values
 (986,'India',100,'MysticCellars')
,(562,'Switzerland',76,'CrimsonBottles')
,(289,'Switzerland',61,'SilverOak')
,(728,'Australia',13,'MysticCellars')
,(410,'Argentina',12,'TropicalWines')
,(929,'Italy',77,'LushWines')
,(563,'Japan',84,'StarWine')
,(738,'France',68,'GoldenGrapes')
,(160,'Italy',25,'HarmonyHill')
,(347,'Japan',4,'WineWharf')
,(575,'NewZealand',57,'PacificCrest')
,(962,'Chile',67,'GreenHarvest')
,(755,'SouthAfrica',64,'VineyardA')
,(778,'Spain',59,'SilverOak')
,(384,'Austria',71,'NectarVineyards')
,(960,'Spain',91,'AzureWinery')
,(422,'Germany',66,'RusticBarrels')
,(130,'Spain',73,'WineWharf')
,(210,'Brazil',14,'WineCrafters')
,(397,'Brazil',9,'VineyardA')
,(967,'France',28,'CrimsonBottles')
,(153,'Hungary',49,'WhisperingPines')
,(506,'Austria',10,'PacificCrest')
,(744,'Chile',100,'CasaDelVino')
,(376,'NewZealand',12,'RusticBarrels')
,(440,'France',53,'WineWharf')
,(220,'Argentina',32,'WhisperingPines')
,(203,'France',8,'MysticCellars')
,(916,'Hungary',23,'CasaDelVino')
,(672,'Chile',58,'RoyalVines')
,(295,'Argentina',54,'SilverOak')
,(492,'USA',51,'EaglesNest')
,(317,'France',35,'WineCrafters')
,(922,'China',39,'HarmonyHill')
,(120,'Chile',24,'LushWines')
,(974,'Japan',83,'PacificCrest')
,(202,'Italy',19,'CrimsonBottles')
,(552,'Portugal',2,'WineWharf')
,(724,'NewZealand',38,'LushWines')
,(175,'Spain',12,'CrimsonBottles')
,(696,'Germany',2,'MountainVines')
,(477,'Canada',80,'MysticCellars')
,(230,'China',62,'CellarDoor')
,(688,'Argentina',50,'StarWine')
,(742,'Argentina',40,'NectarVineyards')
,(333,'Japan',32,'SunnySlope')
,(294,'Australia',95,'SilverOak')
,(667,'Chile',88,'LushWines')
,(594,'Japan',11,'EaglesNest')
,(148,'USA',14,'WineOasis')
,(624,'Portugal',31,'SunnySlope')
,(821,'Brazil',33,'EaglesNest')
,(943,'Japan',63,'RusticBarrels')
,(632,'Australia',93,'GoldenGrapes')
,(229,'Germany',62,'TropicalWines')
,(769,'Japan',79,'GoldenGrapes')
,(386,'Chile',27,'SunnySlope')
,(116,'Spain',35,'EaglesNest')
,(556,'Germany',8,'WineOasis')
,(280,'SouthAfrica',48,'RoyalVines')
,(685,'Argentina',12,'HarvestMoon')
,(241,'Greece',43,'CasaDelVino')
,(850,'Switzerland',75,'MoonlitCellars')
,(704,'Italy',3,'WineHaven')
,(466,'SouthAfrica',5,'VineyardA')
,(712,'Spain',62,'GoldenGrapes')
,(848,'SouthAfrica',41,'MoonlitCellars')
,(174,'Spain',58,'TropicalWines')
,(476,'Italy',95,'SunnySlope')
,(820,'Argentina',44,'HarvestMoon')
,(186,'Hungary',10,'WineCrafters')
,(977,'Austria',4,'WineCrafters')
,(611,'China',2,'MountainVines')
,(491,'Brazil',75,'VineyardA')
,(723,'Spain',11,'GoldenGrapes')
,(754,'USA',33,'HarmonyHill')
,(526,'NewZealand',50,'NectarVineyards')
,(852,'China',59,'MysticCellars')
,(573,'India',11,'RoyalVines')
,(868,'Switzerland',4,'RusticBarrels')
,(715,'Spain',62,'VineyardA')
,(335,'USA',64,'WineWharf')
,(729,'Hungary',33,'HarmonyHill')
,(111,'Canada',39,'MoonlitCellars')
,(794,'Japan',26,'RoyalVines')
,(273,'NewZealand',85,'NectarVineyards')
,(610,'Germany',42,'LushWines')
,(781,'Portugal',26,'SilverOak')
,(541,'Chile',28,'LushWines')
,(324,'China',41,'CrimsonBottles')
,(239,'Argentina',64,'HarvestMoon')
,(957,'Italy',92,'GoldenGrapes')
,(383,'Australia',15,'MysticCellars')
,(582,'Portugal',28,'CellarDoor')
,(523,'Brazil',81,'RoyalVines')
,(605,'NewZealand',92,'CellarDoor')
,(739,'Greece',42,'GoldenGrapes')
,(948,'Italy',36,'WineCrafters')
,(722,'Italy',87,'WhisperingPines')
,(387,'China',46,'RusticBarrels')
,(764,'China',3,'SilverOak')
,(514,'Greece',25,'VineyardA')
,(887,'Portugal',31,'WineWharf')
,(244,'Italy',81,'SunsetVines')
,(557,'USA',81,'TropicalWines')
,(770,'Canada',10,'CasaDelVino')
,(302,'Chile',61,'AzureWinery')
,(282,'France',97,'WineHaven')
,(647,'Italy',23,'GreenHarvest')
,(378,'Canada',70,'WhisperingPines')
,(612,'Japan',97,'StarWine');

Expected 
| country     | top_winery            | second_winery        | third_winery         |
| ----------- | --------------------- | -------------------- | -------------------- |
| Argentina   | HarvestMoon (120)     | SilverOak (54)       | StarWine (50)        |
| Australia   | SilverOak (95)        | GoldenGrapes (93)    | MysticCellars (28)   |
| Austria     | NectarVineyards (71)  | PacificCrest (10)    | WineCrafters (4)     |
| Brazil      | VineyardA (84)        | RoyalVines (81)      | Eagle'sNest (33)     |
| Canada      | MysticCellars (80)    | WhisperingPines (70) | MoonlitCellars (39)  |
| Chile       | LushWines (140)       | CasaDelVino (100)    | GreenHarvest (67)    |
| China       | CellarDoor (62)       | MysticCellars (59)   | RusticBarrels (46)   |
| France      | WineHaven (97)        | GoldenGrapes (68)    | WineWharf (53)       |
| Germany     | RusticBarrels (66)    | TropicalWines (62)   | LushWines (42)       |
| Greece      | CasaDelVino (43)      | GoldenGrapes (42)    | VineyardA (25)       |
| Hungary     | WhisperingPines (49)  | HarmonyHill (33)     | CasaDelVino (23)     |
| India       | MysticCellars (100)   | RoyalVines (11)      | No third winery      |
| Italy       | SunnySlope (95)       | GoldenGrapes (92)    | WhisperingPines (87) |
| Japan       | StarWine (181)        | PacificCrest (83)    | GoldenGrapes (79)    |
| NewZealand  | NectarVineyards (135) | CellarDoor (92)      | PacificCrest (57)    |
| Portugal    | WineWharf (33)        | SunnySlope (31)      | CellarDoor (28)      |
| SouthAfrica | VineyardA (69)        | RoyalVines (48)      | MoonlitCellars (41)  |
| Spain       | AzureWinery (91)      | GoldenGrapes (73)    | WineWharf (73)       |
| Switzerland | CrimsonBottles (76)   | MoonlitCellars (75)  | SilverOak (61)       |
| USA         | TropicalWines (81)    | WineWharf (64)       | Eagle'sNest (51)     |

*/ 

