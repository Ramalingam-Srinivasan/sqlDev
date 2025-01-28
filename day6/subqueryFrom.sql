select * from payment

select customer_id,sum(amount) as total_amount from payment
group by 1 

select round(avg(total_amount),2) as avg_total_amount from
(select customer_id,sum(amount) as total_amount from payment
group by 1) as subquery


select round(avg(total_amount),2) as avg_total_amount from
(select date(payment_date),sum(amount) as total_amount from payment
group by 1) as subquery