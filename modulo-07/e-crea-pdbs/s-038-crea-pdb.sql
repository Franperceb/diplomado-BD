--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 23/02/2024
--@Descripción: Ejercicio 04 - Módulo 07. Creación de una PDB


spool /unam-diplomado-bd/modulos/modulo-07/e-crea-pdbs/m07-e03-08.txt
Prompt Creando un Application container en jrcdip03

Prompt detener jrcdip04
!sh s-030-stop-cdb.sh jrcdip04 system4

Prompt iniciar jrcdip03
!sh s-030-start-cdb.sh jrcdip03 system3

Prompt conectando jrcdip03
connect sys/system3@jrcdip03 as sysdba

Prompt Crear un application container jrcdip03_appc1
--TODO: Crear  PDB
create pluggable database jrcdip03_appc1 as application container 
  admin user admin identified by admin
  file_name_convert=(
    '/u01/app/oracle/oradata/JRCDIP03/pdbseed',
    '/u01/app/oracle/oradata/JRCDIP03/jrcdip03_appc1'
);

prompt abriendo jrcdip03_appc1
alter pluggable database jrcdip03_appc1 open read write;

prompt conectando a jrcdip03_appc1
alter session set container=jrcdip03_appc1;

prompt mostrando datos del container
show con_id
show con_name

pause Analizar resultados, [Enter] para continuar

Prompt crear PDB jrcdip03_appc1_s1

--TODO crear PDB

create pluggable database jrcdip03_appc1_s1
 admin user admin identified by admin
 file_name_convert=(
  '/u01/app/oracle/oradata/JRCDIP03/pdbseed',
  '/u01/app/oracle/oradata/JRCDIP03/jrcdip03_appc1/jrcdip03_appc1_s1'
 );

Prompt Abrir  jrcdip03_appc1_s1
alter pluggable database jrcdip03_appc1_s1 open read write;

Prompt  realizar sync entre pdb y app container
--TODO Realizar sync
alter session set container=jrcdip03_appc1_s1;
alter pluggable database application all sync;

Prompt  Crear un application  jrcdip03_appc1_app1
alter session set container=jrcdip03_appc1;

alter pluggable database application jrcdip03_appc1_app1 begin install '1.0';

Prompt creando objetos comunes

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
create table app1_test_user.carrera(
  id number(10,0) constraint carrera_pk primary key,
  nombre varchar2(40)
);

Prompt Insertando datos
insert into app1_test_user.carrera(id,nombre) values (1,'Ing Computación');
insert into app1_test_user.carrera(id,nombre) values (2,'Medicina');
insert into app1_test_user.carrera(id,nombre) values (3,'Contaduría');
commit;

Prompt terminar de asociar objetos comunes
alter pluggable database application jrcdip03_appc1_app1 end install;

prompt Probando realizando sync
alter session set container=jrcdip03_appc1_s1;
alter pluggable database application jrcdip03_appc1_app1 sync;

prompt Mostrando datos de objetos comunes
select * from app1_test_user.carrera;

pause Revisar resultados, [Enter] para continuar

Prompt creando nueva PDB jrcdip03_appc1_s2

alter session set container=jrcdip03_appc1;

create pluggable database jrcdip03_appc1_s2
 admin user admin identified by admin
 file_name_convert=(
  '/u01/app/oracle/oradata/JRCDIP03/pdbseed',
  '/u01/app/oracle/oradata/JRCDIP03/jrcdip03_appc1/jrcdip03_appc1_s2'
 );

Prompt abrir jrcdip03_appc1_s2
alter pluggable database jrcdip03_appc1_s2 open read write;

Prompt Mostrar los datos en jrcdip03_appc1_s2 sin hacer sync 
alter session set container=jrcdip03_appc1_s2;
select * from app1_test_user.carrera;
pause Analizar resultados, [enter] para continuar

Prompt hacer sync en jrcdip03_appc1_s2, mostrar datos
alter pluggable database application jrcdip03_appc1_app1 sync;

select * from app1_test_user.carrera;
pause Analizar resultados, [enter] para continuar


Prompt  Generando version 1.1 de  jrcdip03_appc1_app1
alter session set container= jrcdip03_appc1;

alter pluggable database application jrcdip03_appc1_app1 
  begin upgrade '1.0' to '1.1';

Prompt insertar un nuevo dato
insert into app1_test_user.carrera(id,nombre) values(4,'Filosofía');

Prompt agregando una nueva columna
alter table app1_test_user.carrera add total_creditos number;

Prompt agregando un procedimiento almacenado
create or replace procedure app1_test_user.p_asigna_creditos(
  p_carrera_id number) is
begin
  update app1_test_user.carrera set total_creditos = id+10
  where id = p_carrera_id;
end;
/
show errors

Prompt marcar el final del upgrade 
alter pluggable database application jrcdip03_appc1_app1 end upgrade;

Prompt revisar la nueva version
alter session set container=jrcdip03_appc1_s1;

Prompt Hacer sync
alter pluggable database application jrcdip03_appc1_app1 sync;

Prompt invocando a procedimiento almacenado
pause ¿Qué pasará al modificar un registro a través del procedimiento? [Enter] ..
exec app1_test_user.p_asigna_creditos(1);
commit;

Prompt mostrando los datos de la tabla

select * from app1_test_user.carrera;

Prompt haciendo sync en jrcdip03_appc1_s2
alter session set container=jrcdip03_appc1_s2;
alter pluggable database application jrcdip03_appc1_app1 sync;

Prompt mostrando datos desde jrcdip03_appc1_s2
select * from app1_test_user.carrera;


pause Analizar resultados [enter] para continuar


Prompt consultas al DD
alter session set container=jrcdip03_appc1;

col app_name format a20
col name format a30
col app_version format a10
select  app_name, app_version, app_status
from  dba_applications;

Prompt datos de PDBs asociadas  a un APP container
select  c.name, ap.app_name, ap.app_version, ap.app_status
from dba_app_pdb_status ap
join v$containers c  on c.con_uid=ap.con_uid;

pause Analizar resultados [enter] para realizar limpieza

alter session set container=jrcdip03_appc1;
alter pluggable database jrcdip03_appc1_s1 close;
alter pluggable database jrcdip03_appc1_s2 close;

drop pluggable database jrcdip03_appc1_s1 including datafiles;
drop pluggable database jrcdip03_appc1_s2 including datafiles;

alter pluggable database application jrcdip03_appc1_app1 begin uninstall;

drop tablespace  app1_test01_ts including contents and datafiles;
drop user app1_test_user  cascade;

alter pluggable database application jrcdip03_appc1_app1 end  uninstall;

alter session set container=cdb$root;
alter pluggable database jrcdip03_appc1 close;
drop pluggable database jrcdip03_appc1 including datafiles;