-- Problem: 626. Exchange Seats
-- Difficulty: Medium
-- Topic: Joins (CASE WHEN + odd/even logic)
-- Link: https://leetcode.com/problems/exchange-seats/

SELECT 
    CASE WHEN id % 2 = 0 THEN id-1
         WHEN id % 2 = 1 AND id = (SELECT COUNT(*) FROM Seat) THEN id
         ELSE id + 1
    END AS id,
    student
FROM Seat
ORDER BY id;

-- Key takeaways:
-- 1. CASE WHEN + modulo (id % 2) is the standard pattern for odd/even branching.
--    Three branches: even → id-1, odd & last row → id unchanged, odd & not last → id+1.
-- 2. Use (SELECT COUNT(*) FROM Seat) subquery to detect the last row (only matters
--    when total count is odd — if even, every row has a pair and no special case needed).
-- 3. THEN expects a return VALUE, not an assignment expression.
--    THEN id-1 is correct; THEN id = id-1 is wrong (that's a comparison, returns 0/1).
