--------------------------------------------------------------------------------------------------------------------
--------------------------------------------CREATING & USING PACKAGES-----------------------------------------------
--------------------------------------------------------------------------------------------------------------------
----------------- Creating first package specification
CREATE OR REPLACE 
PACKAGE EMP AS 
  v_salary_increase_rate number := 0.057; 
  cursor cur_emps is select * from employees;
  
  procedure increase_salaries;
  function get_avg_sal(p_dept_id int) return number;
END EMP;
----------------- Creating the package body
CREATE OR REPLACE
PACKAGE BODY EMP AS
  procedure increase_salaries AS
  BEGIN
    for r1 in cur_emps loop
      update employees_copy set salary = salary + salary * v_salary_increase_rate;
    end loop;
  END increase_salaries;
  function get_avg_sal(p_dept_id int) return number AS
  v_avg_sal number := 0;
  BEGIN
    select avg(salary) into v_avg_sal from employees_copy where
          department_id = p_dept_id;
    RETURN v_avg_sal;
  END get_avg_sal;
END EMP;
----------------- using the subprograms in packages
exec EMP_PKG.increase_salaries;
----------------- using the variables in packages
begin
  dbms_output.put_line(emp_pkg.get_avg_sal(50));
  dbms_output.put_line(emp_pkg.v_salary_increase_rate);
end;