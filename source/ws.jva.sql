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
    public static void print( String message )
    {
        String prop = System.getProperty( "ws.system.output" );

        if ( ( prop != null ) && prop.equalsIgnoreCase( "enabled" ) )
            System.out.println( message );
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
            ex.printStackTrace();
        }
        catch ( Exception ex )
        {
            //
            ex.printStackTrace();
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
