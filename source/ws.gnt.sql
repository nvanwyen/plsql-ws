--------------------------------------------------------------------------------
--
-- 2016-07-14, NV - ws.gnt.sql
--

--
prompt ... running ws.gnt.sql

--
alter session set current_schema = ws;

--
grant ws_soap_user to ws_user;
grant ws_rest_user to ws_user;

--
grant ws_user to dba;

--
grant execute on soap_header  to ws_soap_user;
grant execute on soap_headers to ws_soap_user;

--
grant execute on soap_request to ws_soap_user;
grant execute on soap_call    to ws_soap_user;

--
grant execute on rest_property   to ws_rest_user;
grant execute on rest_properties to ws_rest_user;

--
grant execute on rest_request to ws_rest_user;
grant execute on rest_call    to ws_rest_user;

-- bug fix, where the java.security.SecurityPermission didn't take during the inital call
--          it seems calling it after everything is set (e.g. all the grants) it works
exec dbms_java.grant_permission( 'WS', 'SYS:java.security.SecurityPermission', '*', '' );

--
-- ... done!
--
