    declare
      v_name varchar2(6);
    begin
      select first_name into v_name from employees where employee_id = 50;
      dbms_output.put_line('Hello');
    end;