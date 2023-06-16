-- ************************************************************************************************************************************************************************************
-- ************************************************************************************************************************************************************************************
--									( TABLE_NAME					, COLUMN_NAME			, COLUMN_TYPE	,  PREC,  SCALE, 	ISNULLABLE	, 	DEFAULT_VALUE
-- ************************************************************************************************************************************************************************************
-- ************************************************************************************************************************************************************************************
SELECT FN_SYS_CREATETABLE			('match_info_football'			, 'id'																					)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match_info_football'			, 'ref_match'			, 'LONG'		, ' 5',    '0'		, null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match_info_football'			, 'ref_player'			, 'LONG'		,  '5',    '0'      , null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match_info_football'			, 'ref_team'			, 'LONG'		,  '5',    '0'      , null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match_info_football'			, 'goals'				, 'NUMBER'		,  '3',    '0'		, null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match_info_football'			, 'assists'				, 'NUMBER'		,  '3',    '0'		, null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match_info_football'			, 'yellow_card'			, 'BOOLEAN'		,  '3',    '0'      , null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match_info_football'			, 'red_card'			, 'BOOLEAN'		,  '3',    '0'      , null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match_info_football'			, 'shots'				, 'NUMBER'		,  '3',    '0'		, null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match_info_football'			, 'fouls'				, 'NUMBER'		,  '3',    '0'		, null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match_info_football'			, 'completed_passes'	, 'NUMBER'		,  '3',    '0'		, null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match_info_football'			, 'saves'				, 'NUMBER'		,  '3',    '0'		, null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match_info_football'			, 'minutes'				, 'NUMBER'		,  '3',    '0'		, null			, null			)	FROM dual;
SELECT FN_SYS_ADD_SEQ_AUDIT_COLUMNS	('match_info_football'			, 'id'																					)	FROM dual;

