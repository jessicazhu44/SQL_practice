/*
Beautify the query below: 
(rewrite it to look beautiful and follow best-practices and style guidelines)
*/

INSERT INTO `bi_data`.`valid_offers`
	VALUES(
		offer_id, 
		hotel_id, 
		price_usd, 
		original_price, 
		original_currency_code,
    	checkin_date, 
    	checkout_date, 
    	breakfast_included_flag, 
    	valid_from_date, 
    	valid_to_date
	)
;

SELECT 
	`offer_cleanse_date_fix`.`id`, 
	`offer_cleanse_date_fix`.`hotel_id`, 
	`offer_cleanse_date_fix`.`sellings_price` AS `offer_selling_price_usd`, 
    `lst_currency`.`code` AS `lst_currency_code`, 
    `offer_cleanse_date_fix`.`checkin_date`, 
    `offer_cleanse_date_fix`.`checkout_date`, 
    `offer_cleanse_date_fix`.`breakfast_included_flag`,
    `offer_cleanse_date_fix`.`offer_valid_from`, 
    `offer_cleanse_date_fix`.`offer_valid_to`
FROM 1=1,
	 `enterprise_data`.`offer_cleanse_date_fix`, 
	 `primary_data`.`lst_currency`
WHERE 1=1
	AND `offer_cleanse_date_fix`.`currency_id` = 1 
	AND `lst_currency`.`id` = 1
;


/* Original:
insert into bi_data.valid_offers (offer_id, hotel_id, price_usd, original_price, original_currency_code,
      checkin_date, checkout_date, breakfast_included_flag, valid_from_date, valid_to_date)
select of.id, of.hotel_id, of.sellings_price as price_usd, of.sellings_price as original_price,
    lc.code AS original_currency_code, of.checkin_date, of.checkout_date, of.breakfast_included_flag,
    of.offer_valid_from, of.offer_valid_to
from  enterprise_data.offer_cleanse_date_fix of, primary_data.lst_currency lc
where of.currency_id=1 and lc.id=1;
*/