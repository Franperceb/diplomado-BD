--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 12/04/2024
--@Descripción: Ejercicio 02 - Módulo 09. Transformación OR expansion.

define syslogon='sys/system1 as sysdba'
define t_user='control_medico'
define userlogon='&t_user/&t_user'
define autotrace_opt='trace only'


Prompt conectando como &t_user
connect &userlogon

set linesize window

--consulta 1
create index receta_id_cantidad_idx on receta(cantidad);
create index medicamento_nombre_generico_idx on medicamento(nombre_generico);


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

Prompt ====  Consulta 1  Nested loop
select m.medicamento_id, r.dias
from receta r
join medicamento m
on m.medicamento_id = r.medicamento_id 
where r.cantidad < 3
and m.nombre_generico like '%A';  

Prompt Eliminando índices
drop index receta_id_cantidad_idx;
drop index medicamento_nombre_generico_idx;