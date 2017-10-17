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
grant execute on property   to ws_soap_user;
grant execute on properties to ws_soap_user;

--
grant execute on java_property   to ws_soap_user;
grant execute on java_properties to ws_soap_user;

--
grant execute on soap_header  to ws_soap_user;
grant execute on soap_headers to ws_soap_user;

--
grant execute on soap_request to ws_soap_user;

--
grant execute on rest_property   to ws_rest_user;
grant execute on rest_properties to ws_rest_user;

--
grant execute on rest_request to ws_rest_user;

--
-- ... done!
--
