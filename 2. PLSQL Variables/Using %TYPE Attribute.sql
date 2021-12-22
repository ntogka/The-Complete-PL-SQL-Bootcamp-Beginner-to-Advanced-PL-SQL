set serveroutput on
desc employees;
declare
 V_TYPE employees.JOB_ID%TYPE;
 V_TYPE2 V_TYPE%TYPE;
 V_TYPE3 employees.JOB_ID%TYPE ;
begin
 v_type := 'IT_PROG';
 v_type2 := 'SA_MAN';
 v_type3 := NULL;
 dbms_output.put_line(v_type);
 dbms_output.put_line(v_type2);
 dbms_output.put_line('HELLO' || v_type3);
end;