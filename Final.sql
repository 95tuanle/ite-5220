-- Question 1
create or replace package Final_exam_N01414195 is
    type t_first_names is table of EMPLOYEES.FIRST_NAME%type index by binary_integer;
    function get_first_names_by_department_id (p_department_id in EMPLOYEES.DEPARTMENT_ID%type) return t_first_names;
end;

create or replace package body Final_exam_N01414195 is
    function get_first_names_by_department_id (p_department_id in EMPLOYEES.DEPARTMENT_ID%type) return t_first_names is
        v_first_names t_first_names;
    begin
        select FIRST_NAME bulk collect into v_first_names from EMPLOYEES where DEPARTMENT_ID = p_department_id;
        return v_first_names;
    end;
end;

declare
    v_first_names Final_exam_N01414195.t_first_names;
begin
    v_first_names := Final_exam_N01414195.get_first_names_by_department_id(50);
    for i in v_first_names.first..v_first_names.LAST loop
        DBMS_OUTPUT.PUT_LINE(v_first_names(i));
    end loop;
end;



-- Question 2
create table Department_Audit (DEPARTMENT_ID NUMBER(4), OLD_DEPARTMENT_NAME VARCHAR2(30), NEW_DEPARTMENT_NAME VARCHAR2(30));

create or replace trigger department_audit_trigger after update of DEPARTMENT_NAME on DEPARTMENTS for each row
begin
    insert into Department_Audit (department_id, old_department_name, new_department_name) VALUES (:new.DEPARTMENT_ID, :old.DEPARTMENT_NAME, :new.DEPARTMENT_NAME);
end;

begin
    update DEPARTMENTS set DEPARTMENT_NAME = 'Final_Exam_N01414195' where DEPARTMENT_NAME like 'A%';
end;

select * from Department_Audit;



-- Question 3
create or replace procedure execute_delete_by_id_sql_statement (p_delete_by_id_sql_statement in varchar2, p_department_id in DEPARTMENTS.DEPARTMENT_ID%type) is
begin
    execute immediate p_delete_by_id_sql_statement || p_department_id;
end;

begin
    execute_delete_by_id_sql_statement('delete from DEPARTMENTS where DEPARTMENT_ID = ', 190);
end;

select * from DEPARTMENTS;



-- Question 4
create table Final_Exam_Marks (User_Id varchar2(33), Mark number);

begin
    insert into Final_Exam_Marks (User_Id, Mark) VALUES ('N01234567', 80);
    savepoint SavePoint_1;
    insert into Final_Exam_Marks (User_Id, Mark) VALUES ('N07654321', 90);
    savepoint SavePoint_2;
    insert into Final_Exam_Marks (User_Id, Mark) VALUES ('N01414195', 100);
    savepoint SavePoint_3;
    rollback to SavePoint_3;
    commit;
end;

select * from Final_Exam_Marks;






















create or replace procedure update_department_by_manager_id (old_Manager_ID in DEPARTMENTS.MANAGER_ID%type, new_Manager_ID in DEPARTMENTS.MANAGER_ID%type) is
    type t_department_id is table of DEPARTMENTS.DEPARTMENT_ID%type index by binary_integer;
    type t_departments is table of DEPARTMENTS%rowtype index by binary_integer;
    v_departments t_departments;
begin
    update DEPARTMENTS set MANAGER_ID = new_Manager_ID where MANAGER_ID = old_Manager_ID returning * bulk collect into v_departments;
    DBMS_OUTPUT.PUT_LINE('DEPARTMENT_ID ||  DEPARTMENT_NAME ||  MANAGER_ID  ||  LOCATION_ID');
--     for department_rec in v_departments loop
--         DBMS_OUTPUT.PUT_LINE(department_rec.DEPARTMENT_ID || '  ||  ' || department_rec.DEPARTMENT_NAME || '    ||  ' || department_rec.MANAGER_ID || ' ||  ' || department_rec.LOCATION_ID);
--     end loop;
end;

begin
    update_department_by_manager_id(149, 103);
end;


declare
    cursor departments_curs (p_manager_id DEPARTMENTS.MANAGER_ID%type) is select * from DEPARTMENTS where MANAGER_ID = p_manager_id;
begin
    DBMS_OUTPUT.PUT_LINE('DEPARTMENT_ID ||  DEPARTMENT_NAME ||   MANAGER_ID ||  LOCATION_ID');
    for department_rec in departments_curs (149) loop
        DBMS_OUTPUT.PUT_LINE(department_rec.DEPARTMENT_ID || '  ||  ' || department_rec.DEPARTMENT_NAME || '    ||  ' || department_rec.MANAGER_ID || ' ||  ' || department_rec.LOCATION_ID);
    end loop;
end;




CREATE OR REPLACE TRIGGER check_salary
BEFORE INSERT OR UPDATE OF salary, job_id ON employees
FOR EACH ROW
DECLARE
v_minsalary employees.salary%TYPE;
v_maxsalary employees.salary%TYPE;
BEGIN
SELECT MIN(salary), MAX(salary)
INTO v_minsalary, v_maxsalary
FROM employees
WHERE job_id = :NEW.job_id;
IF :NEW.salary < v_minsalary OR
:NEW.salary > v_maxsalary THEN
RAISE_APPLICATION_ERROR(-20505,'Salary out of range');
END IF;
END;

