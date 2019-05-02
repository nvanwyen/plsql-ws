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
grant execute on rest_property   to ws_rest_user;
grant execute on rest_properties to ws_rest_user;

--
grant execute on rest_request to ws_rest_user;

--
grant execute on url_escape to ws_rest_user;
grant execute on url_unescape to ws_rest_user;

--
grant select on runtime_properites to ws_user;
grant select on runtime_log to ws_user;

--
grant select, insert, update, delete on ws$prop$ to dba;
grant select, insert, update, delete on ws$log$ to dba;

--
-- grant execute on dbms_java to ws_rest_user;

--
-- ... done!
--
