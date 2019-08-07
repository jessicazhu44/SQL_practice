/*
Create a function that will return distance between 2 coordinates 
in meters. Each coordinate is defined by latitude and longitude.
*/

DROP FUNCTION IF EXISTS `FC_CALC_DISTANCE` --in case one exists and returns error

DELIMITER //

CREATE FUNCTION `FC_CALC_DISTANCE` (
	lat_1 FLOAT,
	long_1 FLOAT,
	lat_2 FLOAT,
	long_2 FLOAT,
) RETURNS FLOAT(2)
BEGIN
	ROUND( 6371 * 1000 * ACOS(
		COS(RADIANS(lat_1))* COS( RADIANS(lat_2) )* COS( RADIANS(long_1 ) - RADIANS(long_2))
		+SIN(RADIANS(lat_1))*SIN(RADIANS(lat_2))
	)
);
END;
//
DELIMITER; 

SELECT 
	FC_CALC_DISTANCE(14.756331, 99.501765, 13.7562, 100.505) 
	AS distance_in_meters
;

