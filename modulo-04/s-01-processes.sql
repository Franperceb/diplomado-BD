--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 11/01/2024
--@Descripción: Ejercicio 04 - Módulo 04. Tipos de procesos.

/* En terminal correr antes
Prompt Iniciando listener
lsnrctl start

-- user procesess = sqlplus  a nivel cliente
-- server processes =  a nivel instancia
-- Asumiendo que la instancia se encuentra detenida, ningún usuario haciendo uso de sqlplus.
-- Mostrando user y server processes
ps -ef | grep -e jpcdip02 -e sqlplus | grep -v grep 


Prompt entrando a sqlplus 
sqlplus /nolog
*/

Pause Mostrando nuevamente user y server processes ¿ Qué debería mostrarse? [ Enter ] para continuar
!ps -ef | grep -e jpcdip02 -e sqlplus | grep -v grep 


Prompt conectando como sysdba
conn sys/system2 as sysdba

Pause Mostrando nuevamente user y server processes ¿ Qué debería mostrarse? [ Enter ] para continuar
!ps -ef | grep -e jpcdip02 -e sqlplus | grep -v grep 

Prompt Mostrando el proceso asciado con el  listener
!ps -ef | grep -e listener | grep -v grep

Pause Analizar resultado , [ Enter ] ...

Prompt Iniciando instancia en modo nomount
startup nomount

Pause Montando procesos. ¿ Qué se obtendra ? [ Enter ] para continuar
!ps -ef  | grep -e jpcdip02 -e sqlplus | grep -v grep


Pause Analizar resultado, [Enter] para continuar 

Prompt abriendo BD.
alter database mount;
alter database open;

Prompt  Saliendo de sesión 
disconnect

Prompt Creando una nueva sesión como sysdba
conn sys/system2 as sysdba

Prompt Montando procesos de esta nueva conexión a nivel S.O.
!ps -ef  | grep -i  -e 'local=yes' -e sqlplus | grep -v grep

Prompt Anotar los IDs de los procesos en SQL Developer. Ejecutar el repoerte.
pause Presionar [Enter] hasta que se haya viusalizado el reporte 

/* Correr en SQLDeveloper
 select sosid, pid, pname, username, program, tracefile, background,
trunc(pga_used_mem/1024/1024,2) pga_used_mem_mb
from v$process
where sosid in ('id1'. 'id2');
*/




