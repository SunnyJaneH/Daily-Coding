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
