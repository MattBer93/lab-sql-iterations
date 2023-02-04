use sakila;

-- Write a query to find what is the total business done by each store.
select store_id, sum(amount) as total_per_store
from payment
join customer using (customer_id)
group by store_id;


-- Convert the previous query into a stored procedure.
delimiter // 
create procedure total_per_store()
begin 
	select store_id, sum(amount) as total_per_store
	from payment
	join customer using (customer_id)
	group by store_id;
end
// delimiter ;

call total_per_store();

drop procedure if exists total_per_store; 

-- Convert the previous query into a stored procedure that takes the input for store_id and 
-- displays the total sales for that store.

-- Passing it as a PARAMENTERs
DELIMITER //
create procedure total_per_store(in store_id int,out total_amout float)
begin
	select s.store_id,sum(p.amount) as total_business from payment p
	join staff s on s.staff_id = p.staff_id
	group by s.store_id
	having s.store_id = store_id;
 end //
DELIMITER ;
call total_per_store(2, @total_sales_value);


-- Update the previous query. Declare a variable total_sales_value of float type, 
-- that will store the returned result (of the total sales amount for the store). 
-- Call the stored procedure and print the results.
-- Declaring TOTAL INSIDE the procedure
DELIMITER //
create procedure total_per_store_var(in store_id int)
begin
	declare total_sales_value float;
	select sum(p.amount) into total_sales_value
    from payment p
	join staff s on s.staff_id = p.staff_id
	group by s.store_id
	having s.store_id = store_id;
    select total_sales_value; 
 end //
DELIMITER ;
call total_per_store_var(2);


-- In the previous query, add another variable flag. 
-- If the total sales value for the store is over 30.000, then label it as green_flag, 
-- otherwise label is as red_flag. Update the stored procedure that takes an input as the store_id 
-- and returns total sales value for that store and flag value.
DELIMITER //
create procedure total_per_store_var_flag(in store_id int)
begin
	declare total_sales_value float;
    declare flag varchar(10) default "";
	select sum(p.amount) into total_sales_value
    from payment p
	join staff s on s.staff_id = p.staff_id
	group by s.store_id
	having s.store_id = store_id;
    
    if total_sales_value >= 30000 then
		set flag = 'Green';
	else
		set flag = 'Red';
	end if;
    
    
    select total_sales_value, flag; 
 end //
DELIMITER ;
call total_per_store_var_flag(2);





