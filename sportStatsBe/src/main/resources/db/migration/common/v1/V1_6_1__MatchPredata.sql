-- ************************************************************************************************************************************************************************************
-- ************************************************************************************************************************************************************************************
--									( TABLE_NAME				, COLUMN_NAME			, COLUMN_TYPE	,  PREC, SCALE,    ISNULLABLE	, 	DEFAULT_VALUE
-- ************************************************************************************************************************************************************************************
-- ************************************************************************************************************************************************************************************
SELECT FN_SYS_CREATETABLE			('match'					, 'id'																						)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match'					, 'sport'				, 'VARCHAR'		, '10',   '0'      , null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match'					, 'ref_home_team'		, 'LONG'		, '5',    '0'	   , null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match'					, 'ref_away_team'		, 'LONG'		, '5',    '0'      , null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match'					, 'day_match'			, 'DATE'		, null,   '0'      , null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match'					, 'championship'		, 'VARCHAR'		, '100',  '0'      , null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('match'					, 'result'				, 'VARCHAR'		, '10',   '0'      , null			, null			)	FROM dual;
SELECT FN_SYS_ADD_SEQ_AUDIT_COLUMNS	('match'					, 'id'																						)	FROM dual;


