declare
 v_name varchar2(50);
 v_salary employees.salary%type;
begin
  select first_name ||' '|| last_name, salary into v_name, v_salary  from employees where employee_id = 130;
  dbms_output.put_line('The salary of '|| v_name || ' is : '|| v_salary);
end;
------------------------------
declare
 v_name varchar2(50);
 sysdates employees.hire_date%type;
begin
  select first_name ||' '|| last_name, sysdates into v_name, sysdates from employees where employee_id = 130;
  dbms_output.put_line('The salary of '|| v_name || ' is : '|| sysdates);
end;
------------------------------
declare
 v_name varchar2(50);
 v_sysdate employees.hire_date%type;
 employee_id employees.employee_id%type := 130;
begin
  select first_name ||' '|| last_name, sysdate into v_name, v_sysdate from employees where employee_id = employee_id;
  dbms_output.put_line('The salary of '|| v_name || ' is : '|| v_sysdate );
end;
------------------------------
declare
 v_name varchar2(50);
 v_salary employees.salary%type;
 v_employee_id employees.employee_id%type := 130;
begin
  select first_name ||' '|| last_name, salary into v_name, v_salary from employees where employee_id = v_employee_id;
  dbms_output.put_line('The salary of '|| v_name || ' is : '|| v_salary );
end;