create or replace procedure display_department_id (p_table_name varchar2, p_department_id out EMPLOYEES.DEPARTMENT_ID%type) is
begin
    execute immediate 'select DEPARTMENT_ID from ' || p_table_name || ' where MANAGER_ID = 205' into p_department_id;
    exception
    when NO_DATA_FOUND then
    DBMS_OUTPUT.PUT_LINE('No data found');
    when TOO_MANY_ROWS then
    DBMS_OUTPUT.PUT_LINE('Too many rows');
    when others then
    DBMS_OUTPUT.PUT_LINE('Something is wrong');
end;

declare
    v_dept_id_dept EMPLOYEES.DEPARTMENT_ID%type;
    v_dept_id_emp EMPLOYEES.DEPARTMENT_ID%type;
begin
    display_department_id('DEPARTMENTS', v_dept_id_dept);
    DBMS_OUTPUT.PUT_LINE('Result from departments table ' || v_dept_id_dept);
    display_department_id('EMPLOYEES', v_dept_id_emp);
    DBMS_OUTPUT.PUT_LINE('Result from employees table ' || v_dept_id_emp);
end;



create or replace procedure how_many_rows (p_table_name varchar2, p_number_of_rows out number) is
begin
    execute immediate 'select count(*) from ' || p_table_name into p_number_of_rows;
end;

declare
    v_number_of_rows_countries number;
    v_number_of_rows_regions number;
begin
    how_many_rows('COUNTRIES', v_number_of_rows_countries);
    DBMS_OUTPUT.PUT_LINE('Number of rows from COUNTRIES table '|| v_number_of_rows_countries);
    how_many_rows('REGIONS', v_number_of_rows_regions);
    DBMS_OUTPUT.PUT_LINE('Number of rows from REGIONS table '|| v_number_of_rows_regions);
end;



CREATE TABLE copy_countries AS SELECT * FROM countries;

create or replace procedure delete_from_table (p_table_name varchar2, p_number_of_deleted_rows out number) is
begin
    execute immediate 'delete from ' || p_table_name;
    p_number_of_deleted_rows := sql%rowcount;
end;

declare
    v_number_of_deleted_rows number;
begin
    delete_from_table('COPY_COUNTRIES', v_number_of_deleted_rows);
    DBMS_OUTPUT.PUT_LINE('Number of deleted rows ' || v_number_of_deleted_rows);
end;



CREATE TABLE audit_table (action VARCHAR2(50), user_name VARCHAR2(30) DEFAULT USER, last_change_date TIMESTAMP DEFAULT SYSTIMESTAMP);

create or replace trigger insert_employees_log
after insert on EMPLOYEES
begin
    insert into audit_table (action) values ('Inserting');
end;

INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id)
VALUES(1001,'Steven','King','SKIN','515.123.4567',TO_DATE('1987-06-17','yyyy-mm-dd'),'AD_PRES',24000,null,null,90);

select * from audit_table;

delete from EMPLOYEES where EMPLOYEE_ID = 1001;

select * from audit_table;

create or replace trigger insert_employees_log
before update on EMPLOYEES
begin
    insert into audit_table (action) values ('Updating');
end;

update EMPLOYEES set FIRST_NAME = 'Test' where EMPLOYEE_ID = 1001;

select * from audit_table;

create or replace trigger insert_employees_log
before update on EMPLOYEES
begin
    insert into audit_table (action) values ('Updating');
    if sysdate not between to_date('8:00', 'HH24:MI') and to_date('18:00', 'HH24:MI') then
        raise_application_error(-20001, 'You may insert into EMPLOYEES table only during business hours.');
    end if;
end;

SELECT TO_CHAR(SYSDATE,'HH24:MI') FROM dual;

UPDATE employees SET salary = 25000
WHERE employee_id = 100;

create or replace trigger insert_employees_log
after insert or delete on EMPLOYEES
begin
    if inserting then
        insert into audit_table (action) values ('Inserted');
    elsif deleting then
        insert into audit_table (action) values ('Deleted');
    end if;
