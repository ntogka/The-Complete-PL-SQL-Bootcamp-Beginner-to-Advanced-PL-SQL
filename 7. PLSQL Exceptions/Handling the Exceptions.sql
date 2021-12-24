    ----------------- Handling the exception
    declare
      v_name varchar2(6);
    begin
      select first_name into v_name from employees where employee_id = 50;
      dbms_output.put_line('Hello');
    exception
      when no_data_found then
        dbms_output.put_line('There is no employee with the selected id');
    end;
    ----------------- Handling multiple exceptions
    declare
      v_name varchar2(6);
      v_department_name varchar2(100);
    begin
      select first_name into v_name from employees where employee_id = 100;
      select department_id into v_department_name from employees where first_name = v_name;
      dbms_output.put_line('Hello '|| v_name || '. Your department id is : '|| v_department_name );
    exception
      when no_data_found then
        dbms_output.put_line('There is no employee with the selected id');
      when too_many_rows then
        dbms_output.put_line('There are more than one employees with the name '|| v_name);
        dbms_output.put_line('Try with a different employee');
    end;
    ----------------- when others then example
    declare
      v_name varchar2(6);
      v_department_name varchar2(100);
    begin
      select first_name into v_name from employees where employee_id = 103;
      select department_id into v_department_name from employees where first_name = v_name;
      dbms_output.put_line('Hello '|| v_name || '. Your department id is : '|| v_department_name );
    exception
      when no_data_found then
        dbms_output.put_line('There is no employee with the selected id');
      when too_many_rows then
        dbms_output.put_line('There are more than one employees with the name '|| v_name);
        dbms_output.put_line('Try with a different employee');
      when others then
        dbms_output.put_line('An unexpected error happened. Connect with the programmer..');
    end;
    ----------------- sqlerrm & sqlcode example
    declare
      v_name varchar2(6);
      v_department_name varchar2(100);
    begin
      select first_name into v_name from employees where employee_id = 103;
      select department_id into v_department_name from employees where first_name = v_name;
      dbms_output.put_line('Hello '|| v_name || '. Your department id is : '|| v_department_name );
    exception
      when no_data_found then
        dbms_output.put_line('There is no employee with the selected id');
      when too_many_rows then
        dbms_output.put_line('There are more than one employees with the name '|| v_name);
        dbms_output.put_line('Try with a different employee');
      when others then
        dbms_output.put_line('An unexpected error happened. Connect with the programmer..');
        dbms_output.put_line(sqlcode || ' ---> '|| sqlerrm);
    end;
    ----------------- Inner block exception example
    declare
      v_name varchar2(6);
      v_department_name varchar2(100);
    begin
      select first_name into v_name from employees where employee_id = 100;
      begin
        select department_id into v_department_name from employees where first_name = v_name;
        exception
          when too_many_rows then
          v_department_name := 'Error in department_name';
      end;
      dbms_output.put_line('Hello '|| v_name || '. Your department id is : '|| v_department_name );
    exception
      when no_data_found then
        dbms_output.put_line('There is no employee with the selected id');
      when too_many_rows then
        dbms_output.put_line('There are more than one employees with the name '|| v_name);
        dbms_output.put_line('Try with a different employee');
      when others then
        dbms_output.put_line('An unexpected error happened. Connect with the programmer..');
        dbms_output.put_line(sqlcode || ' ---> '|| sqlerrm);
    end;
    /
    select * from employees where first_name = 'Steven';