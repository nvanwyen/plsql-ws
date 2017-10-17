--------------------------------------------------------------------------------
--
-- 2017-07-18, NV - soap.typ.sql
--

--
prompt ... running soap.typ.sql

--
alter session set current_schema = ws;

--
create synonym soap_header for property;

--
create synonym soap_headers for properties;

--
-- ... done!
--
