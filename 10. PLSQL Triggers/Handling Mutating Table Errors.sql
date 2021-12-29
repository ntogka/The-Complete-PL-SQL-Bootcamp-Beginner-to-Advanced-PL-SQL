---------------------------------------------------------------------------------------------
------------------------------------ MUTATING TABLE ERRORS ----------------------------------
---------------------------------------------------------------------------------------------
----------------- A mutating table error example
create or replace trigger trg_mutating_emps
before insert or update on employees_copy 
for each row
    declare
    v_interval number := 15;
    v_avg_salary number;
    begin
    select avg(salary) into v_avg_salary from employees_copy where department_id = :new.department_id;
      if :new.salary > v_avg_salary*v_interval/100 then
        RAISE_APPLICATION_ERROR(-20005, 'A raise cannot be '|| v_interval|| ' percent higher than its department''s average');
      end if;
end;
----------------- Getting mutating table error within a compound trigger
create or replace trigger trg_comp_emps
for insert or update or delete on employees_copy 
compound trigger
  type t_avg_dept_salaries is table of employees_copy.salary%type index by pls_integer;
  avg_dept_salaries t_avg_dept_salaries;
  before statement is
   begin
    for avg_sal in (select avg(salary) salary,nvl(department_id,999) department_id from employees_copy group by department_id) loop
      avg_dept_salaries(avg_sal.department_id) := avg_sal.salary;
    end loop;
  end before statement; 
 
  after each row is
    v_interval number := 15;
    begin
    update employees_copy set commission_pct = commission_pct;
      if :new.salary > avg_dept_salaries(:new.department_id)*v_interval/100 then
        RAISE_APPLICATION_ERROR(-20005, 'A raise cannot be '|| v_interval|| ' percent higher than its department''s average');
      end if;
  end after each row;
  after statement is
    begin
      dbms_output.put_line('All the updates are done successfully!.');
  end after statement;
end;
----------------- An example of getting maximum level of recursive SQL levels
create or replace trigger trg_comp_emps
for insert or update or delete on employees_copy 
compound trigger
  type t_avg_dept_salaries is table of employees_copy.salary%type index by pls_integer;
  avg_dept_salaries t_avg_dept_salaries;
  before statement is
   begin
    update employees_copy set commission_pct = commission_pct where employee_id = 100;
    for avg_sal in (select avg(salary) salary,nvl(department_id,999) department_id from employees_copy group by department_id) loop
      avg_dept_salaries(avg_sal.department_id) := avg_sal.salary;
    end loop;
  end before statement; 
 
  after each row is
    v_interval number := 15;
    begin
      if :new.salary > avg_dept_salaries(:new.department_id)*v_interval/100 then
        RAISE_APPLICATION_ERROR(-20005, 'A raise cannot be '|| v_interval|| ' percent higher than its department''s average');
      end if;
  end after each row;
  after statement is
    begin
      update employees_copy set commission_pct = commission_pct where employee_id = 100;
      dbms_output.put_line('All the updates are done successfully!.');
  end after statement;
end;