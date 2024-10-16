

select a.rating
--CASE WHEN a.rating >= .445 THEN '1 year' END
-- CASE WHEN a.rating >= 1 THEN '3 years' END
from app_store_apps AS a 
full join play_store_apps AS b
USING(name)
WHERE a.rating >= 4
GROUP BY a.rating
ORDER BY a.rating 
LIMIT 40;











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