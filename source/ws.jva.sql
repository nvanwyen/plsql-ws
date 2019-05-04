--------------------------------------------------------------------------------
--
-- 2016-07-14, NV - ws.jva.sql
--

--
prompt ... running ws.jva.sql

--
alter session set current_schema = ws;

--
set define off

create or replace and compile java source named "common" as

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
public class sys
{
    //
    public static final int NONE  = 0;
    public static final int ERROR = 1;
    public static final int WARN  = 2;
    public static final int INFO  = 4;
    public static final int DEBUG = 8;

    //
    public static String getStackTrace( Exception ex )
    {
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter( sw );

        ex.printStackTrace( pw );
        return sw.toString();
    }

    //
    public static void log( int type, String text )
    {
        //
        if ( ( log_level() & type ) != NONE )
        {
            Connection con = null;
            PreparedStatement stm = null;

            try
            {
                String sql = "declare "
                           +     "pragma autonomous_transaction; "
                           + "begin "
                           +     "insert into ws$log$ a "
                           +         "( a.stamp, a.type, a.text ) "
                           +     "values "
                           +         "( current_timestamp, ?, ? ); "
                           +     "commit write nowait; "
                           +     "exception "
                           +         "when others then "
                           +             "rollback; "
                           +             "raise; "
                           + "end;";

                //
                con = new OracleDriver().defaultConnection();

                //
                if ( con.getAutoCommit() )
                    con.setAutoCommit( false );

                //
                stm = con.prepareStatement( sql );

                //
                stm.setInt( 1, type );
                stm.setString( 2, text );

                //
                stm.executeUpdate();
                stm.close();

                //
                // con.commit();
            }
            catch ( SQLException e )
            {
                    System.out.println( e.getMessage() );
                    e.printStackTrace();
            }
            catch( Exception e )
            {
                System.out.println( e.getMessage() );
                e.printStackTrace();
            }
            finally
            {
                try
                {
                    //
                    if ( stm != null )
                        stm.close();
                }
                catch ( SQLException e )
                {
                    System.out.println( e.getMessage() );
                    e.printStackTrace();
                }

                // *** do not close the "default" connection ***
            }
        }
    }

    //
    public static void log_error( String text ) { log( ERROR, text ); }
    public static void log_warn(  String text ) { log( WARN,  text ); }
    public static void log_info(  String text ) { log( INFO,  text ); }
    public static void log_debug( String text ) { log( DEBUG, text ); }

    //
    public static int log_level()
    {
        int lvl = NONE;

        try
        {
            String prop = System.getProperty( "ws.system.loglevel" );

            if ( prop != null )
                lvl = Integer.parseInt( prop );
            else
                lvl = NONE;
        }
        catch ( NumberFormatException e )
        {
            lvl = NONE;
        }

        return lvl;
    }

    //
    public static void load_properties()
    {
        Connection con = null;
        PreparedStatement stm = null;

        //
        try
        {
            String sql = "select a.name, "
                       +        "a.value "
                       +   "from ws$prop$ a";

            //
            con = new OracleDriver().defaultConnection();

            //
            stm = con.prepareStatement( sql );
            ResultSet rst = stm.executeQuery();

            //
            while ( rst.next() )
            {
                String n = rst.getString( "name" );
                String v = rst.getString( "value" );

                if ( ( n != null ) && ( v != null ) )
                    System.setProperty( n, v );
            }   

            //
            rst.close();
            stm.close();
        }
        catch ( SQLException e )
        {
            log_error( getStackTrace( e ) );
        }
        catch( Exception e )
        {
            log_error( getStackTrace( e ) );
        }
        finally
        {
            try
            {
                //
                if ( stm != null )
                    stm.close();
            }
            catch ( SQLException e )
            {
                log_error( getStackTrace( e ) );
            }

            // *** do not close the "default" connection ***
        }
    }

    //
    public static void log_level( int lvl )
    {
        if ( lvl > 0  )
        {
            System.setProperty( "ws.system.loglevel", String.valueOf( lvl ) );
            log_debug( "Reset session log level to value: " + String.valueOf( lvl ) );
        }
        else
            log_warn( "Cannot set session log level to value: " + String.valueOf( lvl ) );
    }

    //
    public static void print( String message )
    {
        String prop = System.getProperty( "ws.system.output" );

        if ( ( prop != null ) && prop.equalsIgnoreCase( "enabled" ) )
            System.out.println( message );

        //
        log_debug( message );
    }

    //
    public static void set( properties prop )
    {
        if ( prop != null )
        {
            for ( property p : prop.list )
                System.setProperty( p.name, p.value );
        }
    }

    //
    static public Clob to_clob( String val )
    {
        //
        Clob clob = null;
        Connection con = null;

        //
        try
        {
            //
            con = DriverManager.getConnection( "jdbc:default:connection:" );

            //
            clob = con.createClob();

            if ( ( val != null ) && ( val.length() > 0 ) )
                clob.setString( 1, val );
            else
                clob.setString( 1, "" );
        }
        catch ( SQLException ex )
        {
            //
            log_error( sys.getStackTrace( ex ) );
        }
        catch ( Exception ex )
        {
            //
            log_error( sys.getStackTrace( ex ) );
        }
        finally
        {
            // ... nothing to do
        }

        //
        return clob;
    }
};
/

show errors

--
-- ...done!
--
