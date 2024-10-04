-- 
use aircargo;
show tables;
-- 1.	Create an ER diagram for the given airlines database.

-- 2.	Write a query to create a route_details table using suitable data types for the fields, such as route_id, flight_num, origin_airport, destination_airport, aircraft_id, and distance_miles. Implement the check constraint for the flight number and unique constraint for the route_id fields. Also, make sure that the distance miles field is greater than 0
create table route_details ( route_id int not null, flight_num varchar(20), origin_airport varchar(200) not null, destination_airport varchar(200) not null, aircraft_id varchar(40) not null, distance_miles int , check (flight_num is not null), unique (route_id), check(distance_miles >0));
select * from route_details;

-- 3.	Write a query to display all the passengers (customers) who have travelled in routes 01 to 25. Take data from the passengers_on_flights table.
select * from passengers_on_flights where route_id >=1 and route_id<=25;

-- 4.	Write a query to identify the number of passengers and total revenue in business class from the ticket_details table.
select count(customer_id) as 'total passengers' , sum(price_per_ticket) as 'revenue_business_class' from ticket_details where class_id = 'bussiness';

-- 5.	Write a query to display the full name of the customer by extracting the first name and last name from the customer table.
select concat(first_name,' ', last_name) as full_name from customer;

-- 6.	Write a query to extract the customers who have registered and booked a ticket. Use data from the customer and ticket_details tables.
select customer_id , concat(first_name, ' ' , last_name) as Name_of_passenger, count(no_of_tickets) as Total_Tickets_booked from customer join ticket_details using (customer_id) group by customer_id, Name_of_passenger order by Total_tickets_booked;

-- 7.	Write a query to identify the customer’s first name and last name based on their customer ID and brand (Emirates) from the ticket_details table.
select first_name, last_name, customer_id from customer join ticket_details using (customer_id) where brand='Emirates';

-- 8.	Write a query to identify the customers who have travelled by Economy Plus class using Group By and Having clause on the passengers_on_flights table
select customer_id, class_id, concat(first_name,' ',last_name) as passengers_travelled from customer join passengers_on_flights using (customer_id) group by customer_id, class_id, passengers_travelled having (class_id) ='economy plus';

-- 9.	Write a query to identify whether the revenue has crossed 10000 using the IF clause on the ticket_details table.
select sum(price_per_ticket*no_of_tickets) as Total_Revenue , if(sum(price_per_ticket*no_of_tickets) > 10000 , 'Yes','No') as Revenue_crossed_10000 from ticket_details;

-- 10.	Write a query to create and grant access to a new user to perform operations on a database.
  select user, host from mysql.user ; create user 'Demo_projectuser'@'localhost'; grant all on aircargo.* to 'Demo_projectuser'@'localhost';

-- 11.	Write a query to find the maximum ticket price for each class using window functions on the ticket_details table. 
  Select distinct class_id, max(price_per_ticket) over (partition by class_id) as max_price_per_class from ticket_details;
  
-- 12.	Write a query to extract the passengers whose route ID is 4 by improving the speed and performance of the passengers_on_flights table.
 select customer_id, concat(first_name,' ',last_name) as Full_name from customer join passengers_on_flights using (customer_id) where route_id=4;
 
-- 13.	 For the route ID 4, write a query to view the execution plan of the passengers_on_flights table.
select customer_id, concat(first_name,' ',last_name) as Full_name, aircraft_id, depart, arrival, seat_num, class_id, travel_date flight_num from customer join passengers_on_flights using (customer_id) where route_id=4;

-- 14.	Write a query to calculate the total price of all tickets booked by a customer across different aircraft IDs using rollup function. 
select aircraft_id, sum(price_per_ticket*no_of_tickets) as total_price from ticket_details group by aircraft_id with rollup;

-- 15.	Write a query to create a view with only business class customers along with the brand of airlines. 
create view customers_businessclass as select customer_id, concat(first_name,' ',last_name) as customer_name, class_id, brand from ticket_details join customer using(customer_id) where class_id='bussiness';
select * from customers_businessclass;

-- 16.	Write a query to create a stored procedure to get the details of all passengers flying between a range of routes defined in run time. Also, return an error message if the table doesn't exist.'
-- following procedure created - CREATE DEFINER=`root`@`localhost` PROCEDURE `passengers_flying_between_range`(in route_id1 int , in route_id2 int) BEGIN select rd.route_id, pf.customer_id, c.first_name, c.last_name from routes rd  inner join passengers_on_flights pf on rd.route_id = pf.route_id left join customer c using (customer_id) where rd.route_id between route_id1 and route_id2;  END
call passengers_flying_between_range(8 , 18);

-- 17.	Write a query to create a stored procedure that extracts all the details from the routes table where the travelled distance is more than 2000 miles.
-- query for stored procedure: CREATE DEFINER=`root`@`localhost` PROCEDURE `routes_details`() BEGIN SELECT * FROM routes WHERE distance_miles > 2000; END call routes_details;
call routes_details;

-- 18.	Write a query to create a stored procedure that groups the distance travelled by each flight into three categories. The categories are, short distance travel (SDT) for >=0 AND <= 2000 miles, intermediate distance travel (IDT) for >2000 AND <=6500, and long-distance travel (LDT) for >6500.
-- CREATE DEFINER=`root`@`localhost` PROCEDURE `distance_travelled_grouping`(in flight_num1 int) BEGIN select * , case when distance_miles >= 0 and distance_miles<=2000 then 'short distance' when distance_miles>2000 and distance_miles<=6500 then 'intermediate distance' else 'long distance'  end as category from routes where flight_num = flight_num1; END call distance_travelled_grouping(1125);
  -- stored procedure is created
  call distance_travelled_grouping(1122);
  
-- 19.	Write a query to extract ticket purchase date, customer ID, class ID and specify if the complimentary services are provided for the specific class using a stored function in stored procedure on the ticket_details table. 
	-- Condition: ●	If the class is Business and Economy Plus, then complimentary services are given as Yes, else it is No
	-- CREATE DEFINER=`root`@`localhost` PROCEDURE `complementary_services_availability`(in customer_id1 int) BEGIN select p_date, customer_id, class_id , case when class_id = 'bussiness class' or class_id = 'economy plus' then 'complimentary services' else ' no complementary services' end as service_distribition from ticket_details where customer_id = customer_id1; END
call complementary_services_availability(10);

-- 20.	Write a query to extract the first record of the customer whose last name ends with Scott using a cursor from the customer table.
call firstrecord_LNscott;
 
 


 
 
 










