select right(left(first_name,3),1) , first_name from customer


--concatenate

select left(first_name,1) || '.' || left(last_name,1) AS initials , first_name,last_name from customer


select left(email,1) || '***' || right(email,19) from customer	

--position


select 
left (email,position('@' in email)) from customer

select 
left (email,position('@' in email)-1) from customer

select 
right(left (email,position('@' in email)-1),position('.' in email)) || ',' || left (email,position(last_name in email)-2) from customer


select last_name || ',' || left(email,position('.' in email)-1) from customer


--substring


select email , substring (email  from position('.' in email)+1 for length(last_name)) from customer

select email , substring (email from position('.' in email)+1 for position('@' in email) - position('.' in email)-1) from customer


select email , substring (email  from 1 for 1) || '***.' || 
substring (email  from position('.' in email)+1 for 1) || '***' || 
substring (email  from position('@' in email) ) from customer



--extract

select * from rental

select extract(day from rental_date) as dayofmonth,count(*)
from rental 
group by  dayofmonth 
order by dayofmonth


-- 1. whats the month with highest total payment ammount?

select * from payment

select sum(amount) , extract(month from payment_date) as mnth FROM payment
group by mnth order by 1



--2 . whats the day of week with highst total payment amount?

select sum(amount) as payment_amount , extract(dow from payment_date) as dayofweek from payment
group by dayofweek order by 1 desc

--3.whats the highest amount a customer has spent in a week?
select customer_id,max(amount) , extract(week from payment_date) as week from payment
group by 1,3 order by 1 


--to_char

select sum(amount) , 
to_char(payment_date,'day,month yyyy') as char_date
from payment 
group by char_date

select sum(amount)as total_amount , 
to_char(payment_date,'day,dd/MM/yyyy') as char_date
from payment 
group by char_date

select sum(amount)as total_amount , 
to_char(payment_date,'Month,yyyy') as char_date
from payment 
group by char_date

select sum(amount)as total_amount , 
to_char(payment_date,'day,HH:ss') as char_date
from payment 
group by char_date

--time intervals

select current_timestamp , extract(day from return_date - rental_date)*24 + 
extract(hour from return_date-rental_date) || 'hours'
from rental

--find rental duration of customer with custoemr id = 35
-- find wich cutomer has the longest avg rental duration

select * from rental

select customer_id , return_date - rental_date
from rental
where customer_id = 35

select customer_id , avg(return_date - rental_date) as rental_avg_date
from rental
group by 1
order by rental_avg_date desc


-----------------------------

-- get the odd numbered customer
select * from customer

select first_name , 
case 
when customer_id%2 =1 then customer_id
else null
end as customer_id
from customer

select * from customer where 
mod(customer_id,2)=1

select * from customer where 
customer_id%2 =1