create or replace function full_name (p_last_name in EMPLOYEES.LAST_NAME%type, p_first_name in EMPLOYEES.FIRST_NAME%type)
return varchar2 is v_full_name varchar2(50);
begin
    v_full_name := p_last_name || ', ' || p_first_name;
    return v_full_name;
end full_name;

begin
    DBMS_OUTPUT.PUT_LINE(full_name('Smith', 'Joe'));
end;

select FIRST_NAME, LAST_NAME, full_name(FIRST_NAME, LAST_NAME) from EMPLOYEES where DEPARTMENT_ID = 50;



create or replace function divide (p_first_number in number, p_second_number in number)
return number is v_result number;
begin
    v_result := round(p_first_number/p_second_number, 2);
    return v_result;
    exception
    when ZERO_DIVIDE then
    return 0;
end divide;

begin
    DBMS_OUTPUT.PUT_LINE(divide(16, 0));
end;



CREATE OR REPLACE PROCEDURE get_country_name_proc (p_country_id IN countries.country_id%TYPE, p_country_name OUT countries.country_name%TYPE) IS
BEGIN
    SELECT country_name INTO p_country_name
    FROM countries
    WHERE country_id = p_country_id;
END;

CREATE OR REPLACE FUNCTION get_country_name_func (p_country_id IN countries.country_id%TYPE)
RETURN VARCHAR2 IS
v_country_name countries.country_name%TYPE;
BEGIN
    SELECT country_name INTO v_country_name FROM countries
    WHERE country_id = p_country_id;
    RETURN v_country_name;
END;

declare
    v_country_name COUNTRIES.COUNTRY_NAME%type;
begin
    get_country_name_proc(2, v_country_name);
    DBMS_OUTPUT.PUT_LINE(v_country_name);
    DBMS_OUTPUT.PUT_LINE(get_country_name_func(2));
end;

DECLARE
    v_country_id countries.country_id%TYPE := 2;
    v_country_name countries.country_name%TYPE;
BEGIN
    get_country_name_proc(v_country_id, v_country_name);
    v_country_name := get_country_name_func(v_country_id);
    v_country_name := get_country_name_proc(v_country_id);
END;
SELECT get_country_name_proc(country_id) FROM countries;
SELECT get_country_name_func(country_id) FROM countries;



create or replace function reverse_string (p_input_string varchar2)
return varchar2 is v_output_string varchar2(100);
begin
    for i in reverse 1..length(p_input_string) loop
        v_output_string := v_output_string || substr(p_input_string, i, 1);
    end loop;
    return v_output_string;
end;

SELECT last_name, reverse_string(last_name) FROM employees;
SELECT country_name, reverse_string(country_name) FROM countries;


drop table f_emps purge;
drop table f_depts purge;

CREATE TABLE f_emps
AS SELECT employee_id, last_name, salary, department_id FROM employees;
CREATE TABLE f_depts
AS SELECT department_id, department_name FROM departments;

CREATE OR REPLACE FUNCTION sal_increase (p_salary f_emps.salary%TYPE, p_percent_incr NUMBER)
RETURN NUMBER IS
BEGIN
RETURN (p_salary + (p_salary * p_percent_incr / 100));
END;
SELECT last_name, salary, sal_increase(salary, 5) FROM f_emps;

select last_name, salary, (salary + (salary * 5 / 100)) from f_emps where (salary + (salary * 5 / 100)) > 10000;
select last_name, salary, sal_increase(salary, 5) from f_emps where sal_increase(salary, 5) > 10000;

select last_name, salary, sal_increase(salary, 5) as increased_salary
from f_emps where sal_increase(salary, 5) > 10000 order by increased_salary desc;

SELECT department_id, SUM(salary) FROM f_emps
GROUP BY department_id
HAVING SUM(salary) > 20000;

SELECT department_id, SUM(salary), SUM(sal_increase(salary, 5)) FROM f_emps
GROUP BY department_id
HAVING SUM(sal_increase(salary, 5)) > 20000;

CREATE OR REPLACE FUNCTION check_dept (p_dept_id f_depts.department_id%TYPE)
RETURN BOOLEAN IS
v_dept_id f_depts.department_id%TYPE;
BEGIN
SELECT department_id INTO v_dept_id FROM f_depts
WHERE department_id = p_dept_id;
RETURN TRUE;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN FALSE;
END;

create or replace procedure insert_emp (p_employee_id in EMPLOYEES.EMPLOYEE_ID%type,
p_last_name in EMPLOYEES.LAST_NAME%type, p_salary in EMPLOYEES.SALARY%type, p_department_id EMPLOYEES.DEPARTMENT_ID%type) is
begin
    if (not check_dept(p_department_id)) then
        insert into f_depts values (p_department_id, 'Temporary');
    end if;
    insert into f_emps values (p_employee_id, p_last_name, p_salary, p_department_id);
