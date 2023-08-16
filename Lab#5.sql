DECLARE
    CURSOR CUR_EMP IS
        SELECT *
        FROM EMPLOYEES
        WHERE SALARY < 4000 FOR UPDATE WAIT 30;
    V_EMP_RECORD EMPLOYEES%ROWTYPE;
BEGIN
    OPEN CUR_EMP;
    LOOP
        FETCH CUR_EMP INTO V_EMP_RECORD;
        EXIT WHEN CUR_EMP%NOTFOUND;
        UPDATE EMPLOYEES
        SET SALARY =V_EMP_RECORD.SALARY + V_EMP_RECORD.SALARY * 0.05
        WHERE CURRENT OF CUR_EMP;
    END LOOP;
    CLOSE CUR_EMP;
END;



DECLARE
    CURSOR currencies_cur IS
        SELECT CURRENCY_CODE, CURRENCY_NAME
        FROM CURRENCIES
        ORDER BY CURRENCY_NAME ASC;
    v_currency_code CURRENCIES.CURRENCY_CODE%TYPE;
    v_currency_name CURRENCIES.CURRENCY_NAME%TYPE;
BEGIN
    OPEN currencies_cur;
    LOOP
        FETCH currencies_cur INTO v_currency_code, v_currency_name;
        EXIT WHEN currencies_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_currency_code || ' ' || v_currency_name);
    END LOOP;
    CLOSE currencies_cur;
END;



DECLARE
    CURSOR countries_curr IS
        SELECT COUNTRY_NAME, NATIONAL_HOLIDAY_DATE, NATIONAL_HOLIDAY_NAME
        FROM COUNTRIES
        WHERE REGION_ID = 5
          AND NATIONAL_HOLIDAY_DATE IS NOT NULL;
BEGIN
    OPEN countries_curr;
END;



DECLARE
    CURSOR regions_curr IS
        SELECT REGION_NAME, COUNT(*)
        FROM REGIONS
                 NATURAL JOIN COUNTRIES
        GROUP BY REGION_NAME
        HAVING COUNT(*) >= 10
        ORDER BY REGION_NAME ASC;
    v_region_name     REGIONS.REGION_NAME%TYPE;
    v_countries_count NUMBER;
BEGIN
    OPEN regions_curr;
    LOOP
        FETCH regions_curr INTO v_region_name, v_countries_count;
        EXIT WHEN regions_curr%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_region_name || ' ' || v_countries_count);
    END LOOP;
    CLOSE regions_curr;
END;



DECLARE
    CURSOR countries_curr IS
        SELECT COUNTRY_NAME, NATIONAL_HOLIDAY_DATE, NATIONAL_HOLIDAY_NAME
        FROM COUNTRIES
        WHERE REGION_ID = 5
          AND NATIONAL_HOLIDAY_DATE IS NOT NULL;
    v_country_record countries_curr%ROWTYPE;
BEGIN
    OPEN countries_curr;
    LOOP
        FETCH countries_curr INTO v_country_record;
        EXIT WHEN countries_curr%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_country_record.COUNTRY_NAME || ' ' ||
                             v_country_record.NATIONAL_HOLIDAY_DATE || ' ' || v_country_record.NATIONAL_HOLIDAY_NAME);
    END LOOP;
    CLOSE countries_curr;
END;



DECLARE
    CURSOR employees_curr IS
        SELECT FIRST_NAME, LAST_NAME, JOB_ID, SALARY
        FROM EMPLOYEES
        ORDER BY SALARY DESC;
    v_employee_record employees_curr%ROWTYPE;
BEGIN
    OPEN employees_curr;
    LOOP
        FETCH employees_curr INTO v_employee_record;
        EXIT WHEN employees_curr%ROWCOUNT > 41 OR employees_curr%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_employee_record.FIRST_NAME || ' ' || v_employee_record.LAST_NAME || ' ' ||
                             v_employee_record.JOB_ID || ' ' || v_employee_record.SALARY);
    END LOOP;
    CLOSE employees_curr;
END;



