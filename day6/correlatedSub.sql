--show only those payments that have the highes amount per customer


select * from payment

select customer_id,amount from payment p1 where amount = (select max(amount) from payment p2 

where p1.customer_id = p2.customer_id) order by 1 desc

--show only those movie titles , their film_id and replacement_cost with the lowest replacement_costs 
--for in the each rating category - also show the rating

select * from film


select title,film_id,replacement_cost,rating from film f1 
where replacement_cost = (select min(replacement_cost) from film f2
where f1.rating = f2.rating )

--show only those movie titles , their film_id and length with the highest length 
--for in the each rating category - also show the rating

select title,film_id,length,rating from film f1 
where length = (select max(length) from film f2
where f1.rating = f2.rating )


--correlated subqueries in select 
--show the maimum amount for every customer
select * , 
(select max(amount) from payment p2
where p1.customer_id = p2.customer_id ) 
from payment p1  order by customer_id
