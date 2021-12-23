    declare
      cursor c_emps is select first_name,last_name from employees;
      v_first_name employees.first_name%type;
      v_last_name employees.last_name%type;
    begin
      open c_emps;
      fetch c_emps into v_first_name,v_last_name;
      fetch c_emps into v_first_name,v_last_name;
      fetch c_emps into v_first_name,v_last_name;
      dbms_output.put_line(v_first_name|| ' ' || v_last_name);
      fetch c_emps into v_first_name,v_last_name;
      dbms_output.put_line(v_first_name|| ' ' || v_last_name);
      close c_emps;
    end;
    --------------- cursor with join example
    declare
      cursor c_emps is select first_name,last_name, department_name from employees
                          join departments using (department_id)
                          where department_id between 30 and 60;
      v_first_name employees.first_name%type;
      v_last_name employees.last_name%type;
      v_department_name departments.department_name%type;
    begin
      open c_emps;
      fetch c_emps into v_first_name, v_last_name,v_department_name;
      dbms_output.put_line(v_first_name|| ' ' || v_last_name|| ' in the department of '|| v_department_name);
      close c_emps;
    end;