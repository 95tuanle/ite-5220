create or replace function AVG_SAL return EMPLOYEES.SALARY%type is
    v_total_sal number := 0;
    v_no_of_emp number := 0;
    cursor emp_curs is select SALARY
                       from EMPLOYEES;
begin
    for emp_rec in emp_curs
        loop
            v_no_of_emp := v_no_of_emp + 1;
            v_total_sal := v_total_sal + emp_rec.SALARY;
        end loop;
    return v_total_sal / v_no_of_emp;
end;

begin
    DBMS_OUTPUT.PUT_LINE(AVG_SAL());
end;

-- this anonymous block is to check against the AVG_SAL function
declare
    v_avg_sal EMPLOYEES.SALARY%type;
begin
    select avg(SALARY) into v_avg_sal from EMPLOYEES;
    DBMS_OUTPUT.PUT_LINE(v_avg_sal);
end;



create or replace function Check_LName(p_last_name in EMPLOYEES.LAST_NAME%type) return boolean is
    cursor emp_curs is select LAST_NAME
                       from EMPLOYEES;
begin
    for emp_rec in emp_curs
        loop
            if emp_rec.LAST_NAME = p_last_name then
                return true;
            end if;
        end loop;
    return false;
end;

begin
    if Check_LName('Le') then
        DBMS_OUTPUT.PUT_LINE('The employee with last name Le exists in EMPLOYEES table');
    else
        DBMS_OUTPUT.PUT_LINE('The employee with last name Le does not in EMPLOYEES table');
    end if;
    if Check_LName('Almeida Castro') then
        DBMS_OUTPUT.PUT_LINE('The employee with last name Almeida Castro exists in EMPLOYEES table');
    else
        DBMS_OUTPUT.PUT_LINE('The employee with last name Almeida Castro does not in EMPLOYEES table');
    end if;
end;



create or replace procedure CALC_TAX(p_emp_id in EMPLOYEES.EMPLOYEE_ID%type, p_annual_tax in out number) is
    v_emp_sal EMPLOYEES.SALARY%type;
begin
    select SALARY into v_emp_sal from EMPLOYEES where EMPLOYEE_ID = p_emp_id;
    p_annual_tax := ((v_emp_sal * 12) - 10000) * .09;
exception
    when NO_DATA_FOUND then
        DBMS_OUTPUT.PUT_LINE('No employee found with that id');
end;

declare
    v_annual_tax number;
begin
    CALC_TAX(143, v_annual_tax);
    DBMS_OUTPUT.PUT_LINE(v_annual_tax);
end;



create or replace package EMP_PKG is
    function CHECK_FNAME(p_first_name in EMPLOYEES.FIRST_NAME%type) return boolean;
    function AVG_SAL return EMPLOYEES.SALARY%type;
end;

create or replace package body EMP_PKG is
    procedure CALC_TAX(p_emp_id in EMPLOYEES.EMPLOYEE_ID%type, p_annual_tax in out number) is
        v_emp_sal EMPLOYEES.SALARY%type;
    begin
        select SALARY into v_emp_sal from EMPLOYEES where EMPLOYEE_ID = p_emp_id;
        p_annual_tax := ((v_emp_sal * 12) - 10000) * .09;
    exception
        when NO_DATA_FOUND then
            DBMS_OUTPUT.PUT_LINE('No employee found with that id');
    end;
    function CHECK_FNAME(p_first_name in EMPLOYEES.FIRST_NAME%type) return boolean is
        cursor emp_curs is select FIRST_NAME
                           from EMPLOYEES;
    begin
        for emp_rec in emp_curs
            loop
                if emp_rec.FIRST_NAME = p_first_name then
                    return true;
                end if;
            end loop;
        return false;
    end;
    function AVG_SAL return EMPLOYEES.SALARY%type is
        v_total_sal number := 0;
        v_no_of_emp number := 0;
        cursor emp_curs is select SALARY
                           from EMPLOYEES;
    begin
        for emp_rec in emp_curs
            loop
                v_no_of_emp := v_no_of_emp + 1;
                v_total_sal := v_total_sal + emp_rec.SALARY;
            end loop;
        return v_total_sal / v_no_of_emp;
    end;
end;

declare
    v_annual_tax number;
begin
    if EMP_PKG.CHECK_FNAME('Nguyen Anh Tuan') then
        DBMS_OUTPUT.PUT_LINE('The employee with first name Nguyen Anh Tuan exists in EMPLOYEES table');
    else
        DBMS_OUTPUT.PUT_LINE('The employee with first name Nguyen Anh Tuan does not in EMPLOYEES table');
    end if;
    if EMP_PKG.CHECK_FNAME('Lucas') then
        DBMS_OUTPUT.PUT_LINE('The employee with first name Lucas exists in EMPLOYEES table');
    else
        DBMS_OUTPUT.PUT_LINE('The employee with first name Lucas does not in EMPLOYEES table');
    end if;

    DBMS_OUTPUT.PUT_LINE(AVG_SAL());

    --     unable to access CALC_TAX procedure from EMP_PKG because it is private
--     EMP_PKG.CALC_TAX(143, v_annual_tax);
    DBMS_OUTPUT.PUT_LINE(v_annual_tax);
end;



drop table audit_employees purge;

create table audit_employees
(
    action      varchar2(50),
    username    varchar2(30) default user,
    timestamp   timestamp    default systimestamp,
    employee_id number
);

create or replace trigger Audit_Employees
    after insert or delete or update
    on EMPLOYEES
    for each row
begin
    if inserting then
        insert into audit_employees (action, employee_id) VALUES ('inserted', :new.EMPLOYEE_ID);
    elsif deleting then
        insert into audit_employees (action, employee_id) VALUES ('deleted', :old.EMPLOYEE_ID);
    elsif updating then
        insert into audit_employees (action, employee_id) VALUES ('updated', :new.EMPLOYEE_ID);
    end if;
end;

insert into EMPLOYEES (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY,
                       COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
values (1001, 'Steven', 'King', 'SKIN', '515.123.4567', TO_DATE('1987-06-17', 'yyyy-mm-dd'), 'AD_PRES', 24000, null,
        null, 90);

update EMPLOYEES
set EMPLOYEE_ID = 1003
where EMPLOYEE_ID = 1001;

delete
from EMPLOYEES
where EMPLOYEE_ID = 1003;

select *
from audit_employees;