-- ============================================================
-- AGGREGATIONS
-- ============================================================
-- [10127] Calculate Samantha's and Lisa's total sales revenue (Amazon)
SELECT SUM(sales_revenue) AS total_revenue
FROM sales_performance
WHERE salesperson IN ('Samantha', 'Lisa');

-- [10005] Hour Of Highest Gas Expense (Lyft)
SELECT hour
FROM lyft_rides
ORDER BY gasoline_cost DESC
LIMIT 1;

-- [9992] Artist Appearance Count (Spotify)
SELECT DISTINCT artist, COUNT(position) AS n_occurences 
FROM spotify_worldwide_daily_song_ranking
GROUP BY artist
ORDER BY n_occurences DESC;

-- [9991] Top Ranked Songs (Spotify)
SELECT trackname, COUNT(*) AS times_top1
FROM spotify_worldwide_daily_song_ranking
WHERE position = '1'
GROUP BY trackname
ORDER BY times_top1 DESC;

-- [9943] Olympics Events List By Age (ESPN)
SELECT MIN(age) AS lowest_age,
       AVG(age) AS mean_age,
       MAX(age) AS highest_age
FROM olympics_athletes_events;

-- [9911] Departments With 5 Employees (Burtch Works)
SELECT department 
FROM employee
GROUP BY department
HAVING COUNT(*) >= 5;

-- [9663] Most Profitable Financial Company (Forbes)
SELECT company, continent
FROM forbes_global_2010_2014
WHERE sector = 'Financials'
ORDER BY profits DESC
LIMIT 1;

-- [9653] MacBookPro User Event Count (Playbook)
SELECT event_name, COUNT(*) AS event_count
FROM playbook_events
WHERE device = 'macbook pro'
GROUP BY event_name
ORDER BY event_count DESC;

-- [2169] Contact Information Completeness (TechCorp)
-- Key: use CASE WHEN inside COUNT for NULL ratio, not WHERE
SELECT COUNT(CASE WHEN phone_number IS NULL THEN 1 END) * 1.0 / COUNT(*) AS null_phone_ratio
FROM techcorp_workforce;

-- [2056] Number of Shipments Per Month (Amazon)
-- Key: TO_CHAR for YYYY-MM format; use || to concat for DISTINCT multi-column
SELECT TO_CHAR(shipment_date, 'YYYY-MM') AS year_month,
       COUNT(DISTINCT shipment_id || '-' || sub_id) AS count
FROM amazon_shipment
GROUP BY year_month
ORDER BY year_month;

-- [2024] Unique Users Per Client Per Month (Facebook)
-- Key: EXTRACT(MONTH) returns integer 1-12; GROUP BY all non-aggregate columns
SELECT client_id,
       EXTRACT(MONTH FROM time_id) AS month,
       COUNT(DISTINCT user_id) AS users_num
FROM fact_events
GROUP BY client_id, EXTRACT(MONTH FROM time_id)
ORDER BY client_id, month;
