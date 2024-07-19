--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 23/02/2024
--@Descripción: Ejercicio 07 - Módulo 07.Crear una PDB  - E07 Proxy  PDBs 


--   EJERCICIO
--   Completar el script en las secciones marcadas con TODO
--
spool /unam-diplomado-bd/modulos/modulo-07/e-crea-pdbs/s-037-crea-pdb-spool.txt
Prompt Creando proxy PDB

Prompt iniciar jpcdip03
!sh s-030-start-cdb.sh jpcdip03 system3

Prompt iniciar jpcdip04
!sh s-030-start-cdb.sh jpcdip04 system4

Prompt Preparando jpcdip03_s2

connect sys/system3@jpcdip03 as sysdba

prompt creando common user 
create user c##jorge_remote identified by jorge container=all;
grant create session,create pluggable database to c##jorge_remote
  container=all;

Prompt Abriendo PDB
alter pluggable database jpcdip03_s2 open read write;

alter session set container=jpcdip03_s2;

--TODO Crear un tablespace de prueba
create tablespace test_proxy_ts
  datafile '/u01/app/oracle/oradata/JPCDIP03/jpcdip03_s2/test_proxy01.dbf'
  size 1M autoextend on next 1M;




Prompt Creando un usuario de prueba
create user jorge_proxy identified by jorge 
 default tablespace test_proxy_ts
 quota unlimited on test_proxy_ts;

grant create session, create table to jorge_proxy;

Prompt creando tabla  test_proxy

create table jorge_proxy.test_proxy(id number);

Prompt insertando datos de prueba

insert into jorge_proxy.test_proxy values (1);
commit;

select * from jorge_proxy.test_proxy;

pause Revisar datos, [Enter] para continuar

Prompt conectando  a jpcdip04 para crear liga y proxy PDB
connect sys/system4@jpcdip04 as sysdba

Prompt creando liga
--TODO: Crear  liga
create database link clone_link
  connect to c##jorge_remote identified by jorge
  using 'JPCDIP03_S2';


Prompt creando Proxy PDB
-- TODO: Creando proxy PDB
create pluggable database jpcdip04_p1 as proxy
  from jpcdip03_s2@clone_link
  file_name_convert=(
    '/u01/app/oracle/oradata/JPCDIP03/jpcdip03_s2',
    '/u01/app/oracle/oradata/JPCDIP04/jpcdip04_p1'
  );
pause Probando proxy PDB [Enter] para continuar

Prompt abrir la proxy PDB
alter pluggable database jpcdip04_p1 open read write;

Prompt accediendo a jpcdip03_s2 a través de la Proxy PDB
connect jorge_proxy/jorge@jpcdip04_p1

Prompt mostrando dastos desde proxy
--TODO: Mostrar los datos desde proxy
select * from test_proxy; 

Prompt insertando datos desde proxy
--TODO: Insetar los datos desde proxy
insert into test_proxy values(2);
commit;

Prompt validando en jpcdip03_s2
connect sys/system3@jpcdip03_s2 as sysdba

select * from jorge_proxy.test_proxy;

pause Analizar resultados [Enter] para hacer limpieza

prompt limpieza en jpcdip03_s2
alter session set container=cdb$root;
drop user c##jorge_remote cascade;

--eliminar tablespace
alter session set container=jpcdip03_s2;
drop tablespace test_proxy_ts including contents and datafiles;

--eliminar al usuario jorge_proxy
drop user jorge_proxy cascade;

Prompt limpieza en jpcdip04
connect sys/system4@jpcdip04 as sysdba

alter pluggable database jpcdip04_p1 close immediate;
drop pluggable database jpcdip04_p1 including datafiles;

drop database link clone_link;