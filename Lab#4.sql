DECLARE
    v_population COUNTRIES.POPULATION%TYPE;
BEGIN
    SELECT POPULATION INTO v_population FROM COUNTRIES WHERE COUNTRY_ID = 15;
    DBMS_OUTPUT.PUT_LINE(v_population);
    IF v_population > 1000000000 THEN
        DBMS_OUTPUT.PUT_LINE('Population is greater than 1 billion.');
    ELSIF v_population > 0 AND v_population <= 1000000000 THEN
        DBMS_OUTPUT.PUT_LINE('Population is greater than 0.');
    ELSIF v_population = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Population is 0.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('No data for this country.');
    END IF;
END;



SELECT date_of_independence, national_holiday_date
FROM countries
WHERE country_id = 1;



DECLARE
    v_country_id   countries.country_name%TYPE := 1;
    v_ind_date     countries.date_of_independence%TYPE;
    v_natl_holiday countries.national_holiday_date%TYPE;
BEGIN
    SELECT date_of_independence, national_holiday_date
    INTO v_ind_date, v_natl_holiday
    FROM countries
    WHERE country_id = v_country_id;
    IF v_ind_date IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('A');
    ELSIF v_natl_holiday IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('B');
    ELSIF v_natl_holiday IS NULL AND v_ind_date IS NULL THEN
        DBMS_OUTPUT.PUT_LINE('C');
    END IF;
END;



DECLARE
    v_num1 NUMBER(3) := 123;
    v_num2 NUMBER    := 100;
BEGIN
    IF v_num1 <> v_num2 THEN
        DBMS_OUTPUT.PUT_LINE('The two numbers are not equal');
    ELSIF v_num1 = v_num2 THEN
        DBMS_OUTPUT.PUT_LINE('The two numbers are equal');
    ELSE
        DBMS_OUTPUT.PUT_LINE('One/both of the two numbers is/are NULL');
    END IF;
END;



DECLARE
    v_year NUMBER(4) := 1884;
BEGIN
    IF (MOD(v_year, 4) = 0 AND MOD(v_year, 100) <> 0) OR MOD(v_year, 400) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Leap year');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Not a leap year');
    END IF;
END;



DECLARE
    v_country_name countries.country_name%TYPE := 'United States of America';
    v_airports     countries.airports%TYPE;
BEGIN
    SELECT airports INTO v_airports FROM COUNTRIES WHERE country_name = v_country_name;
    CASE
        WHEN v_airports >= 0 AND v_airports <= 100 THEN DBMS_OUTPUT.PUT_LINE('There are 100 or fewer airports.');
        WHEN v_airports >= 101 AND v_airports <= 1000
            THEN DBMS_OUTPUT.PUT_LINE('There are between 101 and 1,000 airports.');
        WHEN v_airports >= 1001 AND v_airports <= 10000
            THEN DBMS_OUTPUT.PUT_LINE('There are between 1,001 and 10,000 airports.');
        WHEN v_airports > 10000 THEN DBMS_OUTPUT.PUT_LINE('There are more than 10,000 airports.');
        ELSE DBMS_OUTPUT.PUT_LINE('The number of airports is not available for this country.');
        END CASE;
END;



DECLARE
    v_country_name          countries.country_name%TYPE := 'Ukraine';
    v_coastline             countries.coastline %TYPE;
    v_coastline_description VARCHAR2(50);
BEGIN
    SELECT coastline INTO v_coastline FROM countries WHERE country_name = v_country_name;
    v_coastline_description :=
            CASE
                WHEN v_coastline = 0 THEN 'no coastline'
                WHEN v_coastline < 1000 THEN 'a small coastline'
                WHEN v_coastline < 10000 THEN 'a mid-range coastline'
                ELSE 'a large coastline'
                END;
    DBMS_OUTPUT.PUT_LINE('Country ' || v_country_name || ' has ' || v_coastline_description);
END;



DECLARE
    v_currency            CURRENCIES.CURRENCY_NAME%TYPE := 'Euro';
    v_number_of_countries NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_number_of_countries
    FROM COUNTRIES
             NATURAL JOIN CURRENCIES
    WHERE CURRENCY_NAME = v_currency;
    CASE
        WHEN v_number_of_countries > 20 THEN DBMS_OUTPUT.PUT_LINE('More than 20 countries');
        WHEN v_number_of_countries <= 20 AND v_number_of_countries >= 10
            THEN DBMS_OUTPUT.PUT_LINE('Between 10 and 20 countries');
        WHEN v_number_of_countries < 10 THEN DBMS_OUTPUT.PUT_LINE('Fewer than 10 countries');
        END CASE;
