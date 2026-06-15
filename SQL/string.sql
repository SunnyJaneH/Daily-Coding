-- ============================================================
-- STRING & PATTERN MATCHING
-- ============================================================

-- [9842] First Names With Six Letters Ending in 'h' (Amazon)
SELECT * 
FROM worker
WHERE first_name LIKE '_____h';

-- [9805] Find drafts containing the word 'optimism' (Google)
SELECT * 
FROM google_file_store
WHERE filename LIKE '%draft%'
AND contents LIKE '%optimism%';

-- [10049] Reviews of Categories (Yelp) - Medium
-- Key: STRING_TO_ARRAY splits delimited string into array
-- Key: UNNEST expands array into rows for GROUP BY
SELECT UNNEST(STRING_TO_ARRAY(categories, ';')) AS category,
       SUM(review_count) AS total_reviews
FROM yelp_business
GROUP BY category
ORDER BY total_reviews DESC;
