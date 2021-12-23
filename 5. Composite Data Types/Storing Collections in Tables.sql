    --------------------------------------------------------------------------------------------------------------------
    ---------------------------------------STORING COLLECTIONS IN TABLES------------------------------------------------
    --------------------------------------------------------------------------------------------------------------------
    ---------------Storing Varray Example
    create or replace type t_phone_number as object (p_type varchar2(10), p_number varchar2(50));
    /
    create or replace type v_phone_numbers as varray(3) of t_phone_number;
    /
    create table emps_with_phones (employee_id number,
                                   first_name varchar2(50),
                                   last_name varchar2(50),
                                   phone_number v_phone_numbers);
    /
    select * from emps_with_phones;
    /
    insert into emps_with_phones values (10,'Alex','Brown',v_phone_numbers(
                                                                    t_phone_number('HOME','111.111.1111'),
                                                                    t_phone_number('WORK','222.222.2222'),
                                                                    t_phone_number('MOBILE','333.333.3333')
                                                                    ));
    insert into emps_with_phones values (11,'Bob','Green',v_phone_numbers(
                                                                    t_phone_number('HOME','000.000.000'),
                                                                    t_phone_number('WORK','444.444.4444')
                                                                    ));                                                                
    /
    ---------------Querying the varray example
    select e.first_name,last_name,p.p_type,p.p_number from emps_with_phones e, table(e.phone_number) p;
    ---------------The codes for the storing nested table example
    create or replace type n_phone_numbers as table of t_phone_number;
    /
    create table emps_with_phones2 (employee_id number,
                                   first_name varchar2(50),
                                   last_name varchar2(50),
                                   phone_number n_phone_numbers)
                                   NESTED TABLE phone_number STORE AS phone_numbers_table;
    /
    select * from emps_with_phones2;
    /
    insert into emps_with_phones2 values (10,'Alex','Brown',n_phone_numbers(
                                                                    t_phone_number('HOME','111.111.1111'),
                                                                    t_phone_number('WORK','222.222.2222'),
                                                                    t_phone_number('MOBILE','333.333.3333')
                                                                    ));
    insert into emps_with_phones2 values (11,'Bob','Green',n_phone_numbers(
                                                                    t_phone_number('HOME','000.000.000'),
                                                                    t_phone_number('WORK','444.444.4444')
                                                                    ));      
    /
    select e.first_name,last_name,p.p_type,p.p_number from emps_with_phones2 e, table(e.phone_number) p;
    ---------------new insert and update
    insert into emps_with_phones2 values (11,'Bob','Green',n_phone_numbers(
                                                                    t_phone_number('HOME','000.000.000'),
                                                                    t_phone_number('WORK','444.444.4444'),
                                                                    t_phone_number('WORK2','444.444.4444'),
                                                                    t_phone_number('WORK3','444.444.4444'),
                                                                    t_phone_number('WORK4','444.444.4444'),
                                                                    t_phone_number('WORK5','444.444.4444')
                                                                    ));    
    select * from emps_with_phones2;
    update emps_with_phones2 set phone_number = n_phone_numbers(
                                                                    t_phone_number('HOME','000.000.000'),
                                                                    t_phone_number('WORK','444.444.4444'),
                                                                    t_phone_number('WORK2','444.444.4444'),
                                                                    t_phone_number('WORK3','444.444.4444'),
                                                                    t_phone_number('WORK4','444.444.4444'),
                                                                    t_phone_number('WORK5','444.444.4444')
                                                                    )
    where employee_id = 11;
    ---------------Adding a new value into the nested table inside of a table
    declare
      p_num n_phone_numbers;
    begin
      select phone_number into p_num from emps_with_phones2 where employee_id = 10;
      p_num.extend;
      p_num(5) := t_phone_number('FAX','999.99.9999');
      UPDATE emps_with_phones2 set phone_number = p_num where employee_id = 10;
    end;