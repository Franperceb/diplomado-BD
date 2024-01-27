-- Ejercicio 2. Objetos en el IM Column Store

Prompt Autenticando como sys
connect sys/system2 as sysdba

--whenever sqlerror exit rollback

Prompt consulta 01
set pagesize 100
col title format a50

explain plan 
set statement_id ='q1' for
select /*+ gather_plan_statistics */ title, trunc(duration/60,1) duration_hrs
from user03imc.movie where upper(title) like '% WAR %';

Prompt Visualizando el plan de ejecución sin IM Column store.
select * from table(dbms_xplan.display(statement_id => 'q1'));
pause Analizar plan de ejecución [Enter] para continuar.

Prompt habilitando In Memory column store
alter table user03imc.movie inmemory;

col table_name format a20 
Prompt Mostrando configuraciones asociadas con IM column store 
select table_name,inmemory,inmemory_compression, inmemory_priority,
  inmemory_distribute
from dba_tables 
where table_name='MOVIE'
and owner='USER03IMC';
pause Analizar resultados [Enter] para continuar

Prompt Realizando consulta en v$im_segments previa al acceso
col segment_name format a20 
select segment_name, bytes/1024/1024 MBs, inmemory_size/1024/1024 inmemory_size_mb,
  populate_status 
from   v$im_segments 
where  segment_name = 'MOVIE'
and owner='USER03IMC';
pause Analizar resultados [Enter] para continuar

Prompt Realizando una consulta para provocar el poblado de la IM Column store
select title, trunc(duration/60,1) duration_hrs
from user03imc.movie where upper(title) like '% WAR %';
pause ¿Cuántos registros se obtuvieron? [Enter] para continuar

Prompt consultando nuevamente en v$im_segments
select segment_name, bytes/1024/1024 MBs, inmemory_size/1024/1024 inmemory_size_mb,
  populate_status 
from   v$im_segments 
where  segment_name = 'MOVIE';
pause Analizar resultados [Enter] para continuar

Prompt mostrando información de los IMCUs
set pagesize 30
col column_name format a20
col minimum_value format a20
col maximum_value format a50
select column_number,column_name, minimum_value,maximum_value
from v$im_col_cu cu, dba_objects o, dba_tab_cols c
where cu.objd = o.data_object_id
and o.object_name = c.table_name
and cu.column_number = c.column_id 
and o.object_name='MOVIE'
and o.owner='USER03IMC'
order by column_number,minimum_value;
pause Analizar resultados [Enter] para continuar

Prompt deshabilitando el uso de la IM C Store para mostrar estadísticas
alter session  set inmemory_query=disable;
select title, trunc(duration/60,1) duration_hrs
from user03imc.movie where upper(title) like '% WAR %';

Prompt mostrando estadísticas  del uso de la IM C Store  y sus IMCUs. inmemory_query=disable
col display_name format a30
select display_name,value
from v$mystat m, v$statname n
where m.statistic# = n.statistic#
and display_name in (
  'IM scan segments minmax eligible',
  'IM scan CUs delta pruned',
  'IM scan segments disk',
  'IM scan bytes in-memory',
  'IM scan bytes uncompressed',
  'IM scan rows',
  'IM scan blocks cache'
);

pause Analizar resultados [Enter] para continuar

Prompt Habilitar nuevamente el uso de la IM C Store para mostrar estadísticas
alter session  set inmemory_query=enable;

prompt Ejecutando Consulta Nuevamente
select title, trunc(duration/60,1) duration_hrs
from user03imc.movie where upper(title) like '% WAR %';

Prompt mostrando estadísticas  del uso de la IM C Store  y sus IMCUs. inmemory_query = enable
select display_name,value
from v$mystat m, v$statname n
where m.statistic# = n.statistic#
and display_name in (
  'IM scan segments minmax eligible',
  'IM scan CUs delta pruned',
  'IM scan segments disk',
  'IM scan bytes in-memory',
  'IM scan bytes uncompressed',
  'IM scan rows',
  'IM scan blocks cache'
);

Pause analizar resultados, [Enter] para continuar
Prompt Mostrando nuevamente plan de ejecución con IM COlumn habilitada
explain plan
set statement_id ='q2' for
select title, trunc(duration/60,1) duration_hrs
from user03imc.movie where upper(title) like '% WAR %';

select * from table(dbms_xplan.display(statement_id => 'q2'));
pause Analizar resultados [Enter] para continuar


Prompt deshabilitando el uso de la IM column para que este script sea idempotente
alter table user03imc.movie no inmemory;

--la limpieza del usuario se realiza en el script s-10-column-store.sql
prompt listo!, cerrando sesión

disconnect

  