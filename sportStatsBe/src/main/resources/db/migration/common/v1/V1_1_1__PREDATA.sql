SELECT FN_SYS_ADDCOLUMN			('dettaglio_articolo'			,'ref_utente_ins'				, 'LONG'		, '5',   '0',	null		,null				)	FROM dual;
SELECT FN_SYS_ADDCOLUMN			('dettaglio_articolo'			,'data_creazione'				, 'DATE'		, null,	   null, null		,null				)	FROM dual;
SELECT FN_SYS_ADDCOLUMN			('bolla_intervento'			,'flag_materiali_extra'				, 'VARCHAR'		, '1',   '0',	null		,null				)	FROM dual;

SELECT FN_SYS_ADDCOLUMN			('bolla_intervento'			,'identificativo_padre'				, 'VARCHAR'		, '255',   '0',	null		,null				)	FROM dual;
SELECT FN_SYS_ADDCOLUMN			('indirizzo'			,'comune_desc'				, 'VARCHAR'		, '255',   '0',	null		,null				)	FROM dual;
SELECT FN_SYS_ADDCOLUMN			('indirizzo'			,'provincia_desc'			, 'VARCHAR'		, '255',   '0',	null		,null				)	FROM dual;
SELECT FN_SYS_ADDCOLUMN			('indirizzo'			,'regione_desc'			    , 'VARCHAR'		, '255',   '0',	null		,null				)	FROM dual;
SELECT FN_SYS_ADDCOLUMN			('indirizzo'			,'esterno'			        , 'VARCHAR'		, '255',   '0',	null		,'N'				)	FROM dual;
SELECT FN_SYS_ADDCOLUMN			('indirizzo'			, 'ref_nazione'	            , 'LONG'		, '5', 		'0', 	null	, null				)	FROM dual;
ALTER TABLE tecnoclimaschema.indirizzo ALTER COLUMN ref_comune DROP NOT NULL;


SELECT FN_SYS_CREATETABLE			('tariffario_telegestione_master'		, 'id'																						)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('tariffario_telegestione_master' 		, 'data_validita'			    , 'DATE'		,   null	, null		, null	, null		)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('tariffario_telegestione_master' 		, 'descrizione'					, 'VARCHAR'		,   '255'	, '0'		, null	, null		)	FROM dual;
SELECT FN_SYS_ADD_SEQ_AUDIT_COLUMNS	('tariffario_telegestione_master'		, 'id'																						)	FROM dual;

SELECT FN_SYS_CREATETABLE			('tariffario_telegestione_slave'		, 'id'																						)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('tariffario_telegestione_slave' 		, 'ref_tariffario_master'		, 'LONG'		,   '5'		, '0'		, null	, null		)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('tariffario_telegestione_slave' 		, 'ref_catalogo'				, 'LONG'		,   '5'		, '0'		, null	, null		)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('tariffario_telegestione_slave' 		, 'importo'						 'NUMBER'		,   '10'	, '2'		, null	, null		)	FROM dual;
SELECT FN_SYS_ADD_SEQ_AUDIT_COLUMNS	('tariffario_telegestione_slave'		, 'id'																						)	FROM dual;

SELECT FN_SYS_ADDCOLUMN			('dipendente'			,'flag_rimborso_trasferta'				, 'VARCHAR'		, '1',   '0',	null		,null				)	FROM dual;

ALTER TABLE tecnoclimaschema.contratto_cliente ALTER COLUMN nome_file DROP NOT NULL;

ALTER TABLE tecnoclimaschema.contratto_fornitore ALTER COLUMN nome_file DROP NOT NULL;

CREATE OR REPLACE VIEW tecnoclimaschema.view_report_dashboard
AS
SELECT bi.idrefulcliente AS idunita,
    ((bi.jsuclcliente -> 'lat'::text)::text)::numeric AS lat,
    ((bi.jsuclcliente -> 'lng'::text)::text)::numeric AS lon,
    replace((bi.jsuclcliente -> 'codice'::text)::text, '"'::text, ''::text) AS codice,
    replace((bi.jsuclcliente -> 'descrizione'::text)::text, '"'::text, ''::text) AS descrizione,
    bi.stato,
    bi.tipo,
    replace(((bi.jsuclcliente -> 'indirizzo'::text) -> 'indirizzo'::text)::text, '"'::text, ''::text) AS indirizzo,
    replace(((bi.jsuclcliente -> 'indirizzo'::text) -> 'civico'::text)::text, '"'::text, ''::text) AS civico,
    replace(((bi.jsuclcliente -> 'indirizzo'::text) -> 'cap'::text)::text, '"'::text, ''::text) AS cap,
    replace((((bi.jsuclcliente -> 'indirizzo'::text) -> 'comune'::text) -> 'desCom'::text)::text, '"'::text, ''::text) AS comune,
    replace((((bi.jsuclcliente -> 'indirizzo'::text) -> 'comune'::text) -> 'sigla'::text)::text, '"'::text, ''::text) AS prov,
    replace(((bi.jsuclcliente -> 'cliente'::text) -> 'nominativo'::text)::text, '"'::text, ''::text) AS cliente,
    bi.idcliente,
    bi.idreffornitore,
    (((((bi.jsuclcliente -> 'indirizzo'::text) -> 'comune'::text) -> 'provincia'::text) -> 'id'::text)::text)::integer AS idprovincia,
    bi.idregione
   FROM bolla_interveto_lista_tk bi
  WHERE 1 = 1 AND bi.valid IS TRUE AND (bi.stato::text = ANY (ARRAY['A'::character varying, 'P'::character varying, 'IE'::character varying, 'B'::character varying, 'CP'::character varying, 'C'::character varying, 'CW'::character varying]::text[])) AND (bi.tipo::text = ANY (ARRAY['TICKET ECO'::character varying, 'TICKET COMMESSA'::character varying, 'TICKET CANTIERE'::character varying, 'TICKET PROGRAMMATO'::character varying]::text[]))

	
	SELECT FN_SYS_ADDCOLUMN				('calendario_committenza'		,'ref_unita_locale' 	 , 'LONG'		, '5'	 ,'0'	  ,	null			, null			) 	FROM dual;



CREATE OR REPLACE VIEW tecnoclimaschema.view_report_ore_tecnici_canviere
AS SELECT g1.idopzione,
    g1.cognome,
    g1.nome,
    g1.datariferimento,
    concat(replace((bi.jsuclcliente -> 'codice'::text)::text, '"'::text, ''::text), ' ', replace((bi.jsuclcliente -> 'descrizione'::text)::text, '"'::text, ''::text)) AS sede,
    bi.stato,
    bi.tipo,
    bi.identificativo,
    bi.oggetto,
    g1.idutente,
    replace(((bi.jsuclcliente -> 'cliente'::text) -> 'nominativo'::text)::text, '"'::text, ''::text) AS cliente,
    ((bi.jsuclcliente -> 'cliente' -> 'id')::text)::numeric   as idcliente
   FROM view_timbratura_lista_1 g1
     LEFT JOIN view_timbratura_spesa_json tsj ON tsj.idutente = g1.idutente AND to_date(tsj.datariferimento, 'DD/MM/YYYY'::text) = g1.datariferimento
     LEFT JOIN opz_timbratura t ON t.id = g1.idopzione
     LEFT JOIN bolla_interveto_lista_tk bi ON bi.id = t.ref_bolla_intervento
  WHERE 1 = 1 AND bi.tipo::text = 'TICKET CANTIERE'::text;


CREATE OR REPLACE VIEW tecnoclimaschema.view_spese_genarali_anno_fornitore
AS
select importo
,anno
,percentuale_int
,percentuale_can
,percentuale_man
, idfornitore
from (

select sum(spesa_riconosciuta) as importo
, EXTRACT( year  from data_operazione) as anno
, 0 as percentuale_int
, 0 as  percentuale_can
, 0 as percentuale_man
, s.ref_fornitore as idfornitore
from spesa s where s.ref_fornitore is not null and "valid" is true
group by 2,6
union all
select
importo::numeric  as importo
,anno as anno
,percentuale_int as percentuale_int
,percentuale_can as percentuale_can
,percentuale_man as percentuale_man
, sg.ref_fornitore as idfornitore
from spese_generali sg
) spesagen


CREATE OR REPLACE VIEW tecnoclimaschema.view_report_spese_genarali_anno_fornitore
AS
select anno, idfornitore
, sum(importo) as importo
, case
  when sum(percentuale_int) = 0 then 30
	else sum(percentuale_int)
  end percentualeint
, case
 when sum(percentuale_can) = 0 then 40
 else sum(percentuale_can)
 end percentualecan
,  case when sum(percentuale_man) = 0 then 30
  else sum(percentuale_man)
  end percentualeman
  from view_spese_genarali_anno_fornitore
group by 1,2;

CREATE OR REPLACE VIEW tecnoclimaschema.bolla_intervento_fpo_cantiere
AS SELECT bifoto.idbolla,
bifoto.suitejson
FROM ( WITH testcases AS (
     SELECT m.ref_bolla_intervento AS idbolla,
        m.importo ,
        m.ref_fornitore
       FROM manodopera m
        where  m.valid IS TRUE
    ), fotojson AS (
     SELECT testcases.idbolla,
        json_agg(json_build_object('id', testcases.idbolla, 'importo', testcases.importo, 'idFornitore', testcases.ref_fornitore
        )) AS suitejson
       FROM testcases
      GROUP BY testcases.idbolla
    )
SELECT fotojson.idbolla,
fotojson.suitejson
FROM fotojson) bifoto;


SELECT FN_SYS_ADDCOLUMN			('spesa'			,'spesa_aziendale'			        , 'VARCHAR'		, '1',   '0',	null		,'N'				)	FROM dual;

CREATE OR REPLACE VIEW tecnoclimaschema.view_controllo_timbratura_notifica
AS
select distinct on (1) u.id, u.nome, u.cognome,
               (select count(*) from timbratura t2 where t2.ref_utente = u.id and t2.tipo = 'IN' and
               date_trunc('day', t2.data_movimento ) =  date_trunc('day', current_date)
               ) as numingresso,
               (select count(*) from timbratura t2 where t2.ref_utente = u.id and t2.tipo = 'PP' and
               date_trunc('day', t2.data_movimento ) =  date_trunc('day', current_date)
               ) as numpranzo,
               (select count(*) from timbratura t2 where t2.ref_utente = u.id and t2.tipo = 'FT' and
               date_trunc('day', t2.data_movimento ) =  date_trunc('day', current_date)
               ) as numuscita,
               (select count(*) from assenza a2  where a2.ref_utente = u.id and a2.flg_approved = 'S' and
               date_trunc('day', a2."data" ) =  date_trunc('day', current_date)
               ) as numassenza
               from utente u
               inner join utente_ruolo ur on ur.ref_utente = u.id and ur.valid    is true
               inner join ruolo r on r.id = ur.ref_ruolo and r.valid   is true
               where 1=1 and
               r.cod_ruolo in ('T','AT','CSD');


SELECT FN_SYS_ADDCOLUMN			('magazzino_slave'			,'prezzo_iva'						, 'NUMBER'		, '30',   '2',	null		,null				)	FROM dual;


SELECT FN_SYS_ADDCOLUMN			('bolla_intervento'			,'totale_manodopera'						, 'NUMBER'		, '30',   '2',	null		,null				)	FROM dual;
SELECT FN_SYS_ADDCOLUMN			('bolla_intervento'			,'totale_materiale'						, 'NUMBER'		, '30',   '2',	null		,null				)	FROM dual;


