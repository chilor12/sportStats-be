-- ************************************************************************************************************************************************************************************
-- ************************************************************************************************************************************************************************************
--									( TABLE_NAME				, COLUMN_NAME				, COLUMN_TYPE	,  PREC, SCALE, 	ISNULLABLE	, 	DEFAULT_VALUE
-- ************************************************************************************************************************************************************************************
-- ************************************************************************************************************************************************************************************
SELECT FN_SYS_CREATETABLE			('users'					, 'id'																								)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('users'					, 'usr_name'				, 'VARCHAR'		, '120',   '0'		,'NOT NULL'			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('users'					, 'usr_mail'				, 'VARCHAR'		, '120',   '0'      , null				, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('users'					, 'usr_pwd'					, 'VARCHAR'		, '128',   '0'		, null				, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('users'					, 'name'					, 'VARCHAR'		,  '60',   '0'		, null				, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('users'					, 'surname'					, 'VARCHAR'		,  '60',   '0'		, null				, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('users'					, 'sign_up_date'			, 'DATE'		,  null,   null		, null				, null			)	FROM dual;
SELECT FN_SYS_ADD_SEQ_AUDIT_COLUMNS	('users'					, 'id'																								)	FROM dual;


