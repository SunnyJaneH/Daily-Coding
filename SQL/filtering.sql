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