richiesta_articolo

CREATE OR REPLACE VIEW tecnoclimaschema.bolla_interveto_lista_tk
AS SELECT bi.id,
    bi.identificativo,
    bi.stato,
    bi.oggetto,
    bi.altre_info AS altreinfo,
    bi.protocollo_cliente AS protocollocliente,
    bi.offerta,
    bi.tipo,
    bi.totale_offerta AS totaleofferta,
    bi.spese_trasporto AS spesetrasporto,
    bi.percentuale,
    bi.importo_fornitore AS importofornitore,
    bi.nr_tecnici AS nrtecnici,
    bi.nr_assistenti AS nrassistenti,
    bi.nr_consulenti AS nrconsulenti,
    bi.latitudine_inizio AS latitudineinizio,
    bi.longitudine_inizio AS longitudineinizio,
    bi.latitudine_fine AS latitudinefine,
    bi.longitudine_fine AS longitudinefine,
    bi.lavoro_eseguito AS lavoroeseguito,
    bi.lavoro_eseguito_backoffice AS lavoroeseguitobackoffice,
    bi.flag_risolutivo AS flagrisolutivo,
    bi.flag_idoneo AS flagidoneo,
    bi.flag_ok_backoffice AS flagokbackoffice,
    bi.flag_ok_amministrativo AS flagokamministrativo,
    bi.flag_contabilizzato AS flagcontabilizzato,
    bi.flag_segnalato AS flagsegnalato,
    bi.flag_materiale AS flagmateriale,
    bi.flag_consulenza_specializzata AS flagconsulenzaspecializzata,
    bi.flag_da_fatturare AS flagdafatturare,
    bi.flag_warning_orari AS flagwarningorari,
    bi.flag_sopralluogo AS flagsopralluogo,
    bi.flag_ticket_generato AS flagticketgenerato,
    bi.data_accettazione AS dataaccettazione,
    bi.data_creazione AS datacreazione,
    bi.data_programmazione AS dataprogrammazione,
    bi.data_chiusura AS datachiusura,
        CASE
            WHEN bi.data_modifica IS NOT NULL THEN bi.data_modifica
            ELSE bi.dta_upd
        END AS datamodifica,
    bi.rec_ver AS recver,
    bi.flag_ok_cliente AS flagokcliente,
    bi.flag_ok_fornitore AS flagokfornitore,
    bi.flag_stato_materiale AS flagstatomateriale,
    bi.identificativo_complementare AS identificativocomplementare,
    bi.flag_preventivo_generato AS flagpreventivogenerato,
    bi.chiamante,
    bi.flag_no_sotto_categoria AS flagnosottocategoria,
    bi.flag_azienda AS flagazienda,
    bi.rif_periodo AS rifperiodo,
    bi.importo_fornitore_eco AS importofornitoreeco,
    bi.nota_apertura AS notaapertura,
    bi.nota_chiusura AS notachiusura,
    bi.nota_materiale AS notamateriale,
    bi.nota_materiale_tecnico AS notamaterialetecnico,
    bi.nota_materiale_fornitore AS notamaterialefornitore,
    usl.datijson AS jsulslcliente,
    ucl.datijson AS jsuclcliente,
    uslf.datijson AS jsulslfornitore,
    ufl.datijson AS jsulfornitore,
    cj.datijson AS jscatalogointervento,
    cj2.datijson AS jscatalogocodicepriorita,
    im.id AS idimpianto,
    im.descrizione AS descrizioneimpianto,
    uta.datijson AS jsutenteaccettazione,
    ut.datijson AS jsutente,
    uts.datijson AS jsutentesegnalato,
    utm.datijson AS jsutentemodifica,
    bi.ref_bolla_intervento_padre AS idbollainteventopadre,
    maga.datijson AS jsmagazzino,
    bi.ref_contratto AS idcontratto,
    bf.datifotojson AS jsfoto,
    ba.datidettaglioarticolojson AS jsarticolo,
    ba2.datidettaglioarticolojson AS jsarticoloprev,
    bi.oneri_sicurezza AS onerisicurezza,
    bi.valid,
    bi.flag_notturno AS flagnotturno,
    dtore.numore,
    dttec.numtecnici,
    bi.data_termina_intervento AS dataterminaintervento,
    ntd.numnote AS numnotedip,
    ntf.numnote AS numnotefor,
    ntc.numnote AS numnotecli,
    bi.nota_contabilizzato AS notacontabilizzato,
    bi.tipo_contabilizzato AS tipocontabilizzato,
    bi.nomefile_contabilizzato AS nomefilecontabilizzato,
    bi.ticket_collegato AS ticketcollegato,
    bi.pathfile_contabilizzato AS pathfilecontabilizzato,
    bi.data_segnalazione AS datasegnalazione,
    bi.nota_segnalazione AS notasegnalazione,
    bi.path_nota_segnalazione AS pathnotasegnalazione,
    bi.nome_file_nota_segnalazione AS nomefilenotasegnalazione,
    bi.tipo_file_nota_segnalazione AS tipofilenotasegnalazione,
    bi.nota_annullamento AS notaannullamento,
    bi.flag_fatturato AS flagfatturato,
    bi.nota_sospensione AS notasospensione,
    bi.flag_visibilita_app AS flagvisibilitaapp,
    bft.nominativotecnico,
    bfc.nominativocliente,
    contr.numero_contratto AS numerocontratto,
    bi.nota_risolutivo_no AS notarisolutivono,
    bi.nota_idoneo_no AS notaidoneono,
        CASE
            WHEN COALESCE(v.id, 0::bigint) = 0 THEN 'N'::text
            ELSE 'S'::text
        END AS verbalepresente,
    bi.flag_rischio_interferenza AS flagrischiointerferenza,
    bi.flag_bloccabile AS flagbloccabile,
    utam.datijson AS jsutenteaccettazioneamm,
    utbo.datijson AS jsutenteaccettazionebo,
    utco.datijson AS jsutentemodificaco,
    utfo.datijson AS jsutentemodificafo,
    bi.nota_eliminazione AS notaeliminazione,
    bi.flag_nuova_installazione AS flagnuovainstallazione,
    bi.nota_ripristino AS notaripristino,
    cjivamat.datijson AS jsivamateriale,
    cjivaman.datijson AS jsivamanodeopera,
    bi.tipo_documento AS tipodocumento,
    bi.flag_reverse_change AS flagreversechange,
    bi.numero_documento AS numerodocumento,
    bi.data_documento AS datadocumento,
    bi.importo_nota_credito AS importonotacredito,
    bi.motivazione_nota_credito AS motivazionenotacredito,
    utrev.datijson AS jsutentemodificareverse,
    utmat.datijson AS jsutentemodificamat,
    utman.datijson AS jsutentemodificaman,
    utmatnc.datijson AS jsutentemodificanotacredito,
    bi.data_nota_credito AS datanotacredito,
    bi.ref_utente AS idutente,
    cl.id AS idcliente,
    bi.ref_catalogo_intervento AS idrefcatalogo,
    bi.ref_catalogo_codice_priorita AS idrefcatalogocodicepriorita,
    f2.id AS idreffornitore,
    bm.cnt,
    bme.cnt AS ctnm,
    uts.id AS idutentesegnalato,
    ucl.id AS idrefulcliente,
    mtp.datifonitorejson AS jsmaterialerosso,
    vtca.daticantiereallegatijson AS jstagcantiereallegati,
    culfj.datifonitorejson AS jstdatifonitorejson,
    ( SELECT count(f.id) AS count
           FROM foto f
             LEFT JOIN bolla_intervento bi2 ON f.ref_bolla_intervento = bi2.id
          WHERE (bi2.ref_bolla_intervento_padre IN ( SELECT bip.id
                   FROM bolla_intervento bip
                  WHERE bip.ref_bolla_intervento_padre = bi.id)) AND f.tag::text = 'BOLLECARICATE'::text) AS numbollacantiere,
        CASE
            WHEN bi.tipo::text = 'TICKET CANTIERE'::text THEN split_part(split_part(bi.identificativo::text, 'CA'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'TICKET ECO'::text THEN split_part(split_part(bi.identificativo::text, 'TI'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'TICKET COMMESSA'::text THEN split_part(split_part(bi.identificativo::text, 'TC'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'TICKET PROGRAMMATO'::text THEN split_part(split_part(bi.identificativo::text, 'TP'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'PREVENTIVO'::text THEN split_part(split_part(bi.identificativo::text, 'PR'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'LAVORO EXTRA'::text THEN split_part(split_part(bi.identificativo::text, 'CLX'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'LAVORO ECO'::text THEN split_part(split_part(bi.identificativo::text, 'CLE'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'LAVORO MOD INTERNA'::text THEN split_part(split_part(bi.identificativo::text, 'CLI'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'TICKET LAVORAZIONE CANTIERE'::text THEN split_part(split_part(bi.identificativo::text, 'TLC'::text, 2), '-'::text, 1)::double precision
            ELSE NULL::double precision
        END AS anno,
    split_part(bi.identificativo::text, '-'::text, 2)::double precision AS ord,
    r2.id AS idregione,
    bi.flag_materiali_extra AS materialiextra,
    bi.identificativo_padre AS identificativopadre,
    bi.totale_materiale AS totaleMateriale,
    bi.totale_manodopera AS totaleManodopera
   FROM bolla_intervento bi
     LEFT JOIN unita_locale_json usl ON usl.id = bi.ref_ul_sl_cliente
     LEFT JOIN unita_locale_json ucl ON ucl.id = bi.ref_ul_cliente
     LEFT JOIN unita_locale_json uslf ON uslf.id = bi.ref_ul_sl_fornitore
     LEFT JOIN unita_locale_json ufl ON ufl.id = bi.ref_ul_fornitore
     LEFT JOIN catalogo_json cj ON cj.id = bi.ref_catalogo_intervento
     LEFT JOIN catalogo_json cj2 ON cj2.id = bi.ref_catalogo_codice_priorita
     LEFT JOIN catalogo_json cjivamat ON cjivamat.id = bi.ref_catalogo_iva_materiale
     LEFT JOIN catalogo_json cjivaman ON cjivaman.id = bi.ref_catalogo_iva_manodopera
     LEFT JOIN unita_locale_json maga ON ufl.id = bi.ref_ul_magazzino
     LEFT JOIN utente_json uta ON uta.id = bi.ref_utente_accettazione
     LEFT JOIN utente_json ut ON ut.id = bi.ref_utente
     LEFT JOIN utente_json uts ON uts.id = bi.ref_utente_segnalato
     LEFT JOIN utente_json utm ON utm.id = bi.ref_utente_modifica
     LEFT JOIN bolla_foto_json bf ON bf.idbolla = bi.id
     LEFT JOIN bolla_articolo_json ba ON ba.idbolla = bi.id
     LEFT JOIN bolla_articolo_json ba2 ON ba2.idpreventivo = bi.id
     LEFT JOIN impianto im ON im.id = bi.ref_impianto
     JOIN bolla_dett_ore dtore ON dtore.id = bi.id
     JOIN bolla_dett_tecnici dttec ON dttec.id = bi.id
     JOIN bolla_num_note_dp ntd ON ntd.id = bi.id
     JOIN bolla_num_note_fornitore ntf ON ntf.id = bi.id
     JOIN bolla_num_note_cliente ntc ON ntc.id = bi.id
     LEFT JOIN bolla_firma_tecnico bft ON bft.id = bi.id
     LEFT JOIN bolla_firma_cliente bfc ON bfc.id = bi.id
     LEFT JOIN contratto contr ON contr.id = bi.ref_contratto
     LEFT JOIN verbale v ON v.ref_bolla_intervento = bi.id AND v.valid IS TRUE
     LEFT JOIN utente_json utam ON utam.id = bi.ref_autorizza_amm
     LEFT JOIN utente_json utbo ON utbo.id = bi.ref_autorizza_bo
     LEFT JOIN utente_json utco ON utco.id = bi.ref_autorizza_contabilita
     LEFT JOIN utente_json utfo ON utfo.id = bi.ref_autorizza_fornitore
     LEFT JOIN utente_json utrev ON utrev.id = bi.ref_modifica_reverse
     LEFT JOIN utente_json utman ON utman.id = bi.ref_modifica_iva_man
     LEFT JOIN utente_json utmat ON utmat.id = bi.ref_modifica_iva_mat
     LEFT JOIN utente_json utmatnc ON utmatnc.id = bi.ref_modifica_nota_credito
     LEFT JOIN bolla_materiale_tk bm ON bm.idbolla = bi.id
     LEFT JOIN bolla_materiale_extra_tk bme ON bme.idbolla = bi.id
     LEFT JOIN unita_locale ucl1 ON ucl1.id = bi.ref_ul_cliente
     LEFT JOIN cliente cl ON cl.id = ucl1.ref_cliente
     LEFT JOIN unita_locale ulf1 ON ulf1.id = bi.ref_ul_fornitore
     LEFT JOIN fornitore f2 ON f2.id = ulf1.ref_fornitore
     LEFT JOIN materiale_tk_commessa_rosso_preventivo mtp ON mtp.idbolla = bi.id
     LEFT JOIN view_tag_cantiere_allegati vtca ON vtca.idticket = bi.id
     LEFT JOIN cantiere_unita_locale_fornitore_json_gr culfj ON culfj.idbolla = bi.id
     LEFT JOIN unita_locale uclbase ON uclbase.id = bi.ref_ul_cliente
     LEFT JOIN indirizzo indi ON indi.id = uclbase.ref_indirizzo
     LEFT JOIN comune c2 ON c2.id = indi.ref_comune
     LEFT JOIN provincia p2 ON p2.c_prov_cod::text = c2.c_prov_cod::text
     LEFT JOIN regione r2 ON r2.id = p2.ref_regione
  WHERE bi.valid IS TRUE
  ORDER BY (
        CASE
            WHEN bi.tipo::text = 'TICKET CANTIERE'::text THEN split_part(split_part(bi.identificativo::text, 'CA'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'TICKET ECO'::text THEN split_part(split_part(bi.identificativo::text, 'TI'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'TICKET COMMESSA'::text THEN split_part(split_part(bi.identificativo::text, 'TC'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'TICKET PROGRAMMATO'::text THEN split_part(split_part(bi.identificativo::text, 'TP'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'PREVENTIVO'::text THEN split_part(split_part(bi.identificativo::text, 'PR'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'LAVORO EXTRA'::text THEN split_part(split_part(bi.identificativo::text, 'CLX'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'LAVORO ECO'::text THEN split_part(split_part(bi.identificativo::text, 'CLE'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'LAVORO MOD INTERNA'::text THEN split_part(split_part(bi.identificativo::text, 'CLI'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'TICKET LAVORAZIONE CANTIERE'::text THEN split_part(split_part(bi.identificativo::text, 'TLC'::text, 2), '-'::text, 1)::double precision
            ELSE NULL::double precision
        END) DESC, (split_part(bi.identificativo::text, '-'::text, 2)::double precision) DESC;


CREATE OR REPLACE VIEW tecnoclimaschema.catalogo_json
AS SELECT ts.id,
    ts.tipo,
        CASE
            WHEN catalogopadre.id IS NULL THEN json_build_object('id', ts.id, 'codice', ts.codice, 'descrizione', ts.descrizione, 'tipo', ts.tipo, 'flagNonModificabile', ts.flag_non_modificabile, 'catalogo',  NULL::unknown, 'percentuale', ts.percentuale )
            WHEN catalogopadre.id IS NOT NULL THEN json_build_object('id', ts.id, 'codice', ts.codice, 'descrizione', ts.descrizione, 'tipo', ts.tipo, 'flagNonModificabile', ts.flag_non_modificabile, 'catalogo', catalogopadre.id, 'codiceCatalogoPadre', catalogopadre.codice, 'descrizioneCatalogoPadre', catalogopadre.descrizione,'percentuale', ts.percentuale )
            ELSE NULL::json
        END AS datijson
   FROM catalogo ts
     LEFT JOIN catalogo catalogopadre ON catalogopadre.id = ts.ref_catalogo;


 SELECT FN_SYS_ADDCOLUMN			('bolla_intervento'			,'nascondi_prezzi_materiale'				, 'VARCHAR'		, '1',   '0',	null		,'N'				)	FROM dual;
 SELECT FN_SYS_ADDCOLUMN			('bolla_intervento'			,'nascondi_prezzi_manodopera'				, 'VARCHAR'		, '1',   '0',	null		,'N'				)	FROM dual;





              CREATE OR REPLACE VIEW tecnoclimaschema.bolla_interveto_lista_tk
AS SELECT bi.id,
    bi.identificativo,
    bi.stato,
    bi.oggetto,
    bi.altre_info AS altreinfo,
    bi.protocollo_cliente AS protocollocliente,
    bi.offerta,
    bi.tipo,
    bi.totale_offerta AS totaleofferta,
    bi.spese_trasporto AS spesetrasporto,
    bi.percentuale,
    bi.importo_fornitore AS importofornitore,
    bi.nr_tecnici AS nrtecnici,
    bi.nr_assistenti AS nrassistenti,
    bi.nr_consulenti AS nrconsulenti,
    bi.latitudine_inizio AS latitudineinizio,
    bi.longitudine_inizio AS longitudineinizio,
    bi.latitudine_fine AS latitudinefine,
    bi.longitudine_fine AS longitudinefine,
    bi.lavoro_eseguito AS lavoroeseguito,
    bi.lavoro_eseguito_backoffice AS lavoroeseguitobackoffice,
    bi.flag_risolutivo AS flagrisolutivo,
    bi.flag_idoneo AS flagidoneo,
    bi.flag_ok_backoffice AS flagokbackoffice,
    bi.flag_ok_amministrativo AS flagokamministrativo,
    bi.flag_contabilizzato AS flagcontabilizzato,
    bi.flag_segnalato AS flagsegnalato,
    bi.flag_materiale AS flagmateriale,
    bi.flag_consulenza_specializzata AS flagconsulenzaspecializzata,
    bi.flag_da_fatturare AS flagdafatturare,
    bi.flag_warning_orari AS flagwarningorari,
    bi.flag_sopralluogo AS flagsopralluogo,
    bi.flag_ticket_generato AS flagticketgenerato,
    bi.data_accettazione AS dataaccettazione,
    bi.data_creazione AS datacreazione,
    bi.data_programmazione AS dataprogrammazione,
    bi.data_chiusura AS datachiusura,
        CASE
            WHEN bi.data_modifica IS NOT NULL THEN bi.data_modifica
            ELSE bi.dta_upd
        END AS datamodifica,
    bi.rec_ver AS recver,
    bi.flag_ok_cliente AS flagokcliente,
    bi.flag_ok_fornitore AS flagokfornitore,
    bi.flag_stato_materiale AS flagstatomateriale,
    bi.identificativo_complementare AS identificativocomplementare,
    bi.flag_preventivo_generato AS flagpreventivogenerato,
    bi.chiamante,
    bi.flag_no_sotto_categoria AS flagnosottocategoria,
    bi.flag_azienda AS flagazienda,
    bi.rif_periodo AS rifperiodo,
    bi.importo_fornitore_eco AS importofornitoreeco,
    bi.nota_apertura AS notaapertura,
    bi.nota_chiusura AS notachiusura,
    bi.nota_materiale AS notamateriale,
    bi.nota_materiale_tecnico AS notamaterialetecnico,
    bi.nota_materiale_fornitore AS notamaterialefornitore,
    usl.datijson AS jsulslcliente,
    ucl.datijson AS jsuclcliente,
    uslf.datijson AS jsulslfornitore,
    ufl.datijson AS jsulfornitore,
    cj.datijson AS jscatalogointervento,
    cj2.datijson AS jscatalogocodicepriorita,
    im.id AS idimpianto,
    im.descrizione AS descrizioneimpianto,
    uta.datijson AS jsutenteaccettazione,
    ut.datijson AS jsutente,
    uts.datijson AS jsutentesegnalato,
    utm.datijson AS jsutentemodifica,
    bi.ref_bolla_intervento_padre AS idbollainteventopadre,
    maga.datijson AS jsmagazzino,
    bi.ref_contratto AS idcontratto,
    bf.datifotojson AS jsfoto,
    ba.datidettaglioarticolojson AS jsarticolo,
    ba2.datidettaglioarticolojson AS jsarticoloprev,
    bi.oneri_sicurezza AS onerisicurezza,
    bi.valid,
    bi.flag_notturno AS flagnotturno,
    dtore.numore,
    dttec.numtecnici,
    bi.data_termina_intervento AS dataterminaintervento,
    ntd.numnote AS numnotedip,
    ntf.numnote AS numnotefor,
    ntc.numnote AS numnotecli,
    bi.nota_contabilizzato AS notacontabilizzato,
    bi.tipo_contabilizzato AS tipocontabilizzato,
    bi.nomefile_contabilizzato AS nomefilecontabilizzato,
    bi.ticket_collegato AS ticketcollegato,
    bi.pathfile_contabilizzato AS pathfilecontabilizzato,
    bi.data_segnalazione AS datasegnalazione,
    bi.nota_segnalazione AS notasegnalazione,
    bi.path_nota_segnalazione AS pathnotasegnalazione,
    bi.nome_file_nota_segnalazione AS nomefilenotasegnalazione,
    bi.tipo_file_nota_segnalazione AS tipofilenotasegnalazione,
    bi.nota_annullamento AS notaannullamento,
    bi.flag_fatturato AS flagfatturato,
    bi.nota_sospensione AS notasospensione,
    bi.flag_visibilita_app AS flagvisibilitaapp,
    bft.nominativotecnico,
    bfc.nominativocliente,
    contr.numero_contratto AS numerocontratto,
    bi.nota_risolutivo_no AS notarisolutivono,
    bi.nota_idoneo_no AS notaidoneono,
        CASE
            WHEN COALESCE(v.id, 0::bigint) = 0 THEN 'N'::text
            ELSE 'S'::text
        END AS verbalepresente,
    bi.flag_rischio_interferenza AS flagrischiointerferenza,
    bi.flag_bloccabile AS flagbloccabile,
    utam.datijson AS jsutenteaccettazioneamm,
    utbo.datijson AS jsutenteaccettazionebo,
    utco.datijson AS jsutentemodificaco,
    utfo.datijson AS jsutentemodificafo,
    bi.nota_eliminazione AS notaeliminazione,
    bi.flag_nuova_installazione AS flagnuovainstallazione,
    bi.nota_ripristino AS notaripristino,
    cjivamat.datijson AS jsivamateriale,
    cjivaman.datijson AS jsivamanodeopera,
    bi.tipo_documento AS tipodocumento,
    bi.flag_reverse_change AS flagreversechange,
    bi.numero_documento AS numerodocumento,
    bi.data_documento AS datadocumento,
    bi.importo_nota_credito AS importonotacredito,
    bi.motivazione_nota_credito AS motivazionenotacredito,
    utrev.datijson AS jsutentemodificareverse,
    utmat.datijson AS jsutentemodificamat,
    utman.datijson AS jsutentemodificaman,
    utmatnc.datijson AS jsutentemodificanotacredito,
    bi.data_nota_credito AS datanotacredito,
    bi.ref_utente AS idutente,
    cl.id AS idcliente,
    bi.ref_catalogo_intervento AS idrefcatalogo,
    bi.ref_catalogo_codice_priorita AS idrefcatalogocodicepriorita,
    f2.id AS idreffornitore,
    bm.cnt,
    bme.cnt AS ctnm,
    uts.id AS idutentesegnalato,
    ucl.id AS idrefulcliente,
    mtp.datifonitorejson AS jsmaterialerosso,
    vtca.daticantiereallegatijson AS jstagcantiereallegati,
    culfj.datifonitorejson AS jstdatifonitorejson,
    ( SELECT count(f.id) AS count
           FROM foto f
             LEFT JOIN bolla_intervento bi2 ON f.ref_bolla_intervento = bi2.id
          WHERE (bi2.ref_bolla_intervento_padre IN ( SELECT bip.id
                   FROM bolla_intervento bip
                  WHERE bip.ref_bolla_intervento_padre = bi.id)) AND f.tag::text = 'BOLLECARICATE'::text) AS numbollacantiere,
        CASE
            WHEN bi.tipo::text = 'TICKET CANTIERE'::text THEN split_part(split_part(bi.identificativo::text, 'CA'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'TICKET ECO'::text THEN split_part(split_part(bi.identificativo::text, 'TI'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'TICKET COMMESSA'::text THEN split_part(split_part(bi.identificativo::text, 'TC'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'TICKET PROGRAMMATO'::text THEN split_part(split_part(bi.identificativo::text, 'TP'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'PREVENTIVO'::text THEN split_part(split_part(bi.identificativo::text, 'PR'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'LAVORO EXTRA'::text THEN split_part(split_part(bi.identificativo::text, 'CLX'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'LAVORO ECO'::text THEN split_part(split_part(bi.identificativo::text, 'CLE'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'LAVORO MOD INTERNA'::text THEN split_part(split_part(bi.identificativo::text, 'CLI'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'TICKET LAVORAZIONE CANTIERE'::text THEN split_part(split_part(bi.identificativo::text, 'TLC'::text, 2), '-'::text, 1)::double precision
            ELSE NULL::double precision
        END AS anno,
    split_part(bi.identificativo::text, '-'::text, 2)::double precision AS ord,
    r2.id AS idregione,
    bi.flag_materiali_extra AS materialiextra,
    bi.identificativo_padre AS identificativopadre,
    bi.totale_materiale AS totalemateriale,
    bi.totale_manodopera AS totalemanodopera,
    bi.nascondi_Prezzi_Manodopera as nascondiPrezziManodopera,
    bi.nascondi_Prezzi_Materiale as nascondiPrezziMateriale
   FROM bolla_intervento bi
     LEFT JOIN unita_locale_json usl ON usl.id = bi.ref_ul_sl_cliente
     LEFT JOIN unita_locale_json ucl ON ucl.id = bi.ref_ul_cliente
     LEFT JOIN unita_locale_json uslf ON uslf.id = bi.ref_ul_sl_fornitore
     LEFT JOIN unita_locale_json ufl ON ufl.id = bi.ref_ul_fornitore
     LEFT JOIN catalogo_json cj ON cj.id = bi.ref_catalogo_intervento
     LEFT JOIN catalogo_json cj2 ON cj2.id = bi.ref_catalogo_codice_priorita
     LEFT JOIN catalogo_json cjivamat ON cjivamat.id = bi.ref_catalogo_iva_materiale
     LEFT JOIN catalogo_json cjivaman ON cjivaman.id = bi.ref_catalogo_iva_manodopera
     LEFT JOIN unita_locale_json maga ON ufl.id = bi.ref_ul_magazzino
     LEFT JOIN utente_json uta ON uta.id = bi.ref_utente_accettazione
     LEFT JOIN utente_json ut ON ut.id = bi.ref_utente
     LEFT JOIN utente_json uts ON uts.id = bi.ref_utente_segnalato
     LEFT JOIN utente_json utm ON utm.id = bi.ref_utente_modifica
     LEFT JOIN bolla_foto_json bf ON bf.idbolla = bi.id
     LEFT JOIN bolla_articolo_json ba ON ba.idbolla = bi.id
     LEFT JOIN bolla_articolo_json ba2 ON ba2.idpreventivo = bi.id
     LEFT JOIN impianto im ON im.id = bi.ref_impianto
     JOIN bolla_dett_ore dtore ON dtore.id = bi.id
     JOIN bolla_dett_tecnici dttec ON dttec.id = bi.id
     JOIN bolla_num_note_dp ntd ON ntd.id = bi.id
     JOIN bolla_num_note_fornitore ntf ON ntf.id = bi.id
     JOIN bolla_num_note_cliente ntc ON ntc.id = bi.id
     LEFT JOIN bolla_firma_tecnico bft ON bft.id = bi.id
     LEFT JOIN bolla_firma_cliente bfc ON bfc.id = bi.id
     LEFT JOIN contratto contr ON contr.id = bi.ref_contratto
     LEFT JOIN verbale v ON v.ref_bolla_intervento = bi.id AND v.valid IS TRUE
     LEFT JOIN utente_json utam ON utam.id = bi.ref_autorizza_amm
     LEFT JOIN utente_json utbo ON utbo.id = bi.ref_autorizza_bo
     LEFT JOIN utente_json utco ON utco.id = bi.ref_autorizza_contabilita
     LEFT JOIN utente_json utfo ON utfo.id = bi.ref_autorizza_fornitore
     LEFT JOIN utente_json utrev ON utrev.id = bi.ref_modifica_reverse
     LEFT JOIN utente_json utman ON utman.id = bi.ref_modifica_iva_man
     LEFT JOIN utente_json utmat ON utmat.id = bi.ref_modifica_iva_mat
     LEFT JOIN utente_json utmatnc ON utmatnc.id = bi.ref_modifica_nota_credito
     LEFT JOIN bolla_materiale_tk bm ON bm.idbolla = bi.id
     LEFT JOIN bolla_materiale_extra_tk bme ON bme.idbolla = bi.id
     LEFT JOIN unita_locale ucl1 ON ucl1.id = bi.ref_ul_cliente
     LEFT JOIN cliente cl ON cl.id = ucl1.ref_cliente
     LEFT JOIN unita_locale ulf1 ON ulf1.id = bi.ref_ul_fornitore
     LEFT JOIN fornitore f2 ON f2.id = ulf1.ref_fornitore
     LEFT JOIN materiale_tk_commessa_rosso_preventivo mtp ON mtp.idbolla = bi.id
     LEFT JOIN view_tag_cantiere_allegati vtca ON vtca.idticket = bi.id
     LEFT JOIN cantiere_unita_locale_fornitore_json_gr culfj ON culfj.idbolla = bi.id
     LEFT JOIN unita_locale uclbase ON uclbase.id = bi.ref_ul_cliente
     LEFT JOIN indirizzo indi ON indi.id = uclbase.ref_indirizzo
     LEFT JOIN comune c2 ON c2.id = indi.ref_comune
     LEFT JOIN provincia p2 ON p2.c_prov_cod::text = c2.c_prov_cod::text
     LEFT JOIN regione r2 ON r2.id = p2.ref_regione
  WHERE bi.valid IS TRUE
  ORDER BY (
        CASE
            WHEN bi.tipo::text = 'TICKET CANTIERE'::text THEN split_part(split_part(bi.identificativo::text, 'CA'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'TICKET ECO'::text THEN split_part(split_part(bi.identificativo::text, 'TI'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'TICKET COMMESSA'::text THEN split_part(split_part(bi.identificativo::text, 'TC'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'TICKET PROGRAMMATO'::text THEN split_part(split_part(bi.identificativo::text, 'TP'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'PREVENTIVO'::text THEN split_part(split_part(bi.identificativo::text, 'PR'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'LAVORO EXTRA'::text THEN split_part(split_part(bi.identificativo::text, 'CLX'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'LAVORO ECO'::text THEN split_part(split_part(bi.identificativo::text, 'CLE'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'LAVORO MOD INTERNA'::text THEN split_part(split_part(bi.identificativo::text, 'CLI'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'TICKET LAVORAZIONE CANTIERE'::text THEN split_part(split_part(bi.identificativo::text, 'TLC'::text, 2), '-'::text, 1)::double precision
            ELSE NULL::double precision
        END) DESC, (split_part(bi.identificativo::text, '-'::text, 2)::double precision) DESC;


CREATE OR REPLACE VIEW tecnoclimaschema.bolla_estrai_preventivo
AS
select
	bi.identificativo as identificativo
	,  coalesce (bilt2.identificativo, '') as identificativoComplementare
	,	replace((bi.jsutente -> 'nome'::text)::text, '"'::text, ''::text) AS nome
	,	replace((bi.jsutente -> 'cognome'::text)::text, '"'::text, ''::text) AS cognome
	, bi.oggetto as oggetto,
	replace((bi.jsuclcliente -> 'codice'::text)::text, '"'::text, ''::text) AS codice,
    replace((bi.jsuclcliente -> 'descrizione'::text)::text, '"'::text, ''::text) AS descrizione,
    bi.stato,
    replace(((bi.jsuclcliente -> 'indirizzo'::text) -> 'indirizzo'::text)::text, '"'::text, ''::text) AS indirizzo,
    replace(((bi.jsuclcliente -> 'indirizzo'::text) -> 'civico'::text)::text, '"'::text, ''::text) AS civico,
    replace(((bi.jsuclcliente -> 'indirizzo'::text) -> 'cap'::text)::text, '"'::text, ''::text) AS cap,
    replace((((bi.jsuclcliente -> 'indirizzo'::text) -> 'comune'::text) -> 'desCom'::text)::text, '"'::text, ''::text) AS comune,
    replace((((bi.jsuclcliente -> 'indirizzo'::text) -> 'comune'::text) -> 'sigla'::text)::text, '"'::text, ''::text) AS prov,
    replace((((bi.jsuclcliente -> 'indirizzo'::text) -> 'comune'::text) -> 'provincia'->'regione' -> 'descrizione'::text)::text, '"'::text, ''::text) AS regione,
    replace(((bi.jsuclcliente -> 'cliente'::text)     -> 'nominativo'::text)::text, '"'::text, ''::text) AS cliente,
    replace(((bilt2.jsulfornitore -> 'fornitore'::text) -> 'denominazione'::text)::text, '"'::text, ''::text) AS fornitore,
    bi.dataaccettazione as dataAccettazione,
    bilt2.datacreazione as datacreazione,
	bi.totaleofferta as totaleoffertaPreventivo,
	coalesce(bilt2.importofornitoreeco, bi.importofornitore ) as offertaFornitore
from bolla_interveto_lista_tk bi
left join bolla_interveto_lista_tk bilt2 on  bilt2.identificativocomplementare = bi.identificativo;


SELECT FN_SYS_ADDCOLUMN			('spesa'			, 'ref_foto_cons_rit_furgone'	            , 'LONG'		, '5', 		'0', 	null	, null				)	FROM dual;


CREATE OR REPLACE VIEW tecnoclimaschema.view_giacenze_attive
AS SELECT a.descrizione AS descrizionearticolo,
    c4.descrizione AS modello,
    c5.descrizione AS marca,
    c6.descrizione AS tipo,
    mm.quantita,
    mm.ref_unita_locale_magazzino AS idunitalocale,
    mm.id,
    a.id AS idarticolo,
    c7.codice as codiceunitamisura,
    c7.descrizione as unitamisura
   FROM magazzino_master mm
     JOIN articolo a ON a.id = mm.ref_articolo
     LEFT JOIN catalogo c4 ON c4.id = a.ref_marca_modello
     LEFT JOIN catalogo c5 ON c5.id = c4.ref_catalogo
     LEFT JOIN catalogo c6 ON c6.id = a.ref_catalogo_tipo
     LEFT JOIN catalogo c7 ON c7.id = a.ref_catalogo_udm
  WHERE mm.quantita > 0::numeric AND mm.valid IS TRUE AND mm.flag_rotto::text = 'N'::text;

SELECT FN_SYS_ADDCOLUMN			('richiesta_articolo'			,'totale_rettifica'						, 'NUMBER'		, '30',   '2',	null		,null				)	FROM dual;
SELECT FN_SYS_ADDCOLUMN			('richiesta_articolo'			,'flg_rettificato'			            , 'VARCHAR'		, '1' ,   '0',	null		,'N'				)	FROM dual;
SELECT FN_SYS_ADDCOLUMN			('richiesta_articolo'			,'data_rettifica'				        , 'DATE'		, null,	   null, null		,null				)	FROM dual;

SELECT FN_SYS_ADDCOLUMN			('articolo'						,'codice_barre'							, 'VARCHAR'		, '50',   '0',	null		,null				)	FROM dual;


CREATE OR REPLACE VIEW tecnoclimaschema.view_unitalocale_without_cantiere
AS
select id as id
, datijson as  datijson
, ((ulj.datijson ->'cliente'->'id'::text)::text)::numeric as idcliente,
 replace( ((ulj.datijson ->'codice'::text)::text)::text, '"'::text, ''::text) AS codice,
  replace( ((ulj.datijson ->'descrizione'::text)::text)::text, '"'::text, ''::text) AS descrizione,
  replace(  ((ulj.datijson ->'tipoUnitaLocale'->'codice'::text)::text)::text, '"'::text, ''::text)  as codiceTipoUnitaLocale
 from unita_locale_json ulj;


CREATE OR REPLACE VIEW tecnoclimaschema.view_cliente_fornitore
AS
select cf.id
, ulj.id as idUnitaFornitore
, ulj.datijson as unitaFornitore
, ulj2.id as idUnitaCliente
, ulj2.datijson as unitaCliente
,    replace(  ((ulj.datijson->'fornitore'->'flagTitolare'::text)::text)::text, '"'::text, ''::text)  as flagTitolare
from cliente_fornitore cf
left join unita_locale_json ulj on ulj.id = cf.ref_unita_locale_fornitore
left join unita_locale_json ulj2 on ulj2.id = cf.ref_unita_locale_cliente
left join unita_locale ul on ul.id = cf.ref_unita_locale_fornitore
left join fornitore f on f.id = ul.ref_fornitore and f."valid" is true
left join unita_locale ulc on ulc.id = cf.ref_unita_locale_cliente
left join cliente c on c.id = ulc.ref_cliente and c."valid" is true
where c."valid" is true and f."valid" is true and ulc."valid" is true  and ul."valid" is true
and f.flag_titolare != 'S';



CREATE OR REPLACE VIEW tecnoclimaschema.gruppo_view_cliente_fornitore
AS SELECT bifoto.idunitacliente,
bifoto.datiunitafornitore
FROM ( WITH testcases AS (
SELECT c.idunitacliente,
c.unitafornitore, c.id as idclientefornitore
FROM view_cliente_fornitore c
WHERE 1 = 1
ORDER BY c.idunitacliente DESC
), fotojson AS (
SELECT testcases.idunitacliente,
json_agg(json_build_object('idUnitaCliente', testcases.idunitacliente, 'unitaFornitore', testcases.unitafornitore, 'idclientefornitore', testcases.idclientefornitore)) AS datiunitafornitore
FROM testcases
GROUP BY testcases.idunitacliente
)
SELECT fotojson.idunitacliente,
fotojson.datiunitafornitore
FROM fotojson) bifoto;



CREATE OR REPLACE VIEW tecnoclimaschema.lista_tipo_impianto_unita_locale_cliente
AS SELECT bifoto.idunita,
 bifoto.datiunitaFornitore
FROM ( WITH testcases AS (
            select  i.ref_catalogo_tipo_impianto as idtipo, i.ref_unita_locale as idunita from impianto i
            inner join catalogo c on c.id = i.ref_catalogo_tipo_impianto
            inner join unita_locale ul on ul.id = i.ref_unita_locale
            where ul.ref_cliente is not null and i."valid" is true and ul."valid" is true
            group by 1,2
             ), fotojson AS (
              SELECT testcases.idunita,
                 json_agg(json_build_object('idunita', testcases.idunita, 'idtipo', testcases.idtipo)) AS datiunitaFornitore
                FROM testcases
               GROUP BY testcases.idunita
             )
      SELECT fotojson.idunita,
         fotojson.datiunitaFornitore
        FROM fotojson) bifoto;

 CREATE OR REPLACE VIEW tecnoclimaschema.view_articoli_contratto_unita_loc_json
             AS SELECT bifoto.idcontrattounitalocale,
                 bifoto.datijson
                FROM ( WITH testcases AS (
            				SELECT cf.id,
								    cf.ref_contratto_unita_loc AS idcontrattounitalocale,
								    cf.qta_contratto AS qtacontratto,
								    cf.qta_manutenzione AS qtamanutenzione,
								    cf.prezzo AS prezzo,
								    aj.datijson AS articolo,
								    cf.valid  ,
								    cf.rec_ver AS recVer
								   FROM articoli_contratto_unita_loc cf
								     inner JOIN articolo_json aj ON aj.id = cf.ref_articoli
								  WHERE cf.valid IS true
                             ), fotojson AS (
                              SELECT testcases.idcontrattounitalocale,
                                 json_agg(json_build_object('id', testcases.id
                                 			 , 'idcontrattounitalocale', testcases.idcontrattounitalocale
                                 			 , 'qta_contratto', testcases.qtacontratto
                                 			 , 'qta_manutenzione', testcases.qtamanutenzione
                                 			 , 'prezzo', testcases.prezzo
                                 			 , 'articolo', testcases.articolo
                                 			 , 'recVer', testcases.recVer
                                 			 , 'valid', testcases.valid)) AS datijson
                                FROM testcases
                               GROUP BY testcases.idcontrattounitalocale
                             )
                      SELECT fotojson.idcontrattounitalocale,
                         fotojson.datijson
                        FROM fotojson) bifoto;



CREATE OR REPLACE VIEW tecnoclimaschema.indirizzo_json
AS SELECT i.id,
json_build_object('id', i.id, 'cap', i.cap, 'indirizzo', i.indirizzo, 'civico', i.civico, 'piano', i.piano, 'scala', i.scala, 'interno', i.interno, 'comune', cj.datijson, 'comuneDesc', i.comune_desc) AS datijson
FROM indirizzo i
JOIN comune_json cj ON cj.id = i.ref_comune;


CREATE OR REPLACE VIEW tecnoclimaschema.unita_locale_json
AS SELECT ul.id,
json_build_object('id', ul.id, 'codice', ul.codice, 'descrizione', ul.descrizione, 'cliente', cj.datijson, 'fornitore', fj.datijson, 'tipoUnitaLocale', catj.datijson, 'indirizzo', ij.datijson, 'lat', ul.n_latitudine, 'lng', ul.n_longitudine, 'flagFurgone', ul.flag_furgone
, 'flagUtente', ul.flag_utente
) AS datijson
FROM unita_locale ul
LEFT JOIN cliente_json cj ON cj.id = ul.ref_cliente
LEFT JOIN fornitore_json fj ON fj.id = ul.ref_fornitore
LEFT JOIN catalogo_json catj ON catj.id = ul.ref_catalogo
LEFT JOIN indirizzo_json ij ON ij.id = ul.ref_indirizzo;

CREATE OR REPLACE VIEW tecnoclimaschema.view_unita_locale_json
AS
select ulj.datijson
, ((ulj.datijson -> 'tipoUnitaLocale'->'id'::text)::text)::numeric AS idTipoUnitaLocale
, ((ulj.datijson -> 'cliente'->'id'::text)::text)::numeric AS idCliente
, ((ulj.datijson -> 'fornitore'->'id'::text)::text)::numeric AS idFornitore
, ((ulj.datijson -> 'indirizzo'->'id'::text)::text)::numeric AS idIndirizzo
, ((ulj.datijson -> 'indirizzo'->'comune'->'id'::text)::text)::numeric AS idComune
, ((ulj.datijson -> 'indirizzo'->'comune'->'provincia'->'id'::text)::text)::numeric AS idProvincia
, ((ulj.datijson -> 'indirizzo'->'comune'->'provincia'->'regione'->'id'::text)::text)::numeric AS idRegione
, replace((ulj.datijson -> 'flagFurgone'::text)::text, '"'::text, ''::text) AS flagFurgone
, replace((ulj.datijson -> 'codice'::text)::text, '"'::text, ''::text) AS codice
, replace((ulj.datijson -> 'descrizione'::text)::text, '"'::text, ''::text) AS descrizione
, replace((ulj.datijson -> 'indirizzo'->'comune'->'desCom' ::text)::text, '"'::text, ''::text) AS descrizioneComune
, replace((ulj.datijson -> 'indirizzo'->'comuneDesc' ::text)::text, '"'::text, ''::text) AS descrizioneComuneEstero
from unita_locale_json ulj
order by 11  asc;


CREATE OR REPLACE VIEW tecnoclimaschema.indirizzo_json
AS SELECT i.id,
json_build_object('id', i.id, 'cap', i.cap, 'indirizzo', i.indirizzo, 'civico', i.civico, 'piano', i.piano, 'scala', i.scala, 'interno', i.interno, 'comune', cj.datijson,'esterno',esterno,'comuneDesc',comune_desc) AS datijson
FROM indirizzo i
 JOIN comune_json cj ON cj.id = i.ref_comune;

CREATE OR REPLACE VIEW tecnoclimaschema.lista_codici_int_unita_locale
AS SELECT bifoto.idunita,
bifoto.interventoCodice
FROM ( WITH testcases AS (
select ref_unita_locale as idunita, cj.datijson as datijson
from unita_locale_catalogo ulc
left join catalogo_json cj on cj.id = ulc.ref_catalogo
), fotojson AS (
SELECT testcases.idunita,
 json_agg(json_build_object('interventoCodice', testcases.datijson)) AS interventoCodice
FROM testcases
GROUP BY testcases.idunita
)
SELECT fotojson.idunita,
fotojson.interventoCodice
FROM fotojson) bifoto;


CREATE OR REPLACE VIEW tecnoclimaschema.unita_locale_json
AS SELECT ul.id,
    json_build_object('id', ul.id, 'codice', ul.codice, 'descrizione', ul.descrizione, 'cliente', cj.datijson, 'fornitore', fj.datijson, 'tipoUnitaLocale', catj.datijson, 'indirizzo', ij.datijson, 'lat', ul.n_latitudine, 'lng', ul.n_longitudine, 'flagFurgone', ul.flag_furgone, 'flagUtente', ul.flag_utente,'listaCodiceIntervento', lcd.interventoCodice) AS datijson
   FROM unita_locale ul
     LEFT JOIN cliente_json cj ON cj.id = ul.ref_cliente
     LEFT JOIN fornitore_json fj ON fj.id = ul.ref_fornitore
     LEFT JOIN catalogo_json catj ON catj.id = ul.ref_catalogo
     LEFT JOIN indirizzo_json ij ON ij.id = ul.ref_indirizzo;


 CREATE OR REPLACE VIEW tecnoclimaschema.lista_tipo_catalogo_unita_locale
          AS SELECT bifoto.idunita,
           bifoto.datiunita
          FROM ( WITH testcases AS (
                      select  i.ref_unita_locale as idunita, i.ref_catalogo as idtipo from unita_locale_catalogo i
                      where   1=1 and i."valid"
                      group by 1,2
                       ), fotojson AS (
                        SELECT testcases.idunita,
                           json_agg(json_build_object('idunita', testcases.idunita, 'idtipo', testcases.idtipo)) AS datiunita
                          FROM testcases
                         GROUP BY testcases.idunita
                       )
                SELECT fotojson.idunita,
                   fotojson.datiunita
                  FROM fotojson) bifoto;


CREATE OR REPLACE VIEW tecnoclimaschema.view_cliente_fornitore
AS SELECT cf.id,
    ulj.id AS idunitafornitore,
    ulj.datijson AS unitafornitore,
    ulj2.id AS idunitacliente,
    ulj2.datijson AS unitacliente,
    replace(((ulj.datijson -> 'fornitore'::text) -> 'flagTitolare'::text)::text, '"'::text, ''::text) AS flagtitolare,
    lt.datiunita as interventocodice
   FROM cliente_fornitore cf
     LEFT JOIN unita_locale_json ulj ON ulj.id = cf.ref_unita_locale_fornitore
     LEFT JOIN unita_locale_json ulj2 ON ulj2.id = cf.ref_unita_locale_cliente
     LEFT JOIN unita_locale ul ON ul.id = cf.ref_unita_locale_fornitore
     LEFT JOIN fornitore f ON f.id = ul.ref_fornitore AND f.valid IS TRUE
     LEFT JOIN unita_locale ulc ON ulc.id = cf.ref_unita_locale_cliente
     LEFT JOIN cliente c ON c.id = ulc.ref_cliente AND c.valid IS true
     left join lista_tipo_catalogo_unita_locale lt on lt.idunita = cf.ref_unita_locale_fornitore
  WHERE c.valid IS TRUE AND f.valid IS TRUE AND ulc.valid IS TRUE AND ul.valid IS TRUE AND f.flag_titolare::text <> 'S'::text;








                        CREATE OR REPLACE VIEW tecnoclimaschema.view_cliente_fornitore
                  AS SELECT cf.id,
                      ulj.id AS idunitafornitore,
                      ulj.datijson AS unitafornitore,
                      ulj2.id AS idunitacliente,
                      ulj2.datijson AS unitacliente,
                      replace(((ulj.datijson -> 'fornitore'::text) -> 'flagTitolare'::text)::text, '"'::text, ''::text) AS flagtitolare,
                      ltc.datiunita as interventocodice
                     FROM cliente_fornitore cf
                       LEFT JOIN unita_locale_json ulj ON ulj.id = cf.ref_unita_locale_fornitore
                       LEFT JOIN unita_locale_json ulj2 ON ulj2.id = cf.ref_unita_locale_cliente
                       LEFT JOIN unita_locale ul ON ul.id = cf.ref_unita_locale_fornitore
                       LEFT JOIN fornitore f ON f.id = ul.ref_fornitore AND f.valid IS TRUE
                       LEFT JOIN unita_locale ulc ON ulc.id = cf.ref_unita_locale_cliente
                       LEFT JOIN cliente c ON c.id = ulc.ref_cliente AND c.valid IS true
                       left join lista_tipo_catalogo_unita_locale ltc on ltc.idunita = cf.ref_unita_locale_fornitore
                    WHERE c.valid IS TRUE AND f.valid IS TRUE AND ulc.valid IS TRUE AND ul.valid IS TRUE AND f.flag_titolare::text <> 'S'::text;


      CREATE OR REPLACE VIEW tecnoclimaschema.gruppo_view_cliente_fornitore
AS SELECT bifoto.idunitacliente,
    bifoto.datiunitafornitore
   FROM ( WITH testcases AS (
                 SELECT c.idunitacliente,
                    c.unitafornitore,
                    c.id AS idclientefornitore,
                    c.interventocodice as interventocodice
                   FROM view_cliente_fornitore c
                  WHERE 1 = 1
                  ORDER BY c.idunitacliente DESC
                ), fotojson AS (
                 SELECT testcases.idunitacliente,
                    json_agg(json_build_object('idUnitaCliente', testcases.idunitacliente, 'unitaFornitore', testcases.unitafornitore, 'idclientefornitore', testcases.idclientefornitore,'interventocodice', testcases.interventocodice)) AS datiunitafornitore
                   FROM testcases
                  GROUP BY testcases.idunitacliente
                )
         SELECT fotojson.idunitacliente,
            fotojson.datiunitafornitore
           FROM fotojson) bifoto;

SELECT FN_SYS_ADDCOLUMN				('contratto' 		, 'ref_contratto_padre'				, 'LONG'		,   '5'		, '0'		, null	, null		)	FROM dual;


CREATE OR REPLACE VIEW tecnoclimaschema.unita_locale_json
AS SELECT ul.id,
    json_build_object('id', ul.id, 'codice', ul.codice, 'descrizione', ul.descrizione, 'cliente', cj.datijson, 'fornitore', fj.datijson, 'tipoUnitaLocale', catj.datijson, 'indirizzo', ij.datijson, 'lat', ul.n_latitudine, 'lng', ul.n_longitudine, 'flagFurgone', ul.flag_furgone, 'flagUtente', ul.flag_utente) AS datijson
   FROM unita_locale ul
     LEFT JOIN cliente_json cj ON cj.id = ul.ref_cliente
     LEFT JOIN fornitore_json fj ON fj.id = ul.ref_fornitore
     LEFT JOIN catalogo_json catj ON catj.id = ul.ref_catalogo
     LEFT JOIN indirizzo_json ij ON ij.id = ul.ref_indirizzo
    where ul."valid" is true;


SELECT FN_SYS_ADDCOLUMN				('scheda_tecnica' , 'flag_abilitato'	 , 'VARCHAR'		,  '1'	 , '0'	  , 'NOT NULL'	, 'S'			)	FROM dual;


SELECT FN_SYS_ADDCOLUMN				('bolla_intervento'		, 'flag_luci_trasformatori'			 , 'VARCHAR'		,  '1'	 , '0'	  , null	, 'N'			)	FROM dual;






CREATE OR REPLACE VIEW tecnoclimaschema.bolla_interveto_lista_tk
AS SELECT bi.id,
    bi.identificativo,
    bi.stato,
    bi.oggetto,
    bi.altre_info AS altreinfo,
    bi.protocollo_cliente AS protocollocliente,
    bi.offerta,
    bi.tipo,
    bi.totale_offerta AS totaleofferta,
    bi.spese_trasporto AS spesetrasporto,
    bi.percentuale,
    bi.importo_fornitore AS importofornitore,
    bi.nr_tecnici AS nrtecnici,
    bi.nr_assistenti AS nrassistenti,
    bi.nr_consulenti AS nrconsulenti,
    bi.latitudine_inizio AS latitudineinizio,
    bi.longitudine_inizio AS longitudineinizio,
    bi.latitudine_fine AS latitudinefine,
    bi.longitudine_fine AS longitudinefine,
    bi.lavoro_eseguito AS lavoroeseguito,
    bi.lavoro_eseguito_backoffice AS lavoroeseguitobackoffice,
    bi.flag_risolutivo AS flagrisolutivo,
    bi.flag_idoneo AS flagidoneo,
    bi.flag_ok_backoffice AS flagokbackoffice,
    bi.flag_ok_amministrativo AS flagokamministrativo,
    bi.flag_contabilizzato AS flagcontabilizzato,
    bi.flag_segnalato AS flagsegnalato,
    bi.flag_materiale AS flagmateriale,
    bi.flag_consulenza_specializzata AS flagconsulenzaspecializzata,
    bi.flag_da_fatturare AS flagdafatturare,
    bi.flag_warning_orari AS flagwarningorari,
    bi.flag_sopralluogo AS flagsopralluogo,
    bi.flag_ticket_generato AS flagticketgenerato,
    bi.data_accettazione AS dataaccettazione,
    bi.data_creazione AS datacreazione,
    bi.data_programmazione AS dataprogrammazione,
    bi.data_chiusura AS datachiusura,
        CASE
            WHEN bi.data_modifica IS NOT NULL THEN bi.data_modifica
            ELSE bi.dta_upd
        END AS datamodifica,
    bi.rec_ver AS recver,
    bi.flag_ok_cliente AS flagokcliente,
    bi.flag_ok_fornitore AS flagokfornitore,
    bi.flag_stato_materiale AS flagstatomateriale,
    bi.identificativo_complementare AS identificativocomplementare,
    bi.flag_preventivo_generato AS flagpreventivogenerato,
    bi.chiamante,
    bi.flag_no_sotto_categoria AS flagnosottocategoria,
    bi.flag_azienda AS flagazienda,
    bi.rif_periodo AS rifperiodo,
    bi.importo_fornitore_eco AS importofornitoreeco,
    bi.nota_apertura AS notaapertura,
    bi.nota_chiusura AS notachiusura,
    bi.nota_materiale AS notamateriale,
    bi.nota_materiale_tecnico AS notamaterialetecnico,
    bi.nota_materiale_fornitore AS notamaterialefornitore,
    usl.datijson AS jsulslcliente,
    ucl.datijson AS jsuclcliente,
    uslf.datijson AS jsulslfornitore,
    ufl.datijson AS jsulfornitore,
    cj.datijson AS jscatalogointervento,
    cj2.datijson AS jscatalogocodicepriorita,
    im.id AS idimpianto,
    im.descrizione AS descrizioneimpianto,
    uta.datijson AS jsutenteaccettazione,
    ut.datijson AS jsutente,
    uts.datijson AS jsutentesegnalato,
    utm.datijson AS jsutentemodifica,
    bi.ref_bolla_intervento_padre AS idbollainteventopadre,
    maga.datijson AS jsmagazzino,
    bi.ref_contratto AS idcontratto,
    bf.datifotojson AS jsfoto,
    ba.datidettaglioarticolojson AS jsarticolo,
    ba2.datidettaglioarticolojson AS jsarticoloprev,
    bi.oneri_sicurezza AS onerisicurezza,
    bi.valid,
    bi.flag_notturno AS flagnotturno,
    dtore.numore,
    dttec.numtecnici,
    bi.data_termina_intervento AS dataterminaintervento,
    ntd.numnote AS numnotedip,
    ntf.numnote AS numnotefor,
    ntc.numnote AS numnotecli,
    bi.nota_contabilizzato AS notacontabilizzato,
    bi.tipo_contabilizzato AS tipocontabilizzato,
    bi.nomefile_contabilizzato AS nomefilecontabilizzato,
    bi.ticket_collegato AS ticketcollegato,
    bi.pathfile_contabilizzato AS pathfilecontabilizzato,
    bi.data_segnalazione AS datasegnalazione,
    bi.nota_segnalazione AS notasegnalazione,
    bi.path_nota_segnalazione AS pathnotasegnalazione,
    bi.nome_file_nota_segnalazione AS nomefilenotasegnalazione,
    bi.tipo_file_nota_segnalazione AS tipofilenotasegnalazione,
    bi.nota_annullamento AS notaannullamento,
    bi.flag_fatturato AS flagfatturato,
    bi.nota_sospensione AS notasospensione,
    bi.flag_visibilita_app AS flagvisibilitaapp,
    bft.nominativotecnico,
    bfc.nominativocliente,
    contr.numero_contratto AS numerocontratto,
    bi.nota_risolutivo_no AS notarisolutivono,
    bi.nota_idoneo_no AS notaidoneono,
        CASE
            WHEN COALESCE(v.id, 0::bigint) = 0 THEN 'N'::text
            ELSE 'S'::text
        END AS verbalepresente,
    bi.flag_rischio_interferenza AS flagrischiointerferenza,
    bi.flag_bloccabile AS flagbloccabile,
    utam.datijson AS jsutenteaccettazioneamm,
    utbo.datijson AS jsutenteaccettazionebo,
    utco.datijson AS jsutentemodificaco,
    utfo.datijson AS jsutentemodificafo,
    bi.nota_eliminazione AS notaeliminazione,
    bi.flag_nuova_installazione AS flagnuovainstallazione,
    bi.nota_ripristino AS notaripristino,
    cjivamat.datijson AS jsivamateriale,
    cjivaman.datijson AS jsivamanodeopera,
    bi.tipo_documento AS tipodocumento,
    bi.flag_reverse_change AS flagreversechange,
    bi.numero_documento AS numerodocumento,
    bi.data_documento AS datadocumento,
    bi.importo_nota_credito AS importonotacredito,
    bi.motivazione_nota_credito AS motivazionenotacredito,
    utrev.datijson AS jsutentemodificareverse,
    utmat.datijson AS jsutentemodificamat,
    utman.datijson AS jsutentemodificaman,
    utmatnc.datijson AS jsutentemodificanotacredito,
    bi.data_nota_credito AS datanotacredito,
    bi.ref_utente AS idutente,
    cl.id AS idcliente,
    bi.ref_catalogo_intervento AS idrefcatalogo,
    bi.ref_catalogo_codice_priorita AS idrefcatalogocodicepriorita,
    f2.id AS idreffornitore,
    bm.cnt,
    bme.cnt AS ctnm,
    uts.id AS idutentesegnalato,
    ucl.id AS idrefulcliente,
    mtp.datifonitorejson AS jsmaterialerosso,
    vtca.daticantiereallegatijson AS jstagcantiereallegati,
    culfj.datifonitorejson AS jstdatifonitorejson,
    ( SELECT count(f.id) AS count
           FROM foto f
             LEFT JOIN bolla_intervento bi2 ON f.ref_bolla_intervento = bi2.id
          WHERE (bi2.ref_bolla_intervento_padre IN ( SELECT bip.id
                   FROM bolla_intervento bip
                  WHERE bip.ref_bolla_intervento_padre = bi.id)) AND f.tag::text = 'BOLLECARICATE'::text) AS numbollacantiere,
        CASE
            WHEN bi.tipo::text = 'TICKET CANTIERE'::text THEN split_part(split_part(bi.identificativo::text, 'CA'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'TICKET ECO'::text THEN split_part(split_part(bi.identificativo::text, 'TI'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'TICKET COMMESSA'::text THEN split_part(split_part(bi.identificativo::text, 'TC'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'TICKET PROGRAMMATO'::text THEN split_part(split_part(bi.identificativo::text, 'TP'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'PREVENTIVO'::text THEN split_part(split_part(bi.identificativo::text, 'PR'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'LAVORO EXTRA'::text THEN split_part(split_part(bi.identificativo::text, 'CLX'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'LAVORO ECO'::text THEN split_part(split_part(bi.identificativo::text, 'CLE'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'LAVORO MOD INTERNA'::text THEN split_part(split_part(bi.identificativo::text, 'CLI'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'TICKET LAVORAZIONE CANTIERE'::text THEN split_part(split_part(bi.identificativo::text, 'TLC'::text, 2), '-'::text, 1)::double precision
            ELSE NULL::double precision
        END AS anno,
    split_part(bi.identificativo::text, '-'::text, 2)::double precision AS ord,
    r2.id AS idregione,
    bi.flag_materiali_extra AS materialiextra,
    bi.identificativo_padre AS identificativopadre,
    bi.totale_materiale AS totalemateriale,
    bi.totale_manodopera AS totalemanodopera,
    bi.nascondi_prezzi_manodopera AS nascondiprezzimanodopera,
    bi.nascondi_prezzi_materiale AS nascondiprezzimateriale,
    bi.flag_luci_trasformatori AS flaglucitrasformatori
   FROM bolla_intervento bi
     LEFT JOIN unita_locale_json usl ON usl.id = bi.ref_ul_sl_cliente
     LEFT JOIN unita_locale_json ucl ON ucl.id = bi.ref_ul_cliente
     LEFT JOIN unita_locale_json uslf ON uslf.id = bi.ref_ul_sl_fornitore
     LEFT JOIN unita_locale_json ufl ON ufl.id = bi.ref_ul_fornitore
     LEFT JOIN catalogo_json cj ON cj.id = bi.ref_catalogo_intervento
     LEFT JOIN catalogo_json cj2 ON cj2.id = bi.ref_catalogo_codice_priorita
     LEFT JOIN catalogo_json cjivamat ON cjivamat.id = bi.ref_catalogo_iva_materiale
     LEFT JOIN catalogo_json cjivaman ON cjivaman.id = bi.ref_catalogo_iva_manodopera
     LEFT JOIN unita_locale_json maga ON ufl.id = bi.ref_ul_magazzino
     LEFT JOIN utente_json uta ON uta.id = bi.ref_utente_accettazione
     LEFT JOIN utente_json ut ON ut.id = bi.ref_utente
     LEFT JOIN utente_json uts ON uts.id = bi.ref_utente_segnalato
     LEFT JOIN utente_json utm ON utm.id = bi.ref_utente_modifica
     LEFT JOIN bolla_foto_json bf ON bf.idbolla = bi.id
     LEFT JOIN bolla_articolo_json ba ON ba.idbolla = bi.id
     LEFT JOIN bolla_articolo_json ba2 ON ba2.idpreventivo = bi.id
     LEFT JOIN impianto im ON im.id = bi.ref_impianto
     JOIN bolla_dett_ore dtore ON dtore.id = bi.id
     JOIN bolla_dett_tecnici dttec ON dttec.id = bi.id
     JOIN bolla_num_note_dp ntd ON ntd.id = bi.id
     JOIN bolla_num_note_fornitore ntf ON ntf.id = bi.id
     JOIN bolla_num_note_cliente ntc ON ntc.id = bi.id
     LEFT JOIN bolla_firma_tecnico bft ON bft.id = bi.id
     LEFT JOIN bolla_firma_cliente bfc ON bfc.id = bi.id
     LEFT JOIN contratto contr ON contr.id = bi.ref_contratto
     LEFT JOIN verbale v ON v.ref_bolla_intervento = bi.id AND v.valid IS TRUE
     LEFT JOIN utente_json utam ON utam.id = bi.ref_autorizza_amm
     LEFT JOIN utente_json utbo ON utbo.id = bi.ref_autorizza_bo
     LEFT JOIN utente_json utco ON utco.id = bi.ref_autorizza_contabilita
     LEFT JOIN utente_json utfo ON utfo.id = bi.ref_autorizza_fornitore
     LEFT JOIN utente_json utrev ON utrev.id = bi.ref_modifica_reverse
     LEFT JOIN utente_json utman ON utman.id = bi.ref_modifica_iva_man
     LEFT JOIN utente_json utmat ON utmat.id = bi.ref_modifica_iva_mat
     LEFT JOIN utente_json utmatnc ON utmatnc.id = bi.ref_modifica_nota_credito
     LEFT JOIN bolla_materiale_tk bm ON bm.idbolla = bi.id
     LEFT JOIN bolla_materiale_extra_tk bme ON bme.idbolla = bi.id
     LEFT JOIN unita_locale ucl1 ON ucl1.id = bi.ref_ul_cliente
     LEFT JOIN cliente cl ON cl.id = ucl1.ref_cliente
     LEFT JOIN unita_locale ulf1 ON ulf1.id = bi.ref_ul_fornitore
     LEFT JOIN fornitore f2 ON f2.id = ulf1.ref_fornitore
     LEFT JOIN materiale_tk_commessa_rosso_preventivo mtp ON mtp.idbolla = bi.id
     LEFT JOIN view_tag_cantiere_allegati vtca ON vtca.idticket = bi.id
     LEFT JOIN cantiere_unita_locale_fornitore_json_gr culfj ON culfj.idbolla = bi.id
     LEFT JOIN unita_locale uclbase ON uclbase.id = bi.ref_ul_cliente
     LEFT JOIN indirizzo indi ON indi.id = uclbase.ref_indirizzo
     LEFT JOIN comune c2 ON c2.id = indi.ref_comune
     LEFT JOIN provincia p2 ON p2.c_prov_cod::text = c2.c_prov_cod::text
     LEFT JOIN regione r2 ON r2.id = p2.ref_regione
  WHERE bi.valid IS TRUE
  ORDER BY (
        CASE
            WHEN bi.tipo::text = 'TICKET CANTIERE'::text THEN split_part(split_part(bi.identificativo::text, 'CA'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'TICKET ECO'::text THEN split_part(split_part(bi.identificativo::text, 'TI'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'TICKET COMMESSA'::text THEN split_part(split_part(bi.identificativo::text, 'TC'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'TICKET PROGRAMMATO'::text THEN split_part(split_part(bi.identificativo::text, 'TP'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'PREVENTIVO'::text THEN split_part(split_part(bi.identificativo::text, 'PR'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'LAVORO EXTRA'::text THEN split_part(split_part(bi.identificativo::text, 'CLX'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'LAVORO ECO'::text THEN split_part(split_part(bi.identificativo::text, 'CLE'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'LAVORO MOD INTERNA'::text THEN split_part(split_part(bi.identificativo::text, 'CLI'::text, 2), '-'::text, 1)::double precision
            WHEN bi.tipo::text = 'TICKET LAVORAZIONE CANTIERE'::text THEN split_part(split_part(bi.identificativo::text, 'TLC'::text, 2), '-'::text, 1)::double precision
            ELSE NULL::double precision
        END) DESC, (split_part(bi.identificativo::text, '-'::text, 2)::double precision) DESC;

SELECT FN_SYS_ADDCOLUMN				('dettaglio_articolo'						,'flag_spedito'							, 'VARCHAR'		, '1',   '0',	null		,'N'				)	FROM dual;


CREATE OR REPLACE VIEW tecnoclimaschema.bolla_articolo_json
AS SELECT bifoto.idbolla,
bifoto.idpreventivo,
bifoto.datidettaglioarticolojson
FROM ( WITH testcases AS (
             SELECT da.ref_bolla_intervento_ticket AS idbolla,
                da.ref_bolla_intervento_preventivo AS idpreventivo,
                da.id AS daid,
                un.datijson AS undatijson,
                unf.datijson AS unfdatijson,
                art.datijson AS artdatijson,
                catalogo2.datijson AS catalogo2datijson,
                catalogo3.datijson AS catalogo3datijson,
                ra.id AS raid,
                ra.stato AS rastato,
                ra2.stato AS ra2stato,
                raf.id AS rafid,
                raf.stato AS rafstato,
                raf2.stato AS raf2stato,
                da.id,
                da.quantita,
                da.prezzo_aquisto,
                da.foto,
                da.ref_listino,
                da.ref_richiesta_articolo,
                da.ref_articolo,
                da.ref_bolla_intervento_preventivo,
                da.ref_bolla_intervento_ticket,
                da.valid,
                da.rec_ver,
                da.usr_ins,
                da.usr_upd,
                da.dta_ins,
                da.dta_upd,
                da.ref_catalogo_iva,
                da.descrizione,
                da.ref_ul_magazzino,
                da.flag_cliente,
                da.rientro_magazzino,
                da.rientro_furgone,
                da.rientro_ul_cliente,
                da.rientro_rottame,
                da.rientro_utente,
                da.flag_riservato_da_pagare,
                da.flag_listino,
                da.prezzo_iniziale_cliente,
                da.prezzo_finale_cliente,
                da.prezzo_iniziale_fornitore,
                da.prezzo_finale_fornitore,
                da.ref_richiesta_articolo_finale,
                da.ref_ul_magazzino_finale,
                da.flag_rettifica,
                ra2.id AS idrichiestamaster,
                da.maggiorazione_fornitore AS maggiorazionefornitore,
                da.maggiorazione_cliente AS maggiorazionecliente,
                da.qta_manutenzione,
                da.flag_manutenzione AS flagmanutenzione,
                da.flag_abilitato AS flagabilitato,
                da.flag_da_preventivo AS flagdapreventivo,
                raf.quantita AS rfquantita,
                raf.quantita_disponibile AS rfquantitadisponibile,
                raf.quantita_rientro AS rfquantitarientro,
                raf.quantita_rotta AS rfquantitarotta,
                ra.quantita AS raquantita,
                ra.quantita_disponibile AS raquantitadisponibile,
                ra.quantita_rientro AS raquantitarientro,
                ra.quantita_rotta AS raquantitarotta,
                coalesce (da.flag_spedito, 'N') as flagSpedito
               FROM dettaglio_articolo da
                 LEFT JOIN unita_locale_json un ON un.id = da.ref_ul_magazzino
                 LEFT JOIN unita_locale_json unf ON unf.id = da.ref_ul_magazzino_finale
                 LEFT JOIN articolo_json art ON art.id = da.ref_articolo
                 LEFT JOIN catalogo_json catalogo2 ON catalogo2.id = da.ref_catalogo_udm
                 LEFT JOIN catalogo_json catalogo3 ON catalogo3.id = da.ref_catalogo_iva
                 LEFT JOIN richiesta_articolo ra ON ra.id = da.ref_richiesta_articolo
                 LEFT JOIN richiesta_articolo_master ra2 ON ra2.id = ra.ref_richiesta_articolo_master
                 LEFT JOIN richiesta_articolo raf ON raf.id = da.ref_richiesta_articolo_finale
                 LEFT JOIN richiesta_articolo_master raf2 ON raf2.id = raf.ref_richiesta_articolo_master
              WHERE da.valid IS TRUE
            ), fotojson AS (
             SELECT testcases.idbolla,
                testcases.idpreventivo,
                json_agg(json_build_object('id', testcases.daid, 'quantita', testcases.quantita, 'prezzoAquisto', testcases.prezzo_aquisto, 'prezzoInizialeCliente', testcases.prezzo_iniziale_cliente, 'prezzoFinaleCliente', testcases.prezzo_finale_cliente, 'prezzoInizialeFornitore', testcases.prezzo_iniziale_fornitore, 'prezzoFinaleFornitore', testcases.prezzo_finale_fornitore, 'foto', testcases.foto, 'descrizione', testcases.descrizione, 'flagCliente', testcases.flag_cliente, 'flagRettifica', testcases.flag_rettifica, 'ulMagazzino', testcases.undatijson, 'ulMagazzinoFinale', testcases.unfdatijson, 'articolo', testcases.artdatijson, 'bollaInterventoPreventivo', json_build_object('id', testcases.idpreventivo), 'bollaInterventoTicket', json_build_object('id', testcases.idbolla), 'catalogoUdm', testcases.catalogo2datijson, 'catalogoIva', testcases.catalogo3datijson, 'richiestaArticolo',
                    CASE
                        WHEN testcases.raid IS NOT NULL THEN json_build_object('id', testcases.raid, 'stato', testcases.rastato, 'richiestaArticoloMaster', json_build_object('id', testcases.idrichiestamaster, 'stato', testcases.ra2stato))
                        ELSE NULL::json
                    END, 'richiestaArticoloFinale',
                    CASE
                        WHEN testcases.rafid IS NOT NULL THEN json_build_object('id', testcases.rafid, 'stato', testcases.rafstato, 'quantita', testcases.rfquantita, 'quantitaDisponibile', testcases.rfquantitadisponibile, 'quantitaRientro', testcases.rfquantitarientro, 'quantitaRotta', testcases.rfquantitarotta, 'richiestaArticoloMaster', json_build_object('id', testcases.rafid, 'stato', testcases.raf2stato))
                        ELSE NULL::json
                    END, 'maggiorazioneFornitore', testcases.maggiorazionefornitore, 'maggiorazioneCliente', testcases.maggiorazionecliente, 'qta_manutenzione', testcases.qta_manutenzione, 'flagManutenzione', testcases.flagmanutenzione, 'flagAbilitato', testcases.flagabilitato, 'flagDaPreventivo', testcases.flagdapreventivo, 'flagSpedito', testcases.flagSpedito )) AS datidettaglioarticolojson
               FROM testcases
              GROUP BY testcases.idbolla, testcases.idpreventivo
            )
     SELECT fotojson.idbolla,
        fotojson.idpreventivo,
        fotojson.datidettaglioarticolojson
       FROM fotojson) bifoto;


CREATE OR REPLACE VIEW tecnoclimaschema.view_schede_attive
as select st.id as id ,
case
when st.ultimo_rilevamento is null or
((extract(epoch from st.ultimo_rilevamento) * 1000) + 3600000) < (extract(epoch from now()) * 1000) then 'Off Line'
else 'On Line'
end as stato
from scheda_tecnica st where valid is true



CREATE OR REPLACE VIEW tecnoclimaschema.indirizzo_json
AS SELECT i.id,
json_build_object('id', i.id, 'cap', i.cap, 'indirizzo', i.indirizzo, 'civico', i.civico, 'piano', i.piano, 'scala', i.scala, 'interno', i.interno, 'comune', cj.datijson, 'esterno', i.esterno, 'comuneDesc', i.comune_desc) AS datijson
FROM indirizzo i
left JOIN comune_json cj ON cj.id = i.ref_comune
where i."valid" is true


SELECT FN_SYS_ADDCOLUMN			('scheda_tecnica_allarme'			,'data_ult_accensione'				, 'DATE'		, null,	   null, null		,null				)	FROM dual;
SELECT FN_SYS_ADDCOLUMN			('scheda_tecnica_allarme'			,'data_ult_spegnimento'				, 'DATE'		, null,	   null, null		,null				)	FROM dual;
SELECT FN_SYS_ADDCOLUMN			('scheda_tecnica_allarme'			,'ult_stato_macchina'				  , 'VARCHAR'		, '50',   '0',	null		,null				)	FROM dual;

SELECT FN_SYS_ADDCOLUMN			('scheda_tecnica'			,'data_ult_accensione'				, 'DATE'		, null,	   null, null		,null				)	FROM dual;
SELECT FN_SYS_ADDCOLUMN			('scheda_tecnica'			,'data_ult_spegnimento'				, 'DATE'		, null,	   null, null		,null				)	FROM dual;

CREATE OR REPLACE VIEW tecnoclimaschema.view_contratto_manutenzione_canoni
AS SELECT contr.id,
    contr.data_inizio,
    contr.data_fine,
    contr.frequenza,
    cul.canone,
    cul.ref_fornitore,
    cul.ref_unita_loc,
    bu.cnt AS numerotk,
        CASE
            WHEN contr.frequenza::text = 'QUOTID'::text THEN cul.canone / COALESCE(bu.cnt, 1::bigint)::numeric
            ELSE cul.canone
        END AS costo,
    f2.id as idfornitore
   FROM contratto contr
     JOIN contratto_unita_loc cul ON cul.ref_contratto = contr.id

     JOIN view_contratto_unita_bolla bu ON bu.idcontratto = contr.id AND cul.ref_unita_loc = bu.idunita
     left join cliente_fornitore cf on cf.id = cul.ref_fornitore
     left join unita_locale ul on ul.id = cf.ref_unita_locale_fornitore
     left join fornitore f2 on f2.id = ul.ref_fornitore
  WHERE contr.valid IS TRUE;


   CREATE OR REPLACE VIEW tecnoclimaschema.view_schede_attive
  AS SELECT st.id,
          CASE
              WHEN st.ultimo_rilevamento IS NULL OR
              (date_part('epoch'::text, st.ultimo_rilevamento) * 1000::double precision + 1800000::double precision) < (date_part('epoch'::text, now()) * 1000::double precision) THEN 'Off Line'::text
              ELSE 'On Line'::text
          END AS stato,
            st.ultimo_rilevamento
     FROM scheda_tecnica st
    WHERE st.valid IS TRUE;
    
SELECT FN_SYS_CREATETABLE			('info_ticket_telegestione'		, 'id'																					)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('info_ticket_telegestione' 	, 'ref_bolla'			    , 'LONG'		,  '5'		, '0'		, null	, null		)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('info_ticket_telegestione' 	, 'ref_scheda_tecnica'		, 'LONG'		,  '5'	    , '0'		, null	, null		)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('info_ticket_telegestione' 	, 'ref_catalogo'		    , 'LONG'		,  '5'	    , '0'		, null	, null		)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('info_ticket_telegestione' 	, 'prezzo'					, 'NUMBER'		,   '10'	, '2'		, null	, null		)	FROM dual;
SELECT FN_SYS_ADD_SEQ_AUDIT_COLUMNS	('info_ticket_telegestione'		, 'id'																					)	FROM dual;

SELECT FN_SYS_ADDCOLUMN				('scheda_tecnica' 	, 'codice'			    , 'LONG'		,  '5'		, '0'		, null	, null		)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('scheda_tecnica' 	, 'ref_catalogo'	    , 'LONG'		,  '5'		, '0'		, null	, null		)	FROM dual;
SELECT FN_SYS_ADDCOLUMN				('scheda_tecnica' 	, 'ref_fornitore'	    , 'LONG'		,  '5'		, '0'		, null	, null		)	FROM dual;

    
CREATE OR REPLACE VIEW tecnoclimaschema.view_schede_attive
 AS
  SELECT st.id,

         CASE
             WHEN st.ultimo_rilevamento IS NULL OR
             date_part('epoch'::text,	now() - st.ultimo_rilevamento)::numeric > 30  THEN 'Off Line'::text
             ELSE 'On Line'::text
         END AS stato,
     st.ultimo_rilevamento
    FROM scheda_tecnica st
   WHERE st.valid IS TRUE;



CREATE OR REPLACE VIEW tecnoclimaschema.view_verfica_qta_materiale_prev_to_utilizzato
as
select da.quantita as qtaprev, da1.quantita as qtautil, a2.descrizione as articolo, mpt.id_ticket as idbolla,
case
when da.quantita < da1.quantita then 'ERRORE'
else 'OK'
end	 as stato
from materiale_preventivo_ticket mpt
inner join dettaglio_articolo da on da.id = mpt.ref_dettaglio_articolo_preventivo
inner join dettaglio_articolo da1 on da1.id = mpt.id_dettaglio_articolo_ticket
inner join articolo a2 on a2.id = da1.ref_articolo;