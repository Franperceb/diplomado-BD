--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 13/11/2023
--@Descripción: Ejercicio 06  -módulo 02 . Archivo de passwords. Ejecutar script como user administrador.

prompt Conectando como sysdba
connect sys/system1 as  sysdba

prompt Creando usuarios user01, user02 , user03
create user user01 identified by user01;
create user user02 identified by user01;
create user user03 identified by user01;

prompt Asignando privilegios de administración
grant sysdba, sysoper , sysbackup to user01;
grant sysdba, sysoper , sysbackup to user02;
grant sysdba, sysoper , sysbackup to user03;


prompt Comprobando privilegios asignados


