    --------------------------------------------------------------------------------------------------------------------
    ---------------------------------------------------VARRAYS----------------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------
     
    ---------------A simple working example
    Declare
      type e_list is varray(5) of varchar2(50);
      employees e_list;
    begin
      employees := e_list('Alex','Bruce','John','Bob','Richard');
      for i in 1..5 loop
        dbms_output.put_line(employees(i));
      end loop;
    end;
    ---------------limit exceeding error example
    declare
      type e_list is varray(4) of varchar2(50);
      employees e_list;
    begin
      employees := e_list('Alex','Bruce','John','Bob','Richard');
      for i in 1..5 loop
        dbms_output.put_line(employees(i));
      end loop;
    end;
    ---------------Subscript beyond cound error example
    declare
      type e_list is varray(5) of varchar2(50);
      employees e_list;
    begin
      employees := e_list('Alex','Bruce','John','Bob');
      for i in 1..5 loop
        dbms_output.put_line(employees(i));
      end loop;
    end;
    ---------------A working count() example
    declare
      type e_list is varray(5) of varchar2(50);
      employees e_list;
    begin
      employees := e_list('Alex','Bruce','John','Bob');
      for i in 1..employees.count() loop
        dbms_output.put_line(employees(i));
      end loop;
    end;
    ---------------A working first() last() functions example
    declare
      type e_list is varray(5) of varchar2(50);
      employees e_list;
    begin
      employees := e_list('Alex','Bruce','John','Bob');
      for i in employees.first()..employees.last() loop
        dbms_output.put_line(employees(i));
      end loop;
    end;
    --------------- A working exists() function example
    declare
      type e_list is varray(5) of varchar2(50);
      employees e_list;
    begin
      employees := e_list('Alex','Bruce','John','Bob');
      for i in 1..5 loop
        if employees.exists(i) then
          dbms_output.put_line(employees(i));
        end if;
      end loop;
    end;
    ---------------A working limit() function example
    declare
      type e_list is varray(5) of varchar2(50);
      employees e_list;
    begin
      employees := e_list('Alex','Bruce','John','Bob');
          dbms_output.put_line(employees.limit());
    end;
    --------------- A create-declare at the same time error example
    declare
      type e_list is varray(5) of varchar2(50);
      employees e_list('Alex','Bruce','John','Bob');
    begin
     -- employees := e_list('Alex','Bruce','John','Bob');
      for i in 1..5 loop
        if employees.exists(i) then
          dbms_output.put_line(employees(i));
        end if;
      end loop;
    end;
    --------------- A post insert varray example
    declare
      type e_list is varray(15) of varchar2(50);
      employees e_list := e_list();
      idx number := 1;
    begin
      for i in 100..110 loop
        employees.extend;
        select first_name into employees(idx) from employees where employee_id = i;
        idx := idx + 1;
      end loop;
      for x in 1..employees.count() loop
        dbms_output.put_line(employees(x));
      end loop;
    end;
    --------------- An example for the schema level varray types
    create type e_list is varray(15) of varchar2(50);
    /
    create or replace type e_list as varray(20) of varchar2(100);
    /
    declare
      employees e_list := e_list();
      idx number := 1;
    begin
      for i in 100..110 loop
        employees.extend;
        select first_name into employees(idx) from employees where employee_id = i;
        idx := idx + 1;
      end loop;
      for x in 1..employees.count() loop
        dbms_output.put_line(employees(x));
      end loop;
    end;
    /
    DROP TYPE E_LIST;