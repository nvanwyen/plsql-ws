--------------------------------------------------------------------------------
--
-- 2017-07-18, NV - soap.typ.sql
--

--
prompt ... running soap.typ.sql

--
alter session set current_schema = ws;

--
create or replace type soap_header as object
(
    name  varchar2( 4000 ),
    value varchar2( 4000 )
);
/

show errors

--
create or replace type soap_headers as table of soap_header;
/

show errors
