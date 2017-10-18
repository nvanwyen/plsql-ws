--------------------------------------------------------------------------------
--
-- 2017-10-18, NV - ws.fnc.sql
--

--
prompt ... running ws.fnc.sql

--
alter session set current_schema = ws;

--
create or replace function url_escape( url in varchar2 ) return varchar2 is
begin

    return sys.utl_url.escape( url );

end url_escape;
/

--
create or replace function url_unescape( url in varchar2 ) return varchar2 is
begin

    return sys.utl_url.unescape( url );

end url_unescape;
/

--
-- ... done!
--
