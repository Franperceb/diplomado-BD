--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 23/02/2024
--@Descripción: Ejercicio 04 - Módulo 07. M07 Lab 01.
Prompt conectando como sysdba
conn / as sysdba

Prompt iniciar jpcdip03
!sh s-030-start-cdb.sh jpcdip03 system3

Prompt conectando jpcdip03
connect sys/system3@jpcdip03 as sysdba

Prompt Crear un application container jpcdip03_appc1

create pluggable database jpcdip03_appc1 as application container 
  admin user admin identified by admin
  file_name_convert=(
    '/u01/app/oracle/oradata/JPCDIP03/pdbseed',
    '/u01/app/oracle/oradata/JPCDIP03/jpcdip03_appc1'
);

prompt abriendo jpcdip03_appc1
alter pluggable database jpcdip03_appc1 open read write;

prompt conectando a jpcdip03_appc1
alter session set container=jpcdip03_appc1;


Prompt crear PDB jpcdip03_appc1_s1

create pluggable database jpcdip03_appc1_s1
 admin user admin identified by admin
 file_name_convert=(
  '/u01/app/oracle/oradata/JPCDIP03/pdbseed',
  '/u01/app/oracle/oradata/JPCDIP03/jpcdip03_appc1/jpcdip03_appc1_s1'
 );

Prompt Abrir  jpcdip03_appc1_s1
alter pluggable database jpcdip03_appc1_s1 open read write;

Prompt  realizar sync entre pdb y app container
alter session set container=jpcdip03_appc1_s1;
alter pluggable database application all sync;


alter session set container=jpcdip03_appc1;

Prompt creando un tablespace
alter system set db_create_file_dest='/u01/app/oracle/oradata' scope=memory;
create tablespace app1_test01_ts
datafile size 1m autoextend on next 1m;

Prompt crear un usuario
create user app1_test_user identified by jorge
  default tablespace app1_test01_ts
  quota unlimited on app1_test01_ts
  container=all;




grant create session, create table, create procedure 
  to app1_test_user;


Prompt crear una tabla
create table app1_test_user.datos(
  id number(10,0) constraint carrera_pk primary key,
  nombre varchar2(40)
);

create synonym prueba for app1_test_user.datos;

Prompt Insertando datos
insert into app1_test_user.datos(id,nombre) values (1,'Hola');
commit;

Prompt sync pdb
alter session set container=jpcdip03_appc1_s1;
alter pluggable database application all sync;


Prompt conectandome a la pdb
alter session set container=jpcdip03_appc1_s1;

Prompt Realizando consulta que valida disponibilidad
select  * from app1_test_user.datos;

