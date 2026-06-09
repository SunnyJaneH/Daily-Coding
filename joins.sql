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
