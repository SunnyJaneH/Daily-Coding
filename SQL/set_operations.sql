-- ============================================================
-- SET OPERATIONS
-- ============================================================

-- [10025] Find All Varieties (Wine Magazine) - Medium
-- Key: UNION automatically deduplicates; UNION ALL keeps duplicates
-- Key: ORDER BY goes at the end, applies to the combined result
SELECT variety
FROM winemag_p1
UNION
SELECT variety
FROM winemag_p2
ORDER BY variety ASC;
