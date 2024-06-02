use sakila;

/*query to display each store id, city and country*/
select 
	st.store_id, 
    city, 
    country
from store as st 
	inner join address ad on st.address_id = ad.address_id
    inner join city ct on ad.city_id = ct.city_id
    inner join country cu on ct.country_id = cu.country_id
    ;
    
/* query 2- display amount of money brought for each store*/
select 
	st.store_id, 
    city, 
    country,
    SUM(pa.amount) as total_amount
from store as st 
	left join address ad on st.address_id = ad.address_id
    left join city ct on ad.city_id = ct.city_id
    left join country cu on ct.country_id = cu.country_id
    left join inventory inv on st.store_id = inv.store_id 
    left join rental re on inv.inventory_id = re.rental_id 
    left join payment pa on re.rental_id = pa.rental_id
GROUP BY st.store_id, city, country
    ;
    
/*query 3 average running time */
select 
	c.name,
    AVG(fl.length) as average_running_time
from category as c 
	inner join film_category fc on c.category_id = fc.category_id 
    inner join film fl on fc.film_id = fl.film_id
    GROUP BY c.name;
    
/* query 4 longest film category */
select 
	c.name,
    AVG(fl.length) as average_running_time
from category as c 
	inner join film_category fc on c.category_id = fc.category_id 
    inner join film fl on fc.film_id = fl.film_id
GROUP BY c.name
ORDER BY average_running_time DESC
LIMIT 5;

/*QUERY 5 MOST FREQUENTLY RENTED MOVIES */
select 
	f.title, 
    COUNT( r.rental_id) as rented_times
from film f 
	left join inventory inv on f.film_id = inv.film_id
    left join rental r on inv.inventory_id = r.inventory_id
 group by f.title 
 ORDER BY rented_times DESC;
 
 /* Query 6 top 5 genres */
 SELECT 
    c.name AS category_name,
    SUM(p.amount) AS total_revenue
FROM 
    film AS f
    INNER JOIN film_category fc ON f.film_id = fc.film_id
    INNER JOIN category c ON fc.category_id = c.category_id
    INNER JOIN inventory i ON f.film_id = i.film_id
    INNER JOIN rental r ON i.inventory_id = r.inventory_id
    INNER JOIN payment p ON r.rental_id = p.rental_id
GROUP BY 
    c.name
ORDER BY 
    total_revenue DESC
LIMIT 5;

/*query 7*/
SELECT 
    f.title,
    i.inventory_id,
    s.store_id,
    CASE
        WHEN r.rental_date IS NULL OR r.return_date IS NOT NULL THEN 'Available'
        ELSE 'Rented'
    END AS availability_status
FROM 
    film AS f
    INNER JOIN inventory i ON f.film_id = i.film_id
    INNER JOIN store s ON i.store_id = s.store_id
    LEFT JOIN rental r ON i.inventory_id = r.inventory_id AND r.return_date IS NULL
WHERE 
    f.title = 'Academy Dinosaur'
    AND s.store_id = 1
HAVING 
    availability_status = 'Available';