END;



DECLARE
    x       BOOLEAN     := FALSE;
    y       BOOLEAN ;
    v_color VARCHAR(20) := 'Red';
BEGIN
    IF (x AND y) THEN
        v_color := 'White';
    ELSE
        v_color := 'Black';
    END IF;
    DBMS_OUTPUT.PUT_LINE(v_color);
END;



DECLARE
    v_country_id   COUNTRIES.COUNTRY_ID%TYPE := 1;
    v_country_name COUNTRIES.COUNTRY_NAME%TYPE;
BEGIN
    LOOP
        SELECT COUNTRY_NAME INTO v_country_name FROM COUNTRIES WHERE COUNTRY_ID = v_country_id;
        DBMS_OUTPUT.PUT_LINE(v_country_id || ' ' || v_country_name);
        v_country_id := v_country_id + 1;
        IF v_country_id > 3 THEN
            EXIT;
        END IF;
    END LOOP;
END;



DROP TABLE messages PURGE;
CREATE TABLE messages
(
    results NUMBER(2)
);

DECLARE
    v_number NUMBER(2) := 1;
BEGIN
    LOOP
        IF v_number <> 6 AND v_number <> 8 THEN
            INSERT INTO messages VALUES (v_number);
        END IF;
        v_number := v_number + 1;
        EXIT WHEN v_number > 10;
    END LOOP;
END;

SELECT *
FROM messages;



DECLARE
    v_country_id   COUNTRIES.COUNTRY_ID%TYPE := 51;
    v_country_name COUNTRIES.COUNTRY_NAME%TYPE;
BEGIN
    WHILE v_country_id <= 55
        LOOP
            SELECT COUNTRY_NAME INTO v_country_name FROM COUNTRIES WHERE COUNTRY_ID = v_country_id;
            DBMS_OUTPUT.PUT_LINE(v_country_id || ' ' || v_country_name);
            v_country_id := v_country_id + 1;
        END LOOP;
END;



DECLARE
    v_country_id   COUNTRIES.COUNTRY_ID%TYPE := 51;
    v_country_name COUNTRIES.COUNTRY_NAME%TYPE;
BEGIN
    FOR v_country_id IN REVERSE 51..55
        LOOP
            SELECT COUNTRY_NAME INTO v_country_name FROM COUNTRIES WHERE COUNTRY_ID = v_country_id;
            DBMS_OUTPUT.PUT_LINE(v_country_id || ' ' || v_country_name);
        END LOOP;
END;

DROP TABLE new_emps PURGE;
CREATE TABLE new_emps AS
SELECT *
FROM employees;
ALTER TABLE new_emps
    ADD stars VARCHAR2(50);

DECLARE
    v_empno            new_emps.employee_id%TYPE := 142;
    v_asterisk         new_emps.stars%TYPE       := NULL;
    v_sal_in_thousands new_emps.salary%TYPE;
BEGIN
    SELECT NVL(TRUNC(salary / 1000), 0) INTO v_sal_in_thousands FROM new_emps WHERE employee_id = v_empno;
    FOR i IN 1..v_sal_in_thousands
        LOOP
            v_asterisk := v_asterisk || '*';
        END LOOP;
    UPDATE new_emps SET stars = v_asterisk WHERE employee_id = v_empno;
END;

SELECT stars
FROM new_emps
WHERE employee_id = 142;



DECLARE
    v_first_number  NUMBER(2);
    v_second_number NUMBER(3);
    v_sum           NUMBER(3);
BEGIN
    <<OUTER_LOOP>>
    FOR v_first_number IN 60..65
        LOOP
            <<INNER_LOOP>>
            FOR v_second_number IN 100..110
                LOOP
                    v_sum := v_first_number + v_second_number;
                    EXIT OUTER_LOOP WHEN v_sum > 172;
                    DBMS_OUTPUT.PUT_LINE(v_sum);
                END LOOP INNER_LOOP;
        END LOOP OUTER_LOOP;
END;