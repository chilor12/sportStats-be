--Remove index named INDEX_NAME
CREATE OR REPLACE FUNCTION FN_SYS_REMOVEINDEX( INDEX_NAME TEXT ) RETURNS void AS $$
BEGIN
	IF EXISTS (
		SELECT 1
		FROM   pg_class c
		JOIN pg_namespace ns ON c.relnamespace = ns.oid
        WHERE ns.nspname = 'sportStatsSchema'
	and  c.relname = INDEX_NAME
    ) THEN

		EXECUTE 'DROP  INDEX ' || INDEX_NAME;
		else
		RAISE NOTICE 'FN_SYS_REMOVEINDEX: INDEX % not found', INDEX_NAME;
	END IF;

END;
$$ LANGUAGE plpgsql ;

-- ADD CONSTRAINT
-- Add a conditional unique constraint to table TABLE_NAME with name CONSTRAINT_NAME on COLUMN_NAMES with specified CONDITION
CREATE OR REPLACE FUNCTION FN_SYS_ADDCONDUNIQUECONSTRAINT(TABLE_NAME TEXT, CONSTRAINT_NAME TEXT, COLUMN_NAMES TEXT, CONDITION TEXT) RETURNS void AS $$
BEGIN
	-- check table existence
	IF NOT EXISTS (
		SELECT 1
		from
		pg_class t,
		pg_class i,
		pg_index ix,
		pg_attribute a,
		pg_namespace ns
		where
		t.relnamespace = ns.oid
		and ns.nspname = 'sportStatsSchema'
		and t.oid = ix.indrelid
		and i.oid = ix.indexrelid
		and a.attrelid = t.oid
		and a.attnum = ANY(ix.indkey)
		-- and ix.indisunique = true
		and UPPER(i.relname)=UPPER(CONSTRAINT_NAME)
		and UPPER(a.attname) =UPPER(COLUMN_NAMES)
	and UPPER(t.relname) =UPPER(TABLE_NAME)
    ) THEN

		EXECUTE 'CREATE UNIQUE INDEX '|| CONSTRAINT_NAME ||' ON '|| TABLE_NAME || ' ('||COLUMN_NAMES||') WHERE ('||CONDITION||')';
		else
   		RAISE NOTICE 'FN_SYS_ADDCONDUNIQUECONSTRAINT: CONSTRAINT_NAME % on table % already exists',CONSTRAINT_NAME,TABLE_NAME;
	END IF;
END;
$$ LANGUAGE plpgsql ;


-- ADD COLUMN
	-- Add a new column COLUMN_NAME in table TABLE_NAME
	-- ALLOWED TYPE AND MAPPED TYPE:
	-- VARCHAR -> VARCHAR || Uses PREC to set numeber of characters.
	-- INT -> INTEGER
	-- LONG -> BIGINT
	-- NUMBER -> NUMERIC || Uses PREC to set numeber of digits before comma, uses SCALE to set number of decimal digits)
	-- BOOLEAN -> BOOLEAN ||
	-- DATE -> TIMESTRAMP without time zone||
	-- BLOB -> BYTEA ||
	-- CLOB -> text
	-- When not used, PREC and SCALE must be set to null.
	-- If specified, the default value is set to DEFAULT_VALUE
-- Column can be declared NOT NULL by using 'NOT NULL'
CREATE OR REPLACE FUNCTION FN_SYS_ADDCOLUMN( TABLE_NAME TEXT, COLUMN_NAME TEXT, COLUMN_TYPE TEXT, PREC TEXT, SCALE TEXT, ISNULLABLE TEXT, DEFAULT_VALUE TEXT  ) RETURNS void AS $$
DECLARE
--ENTRY_TABLE_NAME TEXT;
--ENTRY_COLUMN_NAME TEXT;
sqltype TEXT;
sqldim TEXT;
sqlNull TEXT;
sqlDefault TEXT;
query TEXT;
BEGIN
	--ENTRY_TABLE_NAME=TABLE_NAME;
	--ENTRY_COLUMN_NAME=COLUMN_NAME;

	CASE upper(COLUMN_TYPE)
		WHEN 'VARCHAR' THEN
			sqltype='varchar';
		sqldim='('||PREC||')';
		WHEN 'NUMBER' THEN
			sqltype='numeric';
			IF SCALE IS NULL
			THEN sqldim='('||PREC||')';
				ELSE sqldim='('||PREC||', '||SCALE||')';
			END IF;
			WHEN 'INT' THEN
				sqltype='int';
			sqldim='';
			WHEN 'LONG' THEN
				sqltype='bigint';
			sqldim='';
			WHEN 'BOOLEAN' THEN
				sqltype='boolean';
			sqldim='';
			WHEN 'DATE' THEN
				sqltype='timestamp without time zone';
			sqldim = '';
			WHEN 'BLOB' THEN
				sqltype='bytea';
			sqldim = '';
			WHEN 'JSON' THEN
				sqltype='jsonb';
				sqldim = '';
			WHEN 'CLOB' THEN
				sqltype='text';
				sqldim = '';
				ELSE
				RAISE EXCEPTION 'Unsupported type --> %', COLUMN_TYPE;
			END CASE;

			IF DEFAULT_VALUE IS NULL
			THEN sqlDefault='';
				ELSE sqlDefault= ' DEFAULT '||quote_literal(DEFAULT_VALUE);
			END IF;

			CASE
				WHEN ISNULLABLE IS NULL THEN
				sqlNull='';
				WHEN upper(ISNULLABLE)='NOT NULL' or upper(ISNULLABLE)='NULL' THEN
				sqlNull=' '||ISNULLABLE;
				ELSE
				RAISE EXCEPTION 'ISNULLABLE parameter can either be null, "NULL", "NOT NULL". Unsupported keyword.  --> %', ISNULLABLE;
			END CASE;

			-- check column existence in table
			IF NOT EXISTS (
				SELECT 1
				from
				pg_class t,
				pg_attribute a,
				pg_namespace ns
				where
				t.relnamespace = ns.oid
				and ns.nspname = 'sportStatsSchema'
				and a.attrelid = t.oid
				and UPPER(a.attname) = UPPER(COLUMN_NAME)
			and UPPER(t.relname) = UPPER(TABLE_NAME)
			) THEN
				query = 'ALTER TABLE ' ||TABLE_NAME || ' ADD COLUMN ' || COLUMN_NAME || ' ' || sqltype || sqldim || sqlNull || sqlDefault;
				--RAISE NOTICE 'Query = %',query;
				EXECUTE query;
				ELSE
				RAISE NOTICE 'FN_SYS_ADDCOLUMN: COLUMN % on table % already exists',COLUMN_NAME,TABLE_NAME;
			END IF;

END;
$$ LANGUAGE plpgsql ;


--FOREIGN KEY

-- ADD FOREIGN KEY
	-- Add a foreign key to table TABLE_NAME with name CONSTRAINT_NAME creating a field named RELATIONSHIP_NAME.
	-- Key references column REFERENCED_COLUMN_NAME in table REFERENCED_TABLE_NAME.
