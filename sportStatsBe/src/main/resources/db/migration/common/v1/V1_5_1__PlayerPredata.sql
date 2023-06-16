-- ************************************************************************************************************************************************************************************
-- ************************************************************************************************************************************************************************************
--									( TABLE_NAME				, COLUMN_NAME			, COLUMN_TYPE	,  PREC, SCALE, 	ISNULLABLE	, 	DEFAULT_VALUE
-- ************************************************************************************************************************************************************************************
-- ************************************************************************************************************************************************************************************
SELECT FN_SYS_CREATETABLE			('player'					, 'id'																							)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('player'					, 'name'				, 'VARCHAR'		, '100',   '0'		,'NOT NULL'			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('player'					, 'surname'				, 'VARCHAR'		, '100',   '0'      , null				, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('player'					, 'nationality'			, 'VARCHAR'		, '100',   '0'		, null				, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('player'					, 'age'					, 'NUMBER'		,  '5',    '0'		, null				, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('player'					, 'ref_team'			, 'LONG'		,  '5',    '0'		, null				, null			)	FROM dual;
SELECT FN_SYS_ADD_SEQ_AUDIT_COLUMNS	('player'					, 'id'																							)	FROM dual;

