SELECT * FROM bookings.bookings
ORDER BY book_ref ASC 

-----you need to find out how many tickets you have sold in the following categories
--low price : total_amount< 20000
--mid price : total_amount between 20000  and 50000
--high price : total_amount >=150000
-- how many high price tickets has the company sold 


select 
count(1),
case 
when total_amount < 20000 then 'low price'
when total_amount < 150000 then 'mid price'
else 'high price'
end as ticket_price
from bookings.bookings
group by 2


--2. you need to find out how many flights are scheduuled for departure int he following seasons.
--winter - > december,january,february
--spring -- >march , april , may
--summer - > june , july ,august
--fall : sep , oct ,novem


select 
count(1) as flights ,
case
when extract (month from scheduled_departure) in (12,1,2) then 'winter'
when extract (month from scheduled_departure )  <=5 then 'spring'
when extract (month from scheduled_departure ) <=8  then 'summer'
else 'fall'
end as seasons
from flights
group by 2


--Challenge 3:

SELECT
title,
CASE
WHEN rating IN ('PG','PG-13') OR length > 210 THEN 'Great rating or long (tier 1)'
WHEN description LIKE '%Drama%' AND length>90 THEN 'Long drama (tier 2)'
WHEN description LIKE '%Drama%' THEN 'Short drama (tier 3)'
WHEN rental_rate<1 THEN 'Very cheap (tier 4)'
END as tier_list
FROM film
WHERE 
CASE
WHEN rating IN ('PG','PG-13') OR length > 210 THEN 'Great rating or long (tier 1)'
WHEN description LIKE '%Drama%' AND length>90 THEN 'Long drama (tier 2)'
WHEN description LIKE '%Drama%' THEN 'Short drama (tier 3)'
WHEN rental_rate<1 THEN 'Very cheap (tier 4)'
END is not null