-- If REFERENCED_COLUMN_NAME is set to null, then the default column 'ID' is used.
CREATE OR REPLACE FUNCTION FN_SYS_ADDFOREIGNKEY(TABLE_NAME TEXT, CONSTRAINT_NAME TEXT, RELATIONSHIP_NAME TEXT, REFERENCED_TABLE_NAME TEXT, REFERENCED_COLUMN_NAME TEXT) RETURNS void AS $$
DECLARE
refColumn TEXT;

BEGIN

	IF REFERENCED_COLUMN_NAME IS NULL
	THEN refColumn = 'id';
		ELSE refColumn = REFERENCED_COLUMN_NAME;
	END IF;
	-- check constraints existence in table
	IF NOT EXISTS (
		SELECT 1
		from
		pg_class t,
		pg_constraint c,
		pg_namespace ns
		where 1=1
		and c.conrelid = t.oid
		and t.relnamespace = ns.oid
		and ns.nspname = 'sportStatsSchema'
		and UPPER(c.conname)= UPPER(CONSTRAINT_NAME)
		and c.conrelid = t.oid
		and t.relnamespace = ns.oid
	and UPPER(t.relname) = UPPER(TABLE_NAME)
    ) THEN

		EXECUTE 'ALTER TABLE '|| TABLE_NAME || ' ADD CONSTRAINT '|| CONSTRAINT_NAME ||' FOREIGN KEY ('||
		RELATIONSHIP_NAME||') REFERENCES '||REFERENCED_TABLE_NAME||' ('||refColumn||')';

		ELSE
		RAISE NOTICE  'FN_SYS_ADDFOREIGNKEY: CONSTRAINT % on table % already exists',CONSTRAINT_NAME,TABLE_NAME;
	END IF;

END;
$$ LANGUAGE plpgsql ;

--ADD INDEX
	--Add index named INDEX_NAME to table TABLE_NAME.
	--Index is based on columns in COLUMNS_NAME. Columns must be separated by comma: 'column1, column2')
--Parameter UNIQUE is used to add a UNIQUE index, can either be null or 'UNIQUE'
CREATE OR REPLACE FUNCTION FN_SYS_ADDINDEX( INDEX_NAME TEXT, TABLE_NAME TEXT, COLUMNS_NAME TEXT, ISUNIQUE TEXT ) RETURNS void AS $$
DECLARE
uniquekeyword TEXT;
BEGIN
	CASE
		WHEN ISUNIQUE IS NULL THEN
		uniquekeyword='';
		WHEN upper(ISUNIQUE)='UNIQUE' THEN
			uniquekeyword='UNIQUE';
			ELSE
			RAISE EXCEPTION 'ISUNIQUE parameter can be set to null or UNIQUE. Invalid value --> %', ISUNIQUE;
		END CASE;
		IF NOT EXISTS (
			SELECT 1
			from
			pg_class t,
			pg_class i,
			pg_index ix,
			pg_attribute a,
			pg_namespace ns
			where
			t.relnamespace = ns.oid
			and ns.nspname = 'sportStatsSchema'
			and t.oid = ix.indrelid
			and i.oid = ix.indexrelid
			and a.attrelid = t.oid
			and a.attnum = ANY(ix.indkey)
			-- and ix.indisunique = true
			and i.relname=UPPER(INDEX_NAME)
			and a.attname =UPPER(COLUMNS_NAME)
		and t.relname =UPPER(TABLE_NAME)
		) THEN
			EXECUTE 'CREATE '||uniquekeyword||' INDEX ' || INDEX_NAME || ' ON ' || TABLE_NAME || '(' || COLUMNS_NAME || ')';
			ELSE
			RAISE NOTICE 'FN_SYS_ADDINDEX: INDEX % on table % already exists',INDEX_NAME,TABLE_NAME;
		END IF;
END;
$$ LANGUAGE plpgsql ;

