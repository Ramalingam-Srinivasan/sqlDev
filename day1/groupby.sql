select sum(amount),payment_id from payment group by 2

select staff_id , 
date(payment_date) as paymnt_dt , 
sum (amount) as total_amount,
count(*) as cnt 
from payment
group by 1,2 
having count(*) > 400
order by cnt desc