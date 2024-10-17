

	
-- (SELECT * FROM play_store_apps)
-- (SELECT * FROM app_store_apps)
-- ---purchase price calculation
-- WITH app_list as (
-- 	(SELECT name, price, review_count:: int, rating, 'Apple' as store FROM app_store_apps)

-- 	UNION 

-- (SELECT name, CAST(TRIM(REPLACE(price, '$', '')) AS numeric(5,2)) AS New_price, review_count, rating, 'Google' as store 
-- 	FROM play_store_apps)
-- 	)
 
---create table with required colum and combine both table

WITH app_list AS (
    (SELECT 
        name, price, review_count::int, rating,'Apple' AS store
 	FROM app_store_apps)

    UNION 

    (SELECT 
        name, CAST(TRIM(REPLACE(price, '$', '')) AS numeric(5,2)) AS price,review_count::int, rating, 'Google' AS store
         
      FROM play_store_apps)
            
)
	SELECT  name, price, review_count, rating, store FROM app_list 

-- 	---calculate purchase price of apps--
	
-- 	Purchase_price AS ( SELECT name, MAX(price) AS price, 
	
-- 	CASE
-- 			WHEN MAX(price) < 1 THEN 10000
-- 			ELSE 10000 * MAX(price)
-- 		END AS purchase_cost--, review_count, rating, store
-- 	FROM app_list
-- 	GROUP BY name
	
-- 	)
-- SELECT  name, price, rating,store,purchase_cost, store FROM  purchase_price 
	
	
	
         
         
        
         
    