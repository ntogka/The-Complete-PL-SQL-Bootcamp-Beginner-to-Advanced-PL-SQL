    declare
    too_high_salary exception;
    v_salary_check pls_integer;
    begin
      select salary into v_salary_check from employees where employee_id = 100;
      if v_salary_check > 20000 then
        --raise too_high_salary;
     raise_application_error(-20243,'The salary of the selected employee is too high!');
      end if;
      --we do our business if the salary is under 2000
      dbms_output.put_line('The salary is in an acceptable range');
    exception
      when too_high_salary then
      dbms_output.put_line('This salary is too high. You need to decrease it.');
    end;
    ----------------- raise inside of the exception section
    declare
    too_high_salary exception;
    v_salary_check pls_integer;
    begin
      select salary into v_salary_check from employees where employee_id = 100;
      if v_salary_check > 20000 then
        raise too_high_salary;
      end if;
      --we do our business if the salary is under 2000
      dbms_output.put_line('The salary is in an acceptable range');
    exception
      when too_high_salary then
      dbms_output.put_line('This salary is too high. You need to decrease it.');
      raise_application_error(-01403,'The salary of the selected employee is too high!',true);
    end;