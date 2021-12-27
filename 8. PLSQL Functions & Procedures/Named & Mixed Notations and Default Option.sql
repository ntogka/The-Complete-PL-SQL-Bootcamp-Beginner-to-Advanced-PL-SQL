----------------- A standard procedure creation with a default value
create or replace PROCEDURE PRINT(TEXT IN VARCHAR2 := 'This is the print function!.') IS
BEGIN
  DBMS_OUTPUT.PUT_LINE(TEXT);
END;
-----------------Executing a procedure without any parameter. It runs because it has a default value.
exec print();
-----------------Running a procedure with null value will not use the default value 
exec print(null);
-----------------Procedure creation of a default value usage
create or replace procedure add_job(job_id pls_integer, job_title varchar2, 
                                    min_salary number default 1000, max_salary number default null) is
begin
  insert into jobs values (job_id,job_title,min_salary,max_salary);
  print('The job : '|| job_title || ' is inserted!..');
end;
-----------------A standard run of the procedure
exec ADD_JOB('IT_DIR','IT Director',5000,20000); 
-----------------Running a procedure with using the default values
exec ADD_JOB('IT_DIR2','IT Director',5000); 
-----------------Running a procedure with the named notation
exec ADD_JOB('IT_DIR5','IT Director',max_salary=>10000); 
-----------------Running a procedure with the named notation example 2
exec ADD_JOB(job_title=>'IT Director',job_id=>'IT_DIR7',max_salary=>10000 , min_salary=>500);