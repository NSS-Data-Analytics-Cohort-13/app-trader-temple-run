SELECT *
FROM app_store_apps; --7197

SELECT *
FROM play_store_apps; --10840

/* Fields to compare b/t stores:
- price
- name 
- rating
- content-rating (audience for marketing)
- primary_genre and genres
- size_bytes and size
*/

--Part 3b: 
--TOP 20 RATING FROM BOTH APP AND PLAY STORE:
SELECT
	DISTINCT a.name AS app_name
-- ,	p.name AS play_name
,	a.rating AS app_rating
-- ,	p.rating AS play_rating
,	CASE WHEN a.name 
FROM app_store_apps AS a
	FULL JOIN play_store_apps AS p
		USING(rating)
WHERE a.rating IS NOT NULL
ORDER BY 
	app_rating DESC
,	app_name
LIMIT 20;

/*NOTES: 
- is this the correct query for returning top 20 apps from both stores based on highest rating?
*/

--APPS IN BOTH STORES:
SELECT 
	a.name
  FROM table1
 WHERE name IN
 	(SELECT p.name
     FROM table2);