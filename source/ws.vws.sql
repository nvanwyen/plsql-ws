--------------------------------------------------------------------------------
--
-- 2019-05-02, NV - ws.vws.sql
--

--
prompt ... running ws.vws.sql

--
alter session set current_schema = ws;

--
create or replace view runtime_properites
as
select a.name,
       a.value
  from ws$prop$ a
/

--
create or replace view runtime_log
as
select a.stamp,
       decode( a.type, 1, 'ERROR',
                       2, 'WARN',
                       4, 'INFO',
                       8, 'DEBUG',
                          'UNKNOWN' ) type,
       a.text
  from ws$log$ a
/

--
-- ...done!
--