BEGIN
    FOR countries_rec IN (SELECT country_name, national_holiday_name, national_holiday_date
                          FROM countries
                          WHERE region_id = 5)
        LOOP
            DBMS_OUTPUT.PUT_LINE('Country: ' || countries_rec.country_name || ' National holiday: ' ||
                                 countries_rec.national_holiday_name || ', held on: ' ||
                                 countries_rec.national_holiday_date);
        END LOOP;
END;



DECLARE
    CURSOR countries_cur IS
        SELECT COUNTRY_NAME, HIGHEST_ELEVATION, CLIMATE
        FROM COUNTRIES
        WHERE HIGHEST_ELEVATION > 8000;
BEGIN
    FOR countries_rec IN countries_cur
        LOOP
            DBMS_OUTPUT.PUT_LINE(countries_rec.COUNTRY_NAME || ' ' || countries_rec.HIGHEST_ELEVATION || ' ' ||
                                 countries_rec.CLIMATE);
        END LOOP;
END;



DECLARE
    CURSOR countries_cur IS
        SELECT COUNTRY_NAME, COUNT(*) as count
        FROM COUNTRIES
                 NATURAL JOIN SPOKEN_LANGUAGES
        GROUP BY COUNTRY_NAME
        HAVING count(*) > 6;
    v_number_of_countries NUMBER;
BEGIN
    FOR countries_rec IN countries_cur
        LOOP
            DBMS_OUTPUT.PUT_LINE(countries_rec.COUNTRY_NAME || ' ' || countries_rec.count);
            v_number_of_countries := countries_cur%ROWCOUNT;
        END LOOP;
    DBMS_OUTPUT.PUT_LINE('The total number of countries having more than six languages is ' || v_number_of_countries);
END;



DECLARE
    CURSOR countries_cur (p_region_id NUMBER) IS
        SELECT COUNTRY_NAME, AREA
        FROM COUNTRIES
        WHERE REGION_ID = p_region_id;
    v_countries_rec countries_cur%ROWTYPE;
BEGIN
    OPEN countries_cur(5);
    LOOP
        FETCH countries_cur INTO v_countries_rec;
        EXIT WHEN countries_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_countries_rec.COUNTRY_NAME || ' ' || v_countries_rec.AREA);
    END LOOP;
    CLOSE countries_cur;
    OPEN countries_cur(30);
    LOOP
        FETCH countries_cur INTO v_countries_rec;
        EXIT WHEN countries_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_countries_rec.COUNTRY_NAME || ' ' || v_countries_rec.AREA);
    END LOOP;
    CLOSE countries_cur;
END;


DECLARE
    CURSOR countries_cur (p_region_id NUMBER, p_area NUMBER) IS
        SELECT COUNTRY_NAME, AREA
        FROM COUNTRIES
        WHERE REGION_ID = p_region_id
          AND AREA > p_area;
BEGIN
    FOR v_countries_rec IN countries_cur(5, 1000000)
        LOOP
            DBMS_OUTPUT.PUT_LINE(v_countries_rec.COUNTRY_NAME || ' ' || v_countries_rec.AREA);
        END LOOP;
END;



DECLARE
    CURSOR countries_cur (p_region_id NUMBER, p_area NUMBER) IS
        SELECT COUNTRY_NAME, AREA
        FROM COUNTRIES
        WHERE REGION_ID = p_region_id
          AND AREA > p_area;
    v_countries_rec countries_cur%ROWTYPE;
BEGIN
    OPEN countries_cur(5, 200000);
    DBMS_OUTPUT.PUT_LINE('Region: 5 Minimum Area: 200000');
    LOOP
        FETCH countries_cur INTO v_countries_rec;
        EXIT WHEN countries_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_countries_rec.COUNTRY_NAME || ' ' || v_countries_rec.AREA);
    END LOOP;
    CLOSE countries_cur;
    OPEN countries_cur(30, 500000);
    DBMS_OUTPUT.PUT_LINE('Region: 30 Minimum Area: 500000');
    LOOP
        FETCH countries_cur INTO v_countries_rec;
        EXIT WHEN countries_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_countries_rec.COUNTRY_NAME || ' ' || v_countries_rec.AREA);
    END LOOP;
    CLOSE countries_cur;
END;



CREATE TABLE proposed_raises

