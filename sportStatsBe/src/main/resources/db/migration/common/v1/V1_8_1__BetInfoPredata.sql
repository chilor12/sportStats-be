-- ************************************************************************************************************************************************************************************
-- ************************************************************************************************************************************************************************************
--									( TABLE_NAME			, COLUMN_NAME			, COLUMN_TYPE	,  PREC,  SCALE, 	ISNULLABLE	, 	DEFAULT_VALUE
-- ************************************************************************************************************************************************************************************
-- ************************************************************************************************************************************************************************************
SELECT FN_SYS_CREATETABLE			('bet_info'					, 'id'																					)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('bet_info'					, 'ref_match'		, 'LONG'		, ' 5',    '0'		, null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('bet_info'					, 'ref_player'		, 'LONG'		,  '5',    '0'      , null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('bet_info'					, 'ref_type_bet'	, 'LONG'		,  '5',    '0'		, null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('bet_info'					, 'quote'			, 'NUMBER'		,  '7',    '2'		, null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('bet_info'					, 'state'			, 'VARCHAR'		,  '50',   '0'      , null			, null			)	FROM dual;
SELECT FN_SYS_ADD_SEQ_AUDIT_COLUMNS	('bet_info'					, 'id'																					)	FROM dual;

