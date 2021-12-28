---------------------------------------------------------------------------------------------
--------------------------------USING UPDATE OF EVENT IN TRIGGERS----------------------------
---------------------------------------------------------------------------------------------
create or replace trigger prevent_updates_of_constant_columns
before update of hire_date,salary on employees_copy 
for each row
begin
  raise_application_error(-20005,'You cannot modify the hire_date and salary columns');
end;