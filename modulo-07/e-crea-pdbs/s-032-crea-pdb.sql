--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 23/02/2024
--@Descripción: Ejercicio 2 - Módulo 07. Clonar una PDB a partir de otra

--   EJERCICIO
--   Completar el script en las secciones marcadas con TODO
--
spool /unam-diplomado-bd/modulos/modulo-07/e-crea-pdbs/s-032-crea-pdbs-spool.txt

Prompt creando PDB a partir de otra 

Prompt conectar a jpcdip03_s1 para insertar datos de prueba
--TODO, conectar como sys a la PDB
conn sys/system3@jpcdip03_s1 as sysdba

Prompt creando un usuario de prueba
declare
  v_count number;
begin
   select count(*) into v_count from dba_users where username='JORGE07';
   if v_count > 0 then
     execute immediate 'drop user JORGE07 cascade';
   end if;
end;
/

Prompt creando usuario y tabla de prueba
create user jorge07 identified by jorge quota unlimited on users;
grant create session, create table to jorge07;

create table jorge07.test(id number);
insert into jorge07.test values(1);
insert into jorge07.test values(2);
insert into jorge07.test values(3);
commit;

Prompt conectando a cdb$root;
--TODO conectar a root. ¿es posible con alter session?
alter session set container=cdb$root;

Prompt clonando jpcdip03_s3 a partir de jpcdip03_s1
--TODO:  clonar la PDB a partir de jpcdip03_s1
create pluggable database jpcdip03_s3 from jpcdip03_s1
  path_prefix='/u01/app/oracle/oradata/JPCDIP03'
  file_name_convert=(
    '/jpcdip03_s1','/jpcdip03_s3/'
  );

Prompt Mostrando los datos de las PDBs con SQL*Plus
col file_name format A60
show pdbs
pause [Enter] para continuar

Prompt abrir pdb nueva
--TODO Abrir la nueva PDB
alter pluggable database jpcdip03_s3 open;

Prompt mostrando datafiles de la CDB
set linesize window
select file_id, file_name from cdb_data_files;
pause [Enter] para continuar

Prompt verificando los datos clonados
--TODO Agregar instrucciones para validar los datos
-- ¿Qué sucedería con esta instrucción: connect jorge07/jorge@jpcdip03_s3 ?
-- no funciona porque usa un alias de servicio de una pdb nueva no creado
alter session set container=jpcdip03_s3;
select * from  jorge07.test;


pause Revisar datos clonados, [Enter] para continuar

Prompt Limpieza
alter session set container=cdb$root;

prompt eliminando jpcdip03_s3
--TODO, cerrar jpcdip03_s3 y eliminarla
alter pluggable database jpcdip03_s3 close;
drop pluggable database jpcdip03_s3 including datafiles;

spool off
exit