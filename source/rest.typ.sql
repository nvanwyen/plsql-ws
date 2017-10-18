--------------------------------------------------------------------------------
--
-- 2016-07-18, NV - rest.typ.sql
--

--
prompt ... running rest.typ.sql

--
alter session set current_schema = ws;

--
create or replace synonym rest_property for property;

--
create or replace synonym rest_properties for properties;

--
-- ... done!
--
