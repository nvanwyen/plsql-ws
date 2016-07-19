--------------------------------------------------------------------------------
--
-- 2016-07-14, NV - rest.jva.sql
--

--
prompt ... running rest.jva.sql

--
alter session set current_schema = ws;

--
set define off

create or replace and compile java source named "rest" as

package oracle.mti.ws;

//
import java.io.*;
import java.net.*;
import java.sql.*;
import java.lang.*;
import java.util.*;
import java.security.*;
import java.security.cert.*;

//
import javax.net.ssl.*;

//
import oracle.sql.*;
import oracle.jdbc.*;

//
public class property
{
    //
    public String name;
    public String value;

    //
    public property()
    {
        name = "";
        value = "";
    }

    //
    public property( String n, String v )
    {
        name = n;
        value = v;
    }

    //
    public property( oracle.sql.STRUCT obj )
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
        return "property name: " + name + ", value: " + value;
    }
};

//
public class properties
{
    //
    public ArrayList<property> list;

    //
    public properties()
    {
        list = new ArrayList<property>();
    }

    //
    public properties( ArrayList<property> l )
    {
        list = new ArrayList<property>( l );
    }

    //
    public properties( properties n )
    {
        list = new ArrayList<property>( n.list );
    }

    //
    public properties( oracle.sql.ARRAY obj )
        throws SQLException
    {
        list = new ArrayList<property>();

        if ( obj != null )
        {
            Datum[] dat = obj.getOracleArray();

            //
            for ( int i = 0; i < dat.length; ++i )
            {
                if ( dat[ i ] != null )
                    list.add( new property( (STRUCT)dat[ i ] ) );
            }
        }
    }

    //
    public String toString()
    {
        String str = "";

        for ( property val : list )
            str += val.toString() + "\n";

        return str;
    }
};

//
public class rest
{
    //
    final static HostnameVerifier DO_NOT_VERIFY = new HostnameVerifier()
    {
	    public boolean verify( String hostname, SSLSession session )
        {
		    return true;
	    }
    };

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
    static public String call( String url, String mth, String doc, oracle.sql.ARRAY pro )
        throws SQLException, NoSuchAlgorithmException, KeyManagementException
    {
        //
        String res = null;

        try
        {
            URL uri = new URL( url );
            HttpURLConnection htp = null;

            //
            if ( url.trim().toLowerCase().startsWith( "https" ) )
            {
                trust_certificates();
                HttpsURLConnection hts = (HttpsURLConnection)uri.openConnection();

                hts.setHostnameVerifier( DO_NOT_VERIFY );
                htp = hts;
            }
            else
                htp = (HttpURLConnection)uri.openConnection();

            //
            htp.setRequestMethod( mth.toUpperCase() );

            //
            if ( pro != null )
            {
                properties pr = new properties( pro );

                for ( property p : pr.list )
                    htp.setRequestProperty( p.name, p.value );
            }

            //
            if ( doc != null )
            {
                htp.setDoOutput( true );

                OutputStream os = htp.getOutputStream();
                os.write( doc.getBytes() );
                os.flush();

                System.out.println( "Response: " + htp.getResponseCode() );
            }

            /*
                http://download.java.net/jdk7/archive/b123/docs/api/java/net/HttpURLConnection.html

                protected int responseCode - An int representing the three digit HTTP Status-Code.

                    * 1xx: Informational
                    * 2xx: Success
                    * 3xx: Redirection
                    * 4xx: Client Error
                    * 5xx: Server Error
            */
            if ( htp.getResponseCode() < 299 )
            {
                BufferedReader brd = new BufferedReader( new InputStreamReader( ( htp.getInputStream() ) ) );

                String lin = ""; res = "";
                while ( ( lin = brd.readLine() ) != null )
                    res += lin;
            }
            else
                res = htp.getResponseMessage();

            htp.disconnect();
        }
        catch ( MalformedURLException ex )
        {
            ex.printStackTrace();
        }
        catch ( IOException ex )
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
