-- ============================================================
-- FILTERING
-- ============================================================

-- [10024] Wine varieties tasted by 'Roger Voss' (Wine Magazine)
SELECT DISTINCT variety 
FROM winemag_p2
WHERE taster_name = 'Roger Voss'
AND region_1 IS NOT NULL;

-- [10004] Find all Lyft rides which happened on rainy days before noon (Lyft)
SELECT * 
FROM lyft_rides
WHERE weather = 'rainy'
AND hour < 12;

-- [10003] Lyft Driver Wages (Lyft)
SELECT * 
FROM lyft_drivers
WHERE yearly_salary <= 30000 OR yearly_salary >= 70000;

-- [9937] Find all athletes older than 40 who won Bronze or Silver (ESPN)
SELECT name 
FROM olympics_athletes_events
WHERE age > 40
AND medal IN ('Bronze', 'Silver');

-- [9689] Inspection For Glassell Coffee Shop (LA Health)
SELECT *
FROM los_angeles_restaurant_health_inspections
WHERE owner_name = 'GLASSELL COFFEE SHOP LLC';

-- [9688] Churro Activity Date (LA Health)
SELECT activity_date, pe_description
FROM los_angeles_restaurant_health_inspections
WHERE facility_name = 'STREET CHURROS'
AND score < 95;

-- [2168] Users Missing Phone Numbers (Fintech)
-- Key: IS NULL to find missing values
SELECT user_id, user_name
FROM fintech_app_users
WHERE phone_number IS NULL;

-- [2167] High Earners in Support Departments (TechCorp)
-- Key: IN for multiple values is cleaner than OR
SELECT first_name, last_name, department, salary
FROM techcorp_workforce
WHERE department IN ('HR', 'Admin')
AND salary > 80000;
