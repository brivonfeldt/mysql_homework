-- the average rental price of the movies
use sakila;
select 
	avg(rental_rate)
from film;

-- group by of the average price of each rating 
select rating, avg(rental_rate) as rating_rental_avg
from film
group by rating
order by avg(rental_rate) desc;

select rental_duration, count(*), avg(rental_rate) from film group by rental_duration;

-- first and last names of actors
select 
	last_name,
    first_name
 from actor;

-- first and last name together in a new column
select concat(first_name, '  ', last_name) as actor_name from actor;

-- finding actors with the first name Joe
select * 
from sakila.actor
where first_name = 'JOE';

-- last names that contain 'GEN'
select * 
from sakila.actor
where last_name like '%GEN%';

-- last names that contain 'LI' with the change in column order
select actor_id, last_name, first_name
from sakila.actor
where last_name like '%LI%';


-- selecting country info of Afghanistan, Bangladesh and China
use world;
select * from world.country
where name in (
	select distinct name 
    from world.country
    where (name = 'Afghanistan')
    or (name = 'Bangladesh')
    or (name = 'China')
);
	
-- adding description column     
use sakila;    
select *
from sakila.actor;
alter table actor
add column description blob 
after last_update;    

-- deleting description column
select *
from sakila.actor;
alter table actor
drop column description;  

-- getting count of unique last names
select distinct last_name, 
count(last_name) as 'last_name_count'
from actor
group by last_name;


-- getting count of unique last names where there are multiple of the smae last names
select distinct last_name, 
count(last_name) as 'last_name_count'
from actor
group by last_name 
having last_name_count >= 2;

-- finding Groucho Williams to get the actor id
select * 
from sakila.actor
where first_name = 'GROUCHO'
and last_name = 'Williams';

-- updating Groucho's name to Harpo
update sakila.actor
set first_name = 'HARPO'
where actor_id = 172;

-- changing name back to GROUCHO
update sakila.actor
set first_name = 'GROUCHO'
where actor_id = 172;

-- finging like column to join on. 
select *
from sakila.staff;
select *
from sakila.address;


-- joining address and staff tables 
select *
from sakila.staff 
join sakila.address 
on staff.address_id = address.address_id;

-- finging like column to join on. 
select *
from sakila.staff;
select *
from sakila.payment;

-- joining payment and staff tables having transactions between 8/01/2005 and 8/31/2005
select *
from sakila.staff 
join sakila.payment 
on staff.staff_id = payment.staff_id
where payment_date 
between '2005-08-01 00:00:01' 
and '2005-09-01 23:59:59';

-- inner join on film_actor and film showing how many actors are in each film
select film.title, count(film_actor.actor_id) as actor_count
from sakila.film 
inner join sakila.film_actor 
on film.film_id = film_actor.film_id
group by title
order by count(film_actor.actor_id) desc;

-- finding info on Hunchback Impossible film_id =439 
select *
from sakila.film
where title = 'Hunchback Impossible';

-- finding the count of Hunchback Impossible films are in the inventory 
select film.title, count(inventory.inventory_id) as film_inventory_count
from sakila.film
inner join sakila.inventory
on film.film_id = inventory.film_id
where title = 'Hunchback Impossible';

-- finding the total payment of each customer
select customer.first_name, customer.last_name, sum(payment.amount) as total_amount_paid
from sakila.customer 
join sakila.payment
on customer.customer_id = payment.customer_id
group by customer.customer_id
order by last_name asc;

-- finding the language id for English
select *
from sakila.language;

-- finding the english movies that start with K and Q
select *
from sakila.film 
where language_id = 1
and title like 'K%'
or title like 'Q%';

-- finding film id = 17 
select *
from sakila.film
where title = 'Alone Trip';

-- finding the names of the actors in Alone Trip
select last_name, first_name
from sakila.actor
where actor_id in (
	select actor_id	
    from sakila.film_actor
    where film_id in (
		select film_id
        from sakila.film
        where title = 'Alone Trip')
	)
;

-- fininding country code for Canada = 20
select *
from country
where country = 'Canada';


-- finding customers in Canada and their email addresses
use sakila;
select customer.first_name, customer.last_name, customer.email, city.country_id
from customer 
join address
on (customer.address_id = address.address_id)
join city
on (address.city_id = city.city_id)
where country_id = 20;

-- fimding the films cateorized as family films
use sakila;
select film.title, category.name
from film 
join film_category
on (film.film_id = film_category.film_id)
join category
on (film_category.category_id = category.category_id)
where name = 'Family';

-- finding the most frequently rented movies
use sakila;
select film.title, count(rental.rental_id) as rental_count
from rental
join inventory
on (rental.inventory_id = inventory.inventory_id)
join film
on (inventory.film_id = film.film_id)
group by film.film_id
order by rental_count desc;

-- exploring data
select *
from sakila.payment
join sakila.customer
on payment.customer_id = customer.customer_id
join sakila.address
on customer.address_id = address.address_id
join sakila.city
on address.city_id = city.city_id
join sakila.country
on city.country_id = country.country_id 
group by country.country desc; 


-- Sales in the Canada store earnings converted to US dollars
-- 1 Australian dollar to 0.74 US dollars
select store.store_id, (sum(payment.amount)*0.74) as total_store_earnings
from store
join staff
on store.store_id = staff.store_id
join payment
on staff.staff_id = payment.staff_id
where store.store_id = 1;


-- Sales in the Australia store earnings converted to US dollars
-- 1 Australian dollar to 0.70 US dollars
select store.store_id, (sum(payment.amount)*0.70) as total_store_earnings
from store
join staff
on store.store_id = staff.store_id
join payment
on staff.staff_id = payment.staff_id
where store.store_id = 2;

-- finding where the stores are located to get the correct currency conversion
select store.store_id, city.city, country.country
from store
join address
on store.address_id = address.address_id
join city
on address.city_id = city.city_id
join country
on city.country_id = country.country_id;


-- finding the top five grossed categories 
select category.name, sum(payment.amount) as rev_per_category
from sakila.payment
join sakila.rental
on payment.rental_id = rental.rental_id
join sakila.inventory
on rental.inventory_id = inventory.inventory_id
join sakila.film_category
on inventory.film_id = film_category.film_id
join sakila.category
on film_category.category_id = category.category_id 
group by category.name
order by rev_per_category desc limit 5;

-- putting the top 5 gross categories into a View for later use. 
create view top_gross_categories as 
select category.name, sum(payment.amount) as rev_per_category
from sakila.payment
join sakila.rental
on payment.rental_id = rental.rental_id
join sakila.inventory
on rental.inventory_id = inventory.inventory_id
join sakila.film_category
on inventory.film_id = film_category.film_id
join sakila.category
on film_category.category_id = category.category_id 
group by category.name
order by rev_per_category desc limit 5;

-- displaying the View just created
use sakila;
select *
from top_gross_categories;

-- deletes the view from the database 
use sakila;
drop view top_gross_categories;
