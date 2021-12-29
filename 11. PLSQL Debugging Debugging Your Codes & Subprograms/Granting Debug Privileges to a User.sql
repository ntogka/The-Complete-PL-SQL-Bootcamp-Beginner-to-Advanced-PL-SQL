/* 
1)You need to connect with the "SYS" or "SYSTEM" user, 
2)Execute the following codes to be able to debug your PL/SQL codes & subprograms.
3)You can grant debug privileges to another user by replacing HR within the following codes if you need to.
*/
 
GRANT DEBUG CONNECT SESSION TO hr;
GRANT DEBUG ANY PROCEDURE TO hr;
 
BEGIN
    dbms_network_acl_admin.append_host_ace
           (host=>'127.0.0.1',
            ace=> sys.xs$ace_type(privilege_list=>sys.xs$name_list('JDWP') ,
                           principal_name=>'HR',
                           principal_type=>sys.xs_acl.ptype_db) );
END;