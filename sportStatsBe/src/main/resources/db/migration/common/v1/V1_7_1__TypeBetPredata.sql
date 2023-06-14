-- ************************************************************************************************************************************************************************************
-- ************************************************************************************************************************************************************************************
--									( TABLE_NAME		, COLUMN_NAME		, COLUMN_TYPE	,  PREC, SCALE, 	ISNULLABLE	, 	DEFAULT_VALUE
-- ************************************************************************************************************************************************************************************
-- ************************************************************************************************************************************************************************************
SELECT FN_SYS_CREATETABLE			('type_bet'			, 'id'																								)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('type_bet'			, 'sport'			, 'VARCHAR'		, '20',   '0'		,'NOT NULL'			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('type_bet'			, 'type_of_bet'		, 'VARCHAR'		, '200',   '0'      , null				, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('type_bet'			, 'OverUnder'		, 'VARCHAR'		, '10',   '0'		, null				, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('type_bet'			, 'value'			, 'VARCHAR'		, '50',   '0'		, null				, null			)	FROM dual;
SELECT FN_SYS_ADD_SEQ_AUDIT_COLUMNS	('users'			, 'id'																								)	FROM dual;


