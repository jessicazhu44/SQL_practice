/*
Create a query using row number to identify top 3 
user that login most per day per hour. 
*/
SELECT 
	`date`,
	`hour`,
	`login_count`
FROM
（SELECT 
	`date`,
	`hour`,
	`login_count`,
	ROW_NUMBER() OVER( ORDER BY `date` ASC, `hour` ASC,
		`login_count` DESC) row_num
FROM `user_login`
）table_1
WHERE 
	row_num <=3
ORDER BY 
	`date`,
	`hour`,
	`login_count`