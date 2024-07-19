--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 26/01/2024
--@Descripción: Ejercicio 01 - Módulo 06. Backup incremental.

CONNECT user06bk/user06bk 

Prompt Creando tabla prueba
CREATE TABLE prueba (
    id  NUMBER(9,0),
    datos VARCHAR2(40)
);

Prompt Creando secuencia para tabla
create sequence  prueba_id_seq
    start with 0
    increment by 1 
    minvalue 0;

Prompt creando procedimiento para insertar registros
CREATE OR REPLACE PROCEDURE insertar_registros (
    cantidad_registros IN NUMBER
) AS
BEGIN
    FOR i IN 1..cantidad_registros LOOP
        INSERT INTO prueba VALUES (prueba_id_seq.nextval, 'Registro ' || i);
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Se insertaron ' || cantidad_registros || ' registros en la tabla prueba.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

Prompt Insertando 10 registros
exec insertar_registros(10);


Prompt Validando cantidad de registros
select count(*) from prueba;

Pause Realizar backup nivel 0. [Enter] para continuar 


Prompt Insertando más registros a la tabla prueba
exec insertar_registros(500);

Prompt Validando registros insertados
select count(*) from prueba;


Pause Realizar backup incremental diferencial. [Enter] para continuar 


Prompt Modificando los primeros 500 registros de la tabla
update prueba set datos = 'Dato modificado' where id <=500; --validar que los ids no se repitan con un seq y ya


Pause Realizar backup incremental cumulativo. [Enter] para continuar 


Prompt Insertando más registros a la tabla prueba
exec insertar_registros(500);

Prompt Validando registros insertados
select count(*) from prueba;

Pause Realizar backup incremental diferencial. [Enter] para continuar 

Prompt Realizar backup incremental full nivel 0

Prompt Eliminando tabla prueba
drop table prueba;
drop sequence prueba_id_seq;