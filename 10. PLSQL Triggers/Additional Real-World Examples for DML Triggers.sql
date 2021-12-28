---------------------------------------------------------------------------------------------
-----------------------------REAL-WORLD EXAMPLES ON DML TRIGGERS-----------------------------
---------------------------------------------------------------------------------------------
create sequence seq_dep_cpy
  start with 280
  increment by 10;
----------------- primary key example
create or replace trigger trg_before_insert_dept_cpy
before insert on departments_copy 
for each row
begin
  --select seq_dep_cpy.nextval into :new.department_id from dual;
  :new.department_id := seq_dep_cpy.nextval;
end;
----------------- 
insert into departments_copy 
        (department_name,manager_id,location_id)
        values
        ('Security',200,1700);
----------------- 
desc departments_copy;
----------------- creating the audit log table
create table log_departments_copy 
        (log_user varchar2(30), log_date date, dml_type varchar2(10),
         old_department_id number(4), new_department_id number(4), 
         old_department_name varchar2(30), new_department_name varchar2(30),
         old_manager_id number(6), new_manager_id number(6), 
         old_location_id number(4), new_location_id number(4));
----------------- audit log trigger
create or replace trigger trg_department_copy_log
after insert or update or delete on departments_copy 
for each row
declare v_dml_type varchar2(10);
begin
  if inserting then
    v_dml_type := 'INSERT';
  elsif updating then
    v_dml_type := 'UPDATE';
  elsif deleting then
    v_dml_type := 'DELETE';
  end if;
  insert into log_departments_copy values
    (user, sysdate, v_dml_type, 
     :old.department_id, :new.department_id,
     :old.department_name, :new.department_name, 
     :old.manager_id, :new.manager_id,
     :old.location_id, :new.location_id);
end;
----------------- other sql codes used in this lecture
insert into departments_copy (department_name, manager_id,location_id)
    values ('Cyber Security', 100, 1700);
 
select * from LOG_DEPARTMENTS_COPY;
update departments_copy set manager_id = 200 where DEPARTMENT_NAME = 'Cyber Security';
delete from departments_copy where DEPARTMENT_NAME = 'Cyber Security';