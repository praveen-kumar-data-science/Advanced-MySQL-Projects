CREATE TEMPORARY TABLE first_page_vie
SELECT website_session_id, min(website_pageview_id) as min_pageview_id
FROM website_pageviews
WHERE website_pageview_id < 1000
GROUP BY website_session_id;

SELECT  website_pageviews.pageview_url as landing_page, count(first_page_vie.website_session_id) FROM first_page_vie
LEFT JOIN website_pageviews on first_page_vie.min_pageview_id = website_pageviews.website_pageview_id
GROUP BY 1;

SELECT pageview_url, count(distinct(website_pageview_id)) as cnt from website_pageviews where created_at < '2012-06-09'
GROUP BY 1
ORDER BY cnt desc;


CREATE TEMPORARY TABLE first_page_vi
SELECT website_session_id, min(website_pageview_id) as min_pageview_id
FROM website_pageviews where website_pageviews.created_at < '2012-06-12'
GROUP BY website_session_id; 

SELECT pageview_url, count(website_pageviews.website_session_id)
 FROM first_page_vi LEFT JOIN website_pageviews on website_pageviews.website_pageview_id = first_page_vi.min_pageview_id
GROUP BY 1;

-- Bounce rate for created_at < '2012-06-14'
CREATE TEMPORARY TABLE first_page
SELECT website_pageviews.website_session_id, min(website_pageviews.website_pageview_id) as min_pageview_id FROM website_pageviews
LEFT JOIN website_sessions ON website_sessions.website_session_id =  website_pageviews.website_session_id
 WHERE website_sessions.created_at < '2012-06-14'
 GROUP BY 1;
 
 SELECT * FROM first_page;
 CREATE TEMPORARY TABLE landing_page_table
 SELECT first_page.website_session_id, website_pageviews.pageview_url  as landing_page
 FROM first_page 
 LEFT JOIN website_pageviews on first_page.min_pageview_id = website_pageviews.website_pageview_id;
 
 SELECT * FROM landing_page_table;
 CREATE TEMPORARY TABLE bounced_session
 SELECT landing_page_table.website_session_id, landing_page_table.landing_page, 
 COUNT(DISTINCT(website_pageviews.website_pageview_id)) as cnt
 FROM website_pageviews LEFT JOIN landing_page_table ON website_pageviews.website_session_id = landing_page_table.website_session_id
 GROUP BY 1,2
 HAVING cnt = 1;
 SELECT * FROM bounced_session;
 
 SELECT landing_page_table.landing_page, landing_page_table.website_session_id as sessions, bounced_session.website_session_id AS bounce
 FROM landing_page_table LEFT JOIN bounced_session ON bounced_session.website_session_id = landing_page_table.website_session_id
-- GROUP BY 1
ORDER BY 1;

 SELECT  landing_page_table.landing_page,
 count(landing_page_table.website_session_id) as sessions, count(bounced_session.website_session_id) AS bounce,
 100*count(bounced_session.website_session_id)/count(landing_page_table.website_session_id) AS bounce_rate
 FROM landing_page_table LEFT JOIN bounced_session ON bounced_session.website_session_id = landing_page_table.website_session_id
GROUP BY 1;
#ORDER BY 2
 
 SELECT min(created_at), min(website_pageview_id) AS first_pageview_id FROM website_pageviews 
 WHERE created_at > '2012-06-09' AND  created_at < '2012-07-28' AND pageview_url = '/lander-1';
 
 -- Bounce rate for created_at > '2012-06-09' AND  created_at < '2012-07-28' AND pageview_url = '/lander-1'
CREATE TEMPORARY TABLE first_pge_table
SELECT website_pageviews.website_session_id, min(website_pageviews.website_pageview_id) as min_pageview_id FROM website_pageviews
LEFT JOIN website_sessions ON website_sessions.website_session_id =  website_pageviews.website_session_id
 WHERE website_sessions.created_at > '2012-06-14' AND website_sessions.created_at < '2012-07-28' 
 AND pageview_url = '/lander-1' OR pageview_url = '/home'
 GROUP BY 1;
 
 SELECT * FROM first_pge_table;
 CREATE TEMPORARY TABLE landing_pg_table
 SELECT first_pge_table.website_session_id, website_pageviews.pageview_url  as landing_page
 FROM first_pge_table 
 LEFT JOIN website_pageviews on first_pge_table.min_pageview_id = website_pageviews.website_pageview_id;
 
 SELECT * FROM landing_pg_table;
 CREATE TEMPORARY TABLE bounced_session
 SELECT landing_pg_table.website_session_id, landing_pg_table.landing_page, 
 COUNT(DISTINCT(website_pageviews.website_pageview_id)) as cnt
 FROM website_pageviews LEFT JOIN landing_pg_table ON website_pageviews.website_session_id = landing_pg_table.website_session_id
 GROUP BY 1,2
 HAVING cnt = 1;
 SELECT * FROM bounced_session;
 
 SELECT landing_pg_table.landing_page, landing_pg_table.website_session_id as sessions, bounced_session.website_session_id AS bounce
 FROM landing_pg_table LEFT JOIN bounced_session ON bounced_session.website_session_id = landing_pg_table.website_session_id
-- GROUP BY 1
ORDER BY 1;

 SELECT  landing_page_table.landing_page,
 count(landing_page_table.website_session_id) as sessions, count(bounced_session.website_session_id) AS bounce,
 100*count(bounced_session.website_session_id)/count(landing_page_table.website_session_id) AS bounce_rate
 FROM landing_page_table LEFT JOIN bounced_session ON bounced_session.website_session_id = landing_page_table.website_session_id
GROUP BY 1;