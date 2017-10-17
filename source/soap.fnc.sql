--------------------------------------------------------------------------------
--
-- 2016-07-14, NV - soap.fnc.sql
--

--
prompt ... running soap.fnc.sql

--
alter session set current_schema = ws;

--
create or replace function soap_call_( url in varchar2,
                                       xml in varchar2,
                                       hdr in soap_headers,
                                       jva in java_properties ) return clob as
language java
name 'oracle.mti.ws.soap.call( java.lang.String, java.lang.String, oracle.sql.ARRAY, oracle.sql.ARRAY ) return java.sql.Clob';
/

show errors

--
create or replace function soap_request( url in varchar2,
                                         xml in varchar2,
                                         hdr in soap_headers    default null,
                                         jva in java_properties default null ) return clob as
begin

    return soap_call_( url, xml, hdr, jva );

end soap_request;    
/

show errors

--
-- ...done!
--
