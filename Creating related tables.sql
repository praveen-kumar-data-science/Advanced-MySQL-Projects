
CREATE SCHEMA inventory_normalized;
USE inventory_normalized;
CREATE TABLE store
SELECT 
	DISTINCT store_id, store_manager_first_name, store_manager_last_name, store_address, store_city, store_district

FROM mavenmoviesmini.inventory_non_normalized;
CREATE TABLE film
SELECT
	DISTINCT film_id, title, description, release_year, rental_rate, rating

FROM mavenmoviesmini.inventory_non_normalized; 

CREATE TABLE inventory
SELECT inventory_id, film_id, store_id
FROM mavenmoviesmini.inventory_non_normalized;
USE sloppyjoes;
UPDATE customer_orders
SET order_total = 0 
WHERE order_id IN (3,8,12,16,19);
