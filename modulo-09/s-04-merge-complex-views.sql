--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 12/04/2024
--@Descripción: Ejercicio 04 - Módulo 09. Merge complex views.



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
create index medicamento_subclave on medicamento (subclave);
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

Prompt Configurando autotrace 'set autotrace'
set autotrace &autotrace_opt
set linesize window

Prompt ==== Consulta 1
select m.*, q1.cantidad
from medicamento m, (
select medicamento_id, count(*) cantidad
from receta
group by medicamento_id
) q1
where m.medicamento_id = q1.medicamento_id
and m.subclave like '040%' and q1.cantidad<50;

Prompt === Consulta 2

select m.*, count(*) cantidad
from medicamento m, receta r
where m.subclave like '040%'
group by m.medicamento_id, num_grupo_terapeutico, grupo_terapeutico, clave_cbcm,
subclave, nombre_generico, forma_farmaceutica, concentracion, presentacion,
principal_indicacion, indicacion_secundaria, contraindicaciones, unidades_envase,
dosis_diaria, nombre_general
having count (*) <50;

Prompt === Consulta 3

select /*+ no merge (q1) */ m.*, q1.cantidad
from medicamento m, (
select medicamento_id, count(*) cantidad
from receta
group by medicamento_id
)q1
where m.medicamento_id = q1.medicamento_id
and m.subclave like '040%'
and q1.cantidad <50;

Prompt === Consulta 4
select m.*, count(*) cantidad
from medicamento m, receta r
where m.subclave like '040%'
group by m.medicamento_id, num_grupo_terapeutico, grupo_terapeutico, clave_cbcm,
subclave, nombre_generico, forma_farmaceutica, concentracion, presentacion,
principal_indicacion, indicacion_secundaria, contraindicaciones, unidades_envase,
dosis_diaria, nombre_general
having count(*)<50;

Prompt Eliminando índices
drop index receta_medicamento_id_ix;
drop index receta_cita_id_ix;
drop index medicamento_subclave;
drop index cita_consultorio;    