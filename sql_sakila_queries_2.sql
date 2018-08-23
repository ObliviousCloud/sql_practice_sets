USE sakila;

-- 1a
SELECT first_name, last_name 
FROM sakila.actor;

-- 1b
SELECT (CONCAT (first_name, ' ', last_name));

-- 2a
SELECT actor_id, first_name, last_name
FROM sakila.actor
WHERE first_name ='Joe';

-- 2b
SELECT * FROM sakila.actor
WHERE last_name LIKE '%GEN%';

-- 2c
SELECT * FROM sakila.actor
WHERE last_name LIKE '%LI%'
Order by last_name;

-- 2d
SELECT country_id, country
FROM sakila.country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a 
ALTER TABLE sakila.actor
ADD COLUMN description varchar(100) AFTER first_name;

-- 3b
ALTER TABLE sakila.actor
DROP COLUMN description;

-- 4a
SELECT last_name, COUNT(*)
FROM sakila.actor
GROUP BY last_name;

-- 4b
SELECT last_name, COUNT(*)
FROM sakila.actor
GROUP BY last_name
HAVING COUNT(*) > 1;

-- 4c
UPDATE sakila.actor
SET first_name ='HARPO'
WHERE first_name ='GROUCHO' and last_name ='WILLIAMS';

SELECT * FROM sakila.actor
WHERE first_name = 'HARPO' and last_name ='WILLIAMS'; 

-- 4d 
SELECT * FROM sakila.actor
WHERE first_name ='HARPO';

UPDATE sakila.actor
SET first_name = case when first_name ='HARPO' then 'GROUCHO' else 'GROUCHO' end
WHERE actor_id = 172;

SELECT * FROM sakila.actor
WHERE actor_id = 172;

-- 5a
SHOW CREATE TABLE sakila.address;

-- 6a 
SELECT st.first_name, st.last_name, ad.address
FROM sakila.staff st
LEFT OUTER JOIN sakila.address ad on st.address_id = ad.address_id;

-- 6b 
SELECT first_name, last_name, sum(amount) as total_payment
FROM sakila.staff st
JOIN sakila.payment pt
ON st.staff_id = pt.staff_id
WHERE payment_date BETWEEN '2005-08-01' and '2005-08-30'
GROUP BY first_name, last_name;

-- 6c
SELECT title, COUNT(*)
FROM sakila.film f
JOIN sakila.film_actor fa
ON f.film_id = fa.film_id
GROUP BY title
ORDER BY title;

-- 6d 
SELECT f.title, COUNT(i.inventory_id)
FROM sakila.inventory i
JOIN sakila.film f ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible';

SELECT COUNT(*)
FROM sakila.inventory 
WHERE film_id IN
(
SELECT film_id
FROM sakila.film
WHERE title = 'Hunchback Impossible'
);

-- 6e
SELECT c.customer_id, c.first_name, c.last_name
FROM sakila.customer c
JOIN sakila.payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY c.last_name;

SELECT first_name, last_name, sum(amount)
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY p.customer_id
ORDER BY last_name;

-- 7a
SELECT title 
FROM sakila.film
WHERE title LIKE 'K%'
OR title LIKE 'Q%'
AND language_id IN
(
SELECT language_id
FROM sakila.language
WHERE name = 'English'
);

-- 7b 
SELECT a.first_name, a.last_name
FROM sakila.actor a
WHERE a.actor_id in
(
SELECT fa.actor_id
FROM sakila.film_actor fa
JOIN sakila.film f ON fa.film_id = f.film_id
);

SELECT first_name, last_name
FROM sakila.actor
WHERE actor_id IN
(
SELECT actor_id
FROM sakila.film_actor
WHERE film_id IN
(
SELECT film_id
FROM sakila.film
WHERE title = 'Alone Trip'
)
);

-- 7c
SELECT c.customer_id, c.first_name, c.last_name, c.email
FROM sakila.customer c
JOIN sakila.address a ON c.address_id
JOIN sakila.city ct ON a.city_id = ct.city_id
JOIN sakila.country cy ON ct.country_id = cy.country_id
WHERE cy.country = 'CANADA';

SELECT * FROM sakila.address;
SELECT * FROM sakila.country;

SELECT first_name, last_name, email
FROM sakila.customer
WHERE address_id IN 
(
SELECT address_id
FROM sakila.address
WHERE address_id IN
(
SELECT city_id
FROM sakila.city
WHERE country_id IN
(
SELECT country_id
FROM sakila.country
WHERE country = 'Canada'
)
)
);

-- 7d
SELECT * FROM film
WHERE rating = 'G';

-- 7e
USE sakila;
SELECT f.title, COUNT(r.rental_id)
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id
INNER JOIN rental r on i.inventory_id = r.inventory_id
GROUP BY  f.title DESC;

-- 7f
SELECT s.store_id, SUM(p.amount)
FROM payment p
JOIN customer c on p.customer_id = c.customer_id
JOIN store s ON s.store_id = c.store_id
GROUP BY s.store_id; 

-- 7g
SELECT s.store_id, c.city, co.country
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city c on a.city_id = c.city_id
JOIN country co on c.country_id = co.country_id;

-- 7h
SELECT c.name, sum(p.amount) as gross_rev
FROM sakila.inventory i
INNER JOIN sakila.film_category fc ON fc.film_id = i.film_id
INNER JOIN sakila.category c ON fc.category_id = c.category_id
INNER JOIN sakila.rental r ON inventory_id = r.intentory_id
INNER JOIN sakila.payment p ON p.rental_id = r.rental_id
GROUP BY c.name
ORDER BY gross_rev
DESC LIMIT 5;

SELECT c.name, sum(p.amount) as gross_rev
FROM category c
LEFT JOIN film_category fc on c.category_id = fc.category_id
LEFT JOIN inventory i ON fc.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
LEFT JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY gross_rev
DESC LIMIT 5;

-- 8a
CREATE TABLE sakila.top_five_genres as
(
SELECT c.name, sum(p.amount) as gross_rev
FROM sakila.inventory i
INNER JOIN sakila.film_category fc ON fc.film_id = i.film_id
INNER JOIN sakila.category c ON fc.category_id = c.category_id
INNER JOIN sakila.rental r ON inventory_id = r.intentory_id
INNER JOIN sakila.payment p ON p.rental_id = r.rental_id
GROUP BY 1
ORDER BY gross_rev
DESC LIMIT 5
);

SELECT * FROM sakila.top_five_genres;

-- 8b
SELECT * FROM Sakila.top_five_genres;

SHOW CREATE VIEW sakila.top_five_genres;

-- 8c
DROP VIEW IF EXISTS sakila.top_give_genres;



