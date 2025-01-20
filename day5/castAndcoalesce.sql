select * from flights

select 
actual_arrival-scheduled_arrival from flights

--will get error for below query to fix this next solution
select 
coalesce(actual_arrival-scheduled_arrival,'Not arrived') from flights

select 
coalesce(actual_arrival-scheduled_arrival,'0:00') from flights


select 
coalesce(cast(actual_arrival-scheduled_arrival as varchar),'Not arrived') from flights

--replace function

select * from tickets

select replace(passenger_id,' ','') from tickets


select cast(replace(passenger_id,' ','') as Bigint) from tickets


select * from flights

select
flight_no,
replace(flight_no,'PG','') from flights

select 
flight_no,
cast(replace(flight_no,'PG','') as int) from flights