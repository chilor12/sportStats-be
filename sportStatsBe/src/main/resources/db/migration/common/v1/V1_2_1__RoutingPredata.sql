-- ************************************************************************************************************************************************************************************
-- ************************************************************************************************************************************************************************************
--									( TABLE_NAME			, COLUMN_NAME				, COLUMN_TYPE	,  PREC, SCALE, 	ISNULLABLE	, 	DEFAULT_VALUE
-- ************************************************************************************************************************************************************************************
-- ************************************************************************************************************************************************************************************
SELECT FN_SYS_CREATETABLE			('routing' 			    , 'id'																							)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('routing' 				, 'path_funzione'			, 'VARCHAR'		,   '200', '0'		, 'NULL'		, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('routing' 				, 'label_funzione'			, 'VARCHAR'		,   '50', '0'		, 'NOT NULL'	, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('routing' 				, 'icona'					, 'VARCHAR'		,   '50', '0'		,  null			, null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('routing' 				, 'id_parent'				, 'LONG'		,   '30', '0'		, 'NULL'	    , null			)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('routing' 				, 'ordinamento'				, 'LONG'		,   '30', '0'		, 'NOT NULL'	, null			)	FROM dual;
SELECT FN_SYS_ADD_SEQ_AUDIT_COLUMNS	('routing' 				, 'id'																							)	FROM dual;


