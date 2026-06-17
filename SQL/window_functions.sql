-- ============================================================
-- WINDOW FUNCTIONS
-- ============================================================

-- [10299] Finding Updated Records (Microsoft)
SELECT * FROM (
    SELECT DISTINCT ON (id) id, first_name, last_name, department_id, salary AS current_salary
    FROM ms_employee_salary
    ORDER BY id, salary DESC
) subquery
ORDER BY id ASC;

-- [9917] Average Salaries (Glassdoor)
SELECT e.department,
       e.first_name,
       e.salary,
       AVG(e.salary) OVER (PARTITION BY e.department) AS average_salary
FROM employee e;

-- [10322] Finding User Purchases (Amazon) - Medium
-- Approach 1: Self JOIN with subquery to restrict to first purchase
-- Key: WHERE a.created_at = MIN ensures only first purchase is anchor
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

-- [10322] Finding User Purchases (Amazon) - Medium
-- Approach 2: Window Function using LAG + ROW_NUMBER
-- Key: ROW_NUMBER = 2 isolates the second purchase row
-- Key: LAG retrieves the first purchase date on that same row
-- Key: Subquery needed because window functions can't be used directly in WHERE
SELECT DISTINCT user_id
FROM (
    SELECT user_id,
           created_at,
           LAG(created_at) OVER (PARTITION BY user_id ORDER BY created_at) AS prev_date,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_at) AS rn
    FROM amazon_transactions
) t
WHERE rn = 2
AND created_at - prev_date >= 1
AND created_at - prev_date <= 7;

-- [10553] Finding Purchases (Amazon) - Medium
-- Key: LAG to get previous purchase date per user
-- Key: No ROW_NUMBER needed — any adjacent pair within 1-7 days qualifies
-- Key: DISTINCT user_id, created_at in subquery to handle same-day duplicates
SELECT DISTINCT user_id
FROM (
    SELECT user_id,
           created_at,
           LAG(created_at) OVER (PARTITION BY user_id ORDER BY created_at) AS prev_date
    FROM (
        SELECT DISTINCT user_id, created_at
        FROM amazon_transactions
    ) deduped
) t
WHERE created_at - prev_date >= 1
AND created_at - prev_date <= 7;

-- [10159] Ranking Most Active Guests (Airbnb) - Medium
-- Key: DENSE_RANK() for ranking without gaps (1,1,2 not 1,1,3)
-- Key: GROUP BY first to get SUM, then apply window function on top
-- Key: RANK() skips numbers, DENSE_RANK() does not, ROW_NUMBER() never ties
SELECT DENSE_RANK() OVER (ORDER BY SUM(n_messages) DESC) AS ranking,
       id_guest,
       SUM(n_messages) AS sum_n_messages
FROM airbnb_contacts
GROUP BY id_guest
ORDER BY ranking;

-- [10048] Top Businesses With Most Reviews (Yelp) - Medium
-- Key: RANK() for ranking with gaps (ties get same rank, next rank is skipped)
-- Key: Subquery required since window functions cannot be used in WHERE
SELECT business_name, review_count
FROM (
    SELECT name AS business_name,
           review_count,
           RANK() OVER (ORDER BY review_count DESC) AS rnk
    FROM yelp_business
) t
WHERE rnk <= 5;

-- Highest Salary In Department (StrataScratch #9897)
-- Find the employee with the highest salary per department.
-- RANK() (not ROW_NUMBER) so ties are all included.
SELECT department, first_name, salary
FROM (
    SELECT department, first_name, salary,
           RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM employee
) t
WHERE rnk = 1;

-- Second Highest Salary (StrataScratch #9892)
-- Find the second highest distinct salary value.
-- DENSE_RANK() avoids skipped ranks when there are ties at the top.
SELECT salary
FROM (
    SELECT salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS rnk
    FROM employee
) t
WHERE rnk = 2;
