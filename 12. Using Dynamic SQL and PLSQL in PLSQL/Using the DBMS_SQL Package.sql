CREATE TABLE employees_copy AS SELECT * FROM employees;
 
/
set serveroutput on;
DECLARE
    v_table_name VARCHAR2(20) := 'employees_copy';
    v_cursor_id PLS_INTEGER;
    v_affected_rows PLS_INTEGER;
BEGIN
    v_cursor_id := dbms_sql.open_cursor;
    dbms_sql.parse(v_cursor_id, 'update '||v_table_name||' set salary=salary+500',dbms_sql.NATIVE);
    v_affected_rows := dbms_sql.EXECUTE(v_cursor_id);
    dbms_output.put_line(v_affected_rows|| ' rows are updated by dbms_sql!');
    dbms_sql.close_cursor(v_cursor_id);
END;  
 
/
 
select * from employees_copy;
 
/
 
DECLARE
    v_table_name varchar2(20) := 'employees_copy';
    v_cursor_id pls_integer;
    v_affected_rows pls_integer;
BEGIN
    v_cursor_id := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(v_cursor_id, 'update '||v_table_name||' set salary=salary+500 WHERE job_id = :jid',DBMS_SQL.NATIVE);
    DBMS_SQL.BIND_VARIABLE(v_cursor_id, ':jid','IT_PROG');
    v_affected_rows := DBMS_SQL.EXECUTE(v_cursor_id);
    dbms_output.put_line(v_affected_rows|| ' rows are updated by dbms_sql!');
    DBMS_SQL.CLOSE_CURSOR(v_cursor_id);
END;
 
/
 
DECLARE
    v_table_name varchar2(20) := 'employees_copy';
    v_cursor_id pls_integer;
    v_affected_rows pls_integer;
BEGIN
    v_cursor_id := DBMS_SQL.OPEN_CURSOR;
    DBMS_SQL.PARSE(v_cursor_id, 'update '||v_table_name||' set salary=salary+:inc WHERE job_id = :jid',DBMS_SQL.NATIVE);
    DBMS_SQL.BIND_VARIABLE(v_cursor_id, ':jid','IT_PROG');
    DBMS_SQL.BIND_VARIABLE(v_cursor_id, ':inc','5');
    v_affected_rows := DBMS_SQL.EXECUTE(v_cursor_id);
    dbms_output.put_line(v_affected_rows|| ' rows are updated by dbms_sql!');
    DBMS_SQL.CLOSE_CURSOR(v_cursor_id);
END;  
 
/
 
SELECT * FROM user_tab_columns;
EXEC prc_method4_example('employees');
EXEC prc_method4_example('departments');
EXEC prc_method4_example('countries');
EXEC prc_method4_example('locations');
/
 
create or replace PROCEDURE prc_method4_example (p_table_name IN VARCHAR2) IS
    TYPE t_columns IS TABLE OF user_tab_columns%rowtype INDEX BY PLS_INTEGER;
    v_columns               t_columns;
    v_columns_with_commas   VARCHAR2(32767);
    v_number_value          NUMBER;
    v_string_value          VARCHAR2(32767);
    v_date_value            DATE;
    v_output_string         VARCHAR2(32767);
    cur_dynamic             INTEGER;
BEGIN
    SELECT * BULK COLLECT INTO v_columns FROM user_tab_columns WHERE table_name = upper(p_table_name);
    v_columns_with_commas:=v_columns(1).column_name;
    FOR i IN 2..v_columns.COUNT LOOP
        v_columns_with_commas:=v_columns_with_commas||','||v_columns(i).column_name;
    END LOOP;
    cur_dynamic := dbms_sql.open_cursor;
    dbms_sql.parse(cur_dynamic,'SELECT '||v_columns_with_commas||' FROM '||p_table_name,dbms_sql.NATIVE);
     FOR idx IN 1..v_columns.COUNT LOOP
        IF v_columns(idx).data_type = 'NUMBER' THEN
            dbms_sql.define_column(cur_dynamic,idx,1);
        ELSIF v_columns(idx).data_type IN ('VARCHAR2','VARCHAR','CHAR') THEN
            dbms_sql.define_column(cur_dynamic,idx,'dummy text',v_columns(idx).char_length);
        ELSIF v_columns(idx).data_type = 'DATE' THEN
            dbms_sql.define_column(cur_dynamic,idx,sysdate);
        END IF;
        v_output_string:=v_output_string||'  '||rpad(v_columns(idx).column_name,20);
     END LOOP;
     dbms_output.put_line(v_output_string);
     v_number_value:=dbms_sql.execute(cur_dynamic);
     WHILE dbms_sql.fetch_rows(cur_dynamic) > 0 LOOP
        v_output_string:=NULL;
        FOR t IN 1..v_columns.COUNT LOOP
            IF v_columns(T).data_type = 'NUMBER' THEN
                dbms_sql.column_value(cur_dynamic,t,v_number_value);
                v_output_string := v_output_string||'  '||rpad(nvl(to_char(v_number_value),' '),20);
            ELSIF v_columns(T).data_type IN ('VARCHAR2','VARCHAR','CHAR') THEN
                dbms_sql.column_value(cur_dynamic,t,v_string_value);
                v_output_string := v_output_string||'  '||rpad(nvl(to_char(v_string_value),' '),20);
            ELSIF v_columns(T).data_type = 'DATE' THEN
                dbms_sql.column_value(cur_dynamic,t,v_date_value);
                v_output_string := v_output_string||'  '||rpad(nvl(to_char(v_date_value),' '),20);
            END IF;
        END LOOP;
        dbms_output.put_line(v_output_string);
     END LOOP;
END;