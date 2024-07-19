--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 23/02/2024
--@Descripción: Ejercicio 04 - Módulo 07. E04 Creando una PDB a partir de una non CDB


--   EJERCICIO
--   Completar el script en las secciones marcadas con TODO
--

prompt Hacer  jpcdip01 -> jpcdip04_s2  Ahora con DB links

prompt Iniciando jpcdip01
!sh s-030-start-cdb.sh jpcdip01 system2

prompt Iniciando jpcdip04
!sh s-030-start-cdb.sh jpcdip04 system4

prompt conectando a jpcdip01
connect sys/system1@jpcdip01 as sysdba

-- TODO: Crear un usuario en común (nivel CDB) para realizar conexiones a través
-- de un DB link
prompt creando usuario en jpcdip01
create user jorge_remote identified by jorge;
grant create session, create pluggable database to jorge_remote;

prompt Mostrando ORACLE_SID
!echo $ORACLE_SID

pause es correcto? [Enter] para continuar
conn sys/system4 as sysdba 

--TODO: Crear el DB Link, agregar el alias de servicio de ser necesario
create database link clone_link
  connect to jorge_remote identified by jorge
  using 'jpcdip01';

prompt Creando pdb jpcdip04_s2
--TODO:  clonar la PDB en  jpcdip04_s2
create pluggable database jpcdip04_s2
  from jpcdip01@clone_link
  file_name_convert=(
    '/u01/app/oracle/oradata/JPCDIP01', 
    '/u01/app/oracle/oradata/JPCDIP04/jpcdip04_s2'
  );

prompt ejecutando el script noncdb to_pdb.sql
--TODO: Incluir la ejecución del script
alter session set container=jpcdip04_s2;
@$ORACLE_HOME/rdbms/admin/noncdb_to_pdb.sql

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

prompt eliminando usuario en jpcdip01
connect sys/system3@jpcdip01 as sysdba

drop user jorge_remote cascade;

spool off
exit
