--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 16/02/2024
--@Descripción: Ejercicio 03 - Módulo 07. Estados de las PDBS.

--   EJERCICIO
--   Completar el script en las secciones marcadas con TODO
--

pause Asegurarse que la CDB esté iniciada, asi como oracle_sid= jrcdip03
pause [enter] para continuar

set linesize window
Prompt Pregunta 1 --ser cierra solo la cdb no toda la instancia.
-----------------------------------------------------------
prompt conectando a jpcdip03_s1
connect sys/system3@jpcdip03_s1 as sysdba
pause ¿que sucederá al ejecutar shutdown immediate? [enter]
shutdown immediate

Prompt pregunta 2 -- debe de cambiarse el estado de la cdb cerrada
-----------------------------------------------------------
alter session set container=cdb$root;
col name format a20

select con_id, name,open_mode from v$pdbs;
pause Analizar resultados [enter] para continuar

Prompt pregunta 3 detener a la CDB
-----------------------------------------------------------
--TODO: Completar -- cierra todas las cdbs por el nivel y la instancia si se detiene
shutdown immediate

Prompt pregunta 4 , iniciando Nuevamente  
-------------------------------------------------------------
-- Analizar la siguiente instrucción ¿Será correta?, ¿ A qué PDB se conectará?
Pause Asegurar que oracle_sid sea igual a jpcdip03 [Enter] para continuar
connect sys/system3 as sysdba 
startup

prompt Ejecutando nuevamente consulta 2
--alter session set container=cdb$root;
select con_id, name,open_mode from v$pdbs;
pause Analizar resultados [enter] para continuar

--TODO: Completar para modificar el valor de open_mode,
-- hacer el cambio permanente  
Prompt abriendo todas las Pdbs
alter pluggable database all open;

Prompt haciendo permanente el cambio 
alter pluggable database all save state;

Prompt reiniciando CDB
shutdown immediate
Prompt iniciando nuevamente
startup

Prompt mostrando consulta 2 nuevamente
select con_id, name,open_mode from v$pdbs;