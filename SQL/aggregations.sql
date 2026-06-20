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

-- [10130] Inspections by Risk Category (SF Health) - Medium
-- Key: PIVOT using CASE WHEN to turn row values into columns
-- Key: COUNT(CASE WHEN condition THEN 1 END) counts matching rows
-- Key: NULL risk_category is treated as a separate category
SELECT inspection_type,
       COUNT(CASE WHEN risk_category IS NULL THEN 1 END) AS no_risk_results,
       COUNT(CASE WHEN risk_category = 'Low Risk' THEN 1 END) AS low_risk_results,
       COUNT(CASE WHEN risk_category = 'Moderate Risk' THEN 1 END) AS medium_risk_results,
       COUNT(CASE WHEN risk_category = 'High Risk' THEN 1 END) AS high_risk_results,
       COUNT(*) AS total_inspections
FROM sf_restaurant_health_violations
GROUP BY inspection_type
ORDER BY total_inspections DESC;

-- [10090] Percentage of Shipable Orders (Amazon) - Medium
-- Key: JOIN customers to get address; no WHERE needed
-- Key: CASE WHEN inside COUNT to count shipable orders
-- Key: * 100.0 to avoid integer division
SELECT COUNT(CASE WHEN c.address IS NOT NULL THEN 1 END) * 100.0 / COUNT(*) AS percent_shipable
FROM orders o
JOIN customers c ON o.cust_id = c.id;

-- [10060] Top Cool Votes (Yelp) - Medium
-- Key: Subquery with MAX() to find highest value; handles ties unlike LIMIT 1
SELECT business_name, review_text
FROM yelp_reviews
WHERE cool = (SELECT MAX(cool) FROM yelp_reviews);

-- Titanic Survivors and Non-Survivors (StrataScratch #9881)
-- Pivot pclass into columns, grouped by survived status.
-- COUNT(CASE WHEN...) only counts non-NULL matches per class.
SELECT survived,
       COUNT(CASE WHEN pclass = 1 THEN 1 END) AS first_class,
       COUNT(CASE WHEN pclass = 2 THEN 1 END) AS second_class,
       COUNT(CASE WHEN pclass = 3 THEN 1 END) AS third_class
FROM titanic
GROUP BY survived;

-- Problem: 1193. Monthly Transactions I
-- Difficulty: Medium
-- Topic: Aggregations (GROUP BY, conditional aggregation, COALESCE)
-- Link: https://leetcode.com/problems/monthly-transactions-i/

-- For each month and country, find the number of transactions and their total amount,
-- the number of approved transactions and their total amount.

SELECT DATE_FORMAT(trans_date, '%Y-%m') AS month, 
    country, 
    COUNT(*) AS trans_count, 
    COUNT(CASE WHEN state='approved' THEN 1 END) AS approved_count, 
    SUM(amount) AS trans_total_amount, 
    COALESCE(SUM(CASE WHEN state='approved' THEN amount END), 0) AS approved_total_amount
FROM Transactions
GROUP BY month, country;

-- Key takeaways:
-- 1. DATE_FORMAT(date_col, '%Y-%m') extracts "YYYY-MM" string directly, avoiding
--    year/month collision issues that MONTH(date_col) alone would cause.
-- 2. COUNT(CASE WHEN condition THEN 1 END) is the standard conditional count pattern:
--    rows not matching the condition return NULL, which COUNT() ignores.
-- 3. SUM(CASE WHEN condition THEN col END) returns NULL (not 0) when no rows match
--    the condition within a group. Wrap with COALESCE(..., 0) to force 0 instead of NULL.
