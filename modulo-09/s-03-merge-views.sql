--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 12/04/2024
--@Descripción: Ejercicio 03 - Módulo 09. Merge views.

define syslogon='sys/system1 as sysdba'
define t_user='control_medico'
define userlogon='&t_user/&t_user'
define autotrace_opt='trace only'


Prompt conectando como &t_user
connect &userlogon

Prompt Ejemplo Transformación OR

Prompt Generando índices

create index receta_medicamento_id_ix on receta(medicamento_id);
create index receta_cita_id_ix on receta(cita_id);
create index medicamento_subclave on medicamento(subclave);
create index cita_consultorio on cita(consultorio);


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

Prompt ====  Consulta 1 Sin subconsulta

select m.nombre_generico,r.receta_id,r.cantidad,c.fecha_cita
from medicamento m
join receta r
  on m.medicamento_id = r.medicamento_id
join  cita c
  on  r.cita_id = c.cita_id
and m.subclave like '010%' 
and  c.consultorio like 'C-6%';

Prompt  Consulta 2 con subconsulta y con hint no_merge

select /*+ no_merge(q1) */ q1.nombre_generico,q1.receta_id,q1.cantidad,c.fecha_cita
from cita c
join (
  select m.nombre_generico, r.medicamento_id, r.receta_id,r.cantidad,r.cita_id
  from receta r
  join medicamento m
    on m.medicamento_id = r.medicamento_id
  where  m.subclave like '01%' 
) q1 
on c.cita_id = q1.cita_id
where c.consultorio like 'C-6%'; 



Prompt  Consulta 3 con subconsulta y sin hint no_merge

select  m.nombre_generico,q1.receta_id,q1.cantidad,q1.fecha_cita
from medicamento m
join (
  select r.medicamento_id, r.receta_id,r.cantidad,c.fecha_cita
  from receta r
  join cita c
    on r.cita_id = c.cita_id
  where  c.consultorio like 'C-6%'
) q1 
on q1.medicamento_id = m.medicamento_id
where m.subclave like '01%'; 



Prompt Eliminando índices
drop index receta_medicamento_id_ix;
drop index receta_cita_id_ix;
drop index medicamento_subclave;
drop index cita_consultorio;

