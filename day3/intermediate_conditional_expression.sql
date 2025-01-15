--basic mathematics

select 
8/4

select 
round(9.0/2,2)


select film_id,
rental_rate as old_rental_rate,
(rental_rate+1) as new_rental_rate
from film

select film_id,
rental_rate as old_rental_rate,
ceil(rental_rate*1.4) as new_rental_rate
from film

select film_id,
rental_rate as old_rental_rate,
ceil(rental_rate*1.4) -0.01 as new_rental_rate
from film



---------------problem------------------

--to increase the price for films that are more expensive to replace 
--create a list of films including the relation of rental rate /replacemet cost
--where rental rate is less than 4 % of replacement cost
--create a list of that film_ids together with the percentage rounded to 2 decimal points for example 3.54%

select
film_id,
round(rental_rate/replacement_cost*100,2) as percentage 
from 
film 
where round(rental_rate/replacement_cost*100,2) < 4
order by 2 asc


--case statement 

select
total_amount,
to_char(book_date,'Dy'),
case 
	when to_char(book_date,'Dy') = 'Mon' then 'monday special'
	when total_amount<30000 then 'special discount'
	else 'no discount'
end
from bookings

--Using the sales_orders table, write a SQL query to select the order_id, product_id, quantity, unit_price, and a new column named total_price. The total_price should be calculated as follows:

--If a customer orders more than 1 unit of any product, they get a 10% discount on the total price for those products before adding the shipping fee.

--The total_price should include the shipping fee.

select order_id,product_id,quantity,unit_price,
case
when quantity >1 then (quantity*unit_price*0.9 ) + shipping_fee
else quantity*unit_price + shipping_fee
end as total_price
from sales_orders




------------------------------------------

select * from film


select 
rating,
sum (case 
when rating in ('PG','G') then 1
else 0
end)as total_ratings
from film 
group by 1
--------------------------------

--make pivot like using case statement

select 
sum(case when rating = 'G' then 1 else 0 end ) as "G",
sum(case when rating = 'R' then 1 else 0 end ) as "R",
sum(case when rating = 'NC-17' then 1 else 0 end ) as "NC-17",
sum(case when rating = 'PG-13' then 1 else 0 end ) as "PG-13",	
sum(case when rating = 'PG' then 1 else 0 end ) as "PG"
from film


