-----------------An anonymous block example
declare
    cursor c_emps is select * from employees_copy for update;
    v_salary_increase number:= 1.10;
    v_old_salary number;
begin
    for r_emp in c_emps loop
      v_old_salary := r_emp.salary;
      r_emp.salary := r_emp.salary*v_salary_increase + r_emp.salary * nvl(r_emp.commission_pct,0);
      update employees_copy set row = r_emp where current of c_emps;
      dbms_output.put_line('The salary of : '|| r_emp.employee_id 
                            || ' is increased from '||v_old_salary||' to '||r_emp.salary);
    end loop;
end;
-----------------An anonymous block example 2 
declare
    cursor c_emps is select * from employees_copy for update;
    v_salary_increase number:= 1.10;
    v_old_salary number;
    v_new_salary number;
    v_salary_max_limit pls_integer := 20000;
begin
    for r_emp in c_emps loop
      v_old_salary := r_emp.salary;
      --check salary area
      v_new_salary := r_emp.salary*v_salary_increase + r_emp.salary * nvl(r_emp.commission_pct,0);
      if v_new_salary > v_salary_max_limit then
       RAISE_APPLICATION_ERROR(-20000, 'The new salary of '||r_emp.first_name|| ' cannot be higher than '|| v_salary_max_limit);
      end if;
      r_emp.salary := r_emp.salary*v_salary_increase + r_emp.salary * nvl(r_emp.commission_pct,0);
      ----------
      update employees_copy set row = r_emp where current of c_emps;
      dbms_output.put_line('The salary of : '|| r_emp.employee_id 
                            || ' is increased from '||v_old_salary||' to '||r_emp.salary);
    end loop;
end;