update EMPLOYEES set SALARY = 1, JOB_ID = 'ST_MAN' where EMPLOYEE_ID = 235;



DECLARE
    CURSOR DEPARTMENTS_CURSOR (MANAGER_ID_PARAM NUMBER)
    IS SELECT * FROM DEPARTMENTS WHERE MANAGER_ID = MANAGER_ID_PARAM;
    DEPARTMENT_VARIABLE DEPARTMENTS%ROWTYPE;
BEGIN
    OPEN DEPARTMENTS_CURSOR(100);
    LOOP
        FETCH DEPARTMENTS_CURSOR INTO DEPARTMENT_VARIABLE;
        EXIT WHEN DEPARTMENTS_CURSOR%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(DEPARTMENT_VARIABLE.DEPARTMENT_NAME);
    END LOOP;
    CLOSE DEPARTMENTS_CURSOR;
END;



CREATE OR REPLACE PACKAGE FINAL_EXAM_N01234567 IS
    TYPE FIRST_NAME_TYPE IS TABLE OF EMPLOYEES.FIRST_NAME%TYPE INDEX BY BINARY_INTEGER;
    FUNCTION GET_FIRST_NAMES (DEPARTMENT_ID_PARAM EMPLOYEES.DEPARTMENT_ID%TYPE) RETURN FIRST_NAME_TYPE;
END;

CREATE OR REPLACE PACKAGE BODY FINAL_EXAM_N01234567 IS
    FUNCTION GET_FIRST_NAMES (DEPARTMENT_ID_PARAM EMPLOYEES.DEPARTMENT_ID%TYPE) RETURN FIRST_NAME_TYPE IS
    FIRST_NAME_TYPE_VARIABLE FIRST_NAME_TYPE;
    BEGIN
        SELECT FIRST_NAME BULK COLLECT INTO FIRST_NAME_TYPE_VARIABLE FROM EMPLOYEES WHERE DEPARTMENT_ID = DEPARTMENT_ID_PARAM;
        RETURN FIRST_NAME_TYPE_VARIABLE;
    END;
END;

DECLARE
    FIRST_NAME_VARIABLE FINAL_EXAM_N01234567.FIRST_NAME_TYPE;
BEGIN
    FIRST_NAME_VARIABLE := FINAL_EXAM_N01234567.GET_FIRST_NAMES(10);
    FOR I IN FIRST_NAME_VARIABLE.FIRST..FIRST_NAME_VARIABLE.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(FIRST_NAME_VARIABLE(I));
    END LOOP;
END;

create or replace package final_exam_n01234567 is
type fname_question1 is table of employees.first_name%type;
function get_first_names (id_question1 employees.department_id%type) return fname_question1;
end;

create or replace package body final_exam_n01234567 is
function get_first_names (id_question1 employees.department_id%type) return fname_question1 is
variable_question1 fname_question1;
begin
select first_name bulk collect into variable_question1 from employees where department_id = id_question1;
return variable_question1;
end;end;

    drop package final_exam_n01234567;
alter package final_exam_n01234567 compile body;

DECLARE
    FIRST_NAME_VARIABLE final_exam_n01234567.fname_question1;
BEGIN
    FIRST_NAME_VARIABLE := final_exam_n01234567.GET_FIRST_NAMES(10);
    FOR I IN FIRST_NAME_VARIABLE.FIRST..FIRST_NAME_VARIABLE.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(FIRST_NAME_VARIABLE(I));
    END LOOP;
END;

CREATE OR REPLACE PACKAGE TEST_PACKAGE IS
    TYPE DEPARTMENT_ROW_TYPE IS TABLE OF DEPARTMENTS%ROWTYPE INDEX BY BINARY_INTEGER;
    PROCEDURE UPDATE_MANAGER (OLD_MANAGER_ID NUMBER, NEW_MANAGER_ID NUMBER, DEPARTMENT_ROWS IN OUT DEPARTMENT_ROW_TYPE);
END;

CREATE OR REPLACE PACKAGE BODY TEST_PACKAGE IS
    PROCEDURE UPDATE_MANAGER (OLD_MANAGER_ID NUMBER, NEW_MANAGER_ID NUMBER, DEPARTMENT_ROWS IN OUT DEPARTMENT_ROW_TYPE) IS
    BEGIN
        UPDATE DEPARTMENTS SET MANAGER_ID = NEW_MANAGER_ID WHERE MANAGER_ID = OLD_MANAGER_ID;
        SELECT * BULK COLLECT INTO DEPARTMENT_ROWS FROM DEPARTMENTS WHERE MANAGER_ID = NEW_MANAGER_ID;
    END;
END;

DECLARE
    DEPARTMENT_ROW_TYPE_VARIABLE TEST_PACKAGE.DEPARTMENT_ROW_TYPE;
