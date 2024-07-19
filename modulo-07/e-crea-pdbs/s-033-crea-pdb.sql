--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 23/02/2024
--@Descripción: Ejercicio 03 - Módulo 07. Clonar una PDB a partir de una CDB remota

--   EJERCICIO
--   Completar el script en las secciones marcadas con TODO
--
spool /unam-diplomado-bd/modulos/modulo-07/e-crea-pdbs/s-033-crea-pdb-spool.txt

prompt Hacer Clon jpcdip03_s1 -> jpcdip04_s2  Ahora con DB links

prompt Iniciando jpcdip03
!sh s-030-start-cdb.sh jpcdip03 system3

prompt Iniciando jpcdip04
!sh s-030-start-cdb.sh jpcdip04 system4

prompt conectando a jpcdip03
connect sys/system3@jpcdip03 as sysdba

-- TODO: Crear un usuario en común (nivel CDB) para realizar conexiones a través
-- de un DB link
prompt creando usuario en jpcdip03
create user c##jorge_remote identified by jorge container=ALL;
grant create session, create pluggable database to c##jorge_remote container=ALL;

prompt conectando a jpcdip04 para crear DB Link
--TODO:  realizar la conexión
Pause cambiar ORACLE_SID a nueva cdb [Enter] para continuar

conn sys/system4 as sysdba 

--TODO: Crear el DB Link, agregar el alias de servicio de ser necesario
create database link clone_link
  connect to c##jorge_remote identified by jorge
  using 'jpcdip03';

prompt Creando pdb jpcdip04_s2
--TODO:  clonar la PDB en  jpcdip04_s2
create pluggable database jpcdip04_s2
  from jpcdip03_s1@clone_link
  file_name_convert=(
    '/u01/app/oracle/oradata/JPCDIP03/jpcdip03_s1', 
    '/u01/app/oracle/oradata/JPCDIP04/jpcdip04_s2'
  );

prompt Abriendo y verificando la nueva pdb
alter pluggable database jpcdip04_s2 open read write;
show pdbs

Prompt mostrando datafiles de la CDB
set linesize window
col file_name format A60
select file_id, file_name from cdb_data_files;

pause Analizar resultados, [Enter] para continuar con Limpieza

prompt borrar PDB
alter pluggable database jpcdip04_s2 close;
drop  pluggable database jpcdip04_s2 including datafiles;

drop database link clone_link;

prompt eliminando usuario en jpcdip03
connect sys/system3@jpcdip03 as sysdba

--TODO: ELiminar al usuario 
drop user c##jorge_remote cascade;

spool off
exit
