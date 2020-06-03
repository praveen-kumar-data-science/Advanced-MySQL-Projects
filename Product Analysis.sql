SELECT * FROM orders;
SELECT 
		primary_product_id,
        COUNT(order_id) AS orders,
        SUM(price_usd) AS revenue,
        SUM(price_usd-cogs_usd) AS profit,
        AVG(price_usd) AS average_revenue_per_order
FROM orders WHERE order_id BETWEEN 10000 AND 11000
GROUP BY 1
ORDER BY 2 DESC;

SELECT 
		YEAR(created_at),
		MONTH(created_at),
        COUNT(order_id) AS total_sales,
        SUM(price_usd) AS total_revenue,
        SUM(price_usd-cogs_usd) AS total_profit
FROM orders WHERE created_at < '2013-01-04'
GROUP BY 1,2;

-- IMPACT OF NEW PRODUCT LAUNCH
SELECT 
		YEAR(website_sessions.created_at) AS yr,
        MONTH(website_sessions.created_at) as mo,
        COUNT(orders.order_id) AS orders,
        COUNT(orders.website_session_id)/COUNT(website_sessions.website_session_id)  AS conv_rt,
        SUM(price_usd)/COUNT(website_sessions.website_session_id)   AS rev_per_sess,
COUNT(CASE WHEN primary_product_id = 1 THEN order_id ELSE NULL END) AS product_1_orders,
COUNT(CASE WHEN primary_product_id = 2 THEN order_id ELSE NULL END) AS product_2_orders
FROM website_sessions LEFT JOIN orders ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at BETWEEN '2012-04-01' AND '2013-04-05'
GROUP BY 1,2;
        
select * from website_sessions LEFT join orders on orders.website_session_id=website_sessions.website_session_id;

SELECT 
	SUM(tot_sessions) AS sessions, 
	SUM(p),
    SUM(f) AS mr_fuzzy,
    SUM(t), 
    SUM(c), 
    SUM(s), 
    SUM(b) AS love_bear, 
    SUM(l)
FROM 
(SELECT 
	sessions,
    COUNT(sessions) AS tot_sessions, 
    MAX(product) AS p,
    MAX(mr_fuzzy) AS f,
    MAX(thanks) AS t, 
    MAX(cart) AS c, 
    MAX(ship) AS s, 
    MAX(bill) AS b, 
    MAX(lv_br) AS l
FROM
(SELECT
		sessions, pv_url,
        CASE WHEN pv_url = '/products' THEN 1 ELSE 0 END AS product,
        CASE WHEN pv_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mr_fuzzy,
		CASE WHEN pv_url = '/cart' THEN 1 ELSE 0 END AS cart,
		CASE WHEN pv_url = '/shipping' THEN 1 ELSE 0 END AS ship,
		CASE WHEN pv_url = '/billing' THEN 1 ELSE 0 END AS bill,
        CASE WHEN pv_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thanks,
		CASE WHEN pv_url = '/the-forever-love-bear' THEN 1 ELSE 0 END AS lv_br
	FROM
(SELECT website_pageviews.website_session_id as sessions,  website_pageviews.website_pageview_id as pv_id, pageview_url AS pv_url
 FROM website_pageviews 
LEFT JOIN website_sessions ON website_sessions.website_session_id = website_pageviews.website_session_id
 WHERE pageview_url IN ('/products', '/the-original-mr-fuzzy','/thank-you-for-your-order', 
									'/cart', '/shipping','/billing', '/the-forever-love-bear')) AS Al_page_after_prdt) AS multi 
GROUP BY 1)
AS lvl
                                    