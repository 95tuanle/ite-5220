DECLARE
    TYPE dept_rec IS RECORD
        (v_dept_id departments.department_id%TYPE,
        v_dept_name departments.department_name%TYPE,
        v_mgr_id departments.manager_id%TYPE,
        v_loc_id departments.location_id%TYPE);
    v_dept_rec dept_rec;
BEGIN
    SELECT department_id, department_name, manager_id, location_id
    INTO v_dept_rec
    FROM departments
    WHERE department_id = 80;
    DBMS_OUTPUT.PUT_LINE(v_dept_rec.v_dept_id || ' ' || v_dept_rec.v_dept_name || ' ' || v_dept_rec.v_mgr_id || ' ' || v_dept_rec.v_loc_id);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('This department does not exist');
END;



DECLARE
    TYPE t_country_name IS TABLE OF COUNTRIES.COUNTRY_NAME%TYPE
        INDEX BY BINARY_INTEGER;
    v_country_name t_country_name;
BEGIN
    FOR country_name_rec IN (SELECT COUNTRY_ID, COUNTRY_NAME FROM COUNTRIES WHERE REGION_ID = 5 ORDER BY COUNTRY_ID) LOOP
        v_country_name(country_name_rec.COUNTRY_ID) := country_name_rec.COUNTRY_NAME;
    END LOOP;

    FOR i IN v_country_name.FIRST..v_country_name.LAST LOOP
        IF v_country_name.EXISTS(i) THEN
            DBMS_OUTPUT.PUT_LINE(i || '' || v_country_name(i));
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(v_country_name.FIRST || ' ' || v_country_name(v_country_name.FIRST));
    DBMS_OUTPUT.PUT_LINE(v_country_name.LAST || ' ' || v_country_name(v_country_name.LAST));
    DBMS_OUTPUT.PUT_LINE('The number of elements in the table = ' || v_country_name.COUNT);
END;



DECLARE
    CURSOR emp_cur IS SELECT EMPLOYEE_ID, LAST_NAME, JOB_ID, SALARY FROM EMPLOYEES ORDER BY EMPLOYEE_ID;
    TYPE t_emp IS TABLE OF emp_cur%ROWTYPE
        INDEX BY BINARY_INTEGER;
    v_emp t_emp;
BEGIN
    FOR emp_rec IN emp_cur LOOP
        v_emp(emp_rec.EMPLOYEE_ID) := emp_rec;
    END LOOP;

    FOR i IN v_emp.FIRST..v_emp.LAST LOOP
        IF v_emp.EXISTS(i) THEN
            DBMS_OUTPUT.PUT_LINE(i || ' ' || v_emp(i).LAST_NAME || ' ' || v_emp(i).JOB_ID || ' ' || v_emp(i).SALARY);
        END IF;
    END LOOP;
END;



DECLARE
    v_jobid employees.job_id%TYPE;
BEGIN
    SELECT job_id INTO v_jobid
    FROM employees
    WHERE department_id = 80;
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Your select statement retrieved multiple rows. Consider using a cursor.');
END;



BEGIN
INSERT INTO departments (department_id, department_name, manager_id, location_id) VALUES (50, 'A new department', 100, 1500);
DBMS_OUTPUT.PUT_LINE('The new department was inserted');
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE ('An exception has occurred.');
END;



CREATE TABLE emp_temp AS SELECT * FROM employees;

SELECT * FROM emp_temp WHERE department_id = 10;

DECLARE
    v_employee_id emp_temp.employee_id%TYPE;
    v_last_name emp_temp.last_name%TYPE;
BEGIN
    SELECT employee_id, last_name INTO v_employee_id, v_last_name FROM emp_temp
    WHERE department_id = 30; -- run with values 10, 20, and 30 DBMS_OUTPUT.PUT_LINE('The SELECT was successful');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No data found');
        WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('Too many rows');
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('An exception has occurred');
END;

DROP TABLE emp_temp PURGE;



DECLARE
v_number NUMBER(2);
BEGIN
v_number := 9999;
END;



DECLARE
    v_number NUMBER(4);
BEGIN
    v_number := 1234;
    DECLARE
        v_number NUMBER(4);
    BEGIN
        v_number := 5678;
--         v_number := 'A character string';
    END;
    EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An exception has occurred');
    DBMS_OUTPUT.PUT_LINE('The number is: ' || v_number);
END;