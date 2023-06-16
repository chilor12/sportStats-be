-- ************************************************************************************************************************************************************************************
-- ************************************************************************************************************************************************************************************
--									( TABLE_NAME			, COLUMN_NAME			, COLUMN_TYPE	,  PREC, SCALE, 	ISNULLABLE	, 	DEFAULT_VALUE
-- ************************************************************************************************************************************************************************************
-- ************************************************************************************************************************************************************************************
SELECT FN_SYS_CREATETABLE			('bet'					, 'id'																						)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('bet'					, 'code'				, 'VARCHAR'		, '100',   '0'		, null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('bet'					, 'state'				, 'VARCHAR'		,  '50',   '0'      , null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('bet'					, 'quote'				, 'NUMBER'		,  '15',   '2'		, null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('bet'					, 'money_bet'			, 'NUMBER'		,  '15',   '2'		, null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('bet'					, 'potential_win'		, 'NUMBER'		,  '15',   '2'		, null			, null			)	FROM dual;
SELECT FN_SYS_ADD_SEQ_AUDIT_COLUMNS	('bet'					, 'id'																						)	FROM dual;

