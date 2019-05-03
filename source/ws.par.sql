--------------------------------------------------------------------------------
--
-- 2019-05-02, NV - ws.par.sql
--

--
prompt ... running ws.par.sql

--
alter session set current_schema = ws;

-- add run time properties
--
declare

    --
    function exists_( n in varchar2 ) return boolean is

        c number := 0;

    begin

        select count(0) into c
          from ws$prop$ a
         where a.name = n;

        return ( c > 0 );

    end exists_;

    --
    procedure insert_( n in varchar2, v in varchar2 ) is

        pragma autonomous_transaction;

    begin

        --
        insert into ws$prop$ a
            ( a.name, a.value )
        values
            ( n, v );

        --
        commit;

        --
        exception when others then rollback; raise;

    end insert_;

    --
    procedure update_( n in varchar2, v in varchar2 ) is

        pragma autonomous_transaction;

    begin

        --
        update ws$prop$ a
           set a.value = v
         where a.name = n;

        --
        commit;

        --
        exception when others then rollback; raise;

    end update_;

    --
    procedure delete_( n in varchar2 ) is

        pragma autonomous_transaction;

    begin

        --
        delete from ws$prop$ a
         where a.name = n;

        --
        commit;

        --
        exception when others then rollback; raise;

    end delete_;

    --
    procedure property_( n in varchar2, v in varchar2 ) is
    begin

        --
        if ( not exists_( n ) ) then

            --
            insert_( n, v );

        else

            if ( v is not null ) then

                --
                update_( n, v );

            else

                --
                delete_( n );

            end if;

        end if;

    end property_;

begin

    -- logging and output printing
    --
    property_( 'ws.system.loglevel', '15' );
    property_( 'ws.system.output', 'enabled' );

    -- TLS
    --
    property_( 'https.protocols', 'TLSv1.2,TLSv1.1' );
    property_( 'oracle.net.ssl_cipher_suites', '(RSA_WITH_AES_256_CBC_SHA,'              /* TLSv1.2 ciphers */
                                             || 'RSA_WITH_AES_256_CBC_SHA256,'
                                             || 'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA,'
                                             || 'TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,'
                                             || 'RSA_WITH_AES_128_CBC_SHA,'              /* TLSv1.1 ciphers */
                                             || 'TLS_DHE_RSA_WITH_AES_128_CBC_SHA,'
                                             || 'TLS_DHE_RSA_WITH_AES_256_CBC_SHA)' );

    -- java debugging
    --
    property_( 'javax.net.debug', '' ); -- turn on debugging with: "ssl:handshake:data"

end;
/

--
-- ...done!
--
