SELECT website_sessions.website_session_id, website_sessions.created_at, website_pageviews.pageview_url,
CASE WHEN website_pageviews.pageview_url = '/products' THEN 1 ELSE 0 END AS product,
CASE WHEN website_pageviews.pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS fuzzy,
CASE WHEN website_pageviews.pageview_url = '/cart' THEN 1 ELSE 0 END AS cart
 FROM website_sessions 
LEFT JOIN website_pageviews ON website_pageviews.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at > '2014-01-01' AND website_sessions.created_at < '2014-02-01'
AND  website_pageviews.pageview_url IN ('/lander-2', '/products', '/the-original-mr-fuzzy', '/cart')
ORDER BY 1,2;
CREATE TEMPORARY TABLE temp
SELECT website_session_id, pageview_url, product, fuzzy, cart FROM(
SELECT website_sessions.website_session_id, website_sessions.created_at, website_pageviews.pageview_url,
CASE WHEN website_pageviews.pageview_url = '/products' THEN 1 ELSE 0 END AS product,
CASE WHEN website_pageviews.pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS fuzzy,
CASE WHEN website_pageviews.pageview_url = '/cart' THEN 1 ELSE 0 END AS cart
 FROM website_sessions 
LEFT JOIN website_pageviews ON website_pageviews.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at > '2014-01-01' AND website_sessions.created_at < '2014-02-01'
AND  website_pageviews.pageview_url IN ('/lander-2', '/products', '/the-original-mr-fuzzy', '/cart')
ORDER BY 1,2) AS ALIAS;
-- GROUP BY 1;
SELECT * FROM temp;
CREATE TEMPORARY TABLE temp1
SELECT website_session_id, pageview_url, MAX(product) as p, MAX(fuzzy) as f, MAX(cart) as c
FROM temp
GROUP BY 1;
SELECT * FROM temp1;
SELECT count(website_session_id), SUM(p), sum(f), sum(c),  
SUM(p)/count(website_session_id), sum(f)/sum(p),
sum(c)/sum(f)
FROM temp1;

SELECT website_sessions.website_session_id, website_sessions.created_at,
pageview_url FROM website_sessions left join website_pageviews on website_pageviews.website_session_id = website_sessions.website_session_id
 WHERE website_pageviews.pageview_url in 
					('/lander-2', '/products', '/the-original-mr-fuzzy', '/cart', '/shipping', '/billing', 'thank-you-for-your-order')
						AND utm_source = 'gsearch' and utm_campaign = 'nonbrand' AND 
							website_sessions.created_at BETWEEN '2012-08-05' AND '2012-09-05'
                            order by website_sessions.website_session_id;
create temporary table tble
SELECT website_sessions.website_session_id, website_sessions.created_at,pageview_url,
CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS product,
 CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy,
  CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart,
  CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping,
  CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing,
  CASE WHEN pageview_url = 'thank-you-for-your-order' THEN 1 ELSE 0 END AS thanks
 FROM website_sessions left join website_pageviews on website_pageviews.website_session_id = website_sessions.website_session_id
 WHERE website_pageviews.pageview_url in 
					('/products', '/the-original-mr-fuzzy', '/cart', '/shipping', '/billing', 'thank-you-for-your-order')
						AND utm_source = 'gsearch' and utm_campaign = 'nonbrand' AND 
							website_sessions.created_at BETWEEN '2012-08-05' AND '2012-09-05'
                            order by website_sessions.website_session_id;                   
                            
SELECT * FROM tble;
create temporary table templ
SELECT website_session_id, created_at, pageview_url,
MAX(product) as p, max(mrfuzzy)as f, max(cart) as c, max(shipping) as s, max(billing) as b, max(thanks) as t
FROM tble
GROUP BY website_session_id, pageview_url; 
SELECT * FROM templ;
select count(website_session_id) as total_sessions, SUM((p)) as to_products,  SUM((f)) as to_fuzzy,  SUM((c)) as to_cart,
  SUM((s)) as to_shipping,  SUM((b)) as to_billing,  SUM((t)) as to_thanks
from templ;
SELECT * FROM templ;
select SUM((p))/count(website_session_id), SUM((f))/SUM((p)),  SUM((c))/SUM((f)) as to_fuzzy,  SUM((s)) /SUM((c)) as to_cart,
   SUM((b))/SUM((s)), SUM((t))/SUM((b))
from templ;
-- group by 1;

SELECT MIN(website_pageview_id), min(created_at) as first_pv_id FROM website_pageviews where pageview_url = '/billing-2';
-- first_pv_id = 53550
CREATE TEMPORARY TABLE first_table
(SELECT website_sessions.website_session_id, website_sessions.created_at, website_pageviews.pageview_url
FROM website_sessions LEFT JOIN website_pageviews on website_pageviews.website_session_id = website_sessions.website_session_id
WHERE website_pageviews.created_at < '2012-11-10' AND website_pageviews.website_pageview_id >=53550
AND website_pageviews.pageview_url IN ('/billing', '/billing-2')
ORDER BY website_sessions.website_session_id) ;
SELECT * FROM first_table;
SELECT pageview_url, COUNT(website_session_id) as total_sessions, COUNT(orders) as tot_orders, COUNT(orders)/ COUNT(website_session_id) as rt 
FROM 
(SELECT first_table.website_session_id, first_table.created_at, first_table.pageview_url, orders.website_session_id as orders
 from first_table  LEFT JOIN orders on orders.website_session_id=first_table.website_session_id) AS ALIA
 Group by 1;
 