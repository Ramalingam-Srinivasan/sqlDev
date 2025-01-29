--show all the payments plus the total amount for every customer as well as the number of 
--payments of each customer

select p1.* , (select sum(amount)  from payment p2 where 
p2.customer_id = p1.customer_id ) as total_amount  , (select count(payment_id) from payment p3 where 
p3.customer_id = p1.customer_id
)  as total_payment
 from payment p1 order by customer_id desc