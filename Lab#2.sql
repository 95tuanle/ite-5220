DECLARE
    v_country_name VARCHAR2(70) := 'Japan';
    v_highest      NUMBER(6);
    v_lowest       NUMBER(6);
BEGIN
    SELECT HIGHEST_ELEVATION, LOWEST_ELEVATION
    INTO v_highest, v_lowest
    FROM COUNTRIES
    WHERE COUNTRY_NAME = v_country_name;
    DBMS_OUTPUT.PUT_LINE('The highest elevation of ' || v_country_name || ' is ' || v_highest);
    DBMS_OUTPUT.PUT_LINE('The lowest elevation of ' || v_country_name || ' is ' || v_lowest);
END;



DECLARE
    number_of_students     PLS_INTEGER  := 10;
    STUDENT_NAME           VARCHAR2(10) := 'Johnson';
    stu_per_class CONSTANT NUMBER       := 10;
    tomorrow               DATE         := SYSDATE + 1;
BEGIN
    DBMS_OUTPUT.PUT_LINE(number_of_students);
    DBMS_OUTPUT.PUT_LINE(STUDENT_NAME);
    DBMS_OUTPUT.PUT_LINE(stu_per_class);
    DBMS_OUTPUT.PUT_LINE(tomorrow);
END;



DECLARE
    v_country_name countries.country_name%TYPE;
    v_median_age   countries.median_age%TYPE;
BEGIN
    SELECT country_name, median_age INTO v_country_name, v_median_age FROM countries WHERE country_name = 'Japan';
    DBMS_OUTPUT.PUT_LINE('The median age in ' || v_country_name || ' is ' || v_median_age || '.');
END;



DECLARE
    TODAY    DATE := SYSDATE;
    TOMORROW TODAY%TYPE;
BEGIN
    TOMORROW := TODAY + 1;
    DBMS_OUTPUT.PUT_LINE('Hello World');
    DBMS_OUTPUT.PUT_LINE(TODAY);
    DBMS_OUTPUT.PUT_LINE(TOMORROW);
END;



DECLARE
    x VARCHAR2(20);
BEGIN
    x := '123' + '456';
    DBMS_OUTPUT.PUT_LINE(x);
END;



DECLARE
    v_full_name VARCHAR2(33) := 'Nguyen Anh Tuan Le';
BEGIN
    DBMS_OUTPUT.PUT_LINE(LENGTH(v_full_name));
END;



DECLARE
    my_date     DATE := SYSDATE;
    v_last_date DATE := LAST_DAY(my_date);
BEGIN
    DBMS_OUTPUT.PUT_LINE(TO_CHAR(my_date, 'Month dd, yyyy'));
    DBMS_OUTPUT.PUT_LINE(v_last_date);
    DBMS_OUTPUT.PUT_LINE(MONTHS_BETWEEN(my_date + 45, my_date));
END;



DECLARE
    x NUMBER(6);
BEGIN
    x := 5 + 3 * 2;
    DBMS_OUTPUT.PUT_LINE(x);
END;



DECLARE
    v_number  NUMBER;
    v_boolean BOOLEAN;
BEGIN
    v_number := 25;
    v_boolean := NOT (v_number > 30);
END;



DECLARE

    weight  NUMBER(3)     := 600;
    message VARCHAR2(255) := 'Product 10012';

BEGIN

    DECLARE

        weight   NUMBER(3)     := 1;
        message  VARCHAR2(255) := 'Product 11001';
        new_locn VARCHAR2(50)  := 'Europe';

    BEGIN

        weight := weight + 1;

        new_locn := 'Western ' || new_locn;

        -- Position 1 --
--      DBMS_OUTPUT.PUT_LINE(weight);
--      DBMS_OUTPUT.PUT_LINE(new_locn);

    END;

    weight := weight + 1;

    message := message || ' is in stock';

    -- Position 2 --
    DBMS_OUTPUT.PUT_LINE(weight);
    DBMS_OUTPUT.PUT_LINE(message);
--      DBMS_OUTPUT.PUT_LINE(new_locn);

END;


BEGIN
    <<outer>>
        DECLARE
        v_employee_id employees.employee_id%TYPE;
        v_job         employees.job_id%TYPE;
    BEGIN
        SELECT employee_id, job_id INTO v_employee_id, v_job FROM employees WHERE employee_id = 100;
        <<inner>>
            DECLARE
            v_employee_id employees.employee_id%TYPE;
            v_job         employees.job_id%TYPE;
        BEGIN
            SELECT employee_id, job_id INTO v_employee_id, v_job FROM employees WHERE employee_id = 103;
            DBMS_OUTPUT.PUT_LINE(outer.v_employee_id || ' is a(n) ' || outer.v_job);
        END;
        DBMS_OUTPUT.PUT_LINE(v_employee_id || ' is a(n) ' || v_job);
    END;
END;



DECLARE
--     declare country name variable with type similar to country_name column in countries table
    v_country_name countries.country_name%TYPE;
    v_number       NUMBER(4);
BEGIN
    --     query country name from countries table with country id = 421
    SELECT country_name INTO v_country_name FROM countries WHERE country_id = 421;
    v_number := TO_CHAR('1234');
    v_number := v_number * 2;
    DBMS_OUTPUT.PUT_LINE(v_country_name);
END;