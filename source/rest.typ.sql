--------------------------------------------------------------------------------
--
-- 2016-07-18, NV - rest.typ.sql
--

--
prompt ... running rest.typ.sql

--
alter session set current_schema = ws;

--
--
create or replace type rest_property as object
(
    name  varchar2( 4000 ),
    value varchar2( 4000 )
);
/

show errors

--
create or replace type rest_properties as table of rest_property;
/

show errors

--
-- ... done!
--
