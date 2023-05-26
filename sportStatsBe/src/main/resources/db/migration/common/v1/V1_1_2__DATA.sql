INSERT INTO catalogo(id, codice, descrizione, tipo, flag_non_modificabile, flag_in_listino, percentuale,flag_intera_giornata, usr_ins, usr_upd, dta_ins, dta_upd, rec_ver ) VALUES
 (( SELECT FN_SYS_SEQNEXTVAL('seq_catalogo')), '013','Cantiere'							, 'TUL', 'S', null, null, null,'SYSTEM', 'SYSTEM', FN_SYS_CURDATE(), FN_SYS_CURDATE(),0
);

INSERT INTO ruolo(id, cod_ruolo, ruolo, ref_profilo, flag_non_modificabile, usr_ins, usr_upd, dta_ins, dta_upd, rec_ver ) VALUES
	(( SELECT FN_SYS_SEQNEXTVAL('seq_ruolo')), 'PP','Progetti'			 , 3,'N','SYSTEM', 'SYSTEM', FN_SYS_CURDATE(), FN_SYS_CURDATE(),0
);

update spesa set spesa_aziendale = 'S' where ref_fornitore is not null and "valid" is true;


INSERT INTO funzione(id, path_funzione, label_funzione, id_parent, ordinamento, icona, usr_ins, usr_upd, dta_ins, dta_upd, rec_ver ) VALUES
(( SELECT FN_SYS_SEQNEXTVAL('seq_funzione')),'/pages/gestione-rientro-articolo'	,'Rientri Articoli'  , (select id from funzione f where f.label_funzione = 'Gestione Magazzino')		    ,	 43,''	, 'SYSTEM', 'SYSTEM', FN_SYS_CURDATE(), FN_SYS_CURDATE(),0
);

INSERT INTO ruolo_funzione(id, ref_ruolo, ref_funzione, tipo_permessi, usr_ins, usr_upd, dta_ins, dta_upd, rec_ver ) VALUES
(( SELECT FN_SYS_SEQNEXTVAL('seq_ruolo_funzione')), 5,(select id from funzione where label_funzione ='Rientri Articoli' order by id desc limit 1 ) ,'W'    , 'SYSTEM', 'SYSTEM', FN_SYS_CURDATE(), FN_SYS_CURDATE(),0
);

INSERT INTO catalogo(id, codice, descrizione, tipo, flag_non_modificabile, flag_in_listino, percentuale, numerico, flag_intera_giornata, usr_ins, usr_upd, dta_ins, dta_upd, rec_ver, valid ) VALUES
(( SELECT FN_SYS_SEQNEXTVAL('seq_catalogo')), '999','GESTIONE PRESIDIO'							, 'TIPI_IM', 'S', null,  null,null,null, 'SYSTEM', 'SYSTEM', FN_SYS_CURDATE(), FN_SYS_CURDATE(),0, true
);

INSERT INTO catalogo(id, codice, descrizione, tipo, flag_non_modificabile, flag_in_listino, percentuale,flag_intera_giornata, usr_ins, usr_upd, dta_ins, dta_upd, rec_ver ) VALUES
 (( SELECT FN_SYS_SEQNEXTVAL('seq_catalogo')), '0001','2 ORE'			, 'TAR_TEL', 'S', null, 2, null,'SYSTEM', 'SYSTEM', FN_SYS_CURDATE(), FN_SYS_CURDATE(),0
);

INSERT INTO catalogo(id, codice, descrizione, tipo, flag_non_modificabile, flag_in_listino, percentuale,flag_intera_giornata, usr_ins, usr_upd, dta_ins, dta_upd, rec_ver ) VALUES
 (( SELECT FN_SYS_SEQNEXTVAL('seq_catalogo')), '0002','1 GIORNO'		, 'TAR_TEL', 'S', null, 1, null,'SYSTEM', 'SYSTEM', FN_SYS_CURDATE(), FN_SYS_CURDATE(),0
);

INSERT INTO catalogo(id, codice, descrizione, tipo, flag_non_modificabile, flag_in_listino, percentuale,flag_intera_giornata, usr_ins, usr_upd, dta_ins, dta_upd, rec_ver ) VALUES
 (( SELECT FN_SYS_SEQNEXTVAL('seq_catalogo')), '0003','1 SETTIMANA'		, 'TAR_TEL', 'S', null, 7, null,'SYSTEM', 'SYSTEM', FN_SYS_CURDATE(), FN_SYS_CURDATE(),0
);

INSERT INTO catalogo(id, codice, descrizione, tipo, flag_non_modificabile, flag_in_listino, percentuale,flag_intera_giornata, usr_ins, usr_upd, dta_ins, dta_upd, rec_ver ) VALUES
 (( SELECT FN_SYS_SEQNEXTVAL('seq_catalogo')), '0004','6 MESI'			, 'TAR_TEL', 'S', null, 180, null,'SYSTEM', 'SYSTEM', FN_SYS_CURDATE(), FN_SYS_CURDATE(),0
);

INSERT INTO catalogo(id, codice, descrizione, tipo, flag_non_modificabile, flag_in_listino, percentuale,flag_intera_giornata, usr_ins, usr_upd, dta_ins, dta_upd, rec_ver ) VALUES
 (( SELECT FN_SYS_SEQNEXTVAL('seq_catalogo')), '0005','1 ANNO'			, 'TAR_TEL', 'S', null, 365, null,'SYSTEM', 'SYSTEM', FN_SYS_CURDATE(), FN_SYS_CURDATE(),0
);
