--------------------------------------------------------------------------------
--
-- 2016-07-14, NV - soap.jva.sql
--

--
prompt ... running soap.jva.sql

--
alter session set current_schema = ws;

--
set define off

create or replace and compile java source named "soap" as

package oracle.mti.ws;

//
import java.io.*;
import java.sql.*;
import java.lang.*;
import java.util.*;
import java.security.*;
import java.security.cert.*;

//
import javax.net.ssl.*;
import javax.xml.soap.*;
import javax.xml.transform.*;
import javax.xml.transform.stream.*;

//
import oracle.sql.*;
import oracle.jdbc.*;

//
public class soap
{
    //
    public static void trust_certificates() 
        throws NoSuchAlgorithmException, KeyManagementException
    {
        //
        Security.addProvider( new com.sun.net.ssl.internal.ssl.Provider() );

        //
        TrustManager[] trustAllCerts = new TrustManager[]
        { 
            new X509TrustManager()
            {
                public X509Certificate[] getAcceptedIssuers() 
                {
                    return null;
                }

                public void checkServerTrusted( X509Certificate[] certs, String authType ) 
                    throws CertificateException 
                {
                    return;
                }

                public void checkClientTrusted( X509Certificate[] certs, String authType ) 
                    throws CertificateException 
                {
                    return;
                }
            } 
        };

        //
        SSLContext sc = SSLContext.getInstance( "SSL" );
        sc.init( null, trustAllCerts, new SecureRandom() );

        //
        HttpsURLConnection.setDefaultSSLSocketFactory( sc.getSocketFactory() );

        //
        HostnameVerifier hv = new HostnameVerifier()
        {
            public boolean verify( String urlHostName, SSLSession session ) 
            {
                if ( ! urlHostName.equalsIgnoreCase( session.getPeerHost() ) ) 
                {
                    return false;
                }

                return true;
            }
        };

        HttpsURLConnection.setDefaultHostnameVerifier( hv );
    }

    //
    private static SOAPMessage request( String xml, oracle.sql.ARRAY hdr )
        throws Exception
    {
        MessageFactory mf = MessageFactory.newInstance();
        SOAPMessage sm = mf.createMessage();
        SOAPPart sp = sm.getSOAPPart();

        if ( hdr != null )
        {
            MimeHeaders mh = sm.getMimeHeaders();
            properties hd = new properties( hdr );

            if ( hd != null )
            {
                for ( property h : hd.list )
                    mh.addHeader( h.name, h.value );
            }
        }

        sp.setContent( new StreamSource( new StringReader( xml ) ) );
        sm.saveChanges();

        // print request
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        sm.writeTo( out );
        sys.print(  "Request: " + new String( out.toByteArray() ) );

        return sm;
    }

    private static String response( SOAPMessage sr )
        throws Exception
    {
        String msg = "";

        Source sc = sr.getSOAPPart().getContent();
        StringWriter ws = new StringWriter();
        StreamResult rs = new StreamResult( ws );

        TransformerFactory tf = TransformerFactory.newInstance();
        Transformer tr = tf.newTransformer();

        tr.transform( sc, rs );
        msg = ws.toString();

        sys.print( "Response: " + msg );
        return msg;
    }


    //
    static public Clob call( String url, String xml, oracle.sql.ARRAY hdr, oracle.sql.ARRAY jva )
        throws SQLException, NoSuchAlgorithmException, KeyManagementException
    {
        //
        String res = null;

        //
        if ( jva != null )
            sys.set( new properties( jva ) );

        try
        {
            SOAPConnectionFactory sf = SOAPConnectionFactory.newInstance();
            SOAPConnection sc = sf.createConnection();

            if ( url.trim().toLowerCase().startsWith( "https" ) )
                trust_certificates();

            SOAPMessage sr = sc.call( request( xml, hdr ), url );

            res = response( sr );
            sc.close();
        }
        catch ( Exception ex )
        {
            ex.printStackTrace();
        }

        return sys.to_clob( res );
    }
};
/

show errors

--
-- ...done!
--
