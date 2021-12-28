---------------------------------------------------------------------------------------------
------------------------------------- COMPOUND TRIGGERS -------------------------------------
---------------------------------------------------------------------------------------------
----------------- The first simple compound trigger
create or replace trigger trg_comp_emps
for insert or update or delete on employees_copy 
compound trigger
v_dml_type varchar2(10);
  before statement is
   begin
    if inserting then
      v_dml_type := 'INSERT';
    elsif updating then
      v_dml_type := 'UPDATE';
    elsif deleting then
      v_dml_type := 'DELETE';
    end if;
    dbms_output.put_line('Before statement section is executed with the '||v_dml_type ||' event!.');
  end before statement; 
  before each row is
  t number;
    begin
      dbms_output.put_line('Before row section is executed with the '||v_dml_type ||' event!.');
  end before each row;
  after each row is
    begin
      dbms_output.put_line('After row section is executed with the '||v_dml_type ||' event!.');
  end after each row;
  after statement is
    begin
      dbms_output.put_line('After statement section is executed with the '||v_dml_type ||' event!.');
  end after statement;
end;
----------------- 
CREATE OR REPLACE TRIGGER TRG_COMP_EMPS
  FOR INSERT OR UPDATE OR DELETE ON EMPLOYEES_COPY
  COMPOUND TRIGGER
    TYPE T_AVG_DEPT_SALARIES IS TABLE OF EMPLOYEES_COPY.SALARY%TYPE INDEX BY PLS_INTEGER;
    AVG_DEPT_SALARIES T_AVG_DEPT_SALARIES;
  
  BEFORE STATEMENT IS
    BEGIN
      FOR AVG_SAL IN (SELECT AVG(SALARY) SALARY , NVL(DEPARTMENT_ID,999) DEPARTMENT_ID
                        FROM EMPLOYEES_COPY GROUP BY DEPARTMENT_ID) LOOP
        AVG_DEPT_SALARIES(AVG_SAL.DEPARTMENT_ID) := AVG_SAL.SALARY;
      END LOOP;
  END BEFORE STATEMENT;
  
  AFTER EACH ROW IS
    V_INTERVAL NUMBER := 15;
    BEGIN
       IF :NEW.SALARY > AVG_DEPT_SALARIES(:NEW.DEPARTMENT_ID) + AVG_DEPT_SALARIES(:NEW.DEPARTMENT_ID)*V_INTERVAL/100 THEN
        RAISE_APPLICATION_ERROR(-20005,'A raise cannot be '|| V_INTERVAL|| ' percent higher than
                                  its department''s average!');
       END IF;
  END AFTER EACH ROW;
  
  AFTER STATEMENT IS
    BEGIN
      DBMS_OUTPUT.PUT_LINE('All the changes are done successfully!');
  END AFTER STATEMENT;
 
END;