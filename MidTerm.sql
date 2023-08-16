-- Create an anonymous block to list all the countries from Country table where Currency contain keyword ‘Dollar’. Perform following steps:
--  Create user define type with name of the country, currency.
--  Type should contain datatype for name and currency using %type only.
--  Display should include Name of the country, currency code using user defined type.
--  Filter for the data : All the countries from Country table where Currency contain keyword ‘Dollar’.

DECLARE
    TYPE countries_rec IS RECORD
                          (
                              v_country_name  WF_COUNTRIES.COUNTRY_NAME%TYPE,
                              v_currency_code WF_CURRENCIES.CURRENCY_CODE%TYPE
                          );
    v_country_rec countries_rec;
BEGIN
    FOR v_country_rec IN (SELECT COUNTRY_NAME, CURRENCY_CODE
                          FROM WF_COUNTRIES
                                   NATURAL JOIN WF_CURRENCIES
                          WHERE CURRENCY_NAME LIKE '%dollar%')
        LOOP
            DBMS_OUTPUT.PUT_LINE(v_country_rec.COUNTRY_NAME || ' ' || v_country_rec.CURRENCY_CODE);
        END LOOP;
END;


DECLARE
    TYPE countries_rec IS RECORD
                          (
                              v_country_name  WF_COUNTRIES.COUNTRY_NAME%TYPE,
                              v_currency_code WF_CURRENCIES.CURRENCY_CODE%TYPE
                          );
    v_country_rec countries_rec;
BEGIN
    FOR v_country_rec IN (SELECT COUNTRY_NAME, CURRENCY_CODE
                          FROM WF_COUNTRIES
                                   NATURAL JOIN WF_CURRENCIES
                          WHERE CURRENCY_NAME LIKE '%dollar%')
        LOOP
            DBMS_OUTPUT.PUT_LINE(v_country_rec.COUNTRY_NAME || ' ' || v_country_rec.CURRENCY_CODE);
        END LOOP;
END;



-- Have an anonymous block to create a cursor without using for loop to fetch all the countries belonging to region 'Caribbean'.
--  Display should include Name of the country, Country Code and Region Name

DECLARE
    CURSOR countries_cur IS
        SELECT COUNTRY_NAME, COUNTRY_ID, REGION_NAME
        FROM COUNTRIES
                 NATURAL JOIN REGIONS
        WHERE REGION_NAME = 'Caribbean';
BEGIN
    FOR v_country_rec IN countries_cur
        LOOP
            DBMS_OUTPUT.PUT_LINE(v_country_rec.COUNTRY_NAME || ' ' || v_country_rec.COUNTRY_ID || ' ' ||
                                 v_country_rec.REGION_NAME);
        END LOOP;
END;


SELECT TO_CHAR(SYSDATE, 'MM-DD-YY')
FROM DUAL;

DECLARE
    TYPE t_hire_date IS TABLE OF employees.hire_date%TYPE
        INDEX BY BINARY_INTEGER;
    v_hire_date_tab t_hire_date;
    v_count         BINARY_INTEGER := 0;
BEGIN
    FOR emp_rec IN
        (SELECT hire_date FROM employees)
        LOOP
            v_count := v_count + 1;
            v_hire_date_tab(v_count) := emp_rec.hire_date;
        END LOOP;
END;



DECLARE
    CURSOR emp_curs IS
        SELECT last_name, salary
        FROM employees;
    v_last_name employees.last_name%TYPE;
    v_salary    employees.salary%TYPE;
BEGIN
    OPEN emp_curs;
    FETCH emp_curs INTO v_last_name, v_salary;
    CLOSE emp_curs;
END;

DECLARE
    TYPE person_dept IS RECORD
                        (
                            first_name      employees.first_name%TYPE,
                            last_name       employees.last_name%TYPE,
                            department_name departments.department_name%TYPE
                        );
    v_person_dept_rec person_dept;
BEGIN

end;



DECLARE
    CURSOR countries_curs IS
        SELECT COUNTRY_NAME, COUNTRY_ID, REGION_NAME
        FROM WF_COUNTRIES
                 NATURAL JOIN WF_WORLD_REGIONS
        WHERE REGION_NAME LIKE '%Europe%';
BEGIN
    FOR country_rec IN countries_curs
        LOOP
            DBMS_OUTPUT.PUT_LINE(country_rec.COUNTRY_NAME || ' ' || country_rec.COUNTRY_ID || ' ' ||
                                 country_rec.REGION_NAME);
        END LOOP;
END;



DECLARE
    CURSOR countries_curs IS
        SELECT COUNTRY_NAME, COUNTRY_ID, REGION_NAME
        FROM COUNTRIES
                 NATURAL JOIN REGIONS
        WHERE REGION_NAME = 'Europe';
BEGIN
    FOR country_rec IN countries_curs
        LOOP
            DBMS_OUTPUT.PUT_LINE(country_rec.COUNTRY_NAME || ' ' || country_rec.COUNTRY_ID || ' ' ||
                                 country_rec.REGION_NAME);
        END LOOP;
END;



DECLARE
    v_number NUMBER(2);
BEGIN
    FOR v_number IN 1..50
        LOOP
            IF MOD(v_number, 2) = 0 THEN
                DBMS_OUTPUT.PUT_LINE(v_number);
            END IF;
        END LOOP;
END;


DECLARE
    v_name_length NUMBER(2);
BEGIN
    DBMS_OUTPUT.PUT_LINE('Name(Firstname LastName)' || CHR(9) || 'Length');
    FOR employee_rec IN (SELECT FIRST_NAME, LAST_NAME FROM EMPLOYEES)
        LOOP
            v_name_length := LENGTH(employee_rec.FIRST_NAME) + LENGTH(employee_rec.LAST_NAME);
            DBMS_OUTPUT.PUT_LINE(employee_rec.FIRST_NAME || ' ' || employee_rec.LAST_NAME || CHR(9) || v_name_length);
        END LOOP;
END;