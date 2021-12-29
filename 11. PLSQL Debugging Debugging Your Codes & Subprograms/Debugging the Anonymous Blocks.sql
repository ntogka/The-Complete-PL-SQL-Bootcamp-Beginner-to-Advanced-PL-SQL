/*Lecture: Debugging the Anonymous Blocks*/
DECLARE
 CURSOR c_emps IS SELECT * FROM employees_copy;
BEGIN
 dbms_output.put_line('Update started at : '|| systimestamp);
    FOR r_emp IN c_emps LOOP
        IF NVL(r_emp.commission_pct,0) = 0 THEN
            UPDATE employees_copy SET commission_pct = 0.3 WHERE employee_id = r_emp.employee_id;
        end if;
    END LOOP;
 dbms_output.put_line('Update finished at : '|| systimestamp);
 ROLLBACK;
END;