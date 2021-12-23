    ------------------------------OPERATING WITH SELECTED QUERIES--------------------------------
    declare
     v_name varchar2(50);
     v_salary employees.salary%type;
    begin
      select first_name ||' '|| last_name, salary into v_name, v_salary  from employees where employee_id = 130;
      dbms_output.put_line('The salary of '|| v_name || ' is : '|| v_salary);
    end;
    ------------------------------
    declare
     v_name varchar2(50);
     sysdates employees.hire_date%type;
    begin
      select first_name ||' '|| last_name, sysdates into v_name, sysdates from employees where employee_id = 130;
      dbms_output.put_line('The salary of '|| v_name || ' is : '|| sysdates);
    end;
    ------------------------------
    declare
     v_name varchar2(50);
     v_sysdate employees.hire_date%type;
     employee_id employees.employee_id%type := 130;
    begin
      select first_name ||' '|| last_name, sysdate into v_name, v_sysdate from employees where employee_id = employee_id;
      dbms_output.put_line('The salary of '|| v_name || ' is : '|| v_sysdate );
    end;
    ------------------------------
    declare
     v_name varchar2(50);
     v_salary employees.salary%type;
     v_employee_id employees.employee_id%type := 130;
    begin
      select first_name ||' '|| last_name, salary into v_name, v_salary from employees where employee_id = v_employee_id;
      dbms_output.put_line('The salary of '|| v_name || ' is : '|| v_salary );
    end;
    ------------------------------ DML OPERATIONS WITH PL/SQL----------------------------------------
    create table employees_copy as select * from employees;
    DECLARE
      v_employee_id pls_integer := 0;
      v_salary_increase number := 400;
    begin
      for i in 217..226 loop
            --insert into employees_copy 
          --(employee_id,first_name,last_name,email,hire_date,job_id,salary)
        --values 
          --(i, 'employee#'||i,'temp_emp','abc@xmail.com',sysdate,'IT_PROG',1000);
       --update employees_copy 
         --set salary = salary + v_salary_increase
         --where employee_id = i;
         delete from employees_copy
         where employee_id = i;
      end loop;
    end; 
    ----------------------------- USING SEQUENCES IN PL/SQL ----------------------------------------
    create sequence employee_id_seq 
    start with 207
    increment by 1;
    -----------------------------
    begin
      for i in 1..10 loop
        insert into employees_copy 
          (employee_id,first_name,last_name,email,hire_date,job_id,salary)
        values 
          (employee_id_seq.nextval, 'employee#'||employee_id_seq.nextval,'temp_emp','abc@xmail.com',sysdate,'IT_PROG',1000);
      end loop;
    end; 
    ----------------------------
    declare
      v_seq_num number;
    begin
      select employee_id_seq.nextval into v_seq_num from dual;
      dbms_output.put_line(v_seq_num);
    end;
    ----------------------------
    declare
      v_seq_num number;
    begin
      select employee_id_seq.nextval into v_seq_num from employees_copy where rownum = 1;
      dbms_output.put_line(v_seq_num);
    end;
    ----------------------------
    declare
      v_seq_num number;
    begin
      v_seq_num := employee_id_seq.nextval; 
      dbms_output.put_line(v_seq_num);
    end;
    ----------------------------
    begin
      dbms_output.put_line(employee_id_seq.nextval);
    end;
    ----------------------------
    begin
      dbms_output.put_line(employee_id_seq.currval);
    end;