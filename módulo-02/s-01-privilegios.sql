--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 13/11/2023
--@Descripción: Ejercicio 01 -módulo 02 .Creación de usuario jorge01 y valicación de privilegios de sistema
prompt conectando como sysdba
connect sys/system1  as sysdba

--creando usuario
prompt creando usuario jorge01
create user jorge01 identified by jorge01 quota unlimited on users;

--otorgar permisos al user
prompt asignando privilegios de sistema a jorge01
grant create session, create table to jorge01

prompt entrando sesion con jorge01
conn jorge01/jorge01 

prompot creando una tabla de prueba
create table prueba(id number);

prompt conectando como sysdba
conn sys/system1 as sysdba

prompt validando privilegios de usuario creado
col grantee format a20
set linesize window
select grantee, privilege, admin_option
from dba_sys_privs
where grantee='JORGE01';

pause  Actividades de limpieza [Enter] para continuar

drop user jorge01 cascade;
