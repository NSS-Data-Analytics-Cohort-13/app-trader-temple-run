(select * from app_store_apps)
	
union
	
(select * from play_store_apps)

(select name, price, review_count, rating, from app_store_apps)

	union all

(select name, price, review_count, rating, from play_store_apps)