--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 27 /11/2023
--@Descripción: Ejercicio 04 -módulo 03 . Componentes de la SGA.



connect sys/system2 as sysdba

set linesize window
Prompt Reporte 1

select q1.pool, q1.num_componentes,trunc(q1.megas_usados,2) megas_usados,
  trunc(q2.megas_libres,2) megas_libres,
  trunc(q1.megas_usados + nvl(q2.megas_libres,0),2) mb_asignados
from (
  select pool, count(*) as num_componentes,
    sum(bytes)/1024/1024 megas_usados
  from v$sgastat  
  where name <>'free memory'
  and pool is not null
  group by pool
) q1 
left outer join (
  select pool, trunc(bytes/1024/1024,2) megas_libres
  from v$sgastat
  where name ='free memory'
  and pool is not  null
) q2
on q1.pool = q2.pool
union all
select name, 0,bytes/1024/1024,-1,bytes/1024/1024
from v$sgastat
where pool is null
order by megas_usados desc;

Prompt Reporte 2

select name, trunc(bytes/1024/1024,2) mb_asignados
from v$sgainfo 
where name not in(
  'Free SGA Memory Available',
  'Maximum SGA Size',
  'Granule Size',
  'Startup overhead in Shared Pool'
)
union all 
select 'Memoria total', trunc(sum(bytes)/1024/1024,2)
from v$sgainfo 
where name not in (
  'Free SGA Memory Available',
  'Maximum SGA Size',
  'Granule Size',
  'Startup overhead in Shared Pool'
)
group by 'Memoria total'
union all
select name, trunc(bytes/1024/1024,2)
from v$sgainfo 
where name ='Free SGA Memory Available'
order by 2 desc;
