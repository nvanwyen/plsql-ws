--------------------------------------------------------------------------------
--
-- 2019-05-02, NV - ws.tbl.sql
--

--
prompt ... running ws.tbl.sql

--
alter session set current_schema = ws;

-- WS.WS$PROP$
--
set serveroutput on
--
declare

    --
    c number := 0;

begin

    --
    select count(0) into c
      from dba_tables
     where owner = 'WS'
       and table_name = 'WS$PROP$';

    --
    if ( c = 0 ) then

        --
        execute immediate
            'create table ws$prop$ '
         || '( '
         ||     'name  varchar2( 256 )  not null, '
         ||     'value varchar2( 4000 )     null '
         || ') '
         || 'tablespace system ';

        --
        execute immediate
            'comment on table ws$prop$ is ''WS (Web Service Client) Java Properties Data''';

        --
        execute immediate
            'comment on column ws$prop$.name is ''Java property name''';

        --
        execute immediate
            'comment on column ws$prop$.value is ''Java property value''';

        --
        execute immediate
            'create unique index ws$prop$idx '
         ||     'on ws$prop$ ( name asc ) '
         || 'tablespace system';

        --
        dbms_output.put_line( 'Table WS$PROP$ created' );

    else

        --
        dbms_output.put_line( 'Table WS$PROP$ exists' );

    end if;

end;
/

-- WS.WS$LOG$
--
set serveroutput on
--
declare

    --
    c number := 0;

begin

    --
    select count(0) into c
      from dba_tables
     where owner = 'WS'
       and table_name = 'WS$LOG$';

    --
    if ( c = 0 ) then

        --
        execute immediate
            'create table ws$log$ '
         || '( '
         ||     'stamp timestamp        not null, '
         ||     'type  number           not null, '
         ||     'text  varchar2( 4000 )     null '
         || ') '
         || 'tablespace system ';

        --
        execute immediate
            'comment on table ws$log$ is ''WS (Web Service Client) Runtime Log''';

        --
        execute immediate
            'comment on column ws$log$.stamp is ''Log timestamp''';

        --
        execute immediate
            'comment on column ws$log$.type is ''Log type''';

        --
        execute immediate
            'comment on column ws$log$.text is ''Log text''';

        --
        execute immediate
            'create unique index ws$log$idx '
         ||     'on ws$log$ ( stamp asc ) '
         || 'tablespace system';

        --
        dbms_output.put_line( 'Table WS$LOG$ created' );

    else

        --
        dbms_output.put_line( 'Table WS$LOG$ exists' );

    end if;

end;
/

--
-- ...done!
--
