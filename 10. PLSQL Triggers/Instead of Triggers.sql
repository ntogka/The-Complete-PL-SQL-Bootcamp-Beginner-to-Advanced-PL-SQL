---------------------------------------------------------------------------------------------
-----------------------------------USING INSTEAD OF TRIGGERS---------------------------------
---------------------------------------------------------------------------------------------
----------------- creating a complex view -----------------
CREATE OR REPLACE VIEW VW_EMP_DETAILS AS
  SELECT UPPER(DEPARTMENT_NAME) DNAME, MIN(SALARY) MIN_SAL, MAX(SALARY) MAX_SAL 
    FROM EMPLOYEES_COPY JOIN DEPARTMENTS_COPY
    USING (DEPARTMENT_ID)
    GROUP BY DEPARTMENT_NAME;
----------------- updating the complex view -----------------
UPDATE VW_EMP_DETAILS SET DNAME = 'EXEC DEPT' WHERE
  UPPER(DNAME) = 'EXECUTIVE';
----------------- Instead of trigger -----------------
CREATE OR REPLACE TRIGGER EMP_DETAILS_VW_DML
  INSTEAD OF INSERT OR UPDATE OR DELETE ON VW_EMP_DETAILS
  FOR EACH ROW
  DECLARE
    V_DEPT_ID PLS_INTEGER;
  BEGIN
  
  IF INSERTING THEN
    SELECT MAX(DEPARTMENT_ID) + 10 INTO V_DEPT_ID FROM DEPARTMENTS_COPY;
    INSERT INTO DEPARTMENTS_COPY VALUES (V_DEPT_ID, :NEW.DNAME,NULL,NULL);
  ELSIF DELETING THEN
    DELETE FROM DEPARTMENTS_COPY WHERE UPPER(DEPARTMENT_NAME) = UPPER(:OLD.DNAME);
  ELSIF UPDATING('DNAME') THEN
    UPDATE DEPARTMENTS_COPY SET DEPARTMENT_NAME = :NEW.DNAME
      WHERE UPPER(DEPARTMENT_NAME) = UPPER(:OLD.DNAME);
  ELSE
    RAISE_APPLICATION_ERROR(-20007,'You cannot update any data other than department name!.');
  END IF;
END;