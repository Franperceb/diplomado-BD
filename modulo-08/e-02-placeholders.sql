--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 05/04/2024
--@Descripción: Ejercicio 02 - Módulo 08. Uso de placeholders.
set linesize window

conn jorge/jorge

Prompt Creando tabla jpc_test
CREATE TABLE jpc_test(
    id NUMBER NOT NULL
);

Prompt Llenando registros con placeholders 
SET SERVEROUTPUT ON

BEGIN
  FOR i IN 100..10000 LOOP
    EXECUTE IMMEDIATE 'INSERT INTO jpc_test VALUES (:1)' USING i;
  END LOOP;
END;
/

Prompt Mostrando el número de registros
SELECT COUNT(*) FROM jpc_test;

--Prompt conectando como sysdba
--conn sys/system1 as sysdba

--Prompt Mostrando datos de sql
--select sql_text from v$sqlarea
--where sql_fulltext like '%insert into jpc_test values%';


PAUSE Validar cursores generados. [Enter] para continuar..

--Prompt conectando como jorge
--conn jorge/jorge

Prompt Llenando registros sin placeholders 
SET SERVEROUTPUT ON

BEGIN
  FOR i IN 100..10000 LOOP
    EXECUTE IMMEDIATE 'INSERT INTO jpc_test VALUES (' || i || ')';
  END LOOP;
END;
/ 

Prompt Mostrando el número de registros
SELECT COUNT(*) FROM jpc_test;

--Prompt conectando como sysdba
--conn sys/system1 as sysdba

--Prompt Mostrando datos de sql
--select sql_text  from v$sqlarea
--where sql_fulltext like '%insert into jpc_test values%';

PAUSE Validar cursores generados. [Enter] para continuar..

Prompt limpieza
drop table jorge.jpc_test;