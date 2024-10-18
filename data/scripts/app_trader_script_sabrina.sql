SELECT *
FROM app_store_apps; --7197 records

SELECT *
FROM play_store_apps; --10840 records

--Table schemas:
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'app_store_apps';

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'play_store_apps';


/* Fields to compare b/t stores w/ data types to change and clean:
1) **price
	-"price" "numeric" --> app_store_apps --CAST(price AS int)
	- "price" "text" --> play_store	  --CAST(price AS int)
2) name 
	- "name" "text" --> app_store_apps
	- "name" "text"--> play_store
3) **rating (need to change to integer or no?)
	- "rating"	"numeric" --> app_store_apps  --CAST(rating AS int)
	- "rating"	"numeric" --> play_store	   --CAST(rating AS int)
4) content-rating (audience for marketing)
	- "content_rating"	"text" --> app_store_apps
	- "content_rating"	"text" --> play_store
5) primary_genre and genres
	- "primary_genre" "text" --> app_store_apps
	- "genres"	"text" --> play_store
6) size_bytes and size
	- "size_bytes"	"text" E.g. "100788224"--> app_store_apps
	- "size" "text" E.g. "14M"--> play_store
7) **review_count
	- "review_count" "text"  --> app_store_apps  --CAST(review_count AS int)
	- "review_count" "integer"--> play_store
*/

--DATA CLEANUP: PRICE COLUMNS
--PLAY STORE:
SELECT name, 
       rating, 
       CASE 
           WHEN price = '0' OR price IS NULL THEN 10000
           ELSE CAST(TRIM(REPLACE(price, '$', '')) AS numeric(5,2)) * 10000
       END AS purchase_price
FROM play_store_apps;
ORDER BY 

--Part 3b: 
--TOP 20 RATED FROM BOTH APP AND PLAY STORE:
-- SELECT
-- 	DISTINCT a.name AS app_name
-- -- ,	p.name AS play_name
-- ,	a.rating AS app_rating
-- -- ,	p.rating AS play_rating
-- ,	CASE WHEN a.name 
-- FROM app_store_apps AS a
-- 	FULL JOIN play_store_apps AS p
-- 		USING(rating)
-- WHERE a.rating IS NOT NULL
-- ORDER BY 
-- 	app_rating DESC
-- ,	app_name
-- LIMIT 20;

/*NOTES for 3b: 
- is this the correct query for returning top 20 apps from both stores based on highest rating?
*/

--REVISED TOP 10 APPS IN BOTH STORES W/ AVG RATING:
SELECT 
	a.name AS app_name
,	p.name AS play_name
,	a.rating AS app_rating
,	p.rating AS play_rating
,	ROUND(
        (COALESCE(a.rating, 0) + COALESCE(p.rating, 0)) / --temporarily assume '0' for null rating from a and p rating columns
        (CASE WHEN a.rating IS NOT NULL AND p.rating IS NOT NULL THEN 2 --divide by 2 if rating in both a and p tables
              WHEN a.rating IS NOT NULL OR p.rating IS NOT NULL THEN 1 --divide rating by self (1) if a or p rating is null
              ELSE NULL END), 2 --null result if both a and p rating are null
    ) AS avg_rating --avg of both app and play ratings considering null values and rounding 
FROM app_store_apps AS a
	INNER JOIN play_store_apps AS p 
		ON a.name = p.name
WHERE 
	a.rating IS NOT NULL AND p.rating IS NOT NULL
ORDER BY 
	avg_rating DESC
LIMIT 10;
--NOTE: there are NULL values in both rating fields

--*Initial attempt w/ subquery for play table:
-- WHERE name IN
--  	(SELECT p.name
--      FROM play_store_apps);

--Narendra Query w/ CTE:
WITH app_list AS (
    (SELECT
        name, price, review_count::int, rating,'Apple' AS store
 	FROM app_store_apps)
    UNION
    (SELECT
        name, CAST(TRIM(REPLACE(price, '$', '')) AS numeric(5,2)) AS price,review_count::int, rating, 'Google' AS store
      FROM play_store_apps)
)

--Narendra Purchase Price Query:
SELECT  name, price, review_count, rating, store FROM app_list 
	Purchase_price AS ( SELECT name, MAX(price) AS price, 
	
	CASE
			WHEN MAX(price) < 1 THEN 10000
			ELSE 10000 * MAX(price)
		END AS purchase_cost--, review_count, rating, store
	FROM app_list
	GROUP BY name
	
	)
SELECT  name, price, rating,store,purchase_cost, store FROM  purchase_price 


--TEST:
