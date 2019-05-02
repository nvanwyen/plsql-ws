--------------------------------------------------------------------------------
--
-- 2019-05-02, NV - patch_ws.sql
--

--
set linesize 160
set pagesize 50000
set trimspool on
set serveroutput on

--
whenever oserror  exit 9;
whenever sqlerror exit sql.sqlcode;

--
column log new_value log noprint;

--
set termout off;
select sys_context( 'userenv', 'db_name' ) 
    || '_patch_ws.' 
    || to_char( sysdate, 'YYYYMMDDHH24MISS' ) 
    || '.log' log
  from dual;
set termout on;

--
spool &&log append

--
prompt ... running patch_ws.sql

--
select current_timestamp "begin patching"
  from dual;

-- table/view
@@ws.tbl.sql
@@ws.vws.sql

-- common
@@ws.jva.sql

-- soap
@@soap.jva.sql

-- rest
@@rest.jva.sql

-- properties
@@ws.par.sql

--
select current_timestamp "complete patching"
  from dual;

--
prompt ... show post patching object errors

--
set linesize 160
set pagesize 50000

--
col name for a30 head "name"
col text for a80 head "text" word_wrap

--
select name,
       text
  from all_errors
 where owner = 'WS'
   and text not like 'Note: %';

--
declare

    c number := 0;

begin

    select count(0) into c
      from all_errors
     where owner = 'WS'
       and text not like 'Note: %';

    if ( c > 0 ) then

        raise_application_error( -20001, to_char( c ) || ' patching error(s) encountered, please review' );

    else

        dbms_output.put_line( 'patching successful' );

    end if;

end;
/

--
spool off
exit

--
-- ... done!
--
