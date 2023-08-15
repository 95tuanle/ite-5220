declare
    cursor employees_curr is
        select * from upd_emps for update;
begin
    for v_employees_record in employees_curr loop
        update upd_emps set SALARY = 1 where current of employees_curr;
    end loop;
end;

DECLARE
lv_cnt_num NUMBER(3);
BEGIN
FOR i IN 1..7 LOOP
    DBMS_OUTPUT.PUT_LINE(i);

lv_cnt_num := lv_cnt_num + 2;
END LOOP;
END;


DECLARE
CURSOR cur_emps IS
SELECT employee_id, last_name FROM employees;
v_emp_record cur_emps%ROWTYPE;
BEGIN
OPEN cur_emps;
DBMS_OUTPUT.PUT_LINE(cur_emps%ROWCOUNT);
LOOP
FETCH cur_emps INTO v_emp_record;
EXIT WHEN cur_emps%ROWCOUNT > 10 OR cur_emps%NOTFOUND;
END LOOP;
CLOSE cur_emps;
END;


