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
