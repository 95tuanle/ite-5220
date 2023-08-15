ALTER SESSION SET PLSQL_OPTIMIZE_LEVEL = 2;

ALTER SESSION SET PLSQL_CODE_TYPE = NATIVE;

CREATE OR REPLACE PROCEDURE testproc IS
    v_count INTEGER := 1;
BEGIN
    IF v_count = 1 THEN
        DBMS_OUTPUT.PUT_LINE('The count is one.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('The count is not one.');
    END IF;
    FOR i IN 1..500000 LOOP
        SELECT COUNT(*) INTO v_count FROM employees;
    END LOOP;
END testproc;

SELECT name, type, plsql_code_type AS CODE_TYPE, plsql_optimize_level AS OPT_LVL
FROM USER_PLSQL_OBJECT_SETTINGS WHERE name = 'TESTPROC';

begin
    testproc();
end;




ALTER SESSION SET PLSQL_WARNINGS = 'ENABLE:SEVERE';
ALTER PROCEDURE testproc COMPILE;
select * from USER_ERRORS;
ALTER SESSION SET PLSQL_WARNINGS = 'DISABLE:ALL';


DECLARE
    v_settings VARCHAR2(200);
BEGIN
    v_settings := DBMS_WARNING.GET_WARNING_SETTING_STRING;
    DBMS_OUTPUT.PUT_LINE(v_settings);
    DBMS_WARNING.SET_WARNING_SETTING_STRING('ENABLE:SEVERE','SESSION');
    DBMS_OUTPUT.PUT_LINE(DBMS_WARNING.GET_WARNING_SETTING_STRING);
    execute immediate 'ALTER PROCEDURE testproc COMPILE';
    execute immediate 'select * from USER_ERRORS';
    DBMS_WARNING.SET_WARNING_SETTING_STRING(v_settings,'SESSION');
    DBMS_OUTPUT.PUT_LINE(DBMS_WARNING.GET_WARNING_SETTING_STRING);
END;



ALTER SESSION SET PLSQL_CCFLAGS = 'debugFlag:true';

create or replace procedure my_debug_proc is
    v_count number;
begin
    $if $$debugFlag $then
        select count(*) into v_count from DEPARTMENTS;
        DBMS_OUTPUT.PUT_LINE('debugFlag is TRUE and the value of v_count is ' || v_count);
    $else
        DBMS_OUTPUT.PUT_LINE('debugFlag is FALSE');
    $end
end;

begin
    my_debug_proc();
end;

SELECT name, plsql_ccflags FROM USER_PLSQL_OBJECT_SETTINGS WHERE name = 'MY_DEBUG_PROC';

ALTER SESSION SET PLSQL_CCFLAGS = 'debugFlag:false';

create or replace procedure my_debug_proc is
    v_count number;
begin
    $if $$debugFlag $then
        select count(*) into v_count from DEPARTMENTS;
        DBMS_OUTPUT.PUT_LINE('debugFlag is TRUE and the value of v_count is ' || v_count);
    $else
        DBMS_OUTPUT.PUT_LINE('debugFlag is FALSE');
    $end
end;

begin
    my_debug_proc();
end;

SELECT name, plsql_ccflags FROM USER_PLSQL_OBJECT_SETTINGS WHERE name = 'MY_DEBUG_PROC';



create or replace procedure version_proc is
begin
    $IF DBMS_DB_VERSION.VERSION >= 11 $THEN
        DBMS_OUTPUT.PUT_LINE(DBMS_DB_VERSION.VERSION);
    $ELSE
        DBMS_OUTPUT.PUT_LINE('new performance features are available in release 11, so consider upgrading the database');
    $END
end;

begin
    version_proc();
end;


begin
     DBMS_DDL.CREATE_WRAPPED
         ('CREATE OR REPLACE PROCEDURE sample_proc IS
            BEGIN
                DBMS_OUTPUT.PUT_LINE (''Source code is hidden.'');
            END sample_proc;');
end;

SELECT TEXT FROM USER_SOURCE
WHERE TYPE = 'PROCEDURE' AND NAME = 'SAMPLE_PROC' ORDER BY LINE;

