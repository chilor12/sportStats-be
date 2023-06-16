SELECT FN_SYS_ADDFOREIGNKEY	('match_info_football', 'fk_match_info_football_to_match'	, 'ref_match', 		'match'		, null)	FROM dual;
SELECT FN_SYS_ADDFOREIGNKEY	('match_info_football', 'fk_match_info_football_player'		, 'ref_player', 	'player'	, null)	FROM dual;
SELECT FN_SYS_ADDFOREIGNKEY	('match_info_football', 'fk_match_info_football_team'		, 'ref_team', 		'team'		, null)	FROM dual;
