

	
 (SELECT *  FROM play_store_apps)
(SELECT * FROM app_store_apps)
-- -- ---purchase price calculation
-- -- WITH app_list as (
-- -- 	(SELECT name, price, review_count:: int, rating, 'Apple' as store FROM app_store_apps)

-- -- 	UNION 

-- -- (SELECT name, CAST(TRIM(REPLACE(price, '$', '')) AS numeric(5,2)) AS New_price, review_count, rating, 'Google' as store 
-- -- 	FROM play_store_apps)
-- -- 	)
 
-- ---create table with required colum and combine both table

-- WITH app_list AS (
--     (SELECT 
--         distinct name, price, review_count::int, rating,'Apple' AS store
--  	FROM app_store_apps)

--     UNION 

--     (SELECT 
--         distinct name, CAST(TRIM(REPLACE(price, '$', '')) AS numeric(5,2)) AS price,review_count::int, rating, 'Google' AS store
         
--       FROM play_store_apps)
            
-- ),
-- 	--SELECT  name, price, review_count, rating, store FROM app_list 

-- 	life_spans as
-- 	(
	
-- 	Select name, count(store) as stores_num, (ROUND(AVG(rating) * 2, 0) / 2) as rating,
-- 		ROUND(1+(2*(ROUND(AVG(rating) * 2, 0) / 2)),2) as life_span
-- 	from app_list
-- 	group by name
-- 	),
-- 	-- SELECT * from life_spans
-- 	-- where life_span is not null
-- 	-- order by life_span desc

-- 	---calculate purchase price of apps--
	
-- 	 Purchase_price AS ( SELECT name, MAX(price) AS price, 
	
-- 	CASE
-- 			WHEN MAX(price) <= 1 THEN 10000
-- 			ELSE 10000 * MAX(price)
-- 		END AS purchase_cost, review_count, rating, store
-- 	FROM app_list
-- 	GROUP BY name, review_count, rating, store
	
-- 	),
-- --SELECT  name, price, purchase_cost FROM  purchase_price 

-- revenue as  (
-- 	select p.name, p.purchase_cost, (l.life_span*5000*12) as total_revenue, p.store
-- 	from purchase_price as p
-- 	full join life_spans as l
-- 	--group by name
-- 	)
--  select name, purchase_cost, total_revenue, store from revenue
--  order by name

-- marketing_cost as 
-- 	(
-- select name, 1000*12 as Yearly_marketing_price
-- from play_store_apps 
-- full join app_store_apps
-- using (name)
-- 	),
-- -- select name, Yearly_marketing_price
-- --  from marketing_cost



-- total_cost as (

-- 	Select name, rating, life_span, store, (revenue_per_month*12)*life_span as Total_revenue, (life_span * Yearly_marketing_price)+price as Total_cost,  
-- )
	
	



-- SELECT
-- 	a.name AS app_name
-- ,	p.name AS play_name
-- ,	a.rating AS app_rating
-- ,	p.rating AS play_rating
-- ,	ROUND(
--         (COALESCE(a.rating, 0) + COALESCE(p.rating, 0)) / --temporarily assume '0' for null rating from a and p rating columns
--         (CASE WHEN a.rating IS NOT NULL AND p.rating IS NOT NULL THEN 2 --divide by 2 if rating in both a and p tables
--               WHEN a.rating IS NOT NULL OR p.rating IS NOT NULL THEN 1 --divide rating by self (1) if a or p rating is null
--               ELSE NULL END), 2 --null result if both a and p rating are null
--     ) AS avg_rating --avg of both app and play ratings considering null values and rounding
-- FROM app_store_apps AS a
-- 	FULL JOIN play_store_apps AS p
-- 		ON a.name = p.name
-- 	Where (a.rating is not null) AND (p.rating is not null)
-- ORDER BY
-- 	avg_rating DESC
-- --LIMIT 10;

---"Archangel Michael Guidance - Doreen Virtue"---
---TOP 10 LIST of Apps-----
	
	WITH Table_one AS (
	SELECT name
	, MAX(price) as price--,content_rating
   , COUNT(name)*5000 AS Revenue_permonth
   , COUNT(DISTINCT name)*1000 as cost_PerMonth
   , CAST((ROUND(AVG(rating)*2.0)/2.0)*2 +1 AS decimal(5,2)) as Life_yr
   , CASE WHEN COUNT(name) > 1 THEN 'y' ELSE 'n' END AS availableInBothStores
	--, store
	--, genres
	
   FROM 
   ( 
   SELECT distinct name,
   CASE WHEN price <= 1 THEN 10000 ELSE CEILING(price)*10000 END AS price,rating--,'appstore' as store--, content_rating, primary_genre as genres
   FROM app_store_apps
		
   UNION
	
  SELECT distinct name,
  CASE WHEN CAST(REPLACE(price,'$','') as numeric) <= 1 THEN 10000 ELSE
  CEILING(CAST(REPLACE(price,'$','') as numeric))*10000 END AS price, rating--, 'playstore' as store--, content_rating, genres
  FROM play_store_apps
 )
  GROUP BY name--, store--, --content_rating,  genres
),

Table_two AS (

	SELECT 
	 	name
	 ,	price
	 ,	life_yr
	 --, content_rating
	 ,	(revenue_permonth*12*life_yr):: money AS Total_revenue
	 ,	((cost_permonth*12*life_yr)+price)::money AS Total_cost
	 ,	(revenue_permonth*12*life_yr)::money - ((cost_permonth*12*life_yr)+price)::money AS profit, availableInBothStores
	 --, store
	 -- , genres

FROM 	table_one
	)
	 	
	 SELECT 
	 distinct t.name
	 ,	t.price
	 ,	t.life_yr
	 , p.content_rating
	 ,	t. Total_revenue
	 ,	t.Total_cost
	 , t.profit
	 , t. availableInBothStores
	--, p.genres
	 
	 
	 FROM Table_two as t
	 inner join play_store_apps as p
	on t.name = p.name
	WHERE profit IS NOT NULL
	ORDER BY profit DESC
	
limit 10




    