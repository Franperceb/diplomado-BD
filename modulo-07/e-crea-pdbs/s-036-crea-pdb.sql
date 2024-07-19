--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 23/02/2024
--@Descripción: Ejercicio 06 - Módulo 07. E06 Refreshable PDBs



--   EJERCICIO
--   Completar el script en las secciones marcadas con TODO
--
Prompt Creando PDB tipo refreshable

Prompt iniciar jpcdip03
!sh s-030-start-cdb.sh jpcdip03 system3

Prompt iniciar jpcdip04
!sh s-030-start-cdb.sh jpcdip04 system4

Prompt conectando jpcdip03
connect sys/system3@jpcdip03 as sysdba

prompt abriendo jpcdip03_s1
alter pluggable database jpcdip03_s1 open read write;

prompt creando un usuario común
--TODO: Crear usuario comun
create user c##jorge_remote identified by jorge container=all;
grant create table, create session , create pluggable database to c##jorge_remote
  container=all;



Prompt conectando a jpcdip04 para crear la liga
connect sys/system4@jpcdip04 as sysdba 

Prompt crear liga
--TODO: Crear la liga
create database link clone_link
  connect to c##jorge_remote identified by jorge
  using 'JPCDIP03_S1';

Prompt crear PDB tipo refreshable
--TODO crear PDB
create pluggable database jpcdip04_r3
  from jpcdip03_s1@clone_link
  file_name_convert=(
    '/u01/app/oracle/oradata/JPCDIP03/jpcdip03_s1',
    '/u01/app/oracle/oradata/JPCDIP04/jpcdip04_r3'
  ) refresh mode manual;


prompt consultando el último refresh
--TODO consultar último refresh
select last_refresh_scn
from dba_pdbs 
where pdb_name='JPCDIP04_R3';

pause Analizar el valor del S0CN [enter] para continuar

Prompt Crear una tabla y un registro en jpcdip03_s1
connect sys/system3@jpcdip03_s1 as sysdba

--TODO: Crear tablespace
create tablespace test_refresh_ts
  datafile '/u01/app/oracle/oradata/JPCDIP03/jpcdip03_s1/test_refresh01.dbf'
  size 1M autoextend on next 1M;

Prompt Creando un usuario de prueba *
create user jorge_refresh identified by jorge 
 default tablespace test_refresh_ts
 quota unlimited on test_refresh_ts;

grant create session, create table to jorge_refresh;

Prompt creando tabla  test_refresh

create table jorge_refresh.test_refresh(id number);

Prompt insertando datos de prueba

insert into jorge_refresh.test_refresh values (1);
commit;

select * from jorge_refresh.test_refresh;

pause Revisar tabla y datos creados [Enter] para continuar
Prompt conectando a la jpcdip04_r3

connect sys/system4@jpcdip04 as sysdba

Prompt abrir jpcdip04_r3 en modo read only
--TODO: Abrir en modo read only
alter pluggable database jpcdip04_r3 open read only;

Prompt verificando datos
alter session set container = jpcdip04_r3;

pause ¿Qué se obtendría  al intentar consultar la tabla ? [Enter] para continuar

select * from jorge_refresh.test_refresh;

Prompt Hacer refresh (desde root)
--TODO: Agregar las instrucciones necesarias para hacer refresh
alter session set container=cdb$root;

alter pluggable database jpcdip04_r3 close immediate;
alter system set db_create_file_dest='/u01/app/oracle/oradata' scope=memory;
alter pluggable database jpcdip04_r3 refresh;

Prompt consultando datos nuevamente 
pause ¿qué se esperaría ?[Enter] para continuar
alter pluggable database jpcdip04_r3 open read only;

alter session set container = jpcdip04_r3;
select * from jorge_refresh.test_refresh;

prompt consultando el último refresh
select last_refresh_scn
from dba_pdbs
where pdb_name='JPCDIP04_R3';


Pause Analizar resultados, [Enter] para realizar limpieza

alter session set container = cdb$root;
alter pluggable database jpcdip04_r3 close immediate;
drop pluggable database jpcdip04_r3 including datafiles;

drop database link clone_link;

Prompt limpiar al usuario en común
connect sys/system3@jpcdip03 as sysdba
drop user c##jorge_remote cascade;

Prompt Eliminar tablespace
--TODO: Eliminar tablespace
alter session set container=jpcdip03_s1;
drop tablespace test_refresh_ts including contents and datafiles;

Prompt Eliminar al usuario jorge_refresh
drop user jorge_refresh cascade;