-- =========================================
-- EVENTLYTICS SQL ANALYSIS QUERIES
-- =========================================
-- This file contains queries to analyze how
-- moving house impacts food spending.
-- =========================================


-- =========================================
-- QUERY 1: BEFORE VS AFTER SPENDING
-- =========================================
-- This query calculates total food spending
-- before and after the moving event for each user

SELECT 
    u.user_id,
    u.name,
    
    SUM(CASE 
        WHEN t.transaction_date < e.event_date THEN t.amount 
        ELSE 0 
    END) AS before_spending,
    
    SUM(CASE 
        WHEN t.transaction_date >= e.event_date THEN t.amount 
        ELSE 0 
    END) AS after_spending

FROM users u
JOIN transactions_food t ON u.user_id = t.user_id
JOIN events e ON u.user_id = e.user_id

GROUP BY u.user_id, u.name;


-- =========================================
-- QUERY 2: SPENDING CHANGE
-- =========================================
-- This query calculates the difference between
-- after-moving and before-moving spending

SELECT 
    u.user_id,
    u.name,
    
    SUM(CASE 
        WHEN t.transaction_date < e.event_date THEN t.amount 
        ELSE 0 
    END) AS before_spending,
    
    SUM(CASE 
        WHEN t.transaction_date >= e.event_date THEN t.amount 
        ELSE 0 
    END) AS after_spending,

    (
        SUM(CASE WHEN t.transaction_date >= e.event_date THEN t.amount ELSE 0 END)
        -
        SUM(CASE WHEN t.transaction_date < e.event_date THEN t.amount ELSE 0 END)
    ) AS spending_change

FROM users u
JOIN transactions_food t ON u.user_id = t.user_id
JOIN events e ON u.user_id = e.user_id

GROUP BY u.user_id, u.name;


-- =========================================
-- QUERY 3: HIGHEST SPENDING INCREASE
-- =========================================
-- This query identifies which users increased
-- their spending the most after moving

SELECT 
    u.name,
    
    (
        SUM(CASE WHEN t.transaction_date >= e.event_date THEN t.amount ELSE 0 END)
        -
        SUM(CASE WHEN t.transaction_date < e.event_date THEN t.amount ELSE 0 END)
    ) AS spending_change

FROM users u
JOIN transactions_food t ON u.user_id = t.user_id
JOIN events e ON u.user_id = e.user_id

GROUP BY u.name
ORDER BY spending_change DESC;


-- =========================================
-- QUERY 4: SPENDING CHANGE WITH PERCENTAGE
-- =========================================
-- This query calculates both absolute and
-- percentage change in spending

SELECT 
    u.user_id,
    u.name,
    
    SUM(CASE WHEN t.transaction_date < e.event_date THEN t.amount ELSE 0 END) AS before_spending,
    SUM(CASE WHEN t.transaction_date >= e.event_date THEN t.amount ELSE 0 END) AS after_spending,

    (
        SUM(CASE WHEN t.transaction_date >= e.event_date THEN t.amount ELSE 0 END)
        -
        SUM(CASE WHEN t.transaction_date < e.event_date THEN t.amount ELSE 0 END)
    ) AS spending_change,

    ROUND(
        (
            (
                SUM(CASE WHEN t.transaction_date >= e.event_date THEN t.amount ELSE 0 END)
                -
                SUM(CASE WHEN t.transaction_date < e.event_date THEN t.amount ELSE 0 END)
            )
            /
            SUM(CASE WHEN t.transaction_date < e.event_date THEN t.amount ELSE 0 END)
        ) * 100, 2
    ) AS percentage_change

FROM users u
JOIN transactions_food t ON u.user_id = t.user_id
JOIN events e ON u.user_id = e.user_id

GROUP BY u.user_id, u.name;
