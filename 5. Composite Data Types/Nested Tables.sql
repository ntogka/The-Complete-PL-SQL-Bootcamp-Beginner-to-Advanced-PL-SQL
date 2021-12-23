    --------------------------------------------------------------------------------------------------------------------
    -------------------------------------------------NESTED TABLES------------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------
    ---------------The simple usage of nested tables
    declare
      type e_list is table of varchar2(50);
      emps e_list;
    begin
      emps := e_list('Alex','Bruce','John');
      for i in 1..emps.count() loop
        dbms_output.put_line(emps(i));
      end loop;
    end;
    ---------------Adding a new value to a nested table after the initialization
    declare
      type e_list is table of varchar2(50);
      emps e_list;
    begin
      emps := e_list('Alex','Bruce','John');
      emps.extend;
      emps(4) := 'Bob';
      for i in 1..emps.count() loop
        dbms_output.put_line(emps(i));
      end loop;
    end;
    ---------------Adding values from the tabledeclare
      type e_list is table of employees.first_name%type;
      emps e_list := e_list();
      idx pls_integer := 1;
    begin
      for x in 100 .. 110 loop
        emps.extend;
        select first_name into emps(idx) from employees where employee_id = x;
        idx := idx + 1;
      end loop;
      for i in 1..emps.count() loop
        dbms_output.put_line(emps(i));
      end loop;
    end;
    ---------------delete example
    declare
      type e_list is table of employees.first_name%type;
      emps e_list := e_list();
      idx pls_integer := 1;
    begin
      for x in 100 .. 110 loop
        emps.extend;
        select first_name into emps(idx) from employees where employee_id = x;
        idx := idx + 1;
      end loop;
      emps.delete(3);
      for i in 1..emps.count() loop
       if emps.exists(i) then 
        dbms_output.put_line(emps(i));
       end if;
      end loop;
    end;