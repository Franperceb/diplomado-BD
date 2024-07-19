--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 12/04/2024
--@Descripción: Ejercicio 07 - Módulo 09. Ejemplo de vista materializada.

define syslogon='sys/system1 as sysdba'
define t_user='control_medico'
define userlogon='&t_user/&t_user'
define autotrace_opt='trace only'

Prompt conectando como SYS
connect &syslogon
grant create materialized view to &t_user;

Prompt conectando como &t_user
connect &userlogon


create index cita_paciente_id on cita(paciente_id);
create index cita_diagnostico_id on cita(diagnostico_id);
create index cita_medico_id on cita(medico_id);
create index receta_cita_id on receta(cita_id);
create index receta_medicamento_id on receta(medicamento_id);
create unique index paciente_curp on paciente(curp);
create index cita_fecha_cita_fx_1 on cita(to_number(to_char(fecha_cita,'yyyy')));

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

Prompt creando consulta

select p.curp,c.fecha_cita,d.clave,m.cedula,me.nombre_generico,
  q1.num_citas, q2.num_medicamentos
from paciente p, cita c, diagnostico d, medico m , receta r,
  medicamento me,  (
    select paciente_id, count(*) num_citas
    from cita c
    group by paciente_id
    having count(*) <= 3
  ) q1,
  (
    select r.cita_id,count(*) num_medicamentos
    from receta r
    group by cita_id 
    having count(*) <= 2
  ) q2
where p.paciente_id = c.paciente_id
and c.diagnostico_id = d.diagnostico_id
and c.medico_id = m.medico_id
and c.cita_id = r.cita_id
and r.medicamento_id = me.medicamento_id
and q1.paciente_id = p.paciente_id
and q2.cita_id = c.cita_id
and (p.curp like 'C%')
and to_number(to_char(c.fecha_cita,'yyyy'))  between 2005 and 2015;


Prompt creando vista materializada

create materialized view mv_reporte_citas enable query rewrite as
  select p.curp,c.fecha_cita,d.clave,m.cedula,me.nombre_generico,
    q1.num_citas, q2.num_medicamentos
  from paciente p, cita c, diagnostico d, medico m , receta r,
    medicamento me,  (
      select paciente_id, count(*) num_citas
      from cita c
      group by paciente_id
      having count(*) <= 3
    ) q1,
    (
      select r.cita_id,count(*) num_medicamentos
      from receta r
      group by cita_id 
      having count(*) <= 2
    ) q2
  where p.paciente_id = c.paciente_id
  and c.diagnostico_id = d.diagnostico_id
  and c.medico_id = m.medico_id
  and c.cita_id = r.cita_id
  and r.medicamento_id = me.medicamento_id
  and q1.paciente_id = p.paciente_id
  and q2.cita_id = c.cita_id
  and (p.curp like 'C%')
  and to_number(to_char(c.fecha_cita,'yyyy'))  between 2005 and 2015;


prompt Ejecutando nuevamente la consulta con vista materializada

select p.curp,c.fecha_cita,d.clave,m.cedula,me.nombre_generico,
  q1.num_citas, q2.num_medicamentos
from paciente p, cita c, diagnostico d, medico m , receta r,
  medicamento me,  (
    select paciente_id, count(*) num_citas
    from cita c
    group by paciente_id
    having count(*) <= 3
  ) q1,
  (
    select r.cita_id,count(*) num_medicamentos
    from receta r
    group by cita_id 
    having count(*) <= 2
  ) q2
where p.paciente_id = c.paciente_id
and c.diagnostico_id = d.diagnostico_id
and c.medico_id = m.medico_id
and c.cita_id = r.cita_id
and r.medicamento_id = me.medicamento_id
and q1.paciente_id = p.paciente_id
and q2.cita_id = c.cita_id
and (p.curp like 'C%')
and to_number(to_char(c.fecha_cita,'yyyy'))  between 2005 and 2015;

prompt ELiminando índices

drop index cita_paciente_id;
drop index cita_diagnostico_id;
drop index cita_medico_id;
drop index receta_cita_id;
drop index receta_medicamento_id;
drop index paciente_curp;
drop index cita_fecha_cita_fx_1;