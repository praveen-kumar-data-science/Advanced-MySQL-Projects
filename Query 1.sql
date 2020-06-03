SET GLOBAL max_allowed_packet = 1073741824;
USE mavenfuzzyfactory;
-- Running this command will allow Workbench
 -- to accept a larger file (of size 1073741824 in this case).
 SELECT website_sessions.utm_content, 
 count(website_sessions.utm_content), count(orders.order_id),
 count(orders.order_id)/count(website_sessions.utm_content)
 FROM website_sessions 
 LEFT JOIN orders on orders.website_session_id = website_sessions.website_session_id
 WHERE website_sessions.website_session_id BETWEEN 1000 AND 2000
 GROUP BY website_sessions.utm_content
 ORDER BY count(website_sessions.utm_content) desc;
 
 SELECT website_sessions.utm_source, website_sessions.utm_campaign, website_sessions.http_referer,
 count(website_sessions.website_session_id) as sessions,
 count(orders.order_id) as orders,
 100 *count(orders.order_id)/count(website_sessions.website_session_id) as CVR
 FROM website_sessions 
 left JOIN orders on orders.website_session_id = website_sessions.website_session_id
 WHERE website_sessions.created_at <'2012-04-12' and website_sessions.utm_source ='gsearch' and 
 website_sessions.utm_campaign = 'nonbrand'
 GROUP BY 1,2,3
 ORDER BY sessions desc;
 SELECT @@time_zone;
 
 SELECT 
YEAR(created_at),
WEEK(created_at), 
min(date(created_at)), count(website_session_id)
 FROM website_sessions
 WHERE website_session_id BETWEEN 100000 AND 115000
 group by 1,2;
 
 
 SELECT primary_product_id, 
		COUNT(CASE WHEN items_purchased = 1 THEN order_id ELSE NULL END) as No_of_single_orders,
        COUNT(CASE WHEN items_purchased = 2 THEN order_id ELSE NULL END) as No_of_double_orders,
        COUNT(order_id) as total_orders,
        COUNT(primary_product_id)
 FROM orders
 WHERE order_id BETWEEN 31000 AND 32000
 GROUP by 1;
 
  SELECT primary_product_id,  order_id, items_purchased,
  
		COUNT(CASE WHEN items_purchased = 1 THEN order_id ELSE NULL END) as No_of_single_orders,
        COUNT(CASE WHEN items_purchased = 2 THEN order_id ELSE NULL END) as No_of_double_orders,
        COUNT(order_id) as total_orders,
        COUNT(primary_product_id)
 FROM orders
 WHERE order_id BETWEEN 31000 AND 32000
 GROUP by 1, 2 , 3;
 
 SELECT WEEK(created_at), min(date(created_at)), count(website_session_id) from website_sessions 
 where created_at < '2012-05-10' and utm_source = 'gsearch' and utm_campaign = 'nonbrand'
 GROUP BY 1;
 
 # Conversion rate Session to Volume
 SELECT device_type, count(website_sessions.website_session_id) as sessions,
 count(orders.order_id) as orders,
 100*count(orders.order_id)/count(website_sessions.website_session_id) as CVR
 FROM website_sessions
  LEFT JOIN orders on orders.website_session_id = website_sessions.website_session_id
   where utm_source = 'gsearch' and utm_campaign = 'nonbrand' and  website_sessions.created_at < '2012-05-11'
 Group by device_type;
 
 SELECT  min(date(created_at)), 
 count(case when device_type = 'desktop' THEN website_session_id else NULL END) as dtp_sessions,
 count(case when device_type = 'mobile' THEN website_session_id ELSE NULL END) as mob_sessions from website_sessions
 WHERE created_at > '2012-04-15' and created_at < '2012-06-09' and utm_source = 'gsearch' and utm_campaign = 'nonbrand'
 group by week(created_at)