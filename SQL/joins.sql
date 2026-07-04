-- ============================================================
-- JOINS & SETS
-- ============================================================

-- [10087] Find all posts reacted to with a heart (Meta)
SELECT DISTINCT fp.* 
FROM facebook_posts fp
JOIN facebook_reactions fr ON fp.post_id = fr.post_id
WHERE fr.reaction = 'heart';

-- [10183] Total Cost Of Orders (Etsy)
SELECT DISTINCT c.id, c.first_name, SUM(o.total_order_cost) AS total_order_cost
FROM customers c
JOIN orders o ON c.id = o.cust_id
GROUP BY c.id, c.first_name
ORDER BY c.first_name ASC;

-- [10353] Workers With The Highest Salaries (Amazon)
WITH joined AS (
    SELECT w.salary, t.worker_title
    FROM worker w
    JOIN title t ON w.worker_id = t.worker_ref_id
)
SELECT worker_title AS best_paid_title
FROM joined
WHERE salary = (SELECT MAX(salary) FROM joined);

-- [9913] Order Details - Jill and Eva (Shopify)
SELECT c.first_name, o.order_date, o.order_details, o.total_order_cost
FROM customers c
JOIN orders o ON c.id = o.cust_id
WHERE c.first_name IN ('Jill', 'Eva')
ORDER BY c.id;

-- [10322] Finding User Purchases (Amazon) - Medium
-- Key: Self JOIN to compare purchases within the same user
-- Key: Restrict anchor to first purchase using MIN() subquery
-- Key: b.created_at > a.created_at excludes same-day purchases
SELECT DISTINCT a.user_id
FROM amazon_transactions a
JOIN amazon_transactions b
    ON a.user_id = b.user_id
    AND b.created_at > a.created_at
    AND b.created_at - a.created_at <= 7
WHERE a.created_at = (
    SELECT MIN(created_at)
    FROM amazon_transactions
    WHERE user_id = a.user_id
);

-- [10304] Risky Projects (LinkedIn) - Medium
-- Key: Three-table JOIN to link projects, assignments, and salaries
-- Key: Prorate salary by project duration: salary * (end_date - start_date) / 365.0
-- Key: CEILING() to round up to nearest dollar
-- Key: HAVING to filter after aggregation
SELECT p.title,
       p.budget,
       CEILING(SUM(e.salary * (p.end_date - p.start_date) / 365.0)) AS prorated_expenses
FROM linkedin_projects p
JOIN linkedin_emp_projects ep ON p.id = ep.project_id
JOIN linkedin_employees e ON ep.emp_id = e.id
GROUP BY p.title, p.budget
HAVING CEILING(SUM(e.salary * (p.end_date - p.start_date) / 365.0)) > p.budget
ORDER BY p.title;

-- [10156] Number Of Units Per Nationality (Airbnb) - Medium
-- Key: JOIN on host_id to link hosts and units
-- Key: Filter unit_type = 'Apartment' to count only apartment units
-- Key: COUNT(DISTINCT unit_id) to count unique apartments
SELECT h.nationality,
       COUNT(DISTINCT u.unit_id) AS apartment_count
FROM airbnb_hosts h
JOIN airbnb_units u ON h.host_id = u.host_id
WHERE h.age < 30
AND u.unit_type = 'Apartment'
GROUP BY h.nationality
ORDER BY apartment_count DESC;

-- [10085] Matching Users Pairs (Facebook) - Medium
-- Key: Self JOIN with multiple ON conditions
-- Key: same location, gender; different age, seniority
SELECT a.id AS employee_1,
       b.id AS employee_2
FROM facebook_employees a
JOIN facebook_employees b
    ON a.location = b.location
    AND a.age != b.age
    AND a.gender = b.gender
    AND a.is_senior != b.is_senior;

-- [10078] Matching Hosts and Guests (Airbnb) - Medium
-- Key: JOIN two different tables on gender and nationality
-- Key: DISTINCT to avoid duplicate pairs
SELECT DISTINCT a.host_id,
       g.guest_id
FROM airbnb_hosts a
JOIN airbnb_guests g
    ON a.gender = g.gender
    AND a.nationality = g.nationality;

