--------------------------------------------------------------------------------
--
-- 2016-07-15, NV - rest.tst.sql
--

-- uncomment to see detailed output ...
--
set serveroutput on
exec dbms_java.set_output( 1000000 );

-- call a web-service using rest ...

-- non-secure
select ws.rest_request( 'http://services.groupkt.com/country/get/iso2code/US',
                        'get',
                        null,
                        ws.rest_properties( ws.rest_property( 'Accept',
                                                              'application/json' ),
                                            ws.rest_property( 'Accept-Language:en-US',
                                                              'en-US,en' ),
                                            ws.rest_property( 'Connection',
                                                              'keep-alive' ) ) ) response_from_http
  from dual;

-- secure
select ws.rest_request( 'https://httpbin.org/get',
                        'get',
                        null,
                        ws.rest_properties( ws.rest_property( 'Accept',
                                                              'application/json' ),
                                            ws.rest_property( 'Accept-Language:en-US',
                                                              'en-US,en' ),
                                            ws.rest_property( 'Connection',
                                                              'keep-alive' ) ) ) response_from_http
  from dual;

-- pl/sql
--
grant ws_rest_user to scott;

--
grant execute on ws.rest_property   to scott;
grant execute on ws.rest_properties to scott;
grant execute on ws.java_properties to scott;
grant execute on ws.rest_request    to scott;
grant execute on ws.url_escape      to scott;
grant execute on ws.url_unescape    to scott;

--
alter session set current_schema = scott;

--
create or replace function std_address( addr    in varchar2,
                                        city    in varchar2,
                                        state   in varchar2,
                                        country in varchar2,
                                        postal  in varchar2,
                                        flag    in varchar2 default 'D',
                                        entry   in varchar2 default 'B',
                                        hint    in varchar2 default 'nonsense' ) return clob as

    url varchar2( 4000 ) := 'https://map-service.com:443/json';
    mth varchar2( 4000 ) := 'GET';
    cmd varchar2( 32767 ); -- content command
    rst ws.rest_properties := ws.properties();
    jva ws.java_properties := ws.properties();

begin

    --
    cmd := '?'                                                        ||
                'foreignDomestic=' || flag                     || '&' ||
                'billEntry='       || entry                    || '&' ||
                'address1='        || ws.url_escape( addr )    || '&' ||
                'city='            || ws.url_escape( city )    || '&' ||
                'state='           || ws.url_escape( state )   || '&' ||
                'country='         || ws.url_escape( country ) || '&' ||
                'postal='          || ws.url_escape( postal )  || '&' ||
                'hint='            || hint
           ;

    -- rest properties
    rst.extend(); rst( rst.count ) := ws.rest_property( 'content-length', 0 );

    -- remote target is enabled for TLSv1.2 and AES256-CBC-SHA256 encryption only
    jva.extend(); jva( jva.count ) := ws.java_property( 'https.protocols',    'TLSv1.2' );
    jva.extend(); jva( jva.count ) := ws.java_property( 'https.cipherSuites', 'TLS_RSA_WITH_AES_256_CBC_SHA256' );

    --
    return ws.rest_request( url || cmd, mth, null, rst, jva );

end std_address;
/

--
show errors

--
--
set long 1000000
--
select scott.std_address( '1600 Pennsylvania Ave NW', 'Washington', 'DC', 'US', '20500' ) from dual;

/* ***
    SCOTT.STD_ADDRESS('1600PENNSYLVANIAAVENW','WASHINGTON','DC','US','20500')
    --------------------------------------------------------------------------------
    {"standardizerUsed":"NONSENSE","cleanseStatus":"0","cleanseTime":"0","matchTime"
    :"0","addresses":[{"name":"","delivery_addr":"1600 PENNSYLVANIA AVE NW WASHINGTO
    N DC 20500-0003 US ","street":"1600 PENNSYLVANIA AVE NW","city":"WASHINGTON","st
    ate":"DC","ctry":"US","ctry_name":"UNITED STATES","zip":"205000003","latitude":3
    8.89876,"longitude":-77.03645,"address_parser_match_level":"0","geocode_match_fl
    ag":"1","geocode_accuracy":"U","geocode_coord_level":"2","box_number":"","house_
    number":"1600","street_name":"PENNSYLVANIA AVE NW","gout_record_type":"HD","us_d
    pv_confirm":"D","us_dpv_cmra":"N","us_dpv_nostat":"N","us_dpv_vacant":"N","us_dp
    v_footnote2":"N1","us_rdi_flag":"Y","us_building_ind":"A","pr_review_group":"005
    ","gin_record_type":"1","pr_orig_line_pattern":"   S    G"}]}
*** */

-- end the test
exit
