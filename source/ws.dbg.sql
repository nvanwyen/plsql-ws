--------------------------------------------------------------------------------
--
-- 2019-04-30, NV - ws.dbg.sql
--

--
prompt ... running ws.dbg.sql

--
exec dbms_java.set_property( 'javax.net.debug', 'ssl:handshake:data' );

-- output
set serveroutout on
exec dbms_java.set_output( 1000000 );

--
-- ... done!
--
