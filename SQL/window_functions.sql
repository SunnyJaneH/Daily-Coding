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
