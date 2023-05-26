SELECT FN_SYS_ADDFOREIGNKEY	('dettaglio_articolo'	, 'fk_dettaglio_articolo_master_utente_ins'				, 'ref_utente_ins'					, 'utente'						, null	)	FROM dual;
SELECT FN_SYS_ADDFOREIGNKEY	    ('indirizzo'			, 'fk_indirizzo_nazione'			, 'ref_nazione'	, 'nazione'				, null	)	FROM dual;

SELECT FN_SYS_ADDFOREIGNKEY	('calendario_committenza'		, 'fk_cc_unita_locale'	, 'ref_unita_locale'    , 'unita_locale', null	)	FROM dual;


SELECT FN_SYS_ADDFOREIGNKEY	    ('spesa'			, 'fk_spesa_foto_cons'			, 'ref_foto_cons_rit_furgone'	, 'foto_cons_rit_furgone'				, null	)	FROM dual;

SELECT FN_SYS_ADDFOREIGNKEY	('tariffario_telegestione_slave'		, 'fk_tariffario_master_tariffario_slave'	, 'ref_tariffario_master'    		, 'tariffario_telegestione_master',	 null	)	FROM dual;
SELECT FN_SYS_ADDFOREIGNKEY	('tariffario_telegestione_slave'		, 'fk_catalogo_tariffario_slave'			, 'ref_catalogo'    				, 'catalogo'					  ,  null	)	FROM dual;

SELECT FN_SYS_ADDFOREIGNKEY	('info_ticket_telegestione'		, 'fk_bolla_intervento'          			, 'ref_bolla'      	    		, 'bolla_intervento',				 null	)	FROM dual;
SELECT FN_SYS_ADDFOREIGNKEY	('info_ticket_telegestione'		, 'fk_scheda_tecnica'			            , 'ref_scheda_tecnica'    			, 'scheda_tecnica'				  ,  null	)	FROM dual;
SELECT FN_SYS_ADDFOREIGNKEY	('info_ticket_telegestione'		, 'fk_catalogo'								, 'ref_catalogo'    				, 'catalogo'					  ,  null	)	FROM dual;

SELECT FN_SYS_ADDFOREIGNKEY	('scheda_tecnica'		        , 'fk_catalogo'          			    , 'ref_catalogo'      	    		, 'catalogo', 				 null	)	FROM dual;
SELECT FN_SYS_ADDFOREIGNKEY	('scheda_tecnica'		        , 'fk_fornitore'			            , 'ref_fornitore'    				, 'fornitore'				  ,  null	)	FROM dual;