# Load database "sakila"
use sakila;

# 1a. Display the first and last names of all actors from the table actor.
Select first_name as "First Name", last_name as "Last Name" From actor;

# 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
Select CONCAT(first_name, ' ', last_name) AS 'Actor Name' FROM actor;

# 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id as "ID number" , first_name as "First Name", last_name as "Last Name" FROM actor
where first_name = "Joe";

# 2b. Find all actors whose last name contain the letters GEN:
SELECT first_name as "First Name", last_name as "Last Name"  FROM actor where last_name like "%gen%";

# 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
 SELECT first_name as "First Name", last_name as "Last Name"  FROM actor
 where last_name like "%li%"
 order by last_name, first_name;

# 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
 SELECT country_id, country from country
 where country in ("Afghanistan", "Bangladesh", "China");

# 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
    # Turn off safe updates
    SET Sql_safe_updates = 0;
    # Add column of description
    ALTER TABLE actor
    ADD description blob;
    # Turn safe updates on
    SET SQL_SAFE_UPDATES = 1;
    Select description from actor;

# 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
   
    ALTER TABLE actor DROP COLUMN description;
    Select * from actor;

# 4a. List the last names of actors, as well as how many actors have that last name.
    Select last_name as "Last Name", count(last_name) as "Last Name Count" from actor
    group by last_name;

# 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
    Select last_name as "Last Name", count(last_name) as "Last Name Count" from actor
    group by last_name
    having count(last_name) >= 2;
    
# 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
   update actor
   set first_name = "HARPO"
   where last_name = "WILLIAMS" and first_name = "GROUCHO";

# 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
   update actor
   set first_name = "GROUCHO"
   where last_name = "WILLIAMS" and first_name = "HARPO";
   
# 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
# Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html
  SHOW CREATE TABLE address;

# 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
  select s.first_name as "First Name", s.last_name as "Last Name" , a.address as "Address"
  from staff s
  left join address a on a. address_id = s.address_id;

# 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
  select sum(p.amount) as "Total Amount"
  from payment p 
  left join staff s on p.staff_id = s.staff_id
  where p.payment_date like "2005-08%"
  group by p.staff_id;

# 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
  select f.title as "Film", count(fa.actor_id) as "Actor Count" 
  from film f
  join film_actor fa on f.film_id = fa.film_id
  group by f.title;
  
# 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
  Select count(film_id) as "Film Copy"
  from inventory
  where film_id =
  (select film_id from film
   where title = "Hunchback Impossible"
   );

# 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
  select c.first_name as "First Name" , c.last_name as "First Name", sum(p.amount) as "Total Paid" 
  from customer c
  join payment p on  c.customer_id =  p.customer_id
  group by c.customer_id
  order by c.last_name ASC;

7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
   select title from film
   where (title like 'K%' or title like 'Q%') 
   and language_id =
   (select language_id from language
    where name ="English"
   );

# 7b. Use subqueries to display all actors who appear in the film Alone Trip.
  select first_name as "First Name", last_name as "Last Name" 
  from actor
  where actor_id in
  (select actor_id from film_actor
  where film_id = 
  (select film_id from film
   where title = "Alone Trip"
   )
  );

# 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.

select c.first_name as "First Name", c.last_name as "Last Name" ,c.email as Email
from customer c
join address a on c.address_id = a.address_id 
join city ci on a.city_id = ci.city_id
join country co on ci.country_id = co.country_id
where country ="Canada";

7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select f.title from film f
join film_category fc on f.film_id = fc.film_id 
join category c on fc.category_id = c.category_id
where c.name = "family";

7e. Display the most frequently rented movies in descending order.
7f. Write a query to display how much business, in dollars, each store brought in.
7g. Write a query to display for each store its store ID, city, and country.
7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
8b. How would you display the view that you created in 8a?
8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
