    --------------------------------------------------------------------------------------------------------------------
    ----------------------------------------------ASSOCIATIVE ARRAYS----------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------
    ---------------The first example
    declare
      type e_list is table of employees.first_name%type index by pls_integer;
      emps e_list;
    begin
      for x in 100 .. 110 loop
        select first_name into emps(x) from employees 
           where employee_id = x ;
      end loop;
      for i in emps.first()..emps.last() loop
        dbms_output.put_line(emps(i));
      end loop;
    end;
    ---------------Error example for the select into clause
    declare
      type e_list is table of employees.first_name%type index by pls_integer;
      emps e_list;
    begin
      for x in 100 .. 110 loop
        select first_name into emps(x) from employees 
           where employee_id = x and department_id = 60;
      end loop;
      for i in emps.first()..emps.last() loop
        dbms_output.put_line(i);
      end loop;
    end;
    ---------------Error example about reaching the empty indexdeclare
      type e_list is table of employees.first_name%type index by pls_integer;
      emps e_list;
    begin
      emps(100) := 'Bob';
      emps(120) := 'Sue';
      for i in emps.first()..emps.last() loop
        dbms_output.put_line(emps(i));
      end loop;
    end;
    ---------------An example of iterating in associative arrays with while loops
    declare
      type e_list is table of employees.first_name%type index by pls_integer;
      emps e_list;
      idx pls_integer;
    begin
      emps(100) := 'Bob';
      emps(120) := 'Sue';
      idx := emps.first;
      while idx is not null  loop
        dbms_output.put_line(emps(idx));
        idx := emps.next(idx);
      end loop;
    end;
    ---------------An example of using string based indexes with associative arrays
    declare
      type e_list is table of employees.first_name%type index by employees.email%type;
      emps e_list;
      idx employees.email%type;
      v_email employees.email%type;
      v_first_name employees.first_name%type;
    begin
        for x in 100 .. 110 loop
        select first_name,email into v_first_name,v_email from employees
           where employee_id = x;
        emps(v_email) := v_first_name;
      end loop;
      idx := emps.first;
      while idx is not null  loop
        dbms_output.put_line('The email of '|| emps(idx) ||' is : '|| idx);
        idx := emps.next(idx);
      end loop;
    end;
    ---------------An example of using associative arrays with records
    declare
      type e_list is table of employees%rowtype index by employees.email%type;
      emps e_list;
      idx employees.email%type;
    begin
        for x in 100 .. 110 loop
        select * into emps(x) from employees
           where employee_id = x;
      end loop;
      idx := emps.first;
      while idx is not null  loop
        dbms_output.put_line('The email of '|| emps(idx).first_name 
              ||' '||emps(idx).last_name||' is : '|| emps(idx).email);
        idx := emps.next(idx);
      end loop;
    end;
    ---------------An example of using associative arrays with record types
    declare
      type e_type is record (first_name employees.first_name%type,
                             last_name employees.last_name%type,
                             email employees.email%type);
      type e_list is table of e_type index by employees.email%type;
      emps e_list;
      idx employees.email%type;
    begin
        for x in 100 .. 110 loop
        select first_name,last_name,email into emps(x) from employees
           where employee_id = x;
      end loop;
      idx := emps.first;
      while idx is not null  loop
        dbms_output.put_line('The email of '|| emps(idx).first_name 
              ||' '||emps(idx).last_name||' is : '|| emps(idx).email);
        idx := emps.next(idx);
      end loop;
    end;
    ---------------An example of printing from the last to the first
    declare
      type e_type is record (first_name employees.first_name%type,
                             last_name employees.last_name%type,
                             email employees.email%type);
      type e_list is table of e_type index by employees.email%type;
      emps e_list;
      idx employees.email%type;
    begin
        for x in 100 .. 110 loop
        select first_name,last_name,email into emps(x) from employees
           where employee_id = x;
      end loop;
      --emps.delete(100,104);
      idx := emps.last;
      while idx is not null  loop
        dbms_output.put_line('The email of '|| emps(idx).first_name 
              ||' '||emps(idx).last_name||' is : '|| emps(idx).email);
        idx := emps.prior(idx);
      end loop;
    end;
    ---------------An example of inserting with associative arrays
    create table employees_salary_history as select * from employees where 1=2;
    alter table employees_salary_history add insert_date date;
    select * from employees_salary_history;
    /
    declare
      type e_list is table of employees_salary_history%rowtype index by pls_integer;
      emps e_list;
      idx pls_integer;
    begin
        for x in 100 .. 110 loop
        select e.*,'01-JUN-20' into emps(x) from employees e
           where employee_id = x;
      end loop;
      idx := emps.first;
      while idx is not null loop
        emps(idx).salary := emps(idx).salary + emps(idx).salary*0.2;
        insert into employees_salary_history values emps(idx);
        dbms_output.put_line('The employee '|| emps(idx).first_name 
                             ||' is inserted to the history table');
        idx := emps.next(idx);
      end loop;
    end;
    /
    drop table employees_salary_history;