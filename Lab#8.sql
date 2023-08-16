DECLARE
    v_number      NUMBER(6, 2) := 100;
    v_region_id   regions.region_id%TYPE;
    v_region_name regions.region_name%TYPE;
BEGIN
    SELECT region_id, region_name
    INTO v_region_id, v_region_name
    FROM regions
    WHERE region_id = 29;
    DBMS_OUTPUT.PUT_LINE('Region: ' || v_region_id || ' is: ' || v_region_name); v_number := v_number / 0;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No data found');
    WHEN ZERO_DIVIDE THEN
        DBMS_OUTPUT.PUT_LINE('Divisor is equal to zero');
END;



DECLARE
    e_cursor_exception EXCEPTION;
    PRAGMA EXCEPTION_INIT ( e_cursor_exception, -01001 );
    CURSOR regions_curs IS SELECT *
                           FROM regions
                           WHERE region_id < 20
                           ORDER BY region_id;
    regions_rec regions_curs%ROWTYPE;
    v_count     NUMBER(6);
BEGIN
    OPEN regions_curs;
    LOOP
        FETCH regions_curs INTO regions_rec;
        EXIT WHEN regions_curs%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Region: ' || regions_rec.region_id || ' Name: ' || regions_rec.region_name);
    END LOOP;
    CLOSE regions_curs;
    SELECT COUNT(*)
    INTO v_count
    FROM regions
    WHERE region_id = 1;
    DBMS_OUTPUT.PUT_LINE('The number of regions is: ' || v_count);
EXCEPTION
    WHEN e_cursor_exception THEN
        DBMS_OUTPUT.PUT_LINE('The cursor needs to be opened before use');
END;


DROP TABLE error_log PURGE;

CREATE TABLE error_log
(
    who           VARCHAR2(30),
    when          DATE,
    error_code    NUMBER(6),
    error_message VARCHAR2(255)
);

DECLARE
    v_language_id   languages.language_id%TYPE;
    v_language_name languages.language_name%TYPE;
    v_sqlcode       error_log.error_code%type;
    v_sqlerrm       error_log.error_message%type;
BEGIN
    SELECT language_id, language_name
    INTO v_language_id, v_language_name
    FROM languages
    WHERE LOWER(language_name) LIKE 'al%'; -- for example 'ab%'
    INSERT INTO languages(language_id, language_name)
    VALUES (80, null);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        v_sqlcode := SQLCODE;
        v_sqlerrm := SQLERRM;
        INSERT INTO error_log VALUES (USER, SYSDATE, v_sqlcode, v_sqlerrm);
        COMMIT;
END;

SELECT *
FROM error_log;


drop table excep_emps purge;

CREATE TABLE excep_emps AS
SELECT *
FROM employees;

declare
    e_no_rows_updated exception;
begin
    update excep_emps
    set SALARY = 10000
    where DEPARTMENT_ID = 40;
    if sql%rowcount = 0 then
        raise e_no_rows_updated;
    end if;
exception
    when e_no_rows_updated then
        DBMS_OUTPUT.PUT_LINE('No rows were updated');
    when others then
        DBMS_OUTPUT.PUT_LINE(SQLCODE || SQLERRM);
end;

declare
    e_no_rows_updated exception;
begin
    update excep_emps
    set SALARY = 10000
    where DEPARTMENT_ID = 40;
    if sql%rowcount = 0 then
        raise e_no_rows_updated;
    end if;
exception
    when e_no_rows_updated then
        raise_application_error(-20202, 'No rows were updated');
    when others then
        DBMS_OUTPUT.PUT_LINE(SQLCODE || SQLERRM);
end;

begin
    update excep_emps
    set SALARY = 10000
    where DEPARTMENT_ID = 40;
    if sql%rowcount = 0 then
        raise_application_error(-20202, 'No rows were updated');
    end if;
exception
    when others then
        DBMS_OUTPUT.PUT_LINE(SQLCODE || SQLERRM);
end;



DECLARE
    v_dept_id excep_emps.department_id%TYPE;
    v_count   NUMBER;
BEGIN
    v_dept_id := 40;
    SELECT COUNT(*)
    INTO v_count
    FROM excep_emps
    WHERE department_id = v_dept_id;
    if v_count = 0 then
        raise_application_error(-20203, 'There are ' || v_count || ' employees in department id = ' || v_dept_id);
    end if;
    DELETE
    FROM excep_emps
    WHERE department_id = v_dept_id;
    if SQL%ROWCOUNT = 0 then
        raise_application_error(-20204, '0 employees were deleted');
    end if;
    ROLLBACK;
END;



DECLARE
    v_country_name  countries.country_name%TYPE;
    v_currency_code countries.currency_code%TYPE;
    e_no_currency EXCEPTION;
