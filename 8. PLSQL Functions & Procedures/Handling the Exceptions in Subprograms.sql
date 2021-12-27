----------------- An unhandled exception in function
create or replace function get_emp(emp_num employees.employee_id%type) return employees%rowtype is
  emp employees%rowtype;
 begin
   select * into emp from employees where employee_id = emp_num;
  return emp;
 end;
----------------- calling that function in an anonymous block
declare
  v_emp employees%rowtype;
begin
  dbms_output.put_line('Fetching the employee data!..');
  v_emp := get_emp(10);
  dbms_output.put_line('Some information of the employee are : ');
  dbms_output.put_line('The name of the employee is : '|| v_emp.first_name);
  dbms_output.put_line('The email of the employee is : '|| v_emp.email);
  dbms_output.put_line('The salary of the employee is : '|| v_emp.salary);
end;
----------------- hanling the exception wihout the return clause - not working
create or replace function get_emp(emp_num employees.employee_id%type) return employees%rowtype is
  emp employees%rowtype;
 begin
   select * into emp from employees where employee_id = emp_num;
  return emp;
 exception
  when no_data_found then
    dbms_output.put_line('There is no employee with the id '|| emp_num);
 end;
----------------- handling and raising the exception
create or replace function get_emp(emp_num employees.employee_id%type) return employees%rowtype is
  emp employees%rowtype;
 begin
   select * into emp from employees where employee_id = emp_num;
  return emp;
 exception
  when no_data_found then
    dbms_output.put_line('There is no employee with the id '|| emp_num);
    raise no_data_found;
 end;
----------------- handling all possible exception cases
create or replace function get_emp(emp_num employees.employee_id%type) return employees%rowtype is
  emp employees%rowtype;
 begin
   select * into emp from employees where employee_id = emp_num;
  return emp;
 exception
  when no_data_found then
    dbms_output.put_line('There is no employee with the id '|| emp_num);
    raise no_data_found;
  when others then
    dbms_output.put_line('Something unexpected happened!.');
 return null;
 end;