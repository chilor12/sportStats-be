-- ************************************************************************************************************************************************************************************
-- ************************************************************************************************************************************************************************************
--									( TABLE_NAME					, COLUMN_NAME			, COLUMN_TYPE	,  PREC,  SCALE, 	ISNULLABLE	, 	DEFAULT_VALUE
-- ************************************************************************************************************************************************************************************
-- ************************************************************************************************************************************************************************************
SELECT FN_SYS_CREATETABLE			('match_info_basket'			, 'id'																					)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match_info_basket'			, 'ref_match'			, 'LONG'		, ' 5',    '0'		, null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match_info_basket'			, 'ref_player'			, 'LONG'		,  '5',    '0'      , null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match_info_basket'			, 'ref_team'			, 'LONG'		,  '5',    '0'      , null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match_info_basket'			, 'points'				, 'NUMBER'		,  '3',    '0'		, null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match_info_basket'			, 'assists'				, 'NUMBER'		,  '3',    '0'		, null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match_info_basket'			, 'rebound'				, 'NUMBER'		,  '3',    '0'      , null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match_info_basket'			, 'steal'				, 'NUMBER'		,  '3',    '0'		, null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match_info_basket'			, 'block'				, 'NUMBER'		,  '3',    '0'		, null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match_info_basket'			, 'three_point_made'	, 'NUMBER'		,  '3',    '0'		, null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match_info_basket'			, 'minutes'				, 'NUMBER'		,  '3',    '0'		, null			, null			)	FROM dual;
SELECT FN_SYS_ADD_SEQ_AUDIT_COLUMNS	('match_info_basket'			, 'id'																					)	FROM dual;

