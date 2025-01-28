select * from payment

select *,(select round(avg(amount),2) from payment) from payment

select * , (select amount from payment) from payment

select * , (select amount from payment limit 1) from payment

-- show all the payment together with how much payment amount is below the maximum the payment amount

select * , ((select max(amount) from payment)-amount) as difference_amount from payment