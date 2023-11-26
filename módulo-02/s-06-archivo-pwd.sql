--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 24/11/2023
--@Descripción: Ejercicio 06 -módulo 02 .Archivo de passwords.Ejecutar como administrador consulta y 
-- creación de usuarios con privilegios de administración.

prompt conectando como sysdba
conn sys/system1 as sysdba

prompt creando usuarios user01 , user02, user03
create user user01 identified by user01;
create user user02 identified by user02;
create user user03 identified by user03;

prompt asignando privilegios de administración a usuarios creados.
grant sysdba, sysoper, sysbackup to user01;
grant sysdba, sysoper, sysbackup to user02;
grant sysdba, sysoper, sysbackup to user03;

set linesize window
col username format a20

prompt mostrando datos de privilegios de administración asignado a usuarios.
select username, sysdba, sysbackup, sysoper, account_status
from  v$pwfile_users;


