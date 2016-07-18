--------------------------------------------------------------------------------
--
-- 2016-07-14, NV - ws.prm.sql
--

--
prompt ... running ws.prm.sql

--
exec dbms_java.grant_permission( 'WS', 'java.util.PropertyPermission', '*', 'read' );
exec dbms_java.grant_permission( 'WS', 'java.util.PropertyPermission', '*', 'write' );
exec dbms_java.grant_permission( 'WS', 'java.net.SocketPermission', '*', 'connect' );
exec dbms_java.grant_permission( 'WS', 'java.net.SocketPermission', '*', 'resolve' );
exec dbms_java.grant_permission( 'WS', 'java.io.FilePermission', '*', 'read' );

--
exec dbms_java.grant_permission( 'WS', 'java.security.SecurityPermission', 'insertProvider.SunJSSE', '' );
exec dbms_java.grant_permission( 'WS', 'java.lang.RuntimePermission', 'setFactory', '' );
exec dbms_java.grant_permission( 'WS', 'javax.net.ssl.SSLPermission', 'setHostnameVerifier', '' );

--
-- ... done!
--
