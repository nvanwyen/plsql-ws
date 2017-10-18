--------------------------------------------------------------------------------
--
-- 2016-07-14, NV - install_hive.sql
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
column logfile new_value logfile noprint;

--
set termout off;
select sys_context( 'userenv', 'db_name' ) 
    || '_install_ws.' 
    || to_char( sysdate, 'YYYYMMDDHH24MISS' ) 
    || '.log' logfile
  from dual;
set termout on;

--
spool &&logfile append

--
prompt ... running install_ws.sql

--
select current_timestamp "begin installation"
  from dual;

-- schema
@@ws.usr.sql
@@ws.prm.sql

-- common
@@ws.typ.sql
@@ws.jva.sql

-- soap
@@soap.typ.sql
@@soap.jva.sql
@@soap.fnc.sql

-- rest
@@rest.typ.sql
@@rest.jva.sql
@@rest.fnc.sql

--
@@ws.fnc.sql
@@ws.rol.sql
@@ws.gnt.sql

--
select current_timestamp "complete installation"
  from dual;

--
prompt ... show post installation object errors

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

        raise_application_error( -20001, to_char( c ) || ' installation error(s) encountered, please review' );

    else

        dbms_output.put_line( 'Installation successful' );

    end if;

end;
/

--
spool off
exit

--
-- ... done!
--
