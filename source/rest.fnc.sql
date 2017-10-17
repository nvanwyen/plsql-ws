--------------------------------------------------------------------------------
--
-- 2016-07-18, NV - rest.fun.sql
--

--
prompt ... running rest.fun.sql

--
alter session set current_schema = ws;

--
create or replace function rest_call_( url in varchar2,
                                       mth in varchar2,
                                       doc in varchar2,
                                       pro in rest_properties,
                                       jva in java_properties ) return clob as
language java
name 'oracle.mti.ws.rest.call( java.lang.String, java.lang.String, java.lang.String, oracle.sql.ARRAY, oracle.sql.ARRAY ) return java.sql.Clob';
/

show errors

--
create or replace function rest_request( url in varchar2,
                                         mth in varchar2,
                                         doc in varchar2,
                                         pro in rest_properties default null,
                                         jva in java_properties default null ) return clob as
begin

    return rest_call_( url, mth, doc, pro, jva );

end rest_request;    
/

show errors

--
-- ... done!
--
