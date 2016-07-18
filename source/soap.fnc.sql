--------------------------------------------------------------------------------
--
-- 2016-07-14, NV - soap.fnc.sql
--

--
prompt ... running soap.fnc.sql

--
alter session set current_schema = ws;

--
create or replace function soap_request( url in varchar2,
                                         xml in varchar2,
                                         hdr in soap_headers ) return varchar2 as
language java
name 'oracle.mti.ws.soap.call( java.lang.String, java.lang.String, oracle.sql.ARRAY ) return java.lang.String';
/

show errors

--
-- ...done!
--