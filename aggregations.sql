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
