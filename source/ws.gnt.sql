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

--
-- ... done!
--