BEGIN
    TEST_PACKAGE.UPDATE_MANAGER(200, 201, DEPARTMENT_ROW_TYPE_VARIABLE);
    FOR I IN DEPARTMENT_ROW_TYPE_VARIABLE.FIRST..DEPARTMENT_ROW_TYPE_VARIABLE.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(DEPARTMENT_ROW_TYPE_VARIABLE(I).DEPARTMENT_NAME ||  DEPARTMENT_ROW_TYPE_VARIABLE(I).DEPARTMENT_ID);
    END LOOP;
END;




DROP TABLE department_audit PURGE;

CREATE TABLE department_audit(
department_id NUMBER(4),
old_department_name VARCHAR2(50),
new_department_name VARCHAR2(50)
);

CREATE OR REPLACE TRIGGER DEPT_TRIGGER
FOR UPDATE OF department_name ON departments COMPOUND TRIGGER
v_change_result VARCHAR2(200);
BEFORE EACH ROW IS
BEGIN
DBMS_OUTPUT.PUT_LINE('BEFORE UPDATE');
END BEFORE EACH ROW;
AFTER EACH ROW IS
BEGIN
INSERT INTO department_audit(department_id, old_department_name, new_department_name) VALUES (:OLD.DEPARTMENT_ID, :OLD.department_name,:NEW.department_name);
DBMS_OUTPUT.PUT_LINE('AFTER UPDATE');
END AFTER EACH ROW;
END DEPT_TRIGGER;

DECLARE
CURSOR cur_dept_upd IS
SELECT department_name
FROM departments
WHERE department_name LIKE 'A%'
FOR UPDATE;
BEGIN
FOR upd_dept_rec IN cur_dept_upd LOOP
UPDATE departments
SET department_name = 'Final_Exam_N01234567'
WHERE CURRENT OF cur_dept_upd;
END LOOP;
END;

SELECT * FROM department_audit;

update DEPARTMENTS set DEPARTMENT_NAME = 'Administration' where DEPARTMENT_ID = 10;
update DEPARTMENTS set DEPARTMENT_NAME = 'Accounting' where DEPARTMENT_ID = 110;



create or replace procedure abc is
begin

end;


DECLARE
CURSOR emp_curs IS
SELECT last_name, salary FROM employees;
v_last_name employees.last_name%TYPE;
v_salary employees.salary%TYPE;
BEGIN
FETCH emp_curs INTO v_last_name, v_salary;
OPEN emp_curs;
FETCH emp_curs INTO v_last_name, v_salary;
CLOSE emp_curs;
END;


DECLARE
CURSOR emp_curs IS
SELECT last_name, salary FROM employees;
v_last_name employees.last_name%TYPE;
v_salary employees.salary%TYPE;
BEGIN
OPEN emp_curs;
FETCH emp_curs INTO v_last_name, v_salary;
CLOSE emp_curs;
END;

DECLARE
CURSOR emp_curs IS
SELECT last_name, salary FROM employees;
v_last_name employees.last_name%TYPE;
v_salary employees.salary%TYPE;
BEGIN
FETCH emp_curs INTO v_last_name, v_salary;
CLOSE emp_curs;
END;


declare
TYPE t_hire_date IS TABLE OF DATE
INDEX BY BINARY_INTEGER;
v_hire_date_tab t_hire_date;
begin
DBMS_OUTPUT.PUT_LINE('hello');
end;


CREATE OR REPLACE TRIGGER check_salary
BEFORE INSERT OR UPDATE OF salary, job_id ON employees
FOR EACH ROW
DECLARE
v_minsalary employees.salary%TYPE;
v_maxsalary employees.salary%TYPE;
BEGIN
SELECT MIN(salary), MAX(salary)
INTO v_minsalary, v_maxsalary
FROM employees
WHERE job_id = :NEW.job_id;
IF :NEW.salary < v_minsalary OR
:NEW.salary > v_maxsalary THEN
RAISE_APPLICATION_ERROR(-20505,'Salary out of range');
END IF;
END;

update EMPLOYEES set SALARY = 1 where EMPLOYEE_ID = 100;





create or replace procedure execute_delete_by_id_sql_statement (p_delete_by_id_sql_statement in varchar2, p_department_id in DEPARTMENTS.DEPARTMENT_ID%type) is
begin
    execute immediate p_delete_by_id_sql_statement || p_department_id;
end;

begin
    execute_delete_by_id_sql_statement('delete from DEPARTMENTS where DEPARTMENT_ID = ', 190);
end;

select * from DEPARTMENTS;


CREATE OR REPLACE PROCEDURE DEL_DEPT_PROC (SQL_STATEMENT VARCHAR2, DEPARTMENT_ID NUMBER) IS
BEGIN
    EXECUTE IMMEDIATE SQL_STATEMENT || DEPARTMENT_ID;
END;

BEGIN
    DEL_DEPT_PROC('DELETE FROM DEPARTMENTS WHERE DEPARTMENT_ID=', 190);
END;

SELECT COUNT(*) FROM DEPARTMENTS WHERE DEPARTMENT_ID = 190;