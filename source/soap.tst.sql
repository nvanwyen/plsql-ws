--------------------------------------------------------------------------------
--
-- 2016-07-15, NV - soap.tst.sql
--

-- uncomment to see detailed output ...
--
-- set serveroutput on
-- exec dbms_java.set_output( 1000000 );

-- call a web-service using SOAP ...

-- non-secure
select ws.soap_request( 'http://ws.cdyne.com/emailverify/Emailvernotestemail.asmx',
                        '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" ' ||
                        '                   xmlns:example="http://ws.cdyne.com/">' ||
                        '    <SOAP-ENV:Header/>' ||
                        '    <SOAP-ENV:Body>' ||
                        '        <example:VerifyEmail>' ||
                        '            <example:email>mutantninja@gmail.com</example:email>' ||
                        '            <example:LicenseKey>123</example:LicenseKey>' ||
                        '        </example:VerifyEmail>' ||
                        '    </SOAP-ENV:Body>' ||
                        '</SOAP-ENV:Envelope>',
                        ws.soap_headers( ws.soap_header( 'SOAPAction', 
                                                         'http://ws.cdyne.com/VerifyEmail' ) ) ) response_from_http
  from dual;

-- same thing, but secure (https)
select ws.soap_request( 'https://ws.cdyne.com/emailverify/Emailvernotestemail.asmx',
                        '<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" ' ||
                        '                   xmlns:example="http://ws.cdyne.com/">' ||
                        '    <SOAP-ENV:Header/>' ||
                        '    <SOAP-ENV:Body>' ||
                        '        <example:VerifyEmail>' ||
                        '            <example:email>mutantninja@gmail.com</example:email>' ||
                        '            <example:LicenseKey>123</example:LicenseKey>' ||
                        '        </example:VerifyEmail>' ||
                        '    </SOAP-ENV:Body>' ||
                        '</SOAP-ENV:Envelope>',
                        ws.soap_headers( ws.soap_header( 'SOAPAction', 
                                                         'http://ws.cdyne.com/VerifyEmail' ) ) ) response_from_https
  from dual;

-- end the test
exit
