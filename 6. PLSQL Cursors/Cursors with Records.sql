    declare
      type r_emp is record (  v_first_name employees.first_name%type,
                               v_last_name employees.last_name%type);
      v_emp r_emp;
      cursor c_emps is select first_name,last_name from employees;
    begin
      open c_emps;
      fetch c_emps into v_emp;
      dbms_output.put_line(v_emp.v_first_name|| ' ' || v_emp.v_last_name);
      close c_emps;
    end;
    --------------- An example for using cursors table rowtype
    declare
      v_emp employees%rowtype;
      cursor c_emps is select first_name,last_name from employees;
    begin
      open c_emps;
      fetch c_emps into v_emp.first_name,v_emp.last_name;
      dbms_output.put_line(v_emp.first_name|| ' ' || v_emp.last_name);
      close c_emps;
    end;
    --------------- An example for using cursors with cursor%rowtype.
    declare
      cursor c_emps is select first_name,last_name from employees;
      v_emp c_emps%rowtype;
    begin
      open c_emps;
      fetch c_emps into v_emp.first_name,v_emp.last_name;
      dbms_output.put_line(v_emp.first_name|| ' ' || v_emp.last_name);
      close c_emps;
    end;