--------------------------------------------------------------------------------
--
-- 2016-07-14, NV - ws.prm.sql
--

--
prompt ... running ws.prm.sql

--
exec dbms_java.grant_permission( 'WS', 'SYS:java.util.PropertyPermission', '*', 'read' );
exec dbms_java.grant_permission( 'WS', 'SYS:java.util.PropertyPermission', '*', 'write' );
exec dbms_java.grant_permission( 'WS', 'SYS:java.net.SocketPermission', '*', 'connect' );
exec dbms_java.grant_permission( 'WS', 'SYS:java.net.SocketPermission', '*', 'resolve' );
exec dbms_java.grant_permission( 'WS', 'SYS:java.io.FilePermission', '*', 'read' );

--
exec dbms_java.grant_permission( 'WS', 'SYS:java.security.SecurityPermission', 'insertProvider.SunJSSE', '' );
exec dbms_java.grant_permission( 'WS', 'SYS:java.lang.RuntimePermission', 'setFactory', '' );
exec dbms_java.grant_permission( 'WS', 'SYS:javax.net.ssl.SSLPermission', 'setHostnameVerifier', '' );

--
exec dbms_java.grant_permission( 'WS', 'SYS:java.util.PropertyPermission', '*', '*' );
exec dbms_java.grant_permission( 'WS', 'SYS:java.net.SocketPermission', '*', '*' );
exec dbms_java.grant_permission( 'WS', 'SYS:java.io.FilePermission', '*', '*' );
exec dbms_java.grant_permission( 'WS', 'SYS:java.security.SecurityPermission', '*', '' );
exec dbms_java.grant_permission( 'WS', 'SYS:java.lang.RuntimePermission', '*', '' );
exec dbms_java.grant_permission( 'WS', 'SYS:javax.net.ssl.SSLPermission', '*', '' );

--
-- ... done!
--
