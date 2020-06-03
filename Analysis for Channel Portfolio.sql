USE mavenfuzzyfactory;

SELECT 
		WEEK(created_at),
        MIN(DATE(created_at)) as week_start,
        COUNT(CASE WHEN utm_source = 'gsearch' THEN website_session_id ELSE NULL END) AS gsearch,
        COUNT(CASE WHEN utm_source = 'bsearch' THEN website_session_id ELSE NULL END) AS bsearch
FROM website_sessions
where created_at > '2012-08-22' AND created_at < '2012-11-29'
AND utm_campaign = 'nonbrand'
GROUP BY WEEK(created_at);

SELECT 
		utm_source,
        COUNT(DISTINCT website_session_id) AS sessions,
        COUNT(CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END ) AS mobile_sessions,
		100*COUNT(CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END )/  COUNT(DISTINCT website_session_id) AS percent
        
 FROM website_sessions
 WHERE created_at > '2012-08-22' AND created_at < '2012-11-30' AND utm_campaign = 'nonbrand'
 GROUP BY 1;
 
 SELECT 
		website_sessions.device_type,
        website_sessions.utm_source,
        COUNT(DISTINCT website_sessions. website_session_id) AS sessions,
        COUNT(DISTINCT orders.website_session_id) AS orders,
        100*COUNT(DISTINCT orders.website_session_id)/ COUNT(DISTINCT website_sessions. website_session_id) AS CVR
        FROM website_sessions LEFT JOIN orders on orders.website_session_id = website_sessions.website_session_id
        WHERE utm_campaign = 'nonbrand' AND website_sessions.created_at > '2012-08-22' AND website_sessions.created_at < '2012-09-18' 
	GROUP BY 1,2;
    
 SELECT 
		WEEK(created_at),
        MIN(date(created_at)),
        COUNT(CASE WHEN device_type = 'desktop' AND utm_source = 'gsearch' 
										THEN website_sessions. website_session_id ELSE NULL END) AS dtop_gsessions,
		COUNT(CASE WHEN device_type = 'desktop' AND utm_source = 'bsearch' 
										THEN website_sessions. website_session_id ELSE NULL END) AS dtop_bsessions,
		COUNT(CASE WHEN device_type = 'desktop' AND utm_source = 'bsearch' 
										THEN website_sessions. website_session_id ELSE NULL END)/
						COUNT(CASE WHEN device_type = 'desktop' AND utm_source = 'gsearch' 
										THEN website_sessions. website_session_id ELSE NULL END) AS percent_b_to_g_dt,
		COUNT(CASE WHEN device_type = 'mobile' AND utm_source = 'gsearch' 
										THEN website_sessions. website_session_id ELSE NULL END) AS mobile_gsessions,
		COUNT(CASE WHEN device_type = 'mobile' AND utm_source = 'bsearch' 
										THEN website_sessions. website_session_id ELSE NULL END) AS mobile_bsessions,
		COUNT(CASE WHEN device_type = 'mobile' AND utm_source = 'bsearch' 
										THEN website_sessions. website_session_id ELSE NULL END)/
				COUNT(CASE WHEN device_type = 'mobile' AND utm_source = 'gsearch' 
										THEN website_sessions. website_session_id ELSE NULL END) AS percent_b_to_g_mo
        FROM website_sessions
        WHERE utm_campaign = 'nonbrand' AND website_sessions.created_at > '2012-11-04' AND website_sessions.created_at < '2012-12-22' 
	GROUP BY 1;
    
SELECT 
		YEAR(created_at),
        MONTH(created_at),
        COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS nonbrand,
        COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN website_session_id ELSE NULL END) AS brand,
        COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN website_session_id 
			ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS brand_p_of_nonbrand,
        COUNT(CASE WHEN http_referer IS NULL THEN website_session_id ELSE NULL END) AS direct,
        COUNT(CASE WHEN http_referer IS NULL THEN website_session_id 
			ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS dir_percent_of_nonbrand,
		COUNT(CASE WHEN http_referer IS NOT NULL  AND utm_source IS NULL THEN website_session_id ELSE NULL END) AS organic,
        COUNT(CASE WHEN http_referer IS NOT NULL  AND utm_source IS NULL THEN website_session_id 
			ELSE NULL END)/COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id ELSE NULL END) AS org_percent_of_nonbrand
        FROM website_sessions 
        WHERE website_sessions.created_at < '2012-12-23' 
	GROUP BY 1,2 ;