(
    date_proposed       DATE,

    date_approved       DATE,

    employee_id         NUMBER(6),

    department_id       NUMBER(4),

    original_salary     NUMBER(8, 2),

    proposed_new_salary NUMBER(8, 2)
);



declare
    cursor employees_curr (p_salary EMPLOYEES.SALARY%type) is
        select *
        from EMPLOYEES
        where SALARY < p_salary for update nowait;
begin
    for v_employees_record in employees_curr(5000)
        loop
            insert into proposed_raises
            values (sysdate, null, v_employees_record.EMPLOYEE_ID, v_employees_record.DEPARTMENT_ID,
                    v_employees_record.SALARY, v_employees_record.SALARY * 1.05);
        end loop;
end;


SELECT *
FROM proposed_raises;



declare
    cursor proposed_raises_cur is select *
                                  from proposed_raises
                                  where department_id = 50 for update nowait;
begin
    for v_proposed_raises_rec in proposed_raises_cur
        loop
            delete proposed_raises where current of proposed_raises_cur;
        end loop;
end;



CREATE TABLE upd_emps AS
SELECT *
FROM employees;



update upd_emps
set FIRST_NAME = 'Jenny'
where EMPLOYEE_ID = 200;



commit;



declare
    cursor employees_curr is
        select *
        from upd_emps for update nowait;
begin
    for v_employees_record in employees_curr
        loop
            update upd_emps set SALARY = 1 where current of employees_curr;
        end loop;
end;


select *
from upd_emps;
drop table upd_emps purge;



DECLARE
    CURSOR departments_cur IS
        SELECT department_id, department_name
        FROM departments
        ORDER BY department_name;
    CURSOR employees_cur (p_department_id NUMBER) IS
        SELECT first_name, last_name, salary
        FROM employees
        WHERE department_id = p_department_id
        ORDER BY last_name;
BEGIN
    FOR v_departments_rec IN departments_cur
        LOOP
            DBMS_OUTPUT.PUT_LINE(v_departments_rec.DEPARTMENT_ID || ' ' || v_departments_rec.DEPARTMENT_NAME);
            DBMS_OUTPUT.PUT_LINE('---------');
            FOR v_employees_rec IN employees_cur(v_departments_rec.DEPARTMENT_ID)
                LOOP
                    DBMS_OUTPUT.PUT_LINE(v_employees_rec.FIRST_NAME || ' ' || v_employees_rec.LAST_NAME || ' ' ||
                                         v_employees_rec.salary);
                END LOOP;
            DBMS_OUTPUT.PUT_LINE(' ');
        END LOOP;
END;



DECLARE
    CURSOR regions_cur IS
        SELECT REGION_ID, REGION_NAME
        FROM REGIONS
        WHERE REGION_NAME like '%America%'
        ORDER BY region_name;
    CURSOR countries_cur (p_region_id NUMBER) IS
        SELECT COUNTRY_NAME, AREA, POPULATION, COUNTRY_ID
        FROM COUNTRIES
        WHERE REGION_ID = p_region_id
        ORDER BY COUNTRY_NAME;
    CURSOR languages_cur (p_country_id NUMBER) IS
        SELECT LANGUAGE_NAME
        FROM LANGUAGES
                 NATURAL JOIN SPOKEN_LANGUAGES
        WHERE COUNTRY_ID = p_country_id
        ORDER BY LANGUAGE_NAME;
BEGIN
    FOR v_regions_rec IN regions_cur
        LOOP
            DBMS_OUTPUT.PUT_LINE(v_regions_rec.REGION_ID || ' ' || v_regions_rec.REGION_NAME);
            DBMS_OUTPUT.PUT_LINE('---------');
            FOR v_countries_rec IN countries_cur(v_regions_rec.REGION_ID)
                LOOP
                    DBMS_OUTPUT.PUT_LINE(v_countries_rec.COUNTRY_NAME || ' ' || v_countries_rec.AREA || ' ' ||
                                         v_countries_rec.POPULATION);
                    FOR v_languages_cur IN languages_cur(v_countries_rec.COUNTRY_ID)
                        LOOP
                            DBMS_OUTPUT.PUT_LINE('--- ' || v_languages_cur.LANGUAGE_NAME);
                        END LOOP;
                END LOOP;
        END LOOP;
END;