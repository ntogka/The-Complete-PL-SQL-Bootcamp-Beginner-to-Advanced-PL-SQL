---------------------------------------------------------------------------------------------
-------------------------------STATEMENT & ROW LEVEL TRIGGERS--------------------------------
---------------------------------------------------------------------------------------------
----------------- before statement level trigger example
create or replace trigger before_statement_emp_cpy 
before insert or update on employees_copy 
begin
  dbms_output.put_line('Before Statement Trigger is Fired!.');
end;
----------------- after statement level trigger example
create or replace trigger after_statement_emp_cpy 
after insert or update on employees_copy 
begin
  dbms_output.put_line('After Statement Trigger is Fired!.');
end;
----------------- before row level trigger example
create or replace trigger before_row_emp_cpy 
before insert or update on employees_copy 
for each row
begin
  dbms_output.put_line('Before Row Trigger is Fired!.');
end;
----------------- after row level trigger example
create or replace trigger after_row_emp_cpy 
after insert or update on employees_copy 
for each row
begin
  dbms_output.put_line('After Row Trigger is Fired!.');
end;
----------------- sql queries used in this lecture
update employees_copy set salary = salary + 100 where employee_id = 100;
update employees_copy set salary = salary + 100 where employee_id = 99;
update employees_copy set salary = salary + 100
where department_id = 30;