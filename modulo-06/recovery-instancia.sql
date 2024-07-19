
--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 26/01/2024
--@Descripción: Ejercicio 01 - Módulo 06. Fallo backup instancia.

CONNECT user06bk/user06bk 

Prompt Creando secuencia para tabla
create sequence  prueba_id_seq
    start with 0
    increment by 1 
    minvalue 0;

Prompt Creando tabla pruebabk
CREATE TABLE pruebabk (
    id  NUMBER(9,0),
    datos VARCHAR2(40)
);

Prompt creando procedimiento para insertar registros
CREATE OR REPLACE PROCEDURE insertar_registros (
    cantidad_registros IN NUMBER
) AS
BEGIN
    FOR i IN 1..cantidad_registros LOOP
        INSERT INTO pruebabk VALUES (prueba_id_seq.nextval, 'Registro ' || i);
    END LOOP;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Se insertaron ' || cantidad_registros || ' registros en la tabla pruebabk.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/

Prompt Insertando 10 registros
exec insertar_registros(10);

pause Checar altert log [Enter] para continuar 

Prompt simulando caida de instancia
Prompt conectando como sysdba
conn sys/system2 as sysdba
shutdown abort 
startup

Prompt conectando como usuario user06bk
CONNECT user06bk/user06bk 


Prompt verificar información recuperada [Enter] para continuar...



