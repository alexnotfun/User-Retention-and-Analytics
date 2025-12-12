#Funnel Analysis
#Every product has a sequence of actions user must take before completing desired outcome
USE analytics_portfolio;
WITH first_events AS (
    SELECT 
        user_id,
        MIN(CASE WHEN event_name = 'signup' THEN event_time END) AS signup_time,
        MIN(CASE WHEN event_name = 'verify_email' THEN event_time END) AS verify_time,
        MIN(CASE WHEN event_name = 'onboarding_completed' THEN event_time END) AS onboard_time,
        MIN(CASE WHEN event_name = 'view_feature' THEN event_time END) AS feature_time,
        MIN(CASE WHEN event_name = 'add_to_cart' THEN event_time END) AS cart_time,
        MIN(CASE WHEN event_name = 'purchase' THEN event_time END) AS purchase_time
    FROM events
    GROUP BY user_id
), metrics AS 
(SELECT
	COUNT(*) AS signups,
    COUNT(verify_time) AS verified,
    COUNT(onboard_time) AS onboarded,
    COUNT(feature_time) AS viewed_feature,
    COUNT(cart_time) AS added_to_cart,
    COUNT(purchase_time) AS purchased
FROM first_events),

h2p AS (SELECT
	user_id, 
    timestampdiff(HOUR, signup_time, purchase_time) AS hours_to_purchase
FROM first_events
WHERE timestampdiff(HOUR, signup_time, purchase_time) IS NOT NULL AND timestampdiff(HOUR, signup_time, purchase_time) > 0
ORDER BY hours_to_purchase)

SELECT device, hours_to_purchase FROM users u
LEFT JOIN h2p h
ON u.user_id = h.user_id
WHERE hours_to_purchase IS NOT NULL