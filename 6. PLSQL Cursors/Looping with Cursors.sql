    declare
      cursor c_emps is select * from employees where department_id = 30;
      v_emps c_emps%rowtype;
    begin
      open c_emps;
      loop
        fetch c_emps into v_emps;
        dbms_output.put_line(v_emps.employee_id|| ' ' ||v_emps.first_name|| ' ' ||v_emps.last_name);
      end loop;
      close c_emps;
    end; 
    ---------------%notfound example
    declare
      cursor c_emps is select * from employees where department_id = 30;
      v_emps c_emps%rowtype;
    begin
      open c_emps;
      loop
        fetch c_emps into v_emps;
        exit when c_emps%notfound;
        dbms_output.put_line(v_emps.employee_id|| ' ' ||v_emps.first_name|| ' ' ||v_emps.last_name);
      end loop;
      close c_emps;
    end;
    ---------------while loop example
    declare
      cursor c_emps is select * from employees where department_id = 30;
      v_emps c_emps%rowtype;
    begin
      open c_emps;
      fetch c_emps into v_emps;
      while c_emps%found loop
        dbms_output.put_line(v_emps.employee_id|| ' ' ||v_emps.first_name|| ' ' ||v_emps.last_name);
        fetch c_emps into v_emps;
        --exit when c_emps%notfound;
      end loop;
      close c_emps;
    end;
    ---------------for loop with cursor example
    declare
      cursor c_emps is select * from employees where department_id = 30;
      v_emps c_emps%rowtype;
    begin
      open c_emps;
      for i in 1..6 loop
        fetch c_emps into v_emps;
        dbms_output.put_line(v_emps.employee_id|| ' ' ||v_emps.first_name|| ' ' ||v_emps.last_name);
      end loop;
      close c_emps;
    end;
    ---------------FOR..IN clause example
    declare
      cursor c_emps is select * from employees where department_id = 30;
    begin
      for i in c_emps loop
        dbms_output.put_line(i.employee_id|| ' ' ||i.first_name|| ' ' ||i.last_name);
      end loop;
    end;
    ---------------FOR..IN with select example
    begin
      for i in (select * from employees where department_id = 30) loop
        dbms_output.put_line(i.employee_id|| ' ' ||i.first_name|| ' ' ||i.last_name);
      end loop;
    end;