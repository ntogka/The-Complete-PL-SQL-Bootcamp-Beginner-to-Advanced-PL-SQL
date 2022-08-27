CREATE OR REPLACE FUNCTION get_count (table_name IN VARCHAR2) RETURN PLS_INTEGER IS
    v_count PLS_INTEGER;
BEGIN
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || table_name INTO v_count;
    RETURN v_count;
END;
/
SET SERVEROUTPUT ON;
BEGIN
    dbms_output.put_line('There are '||get_count('employees')||' rows in the employees table!');
END;
/
DECLARE
    v_table_name VARCHAR2(50);
BEGIN
    FOR r_table IN (SELECT table_name FROM user_tables) LOOP
        dbms_output.put_line('There are '||get_count(r_table.table_name)||' rows in the '||r_table.table_name||' table!');
    END LOOP;
END;
/
DECLARE
    v_table_name VARCHAR2(50);
BEGIN
    FOR r_table IN (SELECT table_name FROM user_tables) LOOP
        IF get_count(r_table.table_name) > 100 THEN
            dbms_output.put_line('There are '||get_count(r_table.table_name)||' rows in the '||r_table.table_name||' table!');
            dbms_output.put_line('It should be considered for partitioning');
        END IF;
    END LOOP;
END;
/
 
CREATE TABLE stock_managers AS SELECT * FROM employees WHERE job_id = 'ST_MAN';
/
CREATE TABLE stock_clerks AS SELECT * FROM employees WHERE job_id = 'ST_CLERK';
/
CREATE OR REPLACE FUNCTION get_avg_sals (p_table IN VARCHAR2, p_dept_id IN NUMBER) RETURN PLS_INTEGER IS
    v_average PLS_INTEGER;
BEGIN
    EXECUTE IMMEDIATE 'SELECT AVG(salary) FROM :1 WHERE department_id = :2' INTO v_average USING p_table, p_dept_id;
    RETURN v_average;
END;
/
SELECT get_avg_sals('stock_clerks','50') FROM dual;
/
CREATE OR REPLACE FUNCTION get_avg_sals (p_table IN VARCHAR2, p_dept_id IN NUMBER) RETURN PLS_INTEGER IS
    v_average PLS_INTEGER;
BEGIN
    EXECUTE IMMEDIATE 'SELECT AVG(salary) FROM '||p_table||' WHERE department_id = :2' INTO v_average USING p_dept_id;
    RETURN v_average;
END;
/
SELECT get_avg_sals('stock_managers','50') FROM dual;
/
DROP FUNCTION get_count;
DROP FUNCTION get_avg_sals;
DROP TABLE stock_clerks;
DROP TABLE stock_managers;