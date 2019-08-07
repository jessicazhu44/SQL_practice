/*
There is a stored function INS_USER_LOGIN_DATA_GENERATOR which 
simulates users logging to your website or mobile app and writing 
data to sample_staff.user_login. Your assignment will be to:

1. Create a new procedure which will delete from sample_staff.user_login 
data older than 10 minutes, but will keep the new data (newer than 10 minutes).
2. Create a new event in MySQL Event Scheduler which will run the 
procedure INS_USER_LOGIN_DATA_GENERATOR every 30 seconds.
*/

DROP PROCEDURE IF EXISTS `DELETE_TEN_MINS`;

DELIMITER //
CREATE PROCEDURE `DELETE_TEN_MINS` (
)
BEGIN 
	DELETE FROM `sample_staff`.`user_login`
	WHERE DATEDIFF(MINUTE, NOW() , `user_login`.`login_dt`) > 10
END;
//

DELIMITER;