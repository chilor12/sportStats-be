SELECT FN_SYS_ADDFOREIGNKEY	('match_info_basket', 'fk_match_info_basket_to_match'	, 'ref_match', 		'match'		, null)	FROM dual;
SELECT FN_SYS_ADDFOREIGNKEY	('match_info_basket', 'fk_match_info_basket_player'		, 'ref_player', 	'player'	, null)	FROM dual;
SELECT FN_SYS_ADDFOREIGNKEY	('match_info_basket', 'fk_match_info_basket_team'		, 'ref_team', 		'team'		, null)	FROM dual;
