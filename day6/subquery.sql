--select all of the films where length is 	longer than the avg of all films

select * from film

select film_id , title from film
where length(title) > (select avg(length(title)) from film)


--2. return all the films that are available in the inventory in store 2 for more than 3 times

select * from film where film_id in 
(select film_id from inventory where store_id = 2 group by film_id having count(*) > 3)


--select all the customers first name and last name that have made a payment on '2020-01-25'

select first_name , last_name  from customer where customer_id in (select customer_id 
from payment where date(payment_date) = '2020-01-25')


-- return all the customers first name and email that have spent more than 30 $

select first_name,email from customer where customer_id in (

select customer_id from payment group by customer_id having sum(amount) > 30
)

--return all the customers that are from california and have spent more than 100 in total 


select first_name,email from customer where
customer_id in (
select customer_id from payment group by customer_id having sum(amount) > 100
) and 
customer_id in (
select customer_id from customer c inner join address ad on c.address_id = ad.address_id
where district = 'California'
)