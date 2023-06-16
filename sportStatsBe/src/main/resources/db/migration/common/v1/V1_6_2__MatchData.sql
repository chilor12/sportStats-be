SELECT FN_SYS_ADDFOREIGNKEY	('match', 'fk_match_home_team'		, 'ref_home_team', 		'team'		, null)	FROM dual;
SELECT FN_SYS_ADDFOREIGNKEY	('match', 'fk_match_away_team'		, 'ref_away_team', 		'team'		, null)	FROM dual;
