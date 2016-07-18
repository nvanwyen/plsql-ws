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
public class header
{
    //
    public String name;
    public String value;

    //
    public header()
    {
        name = "";
        value = "";
    }

    //
    public header( String n, String v )
    {
        name = n;
        value = v;
    }

    //
    public header( oracle.sql.STRUCT obj )
        throws SQLException
    {
        if ( obj != null )
        {
            oracle.sql.Datum[] atr = obj.getOracleAttributes();

            //
            if ( atr.length > 0 )
            {
                if ( atr[ 0 ] != null )
                    name = atr[ 0 ].toString();
                else
                    name = "";
            }
            else
                name = "";

            //
            if ( atr.length > 1 )
            {
                if ( atr[ 1 ] != null )
                    value = atr[ 1 ].toString();
                else
                    value = "";
            }
            else
                value = "";
        }
        else
        {
            name = "";
            value = "";
        }
    }

    //
    public String toString()
    {
        return "header name: " + name + ", value: " + value;
    }
};

//
public class headers
{
    //
    public ArrayList<header> list;

    //
    public headers()
    {
        list = new ArrayList<header>();
    }

    //
    public headers( ArrayList<header> l )
    {
        list = new ArrayList<header>( l );
    }

    //
    public headers( headers n )
    {
        list = new ArrayList<header>( n.list );
    }

    //
    public headers( oracle.sql.ARRAY obj )
        throws SQLException
    {
        list = new ArrayList<header>();

        if ( obj != null )
        {
            Datum[] dat = obj.getOracleArray();

            //
            for ( int i = 0; i < dat.length; ++i )
            {
                if ( dat[ i ] != null )
                    list.add( new header( (STRUCT)dat[ i ] ) );
            }
        }
    }

    //
    public String toString()
    {
        String str = "";

        for ( header val : list )
            str += val.toString() + "\n";

        return str;
    }
};

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
            headers hd = new headers( hdr );

            if ( hd != null )
            {
                for ( header h : hd.list )
                    mh.addHeader( h.name, h.value );
            }
        }

        sp.setContent( new StreamSource( new StringReader( xml ) ) );
        sm.saveChanges();

        // print request
        System.out.print( "Request: " );
        sm.writeTo( System.out );
        System.out.println();

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

        System.out.print( "Response: " );
        System.out.print( msg );
        System.out.println();

        return msg;
    }


    //
    static public String call( String url, String xml, oracle.sql.ARRAY hdr )
    {
        //
        String res = null;

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

        return res;
    }
};
/

show errors

--
-- ...done!
--
