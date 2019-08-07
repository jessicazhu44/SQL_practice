/*
These queries run longer than 100ms.

How would you make them run in less than 10ms?
*/

CREATE INDEX index_archive_code_flag_sign_date 
ON contract(`archive_code`,`deleted_flag`,`sign_date`);

-- Alternative
ALTER TABLE contract 
ADD INDEX index_archive_code_flag_sign_date
(`archive_code`, `deleted_flag`,`sign_date`)


SELECT `contract`.`archive_code`
FROM `contract`
WHERE 1=1
 AND `contract`.`archive_code` = 'DA970'
 AND `contract`.`deleted_flag` = 0
 AND `contract`.`sign_date` >= '1990-01-01'
;
-- Without composite key, takes 205 ms;
-- With composite key, takes 0.5 ms


SELECT `contract`.`archive_code`
FROM `contract`
WHERE 1=1
 AND `contract`.`archive_code` = 'DA970'
 AND `contract`.`deleted_flag` = 0
;
-- Takes 114 ms
-- With composite key, takes 0.5 ms

/* 
When using composite key, the order of query doesn't matter.
We can query (col1), (col1, col2), (col1, col2, col3),
but we cant query starting in the middle, like (col2, col3)
*/