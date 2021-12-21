--Anonymous Block
DECLARE 
BEGIN
NULL;
END; 

--PL/SQL OUTPUTS
SET SERVEROUTPUT ON;
BEGIN
dbms_output.put_line('HELLO WORLD');
	BEGIN
        dbms_output.put_line('PL/SQL');
    END;
END; 