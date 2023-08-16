CREATE OR REPLACE PACKAGE nocopy_test AS
    TYPE EmpTabTyp IS TABLE OF employees%ROWTYPE;
    emp_tab EmpTabTyp := EmpTabTyp(NULL);
    PROCEDURE get_time(t OUT NUMBER);
    PROCEDURE do_nothing1(tab IN OUT EmpTabTyp);
    PROCEDURE do_nothing2(tab IN OUT NOCOPY EmpTabTyp);
END nocopy_test;

CREATE OR REPLACE PACKAGE BODY nocopy_test AS
    PROCEDURE get_time(t OUT NUMBER) IS
    BEGIN
        t := DBMS_UTILITY.get_time;
    END;
    PROCEDURE do_nothing1(tab IN OUT EmpTabTyp) IS
    BEGIN
        NULL;
    END;
    PROCEDURE do_nothing2(tab IN OUT NOCOPY EmpTabTyp) IS
    BEGIN
        NULL;
    END;
END nocopy_test;

DECLARE
    t1 NUMBER;
    t2 NUMBER;
    t3 NUMBER;
BEGIN
    SELECT *
    INTO nocopy_test.emp_tab(1)
    FROM EMPLOYEES
    WHERE employee_id = 100;
    nocopy_test.emp_tab.EXTEND(49999, 1); -- Copy element 1 into 2..50000
    nocopy_test.get_time(t1);
    nocopy_test.do_nothing1(nocopy_test.emp_tab); -- Pass IN OUT parameter
    nocopy_test.get_time(t2);
    nocopy_test.do_nothing2(nocopy_test.emp_tab); -- Pass IN OUT NOCOPY parameter
    nocopy_test.get_time(t3);
    DBMS_OUTPUT.PUT_LINE('Call Duration (secs)');
    DBMS_OUTPUT.PUT_LINE('--------------------');
    DBMS_OUTPUT.PUT_LINE('Just IN OUT: ' || TO_CHAR((t2 - t1) / 100.0));
    DBMS_OUTPUT.PUT_LINE('With NOCOPY: ' || TO_CHAR((t3 - t2)) / 100.0);
END;



CREATE OR REPLACE PROCEDURE raise_salary(p_percent NUMBER) IS
    TYPE numlist_type IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
    v_id numlist_type; -- collection
BEGIN
    v_id(1) := 100;
    v_id(2) := 102;
    v_id(3) := 104;
    v_id(4) := 110;
    -- bulk-bind the associative array
    FORALL i IN v_id.FIRST .. v_id.LAST
        UPDATE employees
        SET salary = (1 + p_percent / 100) * salary
        WHERE employee_id = v_id(i);
END;

SELECT salary
FROM employees
WHERE employee_id = 100
   OR employee_id = 102
   OR employee_id = 104
   OR employee_id = 100;

BEGIN
    raise_salary(10);
END;

SELECT salary
FROM employees
WHERE employee_id = 100
   OR employee_id = 102
   OR employee_id = 104
   OR employee_id = 100;



create or replace procedure get_departments(p_location_id DEPARTMENTS.LOCATION_ID%type) is
    type t_dept is table of DEPARTMENTS%rowtype index by binary_integer;
    v_deptab t_dept;
begin
    select * bulk collect into v_deptab from DEPARTMENTS;
    for i in v_deptab.FIRST..v_deptab.LAST
        loop
            if v_deptab.EXISTS(i) then
                if v_deptab(i).LOCATION_ID = p_location_id then
                    DBMS_OUTPUT.PUT_LINE(v_deptab(i).DEPARTMENT_NAME || ' ' || v_deptab(i).LOCATION_ID);
                end if;
            end if;
        end loop;
end;

begin
    get_departments(1700);
end;



drop table emp_temp purge;

create table emp_temp as
select *
from EMPLOYEES;

declare
    type t_emp_id is table of EMP_TEMP.EMPLOYEE_ID%type index by binary_integer;
    type t_emp_name is table of EMP_TEMP.LAST_NAME%type index by binary_integer;
    v_emp_id_tab   t_emp_id;
    v_emp_name_tab t_emp_name;
begin
    select EMPLOYEE_ID bulk collect into v_emp_id_tab from emp_temp where DEPARTMENT_ID = 20;
    forall i in v_emp_id_tab.FIRST..v_emp_id_tab.LAST delete
                                                      from emp_temp
                                                      where EMPLOYEE_ID = v_emp_id_tab(i)
                                                      returning LAST_NAME bulk collect into v_emp_name_tab;
    DBMS_OUTPUT.PUT_LINE('Deleted ' || SQL%ROWCOUNT || ' rows:');
    for i in v_emp_id_tab.FIRST..v_emp_id_tab.LAST
        loop
            DBMS_OUTPUT.PUT_LINE('Employee #' || v_emp_id_tab(i) || ': ' || v_emp_name_tab(i));
        end loop;
end;

CREATE OR REPLACE FUNCTION check_dept(p_dept_in IN number)
    RETURN BOOLEAN IS
    v_dept departments.department_id%TYPE;
BEGIN
    SELECT department_id
    INTO v_dept
    FROM departments
    WHERE department_id = p_dept_in;
    RETURN TRUE;
EXCEPTION
    WHEN NO_DATA_FOUND THEN RETURN FALSE;
END;


CREATE OR REPLACE PROCEDURE new_emp(p_empid IN employees.employee_id%TYPE,
                                    p_fname IN employees.first_name%TYPE,
                                    p_lname IN employees.last_name%TYPE,
                                    p_email IN employees.email%TYPE,
                                    p_hdate IN employees.hire_date%TYPE,
                                    p_job IN employees.job_id%TYPE,
                                    p_dept_id IN employees.department_id%TYPE) IS
BEGIN
    IF check_dept(p_dept_id) THEN
        INSERT INTO employees (employee_id, first_name, last_name, email, hire_date, job_id, department_id)
        VALUES (p_empid, p_fname, p_lname, p_email, p_hdate, p_job, p_dept_id);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Invalid department number given, please try again.');
    END IF;
END;

select *
from USER_OBJECTS;

describe USER_OBJECTS;

alter procedure NEW_EMP compile;

select OBJECT_NAME, OBJECT_TYPE, STATUS
from USER_OBJECTS
where OBJECT_NAME in ('EMPLOYEES', 'NEW_EMP', 'CHECK_DEPT');



describe USER_DEPENDENCIES;

select NAME, TYPE
from USER_DEPENDENCIES
where REFERENCED_NAME = 'EMPLOYEES'
order by TYPE;

describe deptree_temptab;
describe deptree_fill;
describe deptree;
describe ideptree;