BEGIN
    BEGIN
        SELECT country_name, currency_code
        INTO v_country_name, v_currency_code
        FROM countries
        WHERE country_id = 672; -- repeat with 672
        IF v_currency_code = 'NONE' THEN
            RAISE e_no_currency;
        END IF;
    END;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('This country does not exist');
    WHEN e_no_currency THEN
        DBMS_OUTPUT.PUT_LINE('This country exists but has no currency');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Another type of error occurred');
END;


DECLARE
    v_empid            employees.employee_id%TYPE := 100;
    v_percent_increase NUMBER(2, 2)               := .05;
BEGIN
    UPDATE employees
    SET salary = (salary * v_percent_increase) + salary
    WHERE employee_id = v_empid;
END;


CREATE PROCEDURE pay_raise(p_empid employees.employee_id%TYPE, p_percent_increase NUMBER) IS
BEGIN
    UPDATE employees
    SET salary = (salary * p_percent_increase) + salary
    WHERE employee_id = p_empid;
END pay_raise;


drop table employees_dup purge;

CREATE TABLE employees_dup AS
SELECT *
from employees;

CREATE OR REPLACE PROCEDURE name_change IS
BEGIN
    UPDATE employees_dup SET first_name = 'Susan' WHERE department_id = 80;
END name_change;

BEGIN
    name_change;
END;

select FIRST_NAME
from employees_dup
where DEPARTMENT_ID = 80;



CREATE OR REPLACE PROCEDURE pay_raise IS
BEGIN
    UPDATE employees_dup SET SALARY = 30000;
END pay_raise;

begin
    pay_raise;
end;

select SALARY
from employees_dup;



CREATE OR REPLACE PROCEDURE update_salary IS
BEGIN
    UPDATE employees_dup SET SALARY = 1000 WHERE DEPARTMENT_ID = 80;
    UPDATE employees_dup SET SALARY = 2000 WHERE DEPARTMENT_ID = 50;
    UPDATE employees_dup SET SALARY = 3000 WHERE DEPARTMENT_ID NOT IN (50, 80) OR DEPARTMENT_ID IS NULL;
END update_salary;


begin
    update_salary;
end;

select SALARY, DEPARTMENT_ID
from employees_dup;



create or replace procedure get_country_info(p_country_id in COUNTRIES.COUNTRY_ID%type) is
    v_country_name COUNTRIES.COUNTRY_NAME%type;
    v_capitol      COUNTRIES.CAPITOL%type;
begin
    select COUNTRY_NAME, CAPITOL into v_country_name, v_capitol from COUNTRIES where COUNTRY_ID = p_country_id;
    DBMS_OUTPUT.PUT_LINE('Country Name - ' || v_country_name || ' | Capitol City - ' || v_capitol);
exception
    when NO_DATA_FOUND then
        DBMS_OUTPUT.PUT_LINE('No country has country_id = ' || p_country_id);
end get_country_info;

begin
    get_country_info(95);
end;



create or replace procedure get_number_of_countries(p_region_id in COUNTRIES.REGION_ID%type,
                                                    p_highest_elevation in COUNTRIES.HIGHEST_ELEVATION%type) is
    v_number_of_countries number;
begin
    select count(*)
    into v_number_of_countries
    from COUNTRIES
    where REGION_ID = p_region_id
      and HIGHEST_ELEVATION > p_highest_elevation;
    DBMS_OUTPUT.PUT_LINE(v_number_of_countries);
end get_number_of_countries;

declare
    v_region_id         COUNTRIES.REGION_ID%type         := 5;
    v_highest_elevation COUNTRIES.HIGHEST_ELEVATION%type := 2000;
    v_first_char        char                             := 'B';
begin
    get_number_of_countries(v_region_id, v_first_char, v_highest_elevation);
end;

describe get_number_of_countries;



create or replace procedure find_area_pop(p_country_id in COUNTRIES.COUNTRY_ID%type,
                                          p_country_name out COUNTRIES.COUNTRY_NAME%type,
                                          p_country_population out COUNTRIES.POPULATION%type) is
begin
    select COUNTRY_NAME, POPULATION
    into p_country_name, p_country_population
    from COUNTRIES
    where COUNTRY_ID = p_country_id;
exception
    when NO_DATA_FOUND then
        DBMS_OUTPUT.PUT_LINE('the country does not exist');
end find_area_pop;

declare
    v_country_name       COUNTRIES.COUNTRY_NAME%type;
    v_country_population COUNTRIES.POPULATION%type;
    v_density            number;
begin
    find_area_pop(p_country_name=>v_country_name, p_country_population=>v_country_population, p_density=>v_density);
    DBMS_OUTPUT.PUT_LINE(v_country_name || ' ' || v_country_population || ' ' || v_density);
end;

select COUNTRY_ID
from COUNTRIES
where lower(COUNTRY_NAME) like '%viet%';



create or replace procedure square_of_an_integer(p_integer in out number) is
begin
    p_integer := p_integer * p_integer;
end square_of_an_integer;

declare
    v_integer number := -20;
begin
    square_of_an_integer(v_integer);
    DBMS_OUTPUT.PUT_LINE(v_integer);
end;