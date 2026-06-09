-- ============================================================
-- PATTERN MATCHING
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
