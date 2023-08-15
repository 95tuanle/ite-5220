CREATE TABLE grocery_items (
    product_id NUMBER(3, 0) NOT NULL,
    brand VARCHAR2(20),
    description VARCHAR2(30)
);



INSERT INTO grocery_items (product_id, brand, description) VALUES (110, 'Colgate', 'Toothpaste');
INSERT INTO grocery_items (product_id, brand, description) VALUES (111, 'Ivory', 'Soap');
INSERT INTO grocery_items (product_id, brand, description) VALUES (112, 'Heinz', 'Ketchup');



INSERT INTO grocery_items (product_id, brand, description) VALUES (113, 'Coke', 'Coke Zero');



UPDATE grocery_items SET description = 'tomato catsup' WHERE brand = 'Heinz';



INSERT INTO grocery_items VALUES (114, 'Haribo', 'Tangfastics');



UPDATE grocery_items SET brand = 'Dove.' WHERE brand = 'Ivory';



SELECT * FROM grocery_items;



CREATE TABLE new_items (
    product_id NUMBER(3, 0) NOT NULL,
    brand VARCHAR2(20),
    description VARCHAR2(30)
);
INSERT INTO new_items VALUES (110, 'Colgate', 'Dental paste');
INSERT INTO new_items VALUES (175, 'Dew', 'Soda');
INSERT INTO new_items VALUES (275, 'Palmolive', 'Dish detergent');



MERGE INTO grocery_items g USING new_items n ON (g.product_id = n.product_id)
WHEN MATCHED THEN UPDATE SET g.brand = n.brand, g.description = n.description
WHEN NOT MATCHED THEN INSERT VALUES (n.product_id, n.brand, n.description);
SELECT * FROM grocery_items;



DECLARE
    v_max_deptno DEPARTMENTS.DEPARTMENT_ID%TYPE;
BEGIN
    SELECT MAX(DEPARTMENT_ID) INTO v_max_deptno FROM DEPARTMENTS;
    DBMS_OUTPUT.PUT_LINE(v_max_deptno);
END;



DECLARE
 v_country_name countries.country_name%TYPE := 'Federative Republic of Brazil';
 v_lowest_elevation countries.lowest_elevation%TYPE;
 v_highest_elevation countries.highest_elevation%TYPE;
BEGIN
 SELECT lowest_elevation, highest_elevation
 INTO v_lowest_elevation, v_highest_elevation
 FROM countries
 WHERE COUNTRY_NAME = v_country_name;
 DBMS_OUTPUT.PUT_LINE('The lowest elevation in '
|| v_country_name || ' is ' || v_lowest_elevation
 || ' and the highest elevation is ' || v_highest_elevation || '.');
END;



DECLARE
    v_emp_lname employees.last_name%TYPE;
    v_emp_salary employees.salary%TYPE;
BEGIN
    SELECT last_name, salary INTO v_emp_lname, v_emp_salary
    FROM employees
    WHERE job_id = 'IT_PRAG';
    DBMS_OUTPUT.PUT_LINE(v_emp_lname || ' ' || v_emp_salary);
END;



CREATE TABLE emp_dup AS SELECT * FROM EMPLOYEES;



SELECT FIRST_NAME, LAST_NAME FROM emp_dup;



DECLARE
    v_last_name VARCHAR2(25) := 'Fay';
BEGIN
    UPDATE emp_dup
    SET first_name = 'Jennifer'
    WHERE last_name = v_last_name;
END;



DROP TABLE EMP_DUP PURGE;
CREATE TABLE emp_dup AS SELECT * FROM EMPLOYEES;



DECLARE
    v_last_name VARCHAR2(25) := 'Fay';
BEGIN
    UPDATE emp_dup
    SET first_name = 'Jennifer'
    WHERE last_name = v_last_name;
END;



SELECT FIRST_NAME, LAST_NAME FROM emp_dup WHERE LAST_NAME = 'Fay';



CREATE TABLE name (
    id NUMBER(3),
    name VARCHAR2(30)
);
INSERT INTO name VALUES (123, 'Hello');
INSERT INTO name VALUES (312, 'World');
SELECT * FROM name;



BEGIN
    UPDATE name SET name = 'NAME' WHERE id = 312;
END;
SELECT * FROM name;



CREATE TABLE new_depts AS SELECT * FROM departments;



DECLARE
    v_max_deptno new_depts.department_id%TYPE;
    v_dept_name new_depts.department_name%TYPE := 'A New Department';
    v_dept_id new_depts.department_id%TYPE;
BEGIN
    SELECT MAX(department_id) INTO v_max_deptno FROM new_depts;
    v_dept_id := v_max_deptno + 10;
    SELECT MAX(department_id) INTO v_max_deptno FROM new_depts;
    UPDATE new_depts SET LOCATION_ID = 1400 WHERE LOCATION_ID = 1700;
    DBMS_OUTPUT.PUT_LINE('The maximum department id is: ' || v_max_deptno);
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' row updated');
END;



CREATE TABLE endangered_species
(species_id NUMBER(4) CONSTRAINT es_spec_pk PRIMARY KEY,
common_name VARCHAR2(30) CONSTRAINT es_com_name_nn NOT NULL, scientific_name VARCHAR2(30) CONSTRAINT es_sci_name_nn NOT NULL);



BEGIN
INSERT INTO endangered_species
VALUES (100, 'Polar Bear', 'Ursus maritimus'); SAVEPOINT sp_100;
INSERT INTO endangered_species
VALUES (200, 'Spotted Owl', 'Strix occidentalis'); SAVEPOINT sp_200;
INSERT INTO endangered_species
VALUES (300, 'Asiatic Black Bear', 'Ursus thibetanus'); ROLLBACK TO sp_100;
COMMIT;
END;
select * from endangered_species;



BEGIN
INSERT INTO endangered_species
VALUES (400, 'Blue Gound Beetle', 'Carabus intricatus'); SAVEPOINT sp_400;
INSERT INTO endangered_species
VALUES (500, 'Little Spotted Cat', 'Leopardus tigrinus'); ROLLBACK;
INSERT INTO endangered_species
VALUES (600, 'Veined Tongue-Fern', 'Elaphoglossum nervosum'); ROLLBACK TO sp_400;
END;
select * from endangered_species;