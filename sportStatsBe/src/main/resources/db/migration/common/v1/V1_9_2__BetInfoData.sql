SELECT FN_SYS_ADDFOREIGNKEY	('bet_info', 'fk_bet_info_match'	, 'ref_match', 		'match'		, null)	FROM dual;
SELECT FN_SYS_ADDFOREIGNKEY	('bet_info', 'fk_bet_info_player'	, 'ref_player', 	'player'	, null)	FROM dual;
SELECT FN_SYS_ADDFOREIGNKEY	('bet_info', 'fk_bet_info_type_bet'	, 'ref_type_bet', 	'type_bet'	, null)	FROM dual;
SELECT FN_SYS_ADDFOREIGNKEY	('bet_info', 'fk_bet_info_to_bet'	, 'ref_bet', 		'bet'		, null)	FROM dual;
