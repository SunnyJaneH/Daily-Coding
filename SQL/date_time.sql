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
