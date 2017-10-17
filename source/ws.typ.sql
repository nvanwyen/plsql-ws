--------------------------------------------------------------------------------
--
-- 2016-07-18, NV - ws.typ.sql
--

--
prompt ... running ws.typ.sql

--
alter session set current_schema = ws;

--
create or replace type property as object
(
    name  varchar2( 4000 ),
    value varchar2( 4000 )
);
/

show errors

--
create or replace type properties as table of property;
/

show errors

--
create or replace synonym java_property for property;

--
create or replace synonym java_properties for properties;

--
-- ... done!
--
