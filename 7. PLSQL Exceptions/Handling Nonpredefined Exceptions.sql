    begin
      UPDATE employees_copy set email = null where employee_id = 100;
    end;
    -----------------HANDLING a nonpredefined exception
    declare
      cannot_update_to_null exception;
      pragma exception_init(cannot_update_to_null,-01407);
    begin
      UPDATE employees_copy set email = null where employee_id = 100;
    exception
      when cannot_update_to_null then
        dbms_output.put_line('You cannot update with a null value!');
    end;