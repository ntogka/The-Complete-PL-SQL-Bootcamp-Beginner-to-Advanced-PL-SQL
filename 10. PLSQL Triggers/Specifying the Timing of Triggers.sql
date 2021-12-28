---------------------------------------------------------------------------------------------
------------------------------SPECIFYING THE TIMING OF TRIGGERS------------------------------
---------------------------------------------------------------------------------------------
----------------- The create code of the first trigger
create or replace trigger first_trigger 
before insert or update on employees_copy 
begin
  dbms_output.put_line('An insert or update occurred in employees_copy table!.');
end;
----------------- sql commands to or not to run the trigger
update employees_copy set salary = salary + 100;
delete from employees_copy;