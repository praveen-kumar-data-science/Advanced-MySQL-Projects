SELECT MIN(created_at), MIN(website_pageview_id), MIN(website_session_id) FROM website_pageviews WHERE pageview_url = '/lander-1';
CREATE TEMPORARY TABLE first_page
SELECT website_pageviews.website_session_id, MIN(website_pageviews.website_pageview_id) AS min_pageview_id
FROM website_pageviews JOIN website_sessions on website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.created_at > '2012-06-19' AND website_sessions.created_at < '2012-07-28' 
AND website_sessions.utm_source = 'gsearch' AND website_sessions.utm_campaign = 'nonbrand' 
GROUP BY 1;
SELECT * FROM first_page;
CREATE TEMPORARY TABLE url
SELECT first_page.website_session_id, first_page.min_pageview_id, website_pageviews.pageview_url 
FROM first_page LEFT JOIN website_pageviews ON website_pageviews.website_pageview_id = first_page.min_pageview_id;
SELECT * FROM url;
CREATE TEMPORARY TABLE bnce
SELECT url.website_session_id, url.min_pageview_id, url.pageview_url, COUNT(DISTINCT (website_pageviews.website_pageview_id)) as cnt
FROM url LEFT JOIN website_pageviews ON website_pageviews.website_session_id = url.website_session_id
GROUP BY 1
HAVING cnt =1;
SELECT * FROM bnce;

SELECT url.pageview_url, url.website_session_id as sessions, bnce.website_session_id AS bounce
 FROM url LEFT JOIN bnce ON url.website_session_id = bnce.website_session_id 
ORDER BY url.website_session_id;

SELECT url.pageview_url, COUNT(url.website_session_id) as sessions, COUNT(bnce.website_session_id) AS bounce,
COUNT(bnce.website_session_id)/COUNT(url.website_session_id) as bounce_rate
 FROM url LEFT JOIN bnce ON url.website_session_id = bnce.website_session_id 
GROUP BY 1;

CREATE TEMPORARY TABLE min_pg
SELECT website_sessions.website_session_id, MIN(website_pageviews.website_pageview_id) AS min_pageview_id, 
MIN(DATE(website_sessions.created_at)) as week_start_date
FROM website_sessions LEFT JOIN website_pageviews on website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.created_at > '2012-06-01' AND website_sessions.created_at < '2012-08-31' 
AND website_sessions.utm_source = 'gsearch' AND website_sessions.utm_campaign = 'nonbrand' 
GROUP BY 1;
SELECT * FROM min_pg ORDER BY website_session_id;
CREATE TEMPORARY TABLE land_page
SELECT min_pg.website_session_id, week_start_date, website_pageviews.pageview_url
FROM min_pg LEFT JOIN website_pageviews ON website_pageviews.website_pageview_id = min_pg.min_pageview_id;
SELECT * FROM land_page;
CREATE TEMPORARY TABLE boun
SELECT 
		land_page.website_session_id,
        land_page.week_start_date, land_page.pageview_url,
      --   COUNT(land_page.pageview_url) AS total_sessions, 
		COUNT(website_pageviews.website_pageview_id) as ct FROM land_page 
LEFT JOIN website_pageviews ON land_page.website_session_id=website_pageviews.website_session_id
GROUP BY 1;
SELECT * FROM boun;
SELECT YEARWEEK(boun.week_start_date) FROM boun;
SELECT YEARWEEK(boun.week_start_date), MIN(boun.week_start_date),-- , land_page.pageview_url,
 COUNT(boun.pageview_url) as total_sessions,
 COUNT(CASE WHEN boun.ct = 1 THEN boun.website_session_id ELSE NULL END) as bounced_sessions,
 COUNT(CASE WHEN boun.ct = 1 THEN boun.website_session_id ELSE NULL END)/ COUNT(boun.pageview_url) as bounce_rate,
 COUNT(CASE WHEN boun.pageview_url = '/home' THEN boun.website_session_id ELSE NULL END) AS home_sessions,
  COUNT(CASE WHEN boun.pageview_url = '/lander-1' THEN boun.website_session_id ELSE NULL END) AS lander_sessions
 FROM boun
-- FROM land_page LEFT JOIN boun on boun.website_session_id = land_page.website_session_id
GROUP BY 1;

-- SELECT land_pa