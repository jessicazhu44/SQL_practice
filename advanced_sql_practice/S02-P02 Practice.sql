/* 
Create a new view v_user_login that list  log_in activity 
in a descending order
*/


CREATE OR REPLACE VIEW `sample_staff`.`v_user_login` AS 
	SELECT 
		`user_login`.`id` AS `user_login_id`,
		`user_login`.`user_id`,
		`user`.`name` AS `user_name`,
		`user_login`.`ip_address` AS `ip_address_integer`,
		INET_ATON(`user_login`.`ip_address`) AS `ip_address`,
		`user_login`.`user_login_dt` AS `user_login_dt`
	FROM `sample_staff`.`user`
	INNER JOIN `sample_staff`.`user_login` ON 1=1
		AND `user_login`.`user_id` = `user`.`id`
	WHERE 1=1
		AND `user_login`.`deleted_flag` = 0
	ORDER BY 
		`user_login`.`id` DESC
;

--Query by 
SELECT * 
FROM `sample_staff`.`v_user_login`
WHERE `v_user_login`.`user_id` = 1
LIMIT 1
;