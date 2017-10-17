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

-- end the test
exit
