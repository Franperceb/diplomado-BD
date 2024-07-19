--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 11/02/2024
--@Descripción: Ejercicio 02 - Módulo 07. Consultas a la base de datos creada CBD.
set linesize window
col pdb_name format a30
col name format a30
col open_time format a40


prompt Consulta 1, conectando a  root
-------------------------------------
connect sys/system3@jpcdip03 as sysdba

select dbid,name,cdb,con_id,con_dbid
from v$database;

prompt Consulta 1, conectando jpcdip03_s1
-----------------------------------------
connect sys/system3@jpcdip03_s1 as sysdba
select dbid,name,cdb,con_id,con_dbidsss
from v$database;

prompt Consulta 1, conectando jpcdip03_s2
-----------------------------------------
connect sys/system3@jpcdip03_s2 as sysdba
select dbid,name,cdb,con_id,con_dbid
from v$database;

pause Analizar resultados [enter] para continuar


prompt Consulta 2 en root - dba_pdbs
----------------------------------------------
connect sys/system3@jpcdip03  as sysdba
select con_id, pdb_id, pdb_name , dbid, status
from dba_pdbs;

prompt Consulta 2 en jpcdip03_s2 - dba_pdbs
--------------------------------------------
connect sys/system3@jpcdip03_s2  as sysdba
select con_id, pdb_id, pdb_name , dbid, status
from dba_pdbs;

pause Analizar resultados [enter] para continuar


prompt Consulta 3 en root - v$pdbs 
-----------------------------------------------
connect sys/system3@jpcdip03  as sysdba
select con_id, name , open_mode, open_time 
from v$pdbs;

prompt Consulta 3 en jpcdip03_s1 - v$pdbs
------------------------------------------
connect sys/system3@jpcdip03_s1  as sysdba
select con_id, name , open_mode, open_time 
from v$pdbs;

prompt Consulta 3 en jpcdip03_s2 - v$pdbs
--------------------------------------------
connect sys/system3@jpcdip03_s2  as sysdba
select con_id, name , open_mode, open_time 
from v$pdbs;

pause Analizar resultados [enter] para continuar


prompt pregunta 4 desde root empleando alter session
----------------------------------------------------
alter session set container=cdb$root;
show con_id
show con_name

prompt pregunta 4 desde jpcdip03_s1 empleando alter session
----------------------------------------------------
alter session set container=jpcdip03_s1;
show con_id
show con_name

prompt pregunta 4 desde jpcdip03_s2 empleando alter session
----------------------------------------------------
alter session set container=jpcdip03_s2;
show con_id
show con_name

pause Analizar resultados [enter] para continuar

Prompt pregunta 5, conectando a jpcdip03_s1, creando una tabla
----------------------------------------------------
alter session set container=jpcdip03_s1;
create user jorge07 identified by jorge quota unlimited on users;
grant create session,create table to jorge07;
create table jorge07.test(id number);

Prompt pregunta 5, conectando a jpcdip03_s2, creando una tabla
----------------------------------------------------
alter session set container=jpcdip03_s2;
create user jorge07 identified by jorge quota unlimited on users;
grant create session,create table to jorge07;
create table jorge07.test(id number);

prompt pregunta 5, creando un nuevo registro en  jpcdip03_s1 para  jorge07.test
----------------------------------------------------
alter session set container=jpcdip03_s1;
--aquí se genera una transacción
insert into jorge07.test values(100);
prompt Verificando los datos de la transacción
select xid,con_id, status, start_time
from v$transaction;

Prompt conectando a jpcdip03_s2 sin hacer commit de esta transacción
----------------------------------------------------
pause ¿Se podrá hacer switch? [enter] para contunuar
alter session set container=jpcdip03_s2;
prompt Verificando los datos de la transacción
select xid,con_id, status, start_time
from v$transaction;

pause ¿fue posible ? [enter] para continuar

prompt intentando insertar en la tabla ¿Se genera otra transacción?
-------------------------------------------------------
insert into jorge07.test values(200);
prompt Verificando los datos de la transacción
select xid,con_id, status, start_time
from v$transaction;

pause ¿fue posible ? [enter] para continuar

prompt conectando nuevamente a jpcdip03_s1 ¿qué sucedió con la txn?
-------------------------------------------------------
alter session set container=jpcdip03_s1;
prompt Verificando los datos de la transacción
select xid,con_id, status, start_time
from v$transaction;

pause ¿qué mostrará al intentar consultar los datos de la tabla test? [enter]
select * from jorge07.test;


prompt pregunta 6 consulta del ejercicio 1  MD 02-conceptos-basicos.md
--------------------------------------------------------
prompt Conectando como cdb$root
alter session set container=cdb$root;
select o.oracle_maintained, count(*)
from sys.tab$ t, dba_objects o
where t.obj#= o.object_id
group by o.oracle_maintained;

prompt Conectando como jpcdip03_s1
alter session set container=jpcdip03_s1;
select o.oracle_maintained, count(*)
from sys.tab$ t, dba_objects o
where t.obj#= o.object_id
group by o.oracle_maintained;

pause Analizar resultados [Enter] para continuar


prompt 7 Limpieza
--eliminando en jpcdip03_s1
drop user jorge07 cascade;
--eliminando en jpcdip03_s2
alter session set container=jpcdip03_s2;
drop user jorge07 cascade;

pause [enter] para continuar


prompt Voler a ejecutar pregunta 6 consulta del ejercicio 1  MD 02-conceptos-basicos.md (repetición)
--------------------------------------------------------
prompt Conectando como cdb$root
alter session set container=cdb$root;
select o.oracle_maintained, count(*)
from sys.tab$ t, dba_objects o
where t.obj#= o.object_id
group by o.oracle_maintained;

prompt Conectando como jpcdip03_s1
alter session set container=jpcdip03_s1;
select o.oracle_maintained, count(*)
from sys.tab$ t, dba_objects o
where t.obj#= o.object_id
group by o.oracle_maintained;

pause Analizar resultados [Enter] para continuar
