-- ============================================================
-- DATE & TIME
-- ============================================================

-- [9845] April Admin Employees (Microsoft)
SELECT COUNT(*) AS n_admins
FROM worker
WHERE department = 'Admin'
AND EXTRACT(MONTH FROM joining_date) >= 4;

-- [9728] Number of Violations - Roxanne Cafe (City of San Francisco)
SELECT EXTRACT(YEAR FROM inspection_date) AS inspection_year, 
       COUNT(violation_id) AS n_violations
FROM sf_restaurant_health_violations
WHERE business_name = 'Roxanne Cafe'
AND violation_id IS NOT NULL
GROUP BY inspection_year
ORDER BY inspection_year;

-- [10352] Users By Average Session Time (Facebook) - Medium
-- Key: subquery first aggregates load/exit per user per day, outer AVG across days
-- Key: FILTER (WHERE ...) replaces CTE for cleaner aggregation
-- Key: EXTRACT(EPOCH FROM interval) converts time difference to seconds
SELECT user_id,
       AVG(EXTRACT(EPOCH FROM (earliest_exit - latest_load))) AS avg_session_time
FROM (
    SELECT user_id,
           DATE(timestamp) AS day,
           MAX(timestamp::timestamp) FILTER (WHERE action = 'page_load') AS latest_load,
           MIN(timestamp::timestamp) FILTER (WHERE action = 'page_exit') AS earliest_exit
    FROM facebook_web_log
    GROUP BY user_id, DATE(timestamp)
) daily
WHERE earliest_exit > latest_load
GROUP BY user_id;
