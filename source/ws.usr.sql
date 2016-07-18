--------------------------------------------------------------------------------
--
-- 2016-07-14, NV - ws.usr.sql
--

--
prompt ... running ws.usr.sql

column defts new_value defts noprint;
column tmpts new_value tmpts noprint;

set term off
select default_tablespace   defts from dba_users where username = 'SYSTEM';
select temporary_tablespace tmpts from dba_users where username = 'SYSTEM';
set term on

set verify off

--
create user ws
    identified by values 'FFFFFFFFFFFFFFFF'
    default tablespace &&defts
    temporary tablespace &&tmpts
    account lock;

--
grant resource to ws;

--
alter user ws quota unlimited on &&defts;

set verify on

--
-- ... done!
--
