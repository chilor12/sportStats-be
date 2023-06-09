-- ************************************************************************************************************************************************************************************
-- ************************************************************************************************************************************************************************************
--									( TABLE_NAME				, COLUMN_NAME				, COLUMN_TYPE	,  PREC, SCALE, ISNULLABLE	, DEFAULT_VALUE
-- ************************************************************************************************************************************************************************************
-- ************************************************************************************************************************************************************************************
SELECT FN_SYS_CREATETABLE			('utente'					, 'id'																								)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('utente'					, 'usr_name'				, 'VARCHAR'		, '120',  '0', 'NOT NULL', 		null					)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('utente'					, 'usr_mail'				, 'VARCHAR'		, '120',  '0',   null, 			null					)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('utente'					, 'usr_pwd'					, 'VARCHAR'		, '128',  '0',   null, 			null					)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('utente'					, 'nome'					, 'VARCHAR'		,  '60',  '0',   null, 			null					)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('utente'					, 'cognome'					, 'VARCHAR'		,  '60',  '0',   null, 			null					)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('utente'					, 'data_scadenza_password'	, 'DATE'		,  null, null,   null, 			null					)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('utente'					, 'login'					, 'BOOLEAN'		,  null, null, 'NOT NULL', 		'0'						)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('utente'					, 'ref_profilo'				, 'LONG'		,  '10',  '0', 'NOT NULL', 		null					)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('utente'					, 'flag_conferma'			, 'VARCHAR'		,   '1',  '0',   null, 			null					)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('utente'					, 'usr_phone'				, 'LONG'		,  '15',  '0',   null, 			null					)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('utente'					, 'ref_unita_locale'		, 'LONG'		,  '10',  '0',   null, 			null					)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('utente'					, 'ref_cliente'				, 'LONG'		,  '10',  '0',   null, 			null					)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('utente'					, 'ref_fornitore'			, 'LONG'		,  '10',  '0',   null, 			null					)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('utente'					, 'primo_login		'		, 'VARCHAR'		,  '1',   '0',   null, 			null					)	FROM dual;
SELECT FN_SYS_ADD_SEQ_AUDIT_COLUMNS	('utente'					, 'id'																								)	FROM dual;



