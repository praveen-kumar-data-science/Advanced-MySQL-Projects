/*
1.	Gsearch seems to be the biggest driver of our business. Could you pull monthly 
trends for gsearch sessions and orders so that we can showcase the growth there? 
*/ 
SELECT DISTINCT YEAR(website_sessions.created_at) FROM website_sessions;
SELECT 
		YEAR(website_sessions.created_at) as yr, 
		MONTH(website_sessions.created_at) as mnth, 
		COUNT(website_sessions.website_session_id) as sessions,
		COUNT(orders.website_session_id) as orders,
        100*COUNT(orders.website_session_id)/COUNT(website_sessions.website_session_id) as session_toorder_rt
 FROM website_sessions 
 LEFT JOIN orders on orders.website_session_id = website_sessions.website_session_id
WHERE utm_source ='gsearch' AND website_sessions.created_at < '2012-11-27'
GROUP BY 1,2;


/*
2.	Next, it would be great to see a similar monthly trend for Gsearch, but this time splitting out nonbrand 
and brand campaigns separately. I am wondering if brand is picking up at all. If so, this is a good story to tell. 
*/ 
SELECT 
		YEAR(website_sessions.created_at) as yr, 
		MONTH(website_sessions.created_at) as mnth,
		COUNT(CASE WHEN utm_campaign = 'nonbrand' THEN website_sessions.website_session_id ELSE NULL END) as nonbrand_sessions,
        COUNT(CASE WHEN utm_campaign = 'nonbrand' THEN orders.website_session_id ELSE NULL END) as nonbrand_orders,
		COUNT(CASE WHEN utm_campaign = 'brand' THEN website_sessions.website_session_id ELSE NULL END) as brand_sessions,
		COUNT(CASE WHEN utm_campaign = 'brand' THEN orders.website_session_id ELSE NULL END) as brand_orders
        
 FROM website_sessions 
 LEFT JOIN orders on orders.website_session_id = website_sessions.website_session_id
WHERE utm_source ='gsearch' AND website_sessions.created_at < '2012-11-27'
GROUP BY 1,2;

/*
3.	While we’re on Gsearch, could you dive into nonbrand, and pull monthly sessions and orders split by device type? 
I want to flex our analytical muscles a little and show the board we really know our traffic sources. 
*/ 
SELECT 
		YEAR(website_sessions.created_at) as yr, 
		MONTH(website_sessions.created_at) as mnth,
		COUNT(CASE WHEN utm_campaign = 'nonbrand' AND device_type = 'desktop' 
			THEN website_sessions.website_session_id ELSE NULL END) as nonbrand_desktop_sessions,
            COUNT(CASE WHEN utm_campaign = 'nonbrand' AND device_type = 'desktop' 
			THEN orders.website_session_id ELSE NULL END) as nonbrand_desktop_orders,
        COUNT(CASE WHEN utm_campaign = 'nonbrand' AND device_type = 'mobile' 
			THEN website_sessions.website_session_id ELSE NULL END) as nonbrand_mobile_sessions,
        COUNT(CASE WHEN utm_campaign = 'nonbrand' AND device_type = 'mobile' 
			THEN orders.website_session_id ELSE NULL END) as nonbrand_mobile_orders
       --  COUNT(CASE WHEN utm_campaign = 'nonbrand' AND device_type = 'desktop' THEN orders.website_session_id ELSE NULL END) as nonbrand_orders,
        
 FROM website_sessions 
 LEFT JOIN orders on orders.website_session_id = website_sessions.website_session_id
WHERE utm_source ='gsearch' AND website_sessions.created_at < '2012-11-27'
GROUP BY 1,2;

/*
4.	I’m worried that one of our more pessimistic board members may be concerned about the large % of traffic from Gsearch. 
Can you pull monthly trends for Gsearch, alongside monthly trends for each of our other channels?
*/ 
SELECT 
		YEAR(created_at) as yr,
        MONTH(created_at) as mnth, 
        COUNT(CASE WHEN utm_source = 'gsearch' THEN website_session_id ELSE NULL END) as gsearch_paid_sessions,
        COUNT(CASE WHEN utm_source = 'bsearch' THEN website_session_id ELSE NULL END) as bsearch_paid_sessions,
        COUNT(CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN website_session_id ELSE NULL END) as organic_search_sessions,
        COUNT(CASE WHEN utm_source IS NULL AND http_referer IS  NULL  THEN website_session_id ELSE NULL END) as direct_typein_sessions
        
	FROM website_sessions
WHERE  website_sessions.created_at < '2012-11-27'  -- utm_source ='gsearch' AND
GROUP BY 1,2;
/*
5.	I’d like to tell the story of our website performance improvements over the course of the first 8 months. 
Could you pull session to order conversion rates, by month? 

*/ 
SELECT
		YEAR(website_sessions.created_at),
        MONTH(website_sessions.created_at),
        COUNT(website_sessions.website_session_id ) AS sessions,
        COUNT(orders.website_session_id ) AS orders,
        COUNT(orders.website_session_id )/COUNT(website_sessions.website_session_id ) AS rt
	FROM website_sessions 
	LEFT JOIN orders ON orders.website_session_id = website_sessions.website_session_id
    WHERE  website_sessions.created_at < '2012-11-27' 
    GROUP BY 1,2;
/*
6.	For the gsearch lander test, please estimate the revenue that test earned us 
(Hint: Look at the increase in CVR from the test (Jun 19 – Jul 28), and use 
nonbrand sessions and revenue since then to calculate incremental value)
*/ 
SELECT MIN(website_pageview_id), MIN(created_at)
 FROM website_pageviews WHERE pageview_url = '/lander-1';
 -- 23504 2012-06-19
 CREATE TEMPORARY TABLE first_pv
 SELECT 
		website_sessions.website_session_id, 
        MIN(website_pageview_id) as min_pv_id
	FROM website_pageviews 
    LEFT JOIN website_sessions ON website_pageviews.website_session_id = website_sessions.website_session_id
		WHERE website_sessions.created_at < '2012-07-28'
        AND website_pageviews.website_pageview_id >=23504
          AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
    GROUP BY 1; 
SELECT * FROM first_pv;

SELECT *
FROM first_pv 
LEFT JOIN website_pageviews ON website_pageviews.website_pageview_id = first_pv.min_pv_id;
 SELECT SUM(price_usd) as tot_lander_rev FROM website_pageviews
 LEFT JOIN orders ON website_pageviews.website_session_id = orders.website_session_id 
 WHERE orders.created_at BETWEEN '2012-06-19' AND '2012-07-28' AND pageview_url IN ('/home', '/lander-1')
/*
7.	For the landing page test you analyzed previously, it would be great to show a full conversion funnel 
from each of the two pages to orders. You can use the same time period you analyzed last time (Jun 19 – Jul 28).
*/ 


/*
8.	I’d love for you to quantify the impact of our billing test, as well. Please analyze the lift generated 
from the test (Sep 10 – Nov 10), in terms of revenue per billing page session, and then pull the number 
of billing page sessions for the past month to understand monthly impact.
*/ 

