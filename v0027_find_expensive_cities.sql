-- Question: Find Expensive Cities. Cities are expensive, if the cities average home prices exceed the national average home price.
-- Video: https://www.youtube.com/watch?v=3v0GtTyAT38

Create Table if Not Exists Listings (listing_id int, city varchar(50), price int);
Truncate table Listings;
insert into Listings (listing_id, city, price) values 
 ('113', 'LosAngeles', '7560386')
,('136', 'SanFrancisco', '2380268')
,('92', 'Chicago', '9833209')
,('60', 'Chicago', '5147582')
,('8', 'Chicago', '5274441')
,('79', 'SanFrancisco', '8372065')
,('37', 'Chicago', '7939595')
,('53', 'LosAngeles', '4965123')
,('178', 'SanFrancisco', '999207')
,('51', 'NewYork', '5951718')
,('121', 'NewYork', '2893760');

-- Approach 1: General Sub Query
select city
      from Listings 
  group by city 
    having avg(price) >= (select avg(price) from Listings )
  order by 1;

-- Approach 2: 
with overall_data as (
select city 
     , avg(price) over() as national_avg 
     , avg(price) over(partition by city) as city_avg
     from Listings )
select city 
      from overall_data 
     where city_avg >= national_avg 
  group by 1 
  order by 1 ; 
