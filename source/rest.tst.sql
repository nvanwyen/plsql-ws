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
select ws.rest_request( 'http://jsonplaceholder.typicode.com/posts/2',
                        'get',
                        null,
                        ws.rest_properties( ws.rest_property( 'Accept',
                                                              'application/json' ) ) ) response_from_http
  from dual;

-- end the test
exit
