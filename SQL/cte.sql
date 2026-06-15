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

-- [10077] Income By Title and Gender (SF) - Medium
-- Key: CTE to sum bonuses per employee first, then JOIN
-- Key: JOIN (not LEFT JOIN) automatically excludes employees without bonuses
WITH bonus AS (
    SELECT worker_ref_id, SUM(bonus) AS total_bonus
    FROM sf_bonus
    GROUP BY worker_ref_id
)
SELECT e.employee_title,
       e.sex,
       AVG(e.salary + b.total_bonus) AS avg_compensation
FROM sf_employee e
JOIN bonus b ON e.id = b.worker_ref_id
GROUP BY e.employee_title, e.sex;