-- ADD PRIMARY KEY
-- Add a primary key to table TABLE_NAME with name CONSTRAINT_NAME on COLUMN_NAMES
CREATE OR REPLACE FUNCTION FN_SYS_ADDPRIMARYKEY(TABLE_NAME TEXT, CONSTRAINT_NAME TEXT, COLUMN_NAMES TEXT) RETURNS void AS $$
BEGIN
	-- check constraints pk existence in table
	IF NOT EXISTS (
		--SELECT 1
			--FROM
			--    information_schema.table_constraints AS tc
			--    JOIN information_schema.key_column_usage AS kcu
			--      ON tc.constraint_name = kcu.constraint_name
			--WHERE UPPER(tc.table_schema) =UPPER('sportStatsSchema') and UPPER( and tc.constraint_type = 'PRIMARY KEY' and UPPER(tc.constraint_name) = UPPER(ENTRY_CONSTRAINT_NAME)
		--AND UPPER(tc.table_name)=UPPER(ENTRY_TABLE_NAME) and UPPER(kcu.column_name)=UPPER(ENTRY_COLUMN_NAMES)
		SELECT 1
		from
		pg_class t,
		pg_class i,
		pg_index ix,
		pg_attribute a,
		pg_namespace ns
		where
		t.relnamespace = ns.oid
		and ns.nspname = 'sportStatsSchema'
		and t.oid = ix.indrelid
		and i.oid = ix.indexrelid
		and a.attrelid = t.oid
		and a.attnum = ANY(ix.indkey)
		-- and ix.indisunique = true
		and i.relname=UPPER(CONSTRAINT_NAME)
		and a.attname =UPPER(COLUMN_NAMES)
	and t.relname =UPPER(TABLE_NAME)
	) THEN
		EXECUTE 'ALTER TABLE '|| TABLE_NAME || ' ADD CONSTRAINT '|| CONSTRAINT_NAME ||' PRIMARY KEY ('||COLUMN_NAMES||')';
		ELSE
		RAISE NOTICE 'FN_SYS_ADDPRIMARYKEY: CONSTRAINT % on table % already exists',CONSTRAINT_NAME,TABLE_NAME;
	END IF;
END;
$$ LANGUAGE plpgsql ;



-- ADD CONSTRAINT
-- Add a unique constraint to table TABLE_NAME with name CONSTRAINT_NAME on COLUMN_NAMES
CREATE OR REPLACE FUNCTION FN_SYS_ADDUNIQUECONSTRAINT(TABLE_NAME TEXT, CONSTRAINT_NAME TEXT, COLUMN_NAMES TEXT) RETURNS void AS $$
BEGIN
	IF NOT EXISTS (
		SELECT 1
		from
		pg_class t,
		pg_constraint c,
		pg_namespace ns
		where 1=1
		and c.conrelid = t.oid
		and t.relnamespace = ns.oid
		and ns.nspname = 'sportStatsSchema'
		and UPPER(c.conname)= UPPER(CONSTRAINT_NAME)
		and c.conrelid = t.oid
		and t.relnamespace = ns.oid
		and UPPER(t.relname) = UPPER(TABLE_NAME)
		) THEN
			EXECUTE 'ALTER TABLE '|| TABLE_NAME || ' ADD CONSTRAINT '|| CONSTRAINT_NAME ||' UNIQUE ('||COLUMN_NAMES||')';
			ELSE
			RAISE NOTICE 'FN_SYS_ADDUNIQUECONSTRAINT: CONSTRAINT % on table % already exists',CONSTRAINT_NAME,TABLE_NAME;
		END IF;
END;
$$ LANGUAGE plpgsql ;

-- REMOVE FOREIGN KEY
-- Removes key with name CONSTRAINT_NAME from table TABLE_NAME
CREATE OR REPLACE FUNCTION FN_SYS_REMOVEFOREIGNKEY(TABLE_NAME TEXT, CONSTRAINT_NAME TEXT) RETURNS void AS $$
--DECLARE
	--ENTRY_TABLE_NAME TEXT;
--ENTRY_CONSTRAINT_NAME TEXT;
BEGIN
	--ENTRY_TABLE_NAME=TABLE_NAME;
	--ENTRY_CONSTRAINT_NAME=CONSTRAINT_NAME;

	-- ADD CONSTRAINT
	-- check if a fk constraint to table TABLE_NAME with name CONSTRAINT_NAME
	IF EXISTS (
		SELECT 1
		from
		pg_class t,
		pg_constraint c,
		pg_namespace ns
		where 1=1
		and c.conrelid = t.oid
		and t.relnamespace = ns.oid
		and ns.nspname = 'sportStatsSchema'
		and UPPER(t.relname) =UPPER(TABLE_NAME)
		and UPPER(c.conname)=UPPER(CONSTRAINT_NAME)
		--SELECT 1
			--FROM
			--    information_schema.table_constraints AS tc
			--    JOIN information_schema.key_column_usage AS kcu
			--      ON tc.constraint_name = kcu.constraint_name
			--WHERE UPPER(tc.table_schema) =UPPER('sportStatsSchema') and tc.constraint_type = 'FOREIGN KEY' and UPPER(tc.constraint_name) = UPPER(ENTRY_CONSTRAINT_NAME)
		--AND UPPER(tc.table_name)=UPPER(ENTRY_TABLE_NAME)
		) THEN
			EXECUTE 'ALTER TABLE '|| TABLE_NAME || ' DROP CONSTRAINT '|| CONSTRAINT_NAME;
			ELSE
			RAISE NOTICE 'FN_SYS_REMOVEFOREIGNKEY: CONSTRAINT % on table % already exists',CONSTRAINT_NAME,TABLE_NAME;
		END IF;
END;
$$ LANGUAGE plpgsql ;

-- REMOVE UNIQUE INDEX --
-- Remove index named INDEX_NAME on table TABLE_NAME
CREATE OR REPLACE FUNCTION FN_SYS_REMOVEUNIQUEINDEX( TABLE_NAME TEXT, INDEX_NAME TEXT ) RETURNS void AS $$
--DECLARE
	--ENTRY_TABLE_NAME TEXT;
--ENTRY_INDEX_NAME TEXT;
BEGIN
	--ENTRY_TABLE_NAME=TABLE_NAME;
		--ENTRY_INDEX_NAME=INDEX_NAME;
		-- ADD CONSTRAINT
	-- check if a fk constraint to table TABLE_NAME with name CONSTRAINT_NAME
	IF EXISTS (
		SELECT 1
		from
		pg_class t,
		pg_constraint c,
		pg_namespace ns
		where 1=1
		and c.conrelid = t.oid
		and t.relnamespace = ns.oid
		and ns.nspname = 'sportStatsSchema'
		and UPPER(c.conname)= UPPER(INDEX_NAME)
		and UPPER(t.relname) = UPPER(TABLE_NAME)
		--    SELECT 1
			--    from
			--      pg_class t,
			--	  pg_constraint c,
			--      pg_namespace ns
			--    where 1=1
			--	  and c.conrelid = t.oid
			--      and t.relnamespace = ns.oid
			--      and ns.nspname = 'sportStatsSchema'
			--      and UPPER(t.relname) =UPPER(TABLE_NAME)
		--      and UPPER(c.conname)=UPPER(INDEX_NAME)
		) THEN
			EXECUTE 'ALTER TABLE ' || TABLE_NAME || ' DROP CONSTRAINT ' || INDEX_NAME || '';
			ELSE
			RAISE NOTICE 'FN_SYS_REMOVEUNIQUEINDEX: CONSTRAINT % on table % already exists',INDEX_NAME,TABLE_NAME;
		END IF;
END;
$$ LANGUAGE plpgsql ;

--RENAME COLUMN
--Rename column from OLD_COLUMN_NAME to NEW_COLUMN_NAME
CREATE OR REPLACE FUNCTION FN_SYS_RENAMECOLUMN(TABLE_NAME TEXT, OLD_COLUMN_NAME TEXT, NEW_COLUMN_NAME TEXT) RETURNS void AS $$
BEGIN
	-- check column existence in table
	IF EXISTS (
		SELECT 1
		from
    	pg_class t,
      	pg_attribute a,
      	pg_namespace ns
		where
        t.relnamespace = ns.oid
        and ns.nspname = 'sportStatsSchema'
        and a.attrelid = t.oid
   		and UPPER(a.attname) = UPPER(OLD_COLUMN_NAME)
	and UPPER(t.relname) = UPPER(TABLE_NAME)
    ) THEN
		EXECUTE 'ALTER TABLE ' || TABLE_NAME || ' RENAME COLUMN ' || OLD_COLUMN_NAME || ' TO ' || NEW_COLUMN_NAME;
		ELSE
		RAISE NOTICE 'FN_SYS_RENAMECOLUMN: COLUMN % on table % not found',OLD_COLUMN_NAME,TABLE_NAME;
	END IF;
END;
$$ LANGUAGE plpgsql ;

-- REMOVE COLUMN
-- Remove column COLUMN_NAME from table TABLE_NAME
CREATE OR REPLACE FUNCTION FN_SYS_REMOVECOLUMN( TABLE_NAME TEXT, COLUMN_NAME TEXT) RETURNS void AS $$
BEGIN
	IF EXISTS (
		SELECT 1
		from
    	pg_class t,
      	pg_attribute a,
      	pg_namespace ns
		where
        t.relnamespace = ns.oid
        and ns.nspname = 'sportStatsSchema'
        and a.attrelid = t.oid
   		and UPPER(a.attname) = UPPER(COLUMN_NAME)
	and UPPER(t.relname) = UPPER(TABLE_NAME)
    ) THEN
		EXECUTE 'ALTER TABLE ' || TABLE_NAME || ' DROP COLUMN ' || COLUMN_NAME;
		ELSE
		RAISE NOTICE 'FN_SYS_REMOVECOLUMN: COLUMN % on table % not found',COLUMN_NAME,TABLE_NAME;
	END IF;
END;
$$ LANGUAGE plpgsql ;

CREATE OR REPLACE FUNCTION FN_SYS_MODIFYCOLUMN( TABLE_NAME TEXT, COLUMN_NAME TEXT, COLUMN_TYPE TEXT, PREC TEXT, SCALE TEXT, ISNULLABLE TEXT, DEFAULT_VALUE TEXT ) RETURNS void AS $$
DECLARE
sqltype TEXT;
sqldim TEXT;
sqlNull TEXT;
sqlDefault TEXT;
query TEXT;
query_null TEXT;
query_default TEXT;
BEGIN
	IF COLUMN_TYPE IS NOT NULL THEN
		CASE upper(COLUMN_TYPE)
			WHEN 'VARCHAR' THEN
				sqltype='varchar';
			sqldim='('||PREC||')';
			WHEN 'NUMBER' THEN
				sqltype='numeric';
				IF SCALE IS NULL
				THEN sqldim='('||PREC||')';
					ELSE sqldim='('||PREC||', '||SCALE||')';
				END IF;
				WHEN 'INT' THEN
					sqltype='int';
				sqldim='';
				WHEN 'LONG' THEN
					sqltype='bigint';
				sqldim='';
				WHEN 'BOOLEAN' THEN
					sqltype='boolean';
				sqldim='';
				WHEN 'DATE' THEN
					sqltype='timestamp without time zone';
				sqldim = '';
				WHEN 'BLOB' THEN
					sqltype='bytea';
				sqldim = '';
				WHEN 'JSON' THEN
				sqltype='jsonb';
				sqldim = '';
				WHEN 'CLOB' THEN
					sqltype='text';
					sqldim = '';
					ELSE
					RAISE EXCEPTION 'Unsupported type --> %', COLUMN_TYPE;
				END CASE;
				query = 'ALTER TABLE ' || TABLE_NAME || ' ALTER COLUMN ' || COLUMN_NAME || ' TYPE ' || sqltype ||  sqldim;
				IF EXISTS (
					SELECT 1
					from
					pg_class t,
					pg_attribute a,
					pg_namespace ns
					where
					t.relnamespace = ns.oid
					and ns.nspname = 'sportStatsSchema'
					and a.attrelid = t.oid
					and UPPER(a.attname) = UPPER(COLUMN_NAME)
				and UPPER(t.relname) = UPPER(TABLE_NAME)
				) THEN
					EXECUTE query;
					ELSE
					RAISE NOTICE  'FN_SYS_MODIFYCOLUMN 1: COLUMN % on table % not found',COLUMN_NAME,TABLE_NAME;
				END IF;
	END IF;

	IF DEFAULT_VALUE IS NULL
	THEN sqlDefault='';
		ELSE sqlDefault= ' SET DEFAULT '||quote_literal(DEFAULT_VALUE);
		query_default= 'ALTER TABLE ' || TABLE_NAME || ' ALTER COLUMN ' || COLUMN_NAME || sqlDefault;
		IF EXISTS (
			SELECT 1
			from
			pg_class t,
			pg_attribute a,
			pg_namespace ns
			where
			t.relnamespace = ns.oid
			and ns.nspname = 'sportStatsSchema'
			and a.attrelid = t.oid
			and UPPER(a.attname) = UPPER(COLUMN_NAME)
		and UPPER(t.relname) = UPPER(TABLE_NAME)
		) THEN
			EXECUTE query_default;
			ELSE
			RAISE NOTICE  'FN_SYS_MODIFYCOLUMN 2: COLUMN % on table % not found',COLUMN_NAME,TABLE_NAME;
		END IF;
	END IF;

	CASE
		WHEN ISNULLABLE IS NULL THEN
		sqlNull='';
		WHEN upper(ISNULLABLE)='NOT NULL' or upper(ISNULLABLE)='NULL' THEN
		IF upper(ISNULLABLE)='NOT NULL' THEN
			sqlNull = ' SET NOT NULL';
			ELSE
			sqlNull = ' DROP NOT NULL';
		END IF;
		query_null = 'ALTER TABLE ' || TABLE_NAME || ' ALTER COLUMN ' || COLUMN_NAME || sqlNull;
		IF EXISTS (
			SELECT 1
			from
			pg_class t,
			pg_attribute a,
			pg_namespace ns
			where
			t.relnamespace = ns.oid
			and ns.nspname = 'sportStatsSchema'
			and a.attrelid = t.oid
			and UPPER(a.attname) = UPPER(COLUMN_NAME)
		and UPPER(t.relname) = UPPER(TABLE_NAME)
		) THEN
			EXECUTE query_null;
			ELSE
			RAISE NOTICE  'FN_SYS_MODIFYCOLUMN 3: COLUMN % on table % not found',COLUMN_NAME,TABLE_NAME;
		END IF;
		ELSE
		RAISE EXCEPTION 'ISNULLABLE parameter can either be null, "NULL", "NOT NULL". Unsupported keyword.  --> %', ISNULLABLE;
	END CASE;
END;
$$ LANGUAGE plpgsql ;

--CREATE SEQUENCE
CREATE OR REPLACE FUNCTION FN_SYS_CREATESEQUENCE(SEQUENCE_NAME TEXT, START_NUMBER NUMERIC) RETURNS void AS $$

DECLARE
start_no NUMERIC;
BEGIN

	IF START_NUMBER IS NULL
	THEN start_no = 1;
		ELSE start_no = START_NUMBER;
	END IF;
	-- check sequence existence
	IF NOT EXISTS (
		SELECT 1
		FROM pg_class c, pg_namespace ns
		WHERE c.relkind = 'S'
		and c.relnamespace = ns.oid
		and ns.nspname = 'sportStatsSchema'
	and UPPER(c.relname) = UPPER(SEQUENCE_NAME)
	) THEN
		EXECUTE 'CREATE SEQUENCE ' || SEQUENCE_NAME || ' START WITH '|| start_no ||' INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1';
		ELSE
		RAISE NOTICE  'FN_SYS_CREATESEQUENCE: SEQUENCE % already exists',SEQUENCE_NAME;
	END IF;
END;
$$ LANGUAGE plpgsql ;

--DROP SEQUENCE
CREATE OR REPLACE FUNCTION FN_SYS_DROPSEQUENCE(SEQUENCE_NAME TEXT) RETURNS void AS $$
BEGIN
	-- check sequence existence
	IF EXISTS (
		SELECT 1
		FROM pg_class c, pg_namespace ns
		WHERE c.relkind = 'S'
		and c.relnamespace = ns.oid
		and ns.nspname = 'sportStatsSchema'
	and UPPER(c.relname) = UPPER(SEQUENCE_NAME)
	) THEN
		EXECUTE 'DROP SEQUENCE ' || SEQUENCE_NAME;
		ELSE
		RAISE NOTICE  'FN_SYS_DROPSEQUENCE: SEQUENCE % not found',SEQUENCE_NAME;
	END IF;
END;
$$ LANGUAGE plpgsql ;

--RENAME SEQUENCE
CREATE OR REPLACE FUNCTION FN_SYS_RENAMESEQUENCE(OLD_SEQUENCE_NAME TEXT, NEW_SEQUENCE_NAME TEXT) RETURNS void AS $$
BEGIN
	-- check sequence existence
	IF EXISTS (
		SELECT 1
		FROM pg_class c, pg_namespace ns
		WHERE c.relkind = 'S'
		and c.relnamespace = ns.oid
		and ns.nspname = 'sportStatsSchema'
	and UPPER(c.relname) = UPPER(OLD_SEQUENCE_NAME)
	) THEN
		EXECUTE 'ALTER SEQUENCE ' || OLD_SEQUENCE_NAME || ' RENAME TO ' || NEW_SEQUENCE_NAME;
		ELSE
		RAISE NOTICE 'FN_SYS_RENAMESEQUENCE: SEQUENCE % not found', OLD_SEQUENCE_NAME;
	END IF;
END;
$$ LANGUAGE plpgsql ;

-- Nextvalue function
create or replace FUNCTION FN_SYS_SEQNEXTVAL(SEQNAME TEXT) RETURNS BIGINT AS $$
DECLARE
valNum bigint;
BEGIN
	-- check sequence existence
	IF EXISTS (
		SELECT 1
		FROM pg_class c, pg_namespace ns
		WHERE c.relkind = 'S'
		and c.relnamespace = ns.oid
		and ns.nspname = 'sportStatsSchema'
	and UPPER(c.relname) = UPPER(SEQNAME)
	) THEN
		valNum := 0;
		execute 'select (''' || SEQNAME || ''').nextval as val from dual' into valNum;
		RETURN valNum;
		ELSE
		RAISE EXCEPTION 'FN_SYS_SEQNEXTVAL: SEQUENCE % not found', SEQNAME;
	END IF;
END;
$$ LANGUAGE plpgsql ;

CREATE OR REPLACE FUNCTION FN_SYS_RENAMETABLE(OLD_TABLE_NAME TEXT, NEW_TABLE_NAME TEXT) RETURNS void AS $$
BEGIN
	IF EXISTS (
		SELECT 1
		from
    	pg_class t,
      	pg_namespace ns
		where
        t.relnamespace = ns.oid
        and ns.nspname = 'sportStatsSchema'
	and UPPER(t.relname) = UPPER(OLD_TABLE_NAME)
    ) THEN
		EXECUTE 'ALTER TABLE ' || OLD_TABLE_NAME || ' RENAME TO ' || NEW_TABLE_NAME;
		ELSE
		RAISE NOTICE 'FN_SYS_RENAMETABLE: TABLE % not found', OLD_TABLE_NAME;
	END IF;
END;
$$ LANGUAGE plpgsql ;




--DROP TABLE
CREATE OR REPLACE FUNCTION FN_SYS_DROPTABLE(TABLE_NAME TEXT) RETURNS void AS $$
BEGIN
	IF EXISTS (
		SELECT 1
		from
    	pg_class t,
      	pg_namespace ns
		where
        t.relnamespace = ns.oid
        and ns.nspname = 'sportStatsSchema'
	and UPPER(t.relname) = UPPER(TABLE_NAME)
    ) THEN
		EXECUTE 'DROP TABLE ' || TABLE_NAME || '';
		ELSE
		RAISE NOTICE 'FN_SYS_DROPTABLE: TABLE % not found', TABLE_NAME;
	END IF;
END;
$$ LANGUAGE plpgsql ;

-- CONVERT TEXT TO CLOB
-- Convert text to clob type
CREATE OR REPLACE FUNCTION FN_SYS_TEXT_TO_CLOB(CONTENT TEXT) RETURNS OID AS $$
BEGIN
	if (CONTENT is not null or CONTENT <> '')
	then
		RETURN lo_from_bytea(0, CONTENT::bytea);
		else
		RAISE NOTICE 'FN_SYS_TEXT_TO_CLOB: string CONTENT % empty or null',CONTENT;
		RETURN CONTENT;
	END IF;
END;
$$ LANGUAGE plpgsql ;


-- CONVERT CLOB TO TEXT
-- Convert text to clob type
CREATE OR REPLACE FUNCTION FN_SYS_CLOB_TO_TEXT(CONTENT OID) RETURNS VARCHAR AS $$
BEGIN
	if (CONTENT is not null or CONTENT <> '')
	then
		RETURN convert_from(lo_get(cast(CONTENT as bigint))::bytea, 'UTF8');
		else
		RAISE NOTICE 'FN_SYS_CLOB_TO_TEXT: string CONTENT % empty or null',CONTENT;
		RETURN CONTENT;
	END IF;
END;
$$ LANGUAGE plpgsql ;

CREATE OR REPLACE FUNCTION FN_SYS_GETBOOLEANVALUE(TXTVALUE TEXT) RETURNS boolean AS $$
DECLARE
BEGIN
	IF TXTVALUE IS NOT NULL THEN
		IF LOWER(TXTVALUE) = 'true' THEN
  			RETURN true;
			ELSIF LOWER(TXTVALUE) = 'false' THEN
  			RETURN false;
			ELSE
  			RAISE EXCEPTION 'TXTVALUE parameter can be "true" or "false" (upper or lower case). Unsupported value.  --> %', TXTVALUE;
		END IF;
		ELSE
		RAISE EXCEPTION 'TXTVALUE parameter can be "true" or "false" (upper or lower case). Unsupported empty value.';
	END IF;
END;
$$ LANGUAGE plpgsql ;

-- current_date function
create or replace FUNCTION FN_SYS_CURDATE() RETURNS date AS $$
DECLARE
curdate date;
BEGIN
	curdate := null;
	execute 'select current_date as val from dual' into curdate;
	RETURN curdate;
END;
$$ LANGUAGE plpgsql ;

CREATE OR REPLACE FUNCTION FN_SYS_CTX_KEY_CODE(
	TABLE_NAME TEXT
	, CLASS_NAME TEXT
	, AUTH_KEY TEXT
	, ITEM_CODE TEXT
	, ITEM_EXTERNAL_CODE TEXT
) RETURNS void AS $$
DECLARE
CTX_CONTEXTS_ID INTEGER;
CTX_CUSTOMVALUES_ID INTEGER;

BEGIN

	IF EXISTS (
		SELECT 1
		from
    	pg_class t,
      	pg_namespace ns
		where
        t.relnamespace = ns.oid
        and ns.nspname = 'sportStatsSchema'
	and UPPER(t.relname) = UPPER(TABLE_NAME)
    ) THEN
		EXECUTE 'SELECT ref_context FROM '||TABLE_NAME||' WHERE code = '''||ITEM_CODE||''';' INTO CTX_CONTEXTS_ID;
		IF CTX_CONTEXTS_ID IS NULL THEN
			CTX_CONTEXTS_ID := nextval('SEQ_CTX_CONTEXTS');
			EXECUTE 'INSERT INTO CTX_CONTEXTS
			(id, insert_time, insert_time_utc, ref_insert_user, update_time, update_time_utc,
			ref_update_user, version, class_name)
			VALUES('||CTX_CONTEXTS_ID||', NOW(),NOW(),1,NOW(),NOW(),1,0,'''||CLASS_NAME||''');';
			EXECUTE 'UPDATE '||TABLE_NAME||' SET ref_context = '|| CTX_CONTEXTS_ID ||' WHERE code = '''||ITEM_CODE||''';';
		END IF;
		ELSE
		RAISE EXCEPTION 'FN_SYS_CTX_KEY_CODE: TABLE % not found', TABLE_NAME;
	END IF;
	IF NOT EXISTS (
		SELECT 1
		from
    	ctx_customvalues
		where
        UPPER(key) = UPPER(AUTH_KEY)
	and ref_context = CTX_CONTEXTS_ID
    ) THEN
    	CTX_CUSTOMVALUES_ID := nextval('SEQ_CTX_CUSTOMVALUES');
		EXECUTE 'INSERT INTO ctx_customvalues
		(id, insert_time, insert_time_utc, ref_insert_user, update_time, update_time_utc,
		ref_update_user, version, key, value, ref_context)
		VALUES('||CTX_CUSTOMVALUES_ID||', NOW(),NOW(),1,NOW(),NOW(),1,0,'''||AUTH_KEY||''','''||ITEM_EXTERNAL_CODE||''','||CTX_CONTEXTS_ID||');';
		ELSE
		RAISE NOTICE 'FN_SYS_CTX_KEY_CODE: record AUTH_KEY=% e CTX_CONTEXTS_ID=% already exists in table ctx_customvalues', AUTH_KEY,CTX_CONTEXTS_ID;
	END IF;
END;
$$ LANGUAGE plpgsql ;

CREATE OR REPLACE FUNCTION FN_SYS_CTX_KEY_IDENTIFIER(
	TABLE_NAME TEXT
	, CLASS_NAME TEXT
	, AUTH_KEY TEXT
	, ITEM_CODE TEXT
	, ITEM_EXTERNAL_CODE TEXT
) RETURNS void AS $$
DECLARE
CTX_CONTEXTS_ID INTEGER:= nextval('SEQ_CTX_CONTEXTS');
CTX_CUSTOMVALUES_ID INTEGER;

BEGIN

	EXECUTE 'INSERT INTO CTX_CONTEXTS
	(id, insert_time, insert_time_utc, ref_insert_user, update_time, update_time_utc,
    ref_update_user, version, class_name)
   	VALUES('||CTX_CONTEXTS_ID||', NOW(),NOW(),1,NOW(),NOW(),1,NULL,'''||CLASS_NAME||''');';
	IF EXISTS (
		SELECT 1
		from
    	pg_class t,
      	pg_namespace ns
		where
        t.relnamespace = ns.oid
        and ns.nspname = 'sportStatsSchema'
	and UPPER(t.relname) = UPPER(TABLE_NAME)
    ) THEN
		EXECUTE 'UPDATE '||TABLE_NAME||' SET ref_context = '|| CTX_CONTEXTS_ID ||' WHERE identifier = '''||ITEM_CODE||''';';
		ELSE
		RAISE EXCEPTION 'FN_SYS_CTX_KEY_IDENTIFIER: TABLE % not found', TABLE_NAME;
	END IF;
	IF NOT EXISTS (
		SELECT 1
		from
    	ctx_customvalues
		where
        UPPER(key) = UPPER(AUTH_KEY)
	and ref_context = CTX_CONTEXTS_ID
    ) THEN
		CTX_CUSTOMVALUES_ID := nextval('SEQ_CTX_CUSTOMVALUES');
		EXECUTE 'INSERT INTO ctx_customvalues
		(id, insert_time, insert_time_utc, ref_insert_user, update_time, update_time_utc,
		ref_update_user, version, key, value, ref_context)
		VALUES('||CTX_CUSTOMVALUES_ID||', NOW(),NOW(),1,NOW(),NOW(),1,NULL,'''||AUTH_KEY||''','''||ITEM_EXTERNAL_CODE||''','||CTX_CONTEXTS_ID||');';
		ELSE
		RAISE NOTICE 'FN_SYS_CTX_KEY_IDENTIFIER: record AUTH_KEY=% e CTX_CONTEXTS_ID=% already exists in table ctx_customvalues', AUTH_KEY,CTX_CONTEXTS_ID;
	END IF;
END;
$$ LANGUAGE plpgsql ;

--CREATE TABLE FOR MANY TO MANY RELATIONSHIPS
-- MODIFY COLUMN AFTER TABLE CREATION
CREATE OR REPLACE FUNCTION FN_SYS_CREATETABLE_NOPK(TABLE_NAME TEXT, FIRST_COLUMN_NAME TEXT) RETURNS void AS $$
BEGIN
	IF NOT EXISTS (
		SELECT 1
		from
    	pg_class t,
      	pg_namespace ns
		where
        t.relnamespace = ns.oid
        and ns.nspname = 'sportStatsSchema'
	and UPPER(t.relname) = UPPER(TABLE_NAME)
    ) THEN
--		EXECUTE 'CREATE TABLE ' || TABLE_NAME || ' ( '||FIRST_COLUMN_NAME||' numeric(1))';
		EXECUTE 'CREATE TABLE ' || TABLE_NAME || ' ( '||FIRST_COLUMN_NAME||' bigint)';
		ELSE
		RAISE NOTICE 'FN_SYS_CREATETABLE_NOPK: TABLE % not found', TABLE_NAME;
	END IF;
END;
$$ LANGUAGE plpgsql ;


-- Returns a condition based on a validity field to be used in unique constraints
-- INDEX_FIELDS is null
CREATE OR REPLACE FUNCTION FN_SYS_UQCONSTRAINT_CONDITION(BOOLEAN_VALIDITY_FIELD VARCHAR(4000) DEFAULT 'valid', INDEX_FIELDS VARCHAR(4000) DEFAULT NULL) RETURNS VARCHAR AS $$
DECLARE
BEGIN
	RETURN BOOLEAN_VALIDITY_FIELD || ' is true';
END;
$$ LANGUAGE plpgsql ;


CREATE OR REPLACE FUNCTION fn_sys_assign_sequence(sequence_name text, table_name text, column_name text)
  RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
start_no NUMERIC;
BEGIN
	-- check sequence existence
	IF EXISTS (
		SELECT 1
		FROM pg_class c, pg_namespace ns
		WHERE c.relkind = 'S'
		and c.relnamespace = ns.oid
		and ns.nspname = 'sportStatsSchema'
	and UPPER(c.relname) = UPPER(SEQUENCE_NAME)
	) THEN
		  EXECUTE 'ALTER TABLE ' ||  table_name || ' ALTER COLUMN ' || column_name || ' SET DEFAULT nextval('''||sequence_name||''')';
      EXECUTE  'ALTER SEQUENCE ' || sequence_name || ' OWNED BY ' || table_name||'.'||column_name;
		ELSE
		RAISE NOTICE  'FN_SYS_ASSIGN_SEQUENCE: ERROR  TABLE % FOR SEQUENCE % ',table_name, sequence_name;
	END IF;
END;
$$;

CREATE OR REPLACE VIEW dual AS
  SELECT 'X'::character(1) AS dummy;

-- Aggiunge tutti i campi audit per la tabella data in input
CREATE OR REPLACE FUNCTION FN_SYS_ADD_SEQ_AUDIT_COLUMNS_NOSEQ(TABLE_NAME TEXT, COLUMN_NAME TEXT) RETURNS void AS $$
BEGIN

	EXECUTE '	SELECT FN_SYS_ADDCOLUMN				('''		|| TABLE_NAME || '''		, ''valid''					, ''BOOLEAN''	,  null		, null	, ''NOT NULL''	, ''1''                 )	FROM dual';
	EXECUTE ' 	SELECT FN_SYS_ADDCOLUMN				('''		|| TABLE_NAME || '''		, ''rec_ver''				, ''LONG''		,  ''10''	,  ''0'',		null	, ''0''					)	FROM dual';
	EXECUTE ' 	SELECT FN_SYS_ADDCOLUMN				('''		|| TABLE_NAME || '''		, ''usr_ins''				, ''VARCHAR''	, ''120''	,  ''0'',		null	, null					)	FROM dual';
	EXECUTE ' 	SELECT FN_SYS_ADDCOLUMN				('''		|| TABLE_NAME || '''		, ''usr_upd''				, ''VARCHAR''	, ''120''	,  ''0'',		null	, null					)	FROM dual';
	EXECUTE ' 	SELECT FN_SYS_ADDCOLUMN				('''		|| TABLE_NAME || '''		, ''dta_ins''				, ''DATE''		,  null		, null	,		null	, null					)	FROM dual';
	EXECUTE ' 	SELECT FN_SYS_ADDCOLUMN				('''		|| TABLE_NAME || '''		, ''dta_upd''				, ''DATE''		,  null		, null	,		null	, null					)	FROM dual';
--	EXECUTE ' 	SELECT fn_sys_createsequence		(''seq_'	|| TABLE_NAME || '''	, ''1''														)	FROM dual';
--	EXECUTE ' 	SELECT fn_sys_assign_sequence		(''seq_'	|| TABLE_NAME || '''	, ''' || TABLE_NAME		|| ''', ''' || COLUMN_NAME	|| '''	)	FROM dual';

END;
$$ LANGUAGE plpgsql ;

-- Aggiunge tutti i campi audit per la tabella data in input
CREATE OR REPLACE FUNCTION FN_SYS_ADD_SEQ_AUDIT_COLUMNS(TABLE_NAME TEXT, COLUMN_NAME TEXT) RETURNS void AS $$
BEGIN

	EXECUTE '	SELECT FN_SYS_ADDCOLUMN				('''		|| TABLE_NAME || '''		, ''valid''					, ''BOOLEAN''	,  null		, null	, ''NOT NULL''	, ''1''                 )	FROM dual';
	EXECUTE ' 	SELECT FN_SYS_ADDCOLUMN				('''		|| TABLE_NAME || '''		, ''rec_ver''				, ''LONG''		,  ''10''	,  ''0'',		null	, ''0''					)	FROM dual';
	EXECUTE ' 	SELECT FN_SYS_ADDCOLUMN				('''		|| TABLE_NAME || '''		, ''usr_ins''				, ''VARCHAR''	, ''120''	,  ''0'',		null	, null					)	FROM dual';
	EXECUTE ' 	SELECT FN_SYS_ADDCOLUMN				('''		|| TABLE_NAME || '''		, ''usr_upd''				, ''VARCHAR''	, ''120''	,  ''0'',		null	, null					)	FROM dual';
	EXECUTE ' 	SELECT FN_SYS_ADDCOLUMN				('''		|| TABLE_NAME || '''		, ''dta_ins''				, ''DATE''		,  null		, null	,		null	, null					)	FROM dual';
	EXECUTE ' 	SELECT FN_SYS_ADDCOLUMN				('''		|| TABLE_NAME || '''		, ''dta_upd''				, ''DATE''		,  null		, null	,		null	, null					)	FROM dual';
	EXECUTE ' 	SELECT fn_sys_createsequence		(''seq_'	|| TABLE_NAME || '''	, ''1''														)	FROM dual';
