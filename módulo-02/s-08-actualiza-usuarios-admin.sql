--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 24/11/2023
--@Descripción: Ejercicio 08 -módulo 02 .Actualización de privilegios de administración a usuarios creados
--previamente con el nuevo archivo de passwd.
prompt  Conectando como sysdba
connect sys/admin1234#¿ as sysdba

set linesize window
col username format a20

prompt mostrando datos de privilegios de administración asignado a usuarios.
select username, sysdba, sysbackup, sysoper, account_status
from  v$pwfile_users;


prompt asignando privilegios de administración a usuarios creados.
grant sysdba, sysoper, sysbackup to user01;
grant sysdba, sysoper, sysbackup to user02;
grant sysdba, sysoper, sysbackup to user03;

prompt mostrando datos de privilegios de administración asignado a usuarios.
select username, sysdba, sysbackup, sysoper, account_status
from  v$pwfile_users;


alter user sys identified by system1;
