SELECT * FROM app_store_apps
SELECT * FROM play_store_apps


-- a. App Trader will purchase apps for 10,000 times the price of the app. For apps that are priced from free up to $1.00, the purchase price is $10,000.

SELECT name, MAX(price) as price,
   COUNT(name)*5000 as profitPerMonth,
   COUNT(DISTINCT name)*1000 as costPerMonth,
   CAST((ROUND(AVG(rating)*2.0)/2.0)*2 +1 as decimal(5,2)) as avg_rating
   ,CASE WHEN COUNT(name) > 1 THEN 'y' ELSE 'n' END AS availableInBothStores
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
  GROUP BY name;
	--SELECT  name, price, review_count, rating, store FROM app_list
	---calculate purchase price of apps--
	
	WITH purchase_price AS ( SELECT name, MAX(price) AS price,
	
	CASE
			WHEN MAX(price) <= 1 THEN 10000
			ELSE 10000 * MAX(price)
		END AS purchase_cost--, review_count, rating, store
	FROM app_list
	GROUP BY name
	
	),
SELECT  name, price, purchase_cost FROM  purchase_price
revenue as  (
	select name, price, 5000 as revenue_per_month, store
	from app_list
	),
-- select name, price, revenue_per_month, store from revenue
-- order by name
marketing_cost as
	(
select name, 1000*12 as Yearly_marketing_price
from play_store_apps
full join app_store_apps
using (name)
	),
-- select name, Yearly_marketing_price
--  from marketing_cost
life_spam as
	(
	
	Select name, rating, CAST((ROUND(AVG(rating)*2.0)/2.0)*2 +1 as decimal(5,2)) as avg_rating
	from app_list
	
	)

-- #### 3. Deliverables

-- a. Develop some general recommendations as to the price range, genre, content rating, or anything else for apps that the company should target.

-- b. Develop a Top 10 List of the apps that App Trader should buy.
	SELECT
	a.name AS app_name
,	p.name AS play_name
,	a.rating AS app_rating
,	p.rating AS play_rating
,	genres
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
-- c. Submit a report based on your findings. All analysis work must be done using PostgreSQL, however you may export query results to create charts in Excel for your report. 