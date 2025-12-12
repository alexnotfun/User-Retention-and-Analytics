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
FROM first_events)
(SELECT
	ROUND(verified*100/signups, 2) AS conv_verified,
    ROUND(onboarded*100/verified, 2) AS conv_onboarded,
    ROUND(viewed_feature*100/onboarded, 2) AS conv_viewing_feature,
    ROUND(added_to_cart*100/viewed_feature, 2) AS conv_to_cart,
    ROUND(purchased*100/added_to_cart, 2) AS conv_to_purchased,
    ROUND(purchased*100/signups , 2) AS macro_conversion
FROM metrics);
