CREATE TABLE names (ID NUMBER PRIMARY KEY, NAME VARCHAR2(100));
/
CREATE OR REPLACE FUNCTION insert_values (ID IN VARCHAR2, NAME IN VARCHAR2) RETURN PLS_INTEGER IS
BEGIN
    EXECUTE IMMEDIATE 'INSERT INTO names VALUES(:a, :b)' USING ID,NAME;
    RETURN SQL%rowcount;
END;
/
SET SERVEROUTPUT ON;
DECLARE 
    v_affected_rows PLS_INTEGER;
BEGIN
    v_affected_rows := insert_values(2,'John');
    dbms_output.put_line(v_affected_rows|| ' row inserted!');
END;
/
SELECT * FROM names;
/
ALTER TABLE names ADD (last_name VARCHAR2(100));
/
CREATE OR REPLACE FUNCTION update_names (ID IN VARCHAR2, last_name IN VARCHAR2) RETURN PLS_INTEGER IS
    v_dynamic_sql VARCHAR2(200);
BEGIN
    v_dynamic_sql := 'UPDATE names SET last_name = :1 WHERE id = :2' ;
    EXECUTE IMMEDIATE v_dynamic_sql USING last_name, ID;
    RETURN SQL%rowcount;
END;
/
DECLARE 
    v_affected_rows PLS_INTEGER;
BEGIN
    v_affected_rows := update_names(2,'Brown');
    dbms_output.put_line(v_affected_rows|| ' row updated!');
END;
/
CREATE OR REPLACE FUNCTION update_names (ID IN VARCHAR2, last_name IN OUT VARCHAR2) RETURN PLS_INTEGER IS
    v_dynamic_sql VARCHAR2(200);
BEGIN
    v_dynamic_sql := 'UPDATE names SET last_name = :1 WHERE id = :2' ;
    EXECUTE IMMEDIATE v_dynamic_sql USING IN OUT last_name, ID;
    RETURN SQL%rowcount;
END;
/
CREATE OR REPLACE FUNCTION update_names (ID IN VARCHAR2, last_name IN VARCHAR2, first_name OUT VARCHAR2) RETURN PLS_INTEGER IS
    v_dynamic_sql VARCHAR2(200);
BEGIN
    v_dynamic_sql := 'UPDATE names SET last_name = :1 WHERE id = :2 :3' ;
    EXECUTE IMMEDIATE v_dynamic_sql USING last_name, ID, OUT first_name;
    RETURN SQL%rowcount;
END;
/
DECLARE 
    v_affected_rows PLS_INTEGER;
    v_first_name VARCHAR2(100);
BEGIN
    v_affected_rows := update_names(2,'KING',v_first_name);
    dbms_output.put_line(v_affected_rows|| ' row updated!');
    dbms_output.put_line(v_first_name);
END;
/
CREATE OR REPLACE FUNCTION update_names (ID IN VARCHAR2, last_name IN VARCHAR2, first_name OUT VARCHAR2) RETURN PLS_INTEGER IS
    v_dynamic_sql VARCHAR2(200);
BEGIN
    v_dynamic_sql := 'UPDATE names SET last_name = :1 WHERE id = :2 RETURNING name INTO :3' ;
    EXECUTE IMMEDIATE v_dynamic_sql USING last_name, ID RETURNING INTO first_name;
    RETURN SQL%rowcount;
END;
/
DROP TABLE names;
DROP FUNCTION insert_values;
DROP FUNCTION update_names;