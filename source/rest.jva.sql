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
        sys.print( "Trusting all certificates" );

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
    static public Clob call( String url, String mth, String doc, oracle.sql.ARRAY pro, oracle.sql.ARRAY jva )
        throws SQLException, NoSuchAlgorithmException, KeyManagementException
    {
        //
        String res = null;

        //
        if ( jva != null )
            sys.set( new properties( jva ) );

        //
        sys.print( "rest::call url: " + ( ( url == null ) ? "{null}" : url ) +
                            ", mth: " + ( ( mth == null ) ? "{null}" : mth ) +
                            ", doc: " + ( ( doc == null ) ? "{null}" : doc ) );

        try
        {
            URL uri = new URL( url );
            HttpURLConnection htp = null;

            //
            if ( url.trim().toLowerCase().startsWith( "https" ) )
            {
                sys.print( "Detected HTTPS call" );

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

                sys.print( "Response: " + htp.getResponseCode() );
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

        return sys.to_clob( res );
    }
};
/

show errors

--
-- ...done!
--