--	EXECUTE ' 	SELECT fn_sys_assign_sequence		(''seq_'	|| TABLE_NAME || '''	, ''' || TABLE_NAME		|| ''', ''' || COLUMN_NAME	|| '''	)	FROM dual';

END;
$$ LANGUAGE plpgsql ;



--RESTART SEQUENCE
CREATE OR REPLACE FUNCTION FN_SYS_RESTARTSEQUENCE(TABLE_NAME TEXT) RETURNS BIGINT AS $$

DECLARE
restart_no NUMERIC;
BEGIN

	execute 'select max(id) as val from ' || TABLE_NAME into restart_no;

	IF   restart_no IS NULL
	THEN restart_no = 1;
	ELSE restart_no = restart_no + 1;
	END IF;
	-- check sequence existence
	IF EXISTS (
		SELECT 1
		FROM pg_class c, pg_namespace ns
		WHERE c.relkind = 'S'
		and c.relnamespace = ns.oid
		and ns.nspname = 'sportStatsSchema'
	and UPPER(c.relname) = UPPER('seq_' || TABLE_NAME)
	) THEN

		EXECUTE 'ALTER SEQUENCE seq_' || TABLE_NAME || ' RESTART WITH '|| restart_no;
		ELSE
		RAISE NOTICE  'FN_SYS_RESTARTSEQUENCE: SEQUENCE % not exists', 'seq_' || TABLE_NAME;
	END IF;
	RETURN restart_no;

END;
$$ LANGUAGE plpgsql ;


-- Aggiunge tutti i campi audit per la tabella data in input
CREATE OR REPLACE FUNCTION FN_SYS_ADD_AUDIT_COLUMNS(TABLE_NAME TEXT) RETURNS void AS $$
BEGIN

	EXECUTE '	SELECT FN_SYS_ADDCOLUMN				('''		|| TABLE_NAME || '''		, ''valid''					, ''BOOLEAN''	,  null		, null	, ''NOT NULL''	, ''1''                 )	FROM dual';
	EXECUTE ' 	SELECT FN_SYS_ADDCOLUMN				('''		|| TABLE_NAME || '''		, ''rec_ver''				, ''LONG''		,  ''10''	,  ''0'',		null	, ''0''					)	FROM dual';
	EXECUTE ' 	SELECT FN_SYS_ADDCOLUMN				('''		|| TABLE_NAME || '''		, ''usr_ins''				, ''VARCHAR''	, ''120''	,  ''0'',		null	, null					)	FROM dual';
	EXECUTE ' 	SELECT FN_SYS_ADDCOLUMN				('''		|| TABLE_NAME || '''		, ''usr_upd''				, ''VARCHAR''	, ''120''	,  ''0'',		null	, null					)	FROM dual';
	EXECUTE ' 	SELECT FN_SYS_ADDCOLUMN				('''		|| TABLE_NAME || '''		, ''dta_ins''				, ''DATE''		,  null		, null	,		null	, null					)	FROM dual';
	EXECUTE ' 	SELECT FN_SYS_ADDCOLUMN				('''		|| TABLE_NAME || '''		, ''dta_upd''				, ''DATE''		,  null		, null	,		null	, null					)	FROM dual';

END;
$$ LANGUAGE plpgsql ;



CREATE OR REPLACE FUNCTION if_modified_func() RETURNS TRIGGER AS $$
DECLARE
    channel text;
    payload jsonb;
    rowdata jsonb;
    idModify text;
BEGIN
    IF TG_WHEN <> 'AFTER' THEN
        RAISE EXCEPTION 'if_modified_func() may only run as an AFTER trigger';
    END IF;
    
     

    -- Determine operation type
    IF (TG_OP = 'UPDATE' AND TG_LEVEL = 'ROW') THEN
        rowdata = row_to_json(NEW.*);
        idModify = NEW.usr_upd::TEXT;
    ELSIF (TG_OP = 'DELETE' AND TG_LEVEL = 'ROW') THEN
        rowdata = row_to_json(OLD.*);
        idModify = OLD.usr_upd:: TEXT;
    ELSIF (TG_OP = 'INSERT' AND TG_LEVEL = 'ROW') THEN
        rowdata = row_to_json(NEW.*);
        idModify = NEW.usr_ins::TEXT;
    ELSIF NOT (TG_LEVEL = 'STATEMENT' AND TG_OP IN ('INSERT','UPDATE','DELETE','TRUNCATE')) THEN
        RAISE EXCEPTION '[if_modified_func] - Trigger func added as trigger for unhandled case: %, %',TG_OP, TG_LEVEL;
        RETURN NULL;
    END IF;

  
    IF (TG_TABLE_NAME::text <> 'logsysext') THEN
    
    -- Construct JSON payload
    payload = jsonb_build_object('schema_name', TG_TABLE_SCHEMA::text,
                                 'table_name', TG_TABLE_NAME::text,
                                 'operation', TG_OP,
                                 'transaction_time', transaction_timestamp(),
                                 'capture_time', clock_timestamp(),
                                 'data', rowdata);
   

    channel = TG_ARGV[0];
    
     
    --RAISE NOTICE '[%]', idModify;
    
    INSERT INTO logsysext( tabella, channel, tipo_operazione, messaggio, data_operazione, capture_time  ) VALUES
    	( TG_TABLE_NAME::text	    	
    	, idModify           	
    	, TG_OP		
    	, rowdata
    	,transaction_timestamp() 
    	,clock_timestamp()
	);
    
 
--	 RAISE NOTICE '[%]', channel;
--	 RAISE NOTICE '[%]', payload::text;
-- 
--    -- Notify to channel with serialized JSON payload.
--    perform pg_notify(channel, payload::text);

    END IF;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Create triggers that will execute on any change to the table.
CREATE OR REPLACE FUNCTION watch_table(target_table regclass, channel text) RETURNS void AS $$
DECLARE
  stmt text;
BEGIN
    -- Drop existing triggers if they exist.
    EXECUTE unwatch_table(target_table);

    -- Row level watch trigger.
    stmt = 'CREATE TRIGGER watch_trigger_row AFTER INSERT OR UPDATE OR DELETE ON ' ||
             target_table || ' FOR EACH ROW EXECUTE PROCEDURE if_modified_func(' ||
             quote_literal(channel) || ');';
    RAISE NOTICE '%', stmt;
    EXECUTE stmt;

    -- Truncate level watch trigger. This will not contain any row data.
    stmt = 'CREATE TRIGGER watch_trigger_stmt AFTER TRUNCATE ON ' ||
             target_table || ' FOR EACH STATEMENT EXECUTE PROCEDURE if_modified_func(' ||
             quote_literal(channel) || ');';
    RAISE NOTICE '%', stmt;
    EXECUTE stmt;

END;
$$ LANGUAGE plpgsql;

-- Unwatch a table.
CREATE OR REPLACE FUNCTION unwatch_table(target_table regclass) RETURNS void AS $$
BEGIN
    EXECUTE 'DROP TRIGGER IF EXISTS watch_trigger_row ON ' || target_table;
    EXECUTE 'DROP TRIGGER IF EXISTS watch_trigger_stmt ON ' || target_table;
END;
$$ LANGUAGE plpgsql;




--CREATE TABLE
CREATE OR REPLACE FUNCTION FN_SYS_CREATETABLE(TABLE_NAME TEXT, COLUMN_NAME TEXT) RETURNS void AS $$
DECLARE
  appo text;
BEGIN
	IF NOT EXISTS (
		SELECT 1
		from
    	pg_class t,
      	pg_namespace ns
		where
        t.relnamespace = ns.oid
        and ns.nspname = 'sportStatsSchema'
	and UPPER(t.relname) = UPPER(TABLE_NAME)
    ) THEN
		EXECUTE 'CREATE TABLE ' || TABLE_NAME || ' (' || COLUMN_NAME || ' BIGINT PRIMARY KEY NOT NULL);';
		ELSE
		RAISE NOTICE 'FN_SYS_CREATETABLE: TABLE % already exists', TABLE_NAME;
	END IF;
	
 	--EXECUTE 'select watch_table('|| TABLE_NAME ,'change_' || TABLE_NAME|| ') from dual';
    --  EXECUTE 'select watch_table(''client.payments''::regclass, ''payment_feed'')';
 	appo =  'change_'||TABLE_NAME;
    EXECUTE 'select watch_table('||quote_literal(TABLE_NAME) ||'::regclass,'|| quote_literal(appo) || ');';
END;
$$ LANGUAGE plpgsql ;


--CREATE TABLE
CREATE OR REPLACE FUNCTION FN_SYS_CREATETABLE(TABLE_NAME TEXT) RETURNS void AS $$
BEGIN
	IF NOT EXISTS (
		SELECT 1
		from
    	pg_class t,
      	pg_namespace ns
		where
        t.relnamespace = ns.oid
        and ns.nspname = 'sportStatsSchema'
	and UPPER(t.relname) = UPPER(TABLE_NAME)
    ) THEN
		EXECUTE 'CREATE TABLE ' || TABLE_NAME ||'();';
		ELSE
		RAISE NOTICE 'FN_SYS_CREATETABLE: TABLE % already exists', TABLE_NAME;
	END IF;
END;
$$ LANGUAGE plpgsql ;



