---------------------------------------------------------------------------------------------
-----------------------------------CREATING DISABLED TRIGGERS--------------------------------
---------------------------------------------------------------------------------------------  
create or replace trigger prevent_high_salary
before insert or update of salary on employees_copy 
for each row
disable
when (new.salary > 50000)
begin
  raise_application_error(-20006,'A salary cannot be higher than 50000!.');
end;