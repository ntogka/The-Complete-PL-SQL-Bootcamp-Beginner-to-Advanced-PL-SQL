    declare
      cursor c_emps is select * from employees where department_id = 50;
      v_emps c_emps%rowtype;
    begin
      if not c_emps%isopen then
        open c_emps;
        dbms_output.put_line('hello');
      end if;
      dbms_output.put_line(c_emps%rowcount);
      fetch c_emps into v_emps;
      dbms_output.put_line(c_emps%rowcount);
      dbms_output.put_line(c_emps%rowcount);
      fetch c_emps into v_emps;
      dbms_output.put_line(c_emps%rowcount);
      close c_emps;
      
      open c_emps;
        loop
          fetch c_emps into v_emps;
          exit when c_emps%notfound or c_emps%rowcount>5;
          dbms_output.put_line(c_emps%rowcount|| ' ' ||v_emps.first_name|| ' ' ||v_emps.last_name);
        end loop;
      close c_emps;
    end;