end;

INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id)
VALUES(1001,'Steven','King','SKIN','515.123.4567',TO_DATE('1987-06-17','yyyy-mm-dd'),'AD_PRES',24000,null,null,90);

delete from EMPLOYEES where EMPLOYEE_ID = 1001;

select * from audit_table;

alter table audit_table add emp_id NUMBER(6);

create or replace trigger insert_employees_log
after insert or delete on EMPLOYEES for each row
begin
    if inserting then
        insert into audit_table (action, emp_id) values ('Inserted', :new.EMPLOYEE_ID);
    elsif deleting then
        insert into audit_table (action, emp_id) values ('Deleted', :old.EMPLOYEE_ID);
    end if;
end;

INSERT INTO employees(employee_id,first_name,last_name,email,phone_number,hire_date,job_id,salary,commission_pct,manager_id,department_id)
VALUES(1001,'Steven','King','SKIN','515.123.4567',TO_DATE('1987-06-17','yyyy-mm-dd'),'AD_PRES',24000,null,null,90);

delete from EMPLOYEES where EMPLOYEE_ID = 1001;

select * from audit_table;



CREATE TABLE dept_count
AS SELECT department_id dept_id, count(*) count_emps FROM employees
GROUP BY department_id;

CREATE VIEW emp_vu
AS SELECT employee_id, last_name, department_id FROM employees;

create or replace trigger dept_count_trigger
instead of insert or delete on emp_vu
begin
    if inserting then
        update dept_count set count_emps = count_emps + 1 where dept_id = :new.department_id;
    elsif deleting then
        update dept_count set count_emps = count_emps - 1 where dept_id = :old.department_id;
    end if;
end;

select * from dept_count;

insert into emp_vu values (1001, 'King', 90);

select * from dept_count;



create or replace trigger emp_audit_trigg
for update of SALARY on EMPLOYEES compound trigger
before each row is
begin
    insert into audit_table (action, emp_id) values ('Updating', :new.EMPLOYEE_ID);
end before each row;
after each row is
begin
    insert into audit_table (action, emp_id) values ('Updated, old salary was '||:old.SALARY||' new salary is '||:new.SALARY, :new.EMPLOYEE_ID);
end after each row;
end;

update EMPLOYEES set SALARY = 1200 where EMPLOYEE_ID = 124;

select * from audit_table;

CREATE TABLE audit_ddl (action VARCHAR2(20), who VARCHAR2(30) DEFAULT USER, when TIMESTAMP DEFAULT SYSTIMESTAMP);



create or replace trigger max_salary_trigger
before update of SALARY on EMPLOYEES for each row
declare
    v_max_salary EMPLOYEES.SALARY%type;
begin
    select max(SALARY) into v_max_salary from EMPLOYEES;
    DBMS_OUTPUT.PUT_LINE(v_max_salary);
end;

update EMPLOYEES set SALARY = 5800 where EMPLOYEE_ID = 124;



alter trigger max_salary_trigger disable;

select TRIGGER_NAME, TRIGGERING_EVENT, TRIGGER_TYPE, BASE_OBJECT_TYPE, TABLE_NAME, STATUS from USER_TRIGGERS;

select TRIGGER_BODY from USER_TRIGGERS where TRIGGER_NAME = upper('max_salary_trigger');

drop trigger max_salary_trigger;

select * from USER_TRIGGERS where TRIGGER_NAME = upper('max_salary_trigger');

create or replace procedure reenable_triggers_proc is
cursor triggers_curs is select TRIGGER_NAME from USER_TRIGGERS where STATUS = 'DISABLED';
begin
    for trigger in triggers_curs loop
        execute immediate 'alter trigger ' || trigger.TRIGGER_NAME || ' ENABLE';
    end loop;
end;

alter trigger insert_employees_log disable;

alter trigger max_sal disable;

begin
    reenable_triggers_proc();
end;

select TRIGGER_NAME, STATUS from USER_TRIGGERS;