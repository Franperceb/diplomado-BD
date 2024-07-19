--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 12/04/2024
--@Descripción: Ejercicio 06 - Módulo 09. Subquery unnesting.

define syslogon='sys/system1 as sysdba'
define t_user='control_medico'
define userlogon='&t_user/&t_user'
define autotrace_opt='trace only'


Prompt conectando como &t_user
connect &userlogon

Prompt Generando índices
create index receta_medicamento_id_ix on receta(medicamento_id);
create index medicamento_subclave_ix on medicamento(subclave);


Prompt conectando como SYS
connect &syslogon

Prompt B. Recolectando estadísticas
begin
  dbms_stats.gather_schema_stats (
      ownname => 'CONTROL_MEDICO',      
      degree  => 2
  );
end;
/

Prompt conectando como &t_user
connect &userlogon

Prompt Configurando autotrace 'set autotrace '
set autotrace &autotrace_opt

set linesize window

Prompt ====  Consulta 1 

select *
from receta
where medicamento_id in (
  select medicamento_id
  from medicamento
  where subclave like '010%'
);

Prompt ====  Consulta 2 Intentando evitar la Transformación 

select /*+ no_query_transformation */ *
from receta
where medicamento_id in (
  select medicamento_id
  from medicamento
  where subclave like '010%'
);


Prompt ====  Consulta 3  aplicando subquery unnesting

select *
from receta r, medicamento m
where r.medicamento_id = m.medicamento_id
and subclave like '010%';


Prompt Eliminando indices 
drop index receta_medicamento_id_ix;
drop index medicamento_subclave_ix;