-- Employee and Manager Salaries (StrataScratch #9894)
-- Find employees earning more than their own manager.
-- Self-join: e = employee row, m = that employee's manager row.
SELECT e.first_name, e.salary
FROM employee e
JOIN employee m ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;

-- Problem: 1174. Immediate Food Delivery II
-- Difficulty: Medium
-- Topic: Joins (subquery + JOIN to find "key row per group")
-- Link: https://leetcode.com/problems/immediate-food-delivery-ii/

-- Find the percentage of immediate orders in the FIRST orders of all customers,
-- rounded to 2 decimal places.

SELECT ROUND(SUM(CASE WHEN d.order_date=d.customer_pref_delivery_date THEN 1 ELSE 0 END)*100/COUNT(*),2) AS immediate_percentage
FROM Delivery d
JOIN (
    SELECT customer_id, 
           MIN(order_date) AS first_date 
    FROM Delivery
    GROUP BY customer_id
) t
ON d.customer_id = t.customer_id
WHERE d.order_date = t.first_date;

-- Key takeaways:
-- 1. Classic pattern: "find the full row matching an aggregate value per group."
--    Step 1 - subquery with GROUP BY + MIN/MAX gets the target value per group
--             (here: each customer's earliest order_date).
--    Step 2 - JOIN that result back to the original table on the group key
--             (customer_id) AND the aggregate value (order_date = first_date)
--             to recover the full row of data (customer_pref_delivery_date, etc).
-- 2. This pattern is very common in SQL interview questions - any time you need
--    "the row where X is min/max within each group", reach for this subquery+JOIN shape.
-- 3. ROUND(numerator * 100 / denominator, 2) is the standard percentage pattern.

-- Problem: 550. Game Play Analysis IV
-- Difficulty: Medium
-- Topic: Joins + Date functions (subquery + JOIN, DATE_ADD)
-- Link: https://leetcode.com/problems/game-play-analysis-iv/

-- Report the fraction of players that logged in again on the day after the day
-- they first logged in, rounded to 2 decimal places.

SELECT ROUND(SUM(CASE WHEN a.event_date=DATE_ADD(t.first_date,INTERVAL 1 DAY) THEN 1 ELSE 0 END)/COUNT(DISTINCT a.player_id),2) AS fraction
FROM Activity a
JOIN (
    SELECT player_id, MIN(event_date) AS first_date
    FROM Activity
    GROUP BY player_id
) t
ON a.player_id=t.player_id;

-- Key takeaways:
-- 1. Same "key row per group" subquery+JOIN pattern as 1174 - find each player's
--    first_date via GROUP BY + MIN, then JOIN back to check for next-day login.
-- 2. DATE_ADD(date_col, INTERVAL 1 DAY) adds one day to a date in MySQL.
-- 3. IMPORTANT PITFALL: do NOT filter with WHERE when the denominator needs the
--    full/unfiltered row count. WHERE executes before aggregation, so filtering
--    rows down to only those matching the "next day login" condition would also
--    shrink COUNT(DISTINCT player_id) - corrupting the denominator (it would only
--    count players who already satisfied the condition, giving 1/1 instead of 1/3).
--    Fix: push the condition into SUM(CASE WHEN ...) instead of WHERE, so COUNT()
--    still sees every row/player while SUM only tallies the qualifying ones.
-- 4. "fraction" in the output means a plain ratio (e.g. 0.33), not a percentage -
--    don't multiply by 100 here (unlike 1193/1174 which ask for percentages).

-- Problem: 1978. Employees Whose Manager Left the Company
-- Difficulty: Easy
-- Topic: Joins (self LEFT JOIN to find "missing" references)
-- Link: https://leetcode.com/problems/employees-whose-manager-left-the-company/

-- Find employee_id of employees whose salary < 30000 AND whose manager has left
-- the company (manager_id points to an employee_id that no longer exists in the table).

SELECT e.employee_id
FROM Employees e
LEFT JOIN Employees m 
ON e.manager_id = m.employee_id
WHERE e.salary<30000
AND m.employee_id IS NULL
AND e.manager_id IS NOT NULL
ORDER BY e.employee_id;

-- Key takeaways:
-- 1. Self LEFT JOIN pattern for finding "dangling references": join the table to
--    itself (e = the row, m = the referenced row), and rows where the JOIN finds
--    no match show up as m.* = NULL. Classic way to detect "this foreign key points
--    to something that no longer exists."
-- 2. CRITICAL PITFALL: NULL = NULL evaluates to NULL (not TRUE) in SQL, so when
--    e.manager_id IS NULL, the ON condition e.manager_id = m.employee_id can never
--    match either - causing the LEFT JOIN to also fill m.* with NULL for employees
--    who simply have no manager. This produces the SAME NULL pattern as "manager left
--    the company", so the two cases get conflated unless explicitly separated.
--    Fix: add `AND e.manager_id IS NOT NULL` to exclude employees who never had
--    a manager in the first place, leaving only the true "manager left" case.
-- 3. Always qualify column names (e.column vs m.column) once you self-join a table -
--    unqualified names are ambiguous since both sides share identical column names.

-- Problem: 1341. Movie Rating
-- Difficulty: Medium
-- Topic: Joins + UNION ALL
-- Link: https://leetcode.com/problems/movie-rating/

(SELECT u.name AS results
FROM Users u
JOIN MovieRating r ON u.user_id = r.user_id
GROUP BY u.user_id
ORDER BY COUNT(r.movie_id) DESC, u.name ASC
LIMIT 1)

UNION ALL

(SELECT m.title AS results
FROM Movies m
JOIN MovieRating r ON m.movie_id = r.movie_id
WHERE DATE_FORMAT(r.created_at, '%Y-%m') = '2020-02'
GROUP BY m.movie_id
ORDER BY AVG(r.rating) DESC, m.title ASC
LIMIT 1);

-- Key takeaways:
-- 1. UNION ALL combines two independent queries into one result set. Use UNION ALL
--    (not UNION) when you don't need deduplication — it's also faster.
-- 2. Each subquery must be wrapped in parentheses when using ORDER BY + LIMIT
--    with UNION ALL. Without parentheses, MySQL interprets ORDER BY/LIMIT as
--    applying to the entire UNION result, causing a syntax error.
-- 3. Both SELECT lists must use the same alias (results) so the output column
--    has a consistent name.
-- 4. Tie-breaking: ORDER BY count/avg DESC, name/title ASC handles lexicographic
--    tiebreak cleanly with a secondary sort.
