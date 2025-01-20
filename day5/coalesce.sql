select * from rental

select 
rental_date,
coalesce(cast(return_date as varchar), 'not returned')
from 
rental
order by rental_date desc
