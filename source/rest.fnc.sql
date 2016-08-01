--------------------------------------------------------------------------------
--
-- 2016-07-18, NV - rest.fun.sql
--

--
prompt ... running rest.fun.sql

--
alter session set current_schema = ws;

--
create or replace function rest_request( url in varchar2,
                                         mth in varchar2,
                                         doc in varchar2,
                                         pro in rest_properties ) return varchar2 as
language java
name 'oracle.mti.ws.rest.call( java.lang.String, java.lang.String, java.lang.String, oracle.sql.ARRAY ) return java.lang.String';
/

show errors

--
create or replace function rest_call( url in varchar2,
                                      mth in varchar2,
                                      doc in varchar2,
                                      pro in rest_properties ) return clob as
begin

    return to_clob( rest_request( url, mth, doc, pro ) );

end rest_call;
/

show errors

--
-- ... done!
--