end;

begin
    insert_emp(800, 'Jokinen', 5000, 750);
end;

select * from f_emps natural join f_depts where employee_id = 800;

CREATE OR REPLACE FUNCTION get_sal (p_emp_id f_emps.employee_id%TYPE)
RETURN NUMBER IS
v_salary f_emps.salary%TYPE;
BEGIN
SELECT salary INTO v_salary FROM f_emps
WHERE employee_id = p_emp_id;
RETURN v_salary;
END;

UPDATE f_emps
SET department_id = 50
WHERE get_sal(employee_id) > 10000;

CREATE OR REPLACE FUNCTION upd_sal (p_emp_id f_emps.employee_id%TYPE)
RETURN NUMBER IS
v_salary f_emps.salary%TYPE; BEGIN
SELECT salary INTO v_salary FROM f_emps
WHERE employee_id = p_emp_id;
v_salary := v_salary * 2;
UPDATE f_emps
SET salary = v_salary
WHERE employee_id = p_emp_id; RETURN v_salary;
END;

SELECT employee_id, last_name, salary, upd_sal(employee_id) FROM f_emps
WHERE employee_id = 100;



select OBJECT_NAME, OBJECT_TYPE, STATUS from USER_OBJECTS order by OBJECT_TYPE;

select OBJECT_NAME, OBJECT_TYPE, STATUS, OWNER from ALL_OBJECTS where OBJECT_TYPE = 'FUNCTION' or OBJECT_TYPE = 'PROCEDURE' order by OBJECT_TYPE;

select * from DICT where TABLE_NAME like '%VIEW%';



CREATE TABLE my_depts AS SELECT * FROM departments;

ALTER TABLE my_depts
ADD CONSTRAINT my_dept_id_pk PRIMARY KEY (department_id);

CREATE OR REPLACE PROCEDURE add_my_dept (p_dept_id IN VARCHAR2, p_dept_name IN VARCHAR2) IS
BEGIN
INSERT INTO my_depts (department_id, department_name)
VALUES (p_dept_id, p_dept_name);
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('An error was found.');
END add_my_dept;

begin
    add_my_dept(10, 'Hello World!');
end;

CREATE OR REPLACE PROCEDURE add_my_dept (p_dept_id IN VARCHAR2, p_dept_name IN VARCHAR2) IS
BEGIN
INSERT INTO my_depts (department_id,department_name)
VALUES (p_dept_id, p_dept_name);
END add_my_dept;

CREATE OR REPLACE PROCEDURE outer_proc IS v_dept NUMBER(2) := 10;
v_dname VARCHAR2(30) := 'Admin';
BEGIN
add_my_dept(v_dept, v_dname);
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Exception was propagated to outer_proc');
END;

begin
    outer_proc();
end;

select OBJECT_NAME from USER_OBJECTS where OBJECT_TYPE = 'PROCEDURE';

drop procedure outer_proc;

select TEXT from USER_SOURCE where NAME = 'ADD_MY_DEPT' order by LINE;

grant select, insert, update, delete on COUNTRIES to SUSAN;

select * from ALL_OBJECTS where (OBJECT_TYPE = 'PROCEDURE' or OBJECT_TYPE = 'FUNCTION') and OWNER = 'N01414195';



create table NEW_DEPT_TAB as select * from DEPARTMENTS;

create or replace procedure ins_new_dept
(p_department_id in NEW_DEPT_TAB.DEPARTMENT_ID%type, p_department_name in NEW_DEPT_TAB.DEPARTMENT_NAME%type,
p_manager_id in NEW_DEPT_TAB.MANAGER_ID%type, p_location_id in NEW_DEPT_TAB.LOCATION_ID%type) is
begin
    insert into NEW_DEPT_TAB values (p_department_id, p_department_name, p_manager_id, p_location_id);
end;

grant execute on ins_new_dept to SUSAN;

describe SUSAN.INS_NEW_DEPT;

begin
    N01414195.ins_new_dept(333, 'New Department', 333, 33);
end;

select * from NEW_DEPT_TAB where DEPARTMENT_ID = 333;

revoke execute on NEW_DEPT_TAB from SUSAN;

describe SUSAN.INS_NEW_DEPT;



describe IACAD_SCHEMA.show_emps_def;
describe IACAD_SCHEMA.show_emps_inv;

select * from IACAD_SCHEMA.EMPS;

begin
    IACAD_SCHEMA.show_emps_def(100);
end;

begin
    IACAD_SCHEMA.show_emps_inv(100);
end;

grant execute on show_emp_inv to N01414195;
grant select on EMPS to N01414195;
