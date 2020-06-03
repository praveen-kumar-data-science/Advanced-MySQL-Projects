-- BUSINESS CONTEXT wE WANNA SEE THE LANDING PAGE PERFORMANCE FOR A CERTAIN TIME PERIOD
-- STEP 1  FIND THE FIRST website_pageview_id for relevant sessions
-- STEP 2  IDENTIFY THE LANDING PAGE FOR EACH SESSION
-- STEP 3  COUNTING PAGEVIEWS FOR EACH SESSION TO IDENTIFY 'BOUNCES'
-- STEP 4  SUMMARIZING TOTAL SESSIONS AND BOUNCED SESSIONS, BY LP

CREATE TEMPORARY TABLE first_pageview_demo
SELECT website_pageviews.website_session_id, min(website_pageviews.website_pageview_id) as min_pageview_id
FROM website_pageviews 
INNER JOIN website_sessions on website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY 1;

SELECT * FROM first_pageview_demo;
CREATE TEMPORARY TABLE sessions_w_landing_page_demo
SELECT first_pageview_demo.website_session_id,website_pageviews.pageview_url as landing_page
FROM first_pageview_demo LEFT JOIN website_pageviews on website_pageviews.website_pageview_id = first_pageview_demo.min_pageview_id;

SELECT * FROM sessions_w_landing_page_demo;

-- Find how many pageviews the user had on his session
-- CREATE TEMPORARY TABLE bounced_sessions_only
SELECT sessions_w_landing_page_demo.website_session_id, sessions_w_landing_page_demo.landing_page,
 COUNT(website_pageviews.website_pageview_id) AS count_of_page_viewed
FROM sessions_w_landing_page_demo LEFT JOIN website_pageviews on website_pageviews.website_session_id = sessions_w_landing_page_demo.website_session_id
GROUP BY 1,2
HAVING count_of_page_viewed = 1;

SELECT * from bounced_sessions_only;

SELECT sessions_w_landing_page_demo.landing_page, sessions_w_landing_page_demo.website_session_id, 
bounced_sessions_only.website_session_id AS bounced_website_session_id
FROM sessions_w_landing_page_demo LEFT JOIN bounced_sessions_only on bounced_sessions_only.website_session_id = sessions_w_landing_page_demo.website_session_id
ORDER BY sessions_w_landing_page_demo.website_session_id;   #Here Null value means no bounce and user has moved to next page(for the session)

-- FINAL OUTPUT
SELECT  sessions_w_landing_page_demo.landing_page, 
		COUNT(sessions_w_landing_page_demo.website_session_id) as sessions, 
		COUNT(bounced_sessions_only.website_session_id) AS bounced_sessions,
        100*COUNT(bounced_sessions_only.website_session_id)/COUNT(sessions_w_landing_page_demo.website_session_id) AS bounce_rate
	FROM sessions_w_landing_page_demo
 LEFT JOIN bounced_sessions_only on bounced_sessions_only.website_session_id = sessions_w_landing_page_demo.website_session_id
GROUP BY 1
ORDER BY bounce_rate DESC;