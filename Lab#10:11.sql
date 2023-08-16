select *
from USER_OBJECTS
where OBJECT_TYPE = 'PACKAGE';



CREATE OR REPLACE PACKAGE check_emp_pkg IS
    g_max_length_of_service CONSTANT NUMBER := 100;
    PROCEDURE chk_hiredate(p_date IN employees.hire_date%TYPE);
    PROCEDURE chk_dept_mgr(p_empid IN employees.employee_id%TYPE, p_mgr IN employees.manager_id%TYPE);
END check_emp_pkg;

CREATE OR REPLACE PACKAGE BODY check_emp_pkg IS
    PROCEDURE chk_hiredate(p_date IN employees.hire_date%TYPE) IS
    BEGIN
        IF MONTHS_BETWEEN(SYSDATE, p_date) > g_max_length_of_service * 12 THEN
            RAISE_APPLICATION_ERROR(-20201, 'Hiredate Too Old');
        END IF;
    END chk_hiredate;
    PROCEDURE chk_dept_mgr(p_empid IN employees.employee_id%TYPE, p_mgr IN employees.manager_id%TYPE) IS
        v_manager_id DEPARTMENTS.MANAGER_ID%TYPE;
    BEGIN
        select DEPARTMENTS.MANAGER_ID
        into v_manager_id
        from DEPARTMENTS
                 join EMPLOYEES on DEPARTMENTS.DEPARTMENT_ID = EMPLOYEES.DEPARTMENT_ID
        where EMPLOYEE_ID = 174;
        if v_manager_id = p_mgr then
            DBMS_OUTPUT.PUT_LINE('success');
        else
            RAISE_APPLICATION_ERROR(-20202, 'Manager id does not match');
        end if;
    exception
        when NO_DATA_FOUND then
            DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND');
    END chk_dept_mgr;
END check_emp_pkg;

begin
    check_emp_pkg.chk_hiredate(to_date('17-Jan-1987', 'DD-MON-YYYY'));
end;

begin
    check_emp_pkg.chk_dept_mgr(174, 149);
end;

begin
    check_emp_pkg.chk_dept_mgr(174, 176);
end;



create or replace package hellofrom is
    procedure proc_1;
    procedure proc_2;
    procedure proc_3;
end hellofrom;

create or replace package body hellofrom is
    procedure proc_1 is
    begin
        DBMS_OUTPUT.PUT_LINE('Hello from Proc 1');
        proc_2();
    end proc_1;
    procedure proc_2 is
    begin
        DBMS_OUTPUT.PUT_LINE('Hello from Proc 2');
        proc_3();
    end proc_2;
    procedure proc_3 is
    begin
        DBMS_OUTPUT.PUT_LINE('Hello from Proc 3');
    end proc_3;
end hellofrom;

desc hellofrom;

create or replace package hellofrom is
    procedure proc_1;
end hellofrom;

begin
    hellofrom.proc_1();
end;

create or replace package body hellofrom is
    procedure proc_2;
    procedure proc_3;
    procedure proc_1 is
    begin
        DBMS_OUTPUT.PUT_LINE('Hello from Proc 1');
        proc_2();
    end proc_1;
    procedure proc_2 is
    begin
        DBMS_OUTPUT.PUT_LINE('Hello from Proc 2');
        proc_3();
    end proc_2;
    procedure proc_3 is
    begin
        DBMS_OUTPUT.PUT_LINE('Hello from Proc 3');
    end proc_3;
end hellofrom;

begin
    hellofrom.proc_1();
end;

begin
    hellofrom.proc_2();
end;

begin
    hellofrom.proc_3();
end;

select *
from USER_PROCEDURES;

select *
from USER_SOURCE;

drop package body hellofrom;

describe hellofrom

drop package hellofrom;



create or replace package overload is
    procedure what_am_i(p_varchar2 in varchar2);
    procedure what_am_i(p_number in number);
    procedure what_am_i(p_date in date);
    procedure what_am_i(p_in in NUMBER, p_in2 in VARCHAR2);
    procedure what_am_i(p_in in NUMBER, p_in2 in VARCHAR2);
end overload;

create or replace package body overload is
    procedure what_am_i(p_varchar2 in varchar2) is
    begin
        DBMS_OUTPUT.PUT_LINE('Here I am a Varchar2.');
    end what_am_i;
    procedure what_am_i(p_number in number) is
    begin
        DBMS_OUTPUT.PUT_LINE('Here I am a Number.');
    end what_am_i;
    procedure what_am_i(p_date in date) is
    begin
        DBMS_OUTPUT.PUT_LINE('Here I am a Date.');
    end what_am_i;
    procedure what_am_i(p_in in NUMBER, p_in2 in VARCHAR2) is
    begin
        DBMS_OUTPUT.PUT_LINE('Here I am a Number and a Varchar 2.');
    end what_am_i;
    procedure what_am_i(p_in in NUMBER, p_in2 in VARCHAR2) is
    begin
        DBMS_OUTPUT.PUT_LINE('Here I am a Number and a Varchar 2.');
    end what_am_i;
end overload;

begin
    overload.what_am_i(123, 'test');
end;

begin
    overload.what_am_i('test');
    overload.what_am_i(123);
    overload.what_am_i(to_date('17-Jan-1987', 'DD-MON-YYYY'));
end;

create or replace package return_type is
    function return_boolean return boolean;
end return_type;

create or replace package body return_type is
    function return_boolean return boolean is
    begin
        return true;
    end return_boolean;
end return_type;

begin
    return_type.return_boolean();
end;



CREATE OR REPLACE PACKAGE init_pkg IS
    g_max_sal employees.salary%TYPE;
    PROCEDURE get_emp_sal(p_emp_id IN employees.employee_id%TYPE);
END init_pkg;

CREATE OR REPLACE PACKAGE BODY init_pkg IS
    PROCEDURE get_emp_sal(p_emp_id IN employees.employee_id%TYPE) IS
        v_salary employees.salary%TYPE;
    BEGIN
        SELECT salary INTO v_salary FROM employees WHERE employee_id = p_emp_id;
        IF v_salary > (g_max_sal / 2) THEN
            DBMS_OUTPUT.PUT_LINE('This employee earns MORE than half of ' || g_max_sal);
        ELSE
            DBMS_OUTPUT.PUT_LINE('This employee earns LESS than half of ' || g_max_sal);
        END IF;
    END get_emp_sal;
BEGIN
    SELECT MAX(salary) INTO g_max_sal FROM employees;
END init_pkg;

BEGIN
    init_pkg.get_emp_sal(101); -- line 1
    init_pkg.g_max_sal := 80000; -- line 2
    init_pkg.get_emp_sal(101); -- line 3 DBMS_OUTPUT.PUT_LINE('g_max_sal is ' || init_pkg.g_max_sal); -- line 4
END;

BEGIN
    DBMS_OUTPUT.PUT_LINE('g_max_sal is ' || init_pkg.g_max_sal);
END;



create or replace package time_conversion_cons is
    c_day_to_hr constant number := 24;
    c_day_to_min constant number := 1440;
    c_day_to_sec constant number := 86400;
    c_hr_to_day constant number := 0.0416667;
    c_hr_to_min constant number := 60;
    c_hr_to_sec constant number := 3600;
    c_min_to_day constant number := 0.000694444;
    c_min_to_hr constant number := 0.0166667;
    c_min_to_sec constant number := 60;
    c_sec_to_day constant number := 1.1574e-5;
    c_sec_to_hr constant number := 0.000277778;
    c_sec_to_min constant number := 0.0166667;
end time_conversion_cons;

declare
    v_days    number := 2.5;
    v_hours   number := 1.8;
    v_minutes number := 13;
    v_seconds number := 720;
begin
    DBMS_OUTPUT.PUT_LINE(v_days || ' days is ' || time_conversion_cons.c_day_to_hr * v_days || ' hours or ' ||
                         time_conversion_cons.c_day_to_min * v_days || ' minutes or ' ||
                         time_conversion_cons.c_day_to_sec * v_days || ' seconds,');
    DBMS_OUTPUT.PUT_LINE(v_hours || ' hours is ' || time_conversion_cons.c_hr_to_day * v_hours || ' days or ' ||
                         time_conversion_cons.c_hr_to_min * v_hours || ' minutes or ' ||
                         time_conversion_cons.c_hr_to_sec * v_hours || ' seconds,');
    DBMS_OUTPUT.PUT_LINE(v_minutes || ' minutes is ' || time_conversion_cons.c_min_to_day * v_minutes || ' days or ' ||
                         time_conversion_cons.c_min_to_hr * v_minutes || ' hours or ' ||
                         time_conversion_cons.c_min_to_sec * v_minutes || ' seconds,');
    DBMS_OUTPUT.PUT_LINE(v_seconds || ' seconds is ' || time_conversion_cons.c_sec_to_day * v_seconds || ' days or ' ||
                         time_conversion_cons.c_sec_to_hr * v_seconds || ' hours or ' ||
                         time_conversion_cons.c_sec_to_min * v_seconds || ' minutes.');
end;



CREATE OR REPLACE PACKAGE pers_pkg IS
    g_var NUMBER := 10;
    PROCEDURE upd_g_var(p_var IN NUMBER);
    FUNCTION show_g_var RETURN number;
END pers_pkg;

CREATE OR REPLACE PACKAGE BODY pers_pkg IS
    PROCEDURE upd_g_var(p_var IN NUMBER) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('Initially g_var is set to: ' || g_var);
        g_var := p_var;
        DBMS_OUTPUT.PUT_LINE('And now g_var is set to: ' || g_var);
    END upd_g_var;
    FUNCTION show_g_var RETURN NUMBER IS
    BEGIN
        RETURN (g_var);
    END show_g_var;
END pers_pkg;

begin
    DBMS_OUTPUT.PUT_LINE(pers_pkg.show_g_var());
end;

begin
    pers_pkg.upd_g_var(100);
end;

begin
    pers_pkg.upd_g_var(1);
end;



create or replace package cursor_state is
    cursor emp_dept_curs is select distinct FIRST_NAME, LAST_NAME, DEPARTMENT_NAME, SALARY
                            from EMPLOYEES
                                     join DEPARTMENTS on EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
                            order by EMPLOYEE_ID;
    procedure open_curs;
    procedure fetch_n_rows(p_number in number);
    procedure close_curs;
end cursor_state;

create or replace package body cursor_state is
    procedure open_curs is
    begin
        if not emp_dept_curs%isopen then
            open emp_dept_curs;
        end if;
    end open_curs;
    procedure fetch_n_rows(p_number in number) is
        type emp_rec is record
                        (
                            first_name      EMPLOYEES.FIRST_NAME%type,
                            last_name       EMPLOYEES.LAST_NAME%type,
                            department_name DEPARTMENTS.DEPARTMENT_NAME%type,
                            salary          EMPLOYEES.SALARY%type
                        );
        v_emp   emp_rec;
        v_count number;
    begin
        DBMS_OUTPUT.PUT_LINE('Number of rows: ' || p_number);
        if emp_dept_curs%isopen then
            for v_count in 1..p_number
                loop
                    DBMS_OUTPUT.PUT('Row ' || v_count || ' ');
                    fetch emp_dept_curs into v_emp;
                    exit when emp_dept_curs%notfound;
                    DBMS_OUTPUT.PUT_LINE(v_emp.first_name || ' ' || v_emp.last_name || ' ' || v_emp.department_name ||
                                         ' ' || v_emp.salary);
                end loop;
        end if;
    end fetch_n_rows;
    procedure close_curs is
    begin
        if emp_dept_curs%isopen then
            close emp_dept_curs;
        end if;
    end close_curs;
end cursor_state;

begin
    cursor_state.open_curs();
    cursor_state.fetch_n_rows(3);
    cursor_state.fetch_n_rows(7);
    cursor_state.close_curs();
end;



select OBJECT_NAME
from ALL_OBJECTS
where OBJECT_TYPE = 'PACKAGE'
  and OWNER = 'SYS'
order by OBJECT_NAME;


CREATE OR REPLACE PROCEDURE display_proc IS
BEGIN
    FOR i IN 1..10
        LOOP
            DBMS_OUTPUT.PUT(i || ' ');
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('done');
END;

begin
    display_proc();
end;



create or replace procedure display_emp_names(p_names out varchar2) is
    cursor emp_curs is select LAST_NAME
                       from EMPLOYEES
                       where DEPARTMENT_ID = 80
                       order by LAST_NAME ASC;
begin
    for v_name in emp_curs
        loop
            p_names := p_names || v_name.LAST_NAME || ' ';
        end loop;
end;

declare
    v_names varchar2(32767);
begin
    display_emp_names(p_names => v_names);
    DBMS_OUTPUT.PUT_LINE(v_names);
end;

CREATE DIRECTORY emps_dir AS '/u01/employee_data';

CREATE OR REPLACE PROCEDURE list_sals IS
    v_file UTL_FILE.FILE_TYPE;
    CURSOR empc IS sELECT last_name, salary
                   FROM employees
                   ORDER BY salary;
BEGIN
    UTL_FILE.PUT_LINE(v_file, ' *** START OF REPORT ***');
    v_file := UTL_FILE.FOPEN('EMPS_DIR', 'salaries.txt', 'w');
    FOR emp_rec IN empc
        LOOP
            UTL_FILE.PUT_LINE(v_file, emp_rec.last_name || ' earns: ' || emp_rec.salary);
        END LOOP;
    UTL_FILE.PUT_LINE(v_file, '*** END OF REPORT ***');
    UTL_FILE.FCLOSE(v_file);
EXCEPTION
    WHEN UTL_FILE.INVALID_FILEHANDLE THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid File.');
    WHEN UTL_FILE.WRITE_ERROR THEN
        RAISE_APPLICATION_ERROR(-20002, 'Unable to write to file');
END list_sals;



SELECT object_name, timestamp
FROM USER_OBJECTS
WHERE object_type = 'FUNCTION';