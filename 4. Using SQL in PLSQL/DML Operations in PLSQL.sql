create table employees_copy as select * from employees;
DECLARE
  v_employee_id pls_integer := 0;
  v_salary_increase number := 400;
begin
  for i in 217..226 loop
        insert into employees_copy 
      (employee_id,first_name,last_name,email,hire_date,job_id,salary)
    values 
      (i, 'employee#'||i,'temp_emp','abc@xmail.com',sysdate,'IT_PROG',1000);
   end loop;
end; 