declare
  procedure insert_high_paid_emp(p_emp employees%rowtype) is 
    emp employees%rowtype;
    e_id number;
    function get_emp(emp_num employees.employee_id%type) return employees%rowtype is
      begin
        select * into emp from employees where employee_id = emp_num;
        return emp;
      end;
    function get_emp(emp_email employees.email%type) return employees%rowtype is
      begin
        select * into emp from employees where email = emp_email;
        return emp;
      end;
    begin
      emp := get_emp(p_emp.employee_id);
      insert into emps_high_paid values emp;
    end;
begin
  for r_emp in (select * from employees) loop
    if r_emp.salary > 15000 then
      insert_high_paid_emp(r_emp);
    end if;
  end loop;
end;
----------------- overloading with multiple usages
declare
  procedure insert_high_paid_emp(p_emp employees%rowtype) is 
    emp employees%rowtype;
    e_id number;
    function get_emp(emp_num employees.employee_id%type) return employees%rowtype is
      begin
        select * into emp from employees where employee_id = emp_num;
        return emp;
      end;
    function get_emp(emp_email employees.email%type) return employees%rowtype is
      begin
        select * into emp from employees where email = emp_email;
        return emp;
      end;
    function get_emp(f_name varchar2, l_name varchar2) return employees%rowtype is
      begin
        select * into emp from employees where first_name = f_name and last_name = l_name;
        return emp;
      end;
    begin
      emp := get_emp(p_emp.employee_id);
      insert into emps_high_paid values emp;
      emp := get_emp(p_emp.email);
      insert into emps_high_paid values emp;
      emp := get_emp(p_emp.first_name,p_emp.last_name);
      insert into emps_high_paid values emp;
    end;
begin
  for r_emp in (select * from employees) loop
    if r_emp.salary > 15000 then
      insert_high_paid_emp(r_emp);
    end if;
  end loop;
end;