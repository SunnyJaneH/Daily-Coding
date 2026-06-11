-- ============================================================
-- CTE (Common Table Expressions)
-- ============================================================

-- [10285] Acceptance Rate By Date (Facebook) - Medium
-- Key: LEFT JOIN to keep all sent records even if not accepted
-- Key: HAVING instead of WHERE for filtering on aggregated values
-- Key: * 1.0 to avoid integer division in PostgreSQL
WITH sent AS (
    SELECT *
    FROM fb_friend_requests
    WHERE action = 'sent'
),
accept AS (
    SELECT *
    FROM fb_friend_requests
    WHERE action = 'accepted'
)
SELECT s.date,
       COUNT(a.user_id_receiver) * 1.0 / COUNT(s.user_id_sender) AS percentage_acceptance
FROM sent s
LEFT JOIN accept a
    ON a.user_id_sender = s.user_id_sender
    AND a.user_id_receiver = s.user_id_receiver
GROUP BY s.date
HAVING COUNT(a.user_id_receiver) > 0;
