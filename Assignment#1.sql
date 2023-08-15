DROP TABLE TEMP PURGE;

CREATE TABLE TEMP(
    NUM_ONE NUMBER(5),
    NUM_TWO NUMBER(2),
    CHAR_OUT VARCHAR2(30));

DECLARE
    x TEMP.NUM_ONE%TYPE := 0;
    counter TEMP.NUM_TWO%TYPE := 0;
BEGIN
    <<OUTER_LOOP>>
    LOOP
        counter := counter + 1;
        x := x + 1000;
        INSERT INTO TEMP VALUES (x, counter, 'in OUTER loop');
        DECLARE
             x TEMP.NUM_ONE%TYPE := 0;
        BEGIN
            <<INNER_LOOP>>
            LOOP
                counter := counter + 1;
                x := x + 1;
                INSERT INTO TEMP VALUES (x, counter, 'in INNER loop');
                EXIT INNER_LOOP WHEN x = 4;
            END LOOP INNER_LOOP;
        END;
        EXIT OUTER_LOOP WHEN x = 4000;
    END LOOP OUTER_LOOP;
END;

SELECT * FROM TEMP;



DROP TABLE emp PURGE;

CREATE TABLE emp (empno, ename, sal, job)
AS (SELECT employee_id, first_name||' '||last_name, salary, job_id FROM employees);

DECLARE
    CURSOR emp_curs IS
        SELECT empno, ename, sal FROM emp JOIN jobs ON emp.job = jobs.JOB_ID
        WHERE JOB_TITLE != 'President' ORDER BY empno FOR UPDATE NOWAIT;
    v_overall_cost emp.sal%TYPE := 0;
    v_proposed_annual_raise emp.sal%TYPE;
BEGIN
    FOR emp_rec IN emp_curs LOOP
        v_proposed_annual_raise := emp_rec.sal*0.05*12;
        IF emp_rec.sal*0.05*12 > 2000 THEN
            v_proposed_annual_raise := 2000;
        END IF;
        UPDATE emp SET sal = sal + v_proposed_annual_raise/12 WHERE CURRENT OF emp_curs;
        v_overall_cost := v_overall_cost + v_proposed_annual_raise;
        DBMS_OUTPUT.PUT_LINE(emp_rec.empno || ' ' || emp_rec.ename || ' ' || (emp_rec.sal*12) || ' ' ||
                             v_proposed_annual_raise || ' ' || (emp_rec.sal*12+v_proposed_annual_raise));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Overall Cost: ' || v_overall_cost);
END;

SELECT * FROM emp;



DECLARE
    CURSOR languages_curs (p_country_name COUNTRIES.COUNTRY_NAME%TYPE) IS
        SELECT DISTINCT COUNTRY_NAME, LANGUAGE_NAME FROM LANGUAGES NATURAL JOIN SPOKEN_LANGUAGES NATURAL JOIN COUNTRIES
        WHERE COUNTRY_NAME LIKE '%'||p_country_name||'%' AND (OFFICIAL = 'Y' OR OFFICIAL = 'QY');
BEGIN
    FOR v_language_rec IN languages_curs('Viet') LOOP
        DBMS_OUTPUT.PUT_LINE(v_language_rec.COUNTRY_NAME || ' uses ' || v_language_rec.LANGUAGE_NAME);
    END LOOP;
END;



DECLARE
    CURSOR employees_curs IS
        SELECT FIRST_NAME, TRUNC(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)/12) as YEARS FROM EMPLOYEES JOIN DEPARTMENTS
        ON EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
        WHERE DEPARTMENT_NAME LIKE '%Sales%';
BEGIN
    FOR v_employee_rec IN employees_curs LOOP
        DBMS_OUTPUT.PUT_LINE(v_employee_rec.FIRST_NAME || ' has worked in the company for ' || v_employee_rec.YEARS || ' years.');
    END LOOP;
END;



DECLARE
    CURSOR orders_curs (p_order_number F_ORDERS.ORDER_NUMBER%TYPE) IS
        SELECT DISTINCT ORDER_NUMBER, SUM(PRICE*QUANTITY) as TOTAL FROM F_ORDERS NATURAL JOIN F_ORDER_LINES NATURAL JOIN F_FOOD_ITEMS
        WHERE ORDER_NUMBER = p_order_number GROUP BY ORDER_NUMBER;
    v_trigger NUMBER;
BEGIN
    FOR v_order_rec IN orders_curs(5800) LOOP
        DBMS_OUTPUT.PUT_LINE(v_order_rec.ORDER_NUMBER || ' total: ' || v_order_rec.TOTAL);
        IF v_order_rec.TOTAL <= 100 THEN
            v_trigger := 'triggered';
        END IF;
        DBMS_OUTPUT.PUT_LINE('This Order Total is ELIGIBLE for discount limit.');
    END LOOP;
    EXCEPTION
    WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('This Order Total is BELOW for discount limit.');
END;



DECLARE
    item_num F_ORDER_LINES.FOOD_ITEM_NUMBER%TYPE;
    qty F_ORDER_LINES.QUANTITY%TYPE;
    price F_FOOD_ITEMS.PRICE%TYPE;
    totalPrice NUMBER(8,2) := 0;
    in_order_num INTEGER := 5800;
    below_limit EXCEPTION;
    CURSOR c1 IS
        SELECT FOOD_ITEM_NUMBER, QUANTITY FROM f_order_lines WHERE ORDER_NUMBER =  in_order_num;
BEGIN
    OPEN c1;
    LOOP
        FETCH c1 INTO item_num, qty;
        EXIT WHEN c1%NOTFOUND;
        SELECT PRICE INTO price FROM F_FOOD_ITEMS WHERE FOOD_ITEM_NUMBER = item_num;
        totalPrice := totalPrice + (price * qty);
    END LOOP;
    CLOSE c1;
    IF(totalPrice > 100) THEN
        DBMS_OUTPUT.PUT_LINE('This order ' || in_order_num ||  ' with total price '  || totalPrice || ' is eligible for discount.');
    ELSE
        RAISE below_limit;
    END IF;
    EXCEPTION
    WHEN below_limit THEN
        DBMS_OUTPUT.PUT_LINE('This order ' || in_order_num || ' with total '  || totalPrice || ' is below discount limit.');
END;