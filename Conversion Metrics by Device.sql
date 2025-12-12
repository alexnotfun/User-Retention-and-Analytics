WITH funnel AS 
(
SELECT user_id,
MIN(CASE WHEN event_name = "signup" THEN event_time END) AS signup_time ,
MIN(CASE WHEN event_name = "verify_email" THEN event_time END) AS verfication_time ,
MIN(CASE WHEN event_name = "onboarding_completed" THEN event_time END) AS onboarding_time ,
MIN(CASE WHEN event_name = "view_feature" THEN event_time END) AS feature_time ,
MIN(CASE WHEN event_name = "add_to_cart" THEN event_time END) AS add_to_cart_time,
MIN(CASE WHEN event_name = "purchase" THEN event_time END) AS purchase_time
FROM events
GROUP BY user_id
ORDER BY user_id
)


SELECT
device, 
ROUND(100*COUNT(verfication_time)/COUNT(signup_time), 2) AS conv_ver,
ROUND(100*COUNT(onboarding_time)/COUNT(verfication_time), 2) AS conv_onb,
ROUND(100*COUNT(feature_time)/COUNT(onboarding_time), 2) AS conv_view_feature,
ROUND(100*COUNT(add_to_cart_time)/COUNT(feature_time), 2) AS conv_add_cart,
ROUND(100*COUNT(purchase_time)/COUNT(add_to_cart_time), 2) AS conv_purchase,
ROUND(100*COUNT(purchase_time)/COUNT(signup_time), 2) AS macro_conv_purchase
FROM users u
LEFT JOIN funnel f
ON u.user_id = f.user_id
GROUP BY device