

-- select a.rating
-- --CASE WHEN a.rating >= .445 THEN '1 year' END
-- -- CASE WHEN a.rating >= 1 THEN '3 years' END
-- from app_store_apps AS a 
-- full join play_store_apps AS b
-- USING(name)
-- WHERE a.rating >= 4
-- GROUP BY a.rating
-- ORDER BY a.rating 
-- LIMIT 40;


select distinct a.name AS names, b.primary_genre
from play_store_apps AS a
FULL JOIN app_store_apps AS b
USING(name)
WHERE abc = 'shopping'


select a.review_count, DISTINCT a.name AS names


select cast()

``
from play_store_apps AS a
FULL JOIN app_store_apps AS b
USING(name)
group by a.review_count
ORDER BY a.review_count desc









---


-- select p.name, a.name, p.rating, a.rating
-- from play_store_apps AS p
-- FULL JOIN app_store_apps AS a
-- USING(name)
-- LIMIT 20;


-- SELECT    p.name
-- 		, p.price
-- 		, p.rating
-- 		, p.review_count
-- 		, 




-- SELECT name, MAX(price) as price,count(name)*5000 as profitpermonth, count(distinct name)*1000 as costpermonth, CAST(ROUNF(AVG(rating)*2.0)/2.0)*2 +1 as decimal (5,2)) as avg_rating from 
-- (select name,case )

SELECT
		name, 
		MAX(price) AS price,
		COUNT(name)*5000 as profit_per_month,
   		COUNT(DISTINCT name)*1000 as cost_per_month,
   		-- CAST((ROUND(AVG(rating)*2.0)/2.0)*2 +1 as decimal(5,2)) as avg_rating,
		   CAST(ROUND((rating) * 2, 0) / 2 AS decimal(5,2) AS rounded_rating,
		CASE WHEN COUNT(name) > 1 THEN 'y' ELSE 'n' END AS available_in_both_stores
FROM
   (
   SELECT name,
   CASE WHEN price = '0.00' THEN 10000 ELSE CEILING(price)*10000 END AS price,rating
   FROM app_store_apps
UNION
SELECT name,
  CASE WHEN CAST(REPLACE(price,'$','') as numeric) = 0 THEN 10000 ELSE
  CEILING(CAST(REPLACE(price,'$','') as numeric))*10000 END AS price, rating
FROM play_store_apps)
WHERE rating IS NOT NULL
GROUP BY name, rounded_rating
ORDER BY rounded_rating DESC

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
ORDER BY
	avg_rating DESC
LIMIT 10;







  select *
  from app_store_apps





