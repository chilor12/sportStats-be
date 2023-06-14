SELECT FN_SYS_ADDFOREIGNKEY	('bet_info', 'fk_bet_match'		, 'ref_match', 		'match'		, null)	FROM dual;
SELECT FN_SYS_ADDFOREIGNKEY	('bet_info', 'fk_bet_player'	, 'ref_player', 	'player'	, null)	FROM dual;
SELECT FN_SYS_ADDFOREIGNKEY	('bet_info', 'fk_bet_type_bet'	, 'ref_type_bet', 	'type_bet'	, null)	FROM dual;

