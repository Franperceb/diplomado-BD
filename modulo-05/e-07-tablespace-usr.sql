--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 12/01/2024
--@Descripción: Ejercicio 07 - Módulo 05. Tablespaces 


Prompt connect sys/system2 as sysdba

connect sys/system2 as sysdba

set linesize window
col property_name format a30
col property_value format a30
col username format a30

Prompt 1 mostrando datos de los tablespaces empleando database_properties
select property_name, property_value
from database_properties
where property_name like '%TABLESPACE%';

Prompt 2 Mostrar los nombres de los tablespaces asignados al usuario
select DEFAULT_TABLESPACE , TEMPORARY_TABLESPACE, LOCAL_TEMP_TABLESPACE
from user_users
where username = 'JORGE05';

Prompt 3 Mostrar el nombre del tablespace undo empleado por todos los usuarios
show parameter undo_tablespace

Prompt 4 Mostrar las cuotas de almacenamiento en MB que tienen los usuarios de la base de datos
select tablespace_name, username, bytes/1024/1024 quota_mb, blocks, max_blocks
from dba_ts_quotas;

Prompt 5 Mostrar en MB los siguientes datos del TS temporal: tamaño, espacio libre, espacio asignado
select tablespace_name, 
  tablespace_size/1024/1024 as ts_size_mb,
  free_space/1024/1024 free_space_mb,
  allocated_space/1024/1024 allocate_space_mb
from dba_temp_free_space;

exit;
