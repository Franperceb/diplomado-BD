--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 12/04/2024
--@Descripción: Ejercicio 05 - Módulo 09. Predicate pushing.


define syslogon='sys/system1 as sysdba'
define t_user='control_medico'
define userlogon='&t_user/&t_user'
define autotrace_opt='trace only'


Prompt conectando como &t_user
connect &userlogon



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

Prompt Configurando autotrace 'set autotrace'
set autotrace &autotrace_opt

set linesize window     

Prompt ====  Consulta 1 
create table medico_suplente as
select * from medico
where cedula like'1%';


Prompt Consulta 2 ===> Sin predicate pushing (manual)

select medico_id, nombre
from (
select medico_id, nombre, ap_paterno, ap_materno, cedula, especialidad_id
from medico
union all
select medico_id, nombre, ap_paterno, ap_materno, cedula, especialidad_id
from medico_suplente
)
where nombre like 'A%' or cedula like '15%';

Prompt consulta 3 ===> Con predicate pushing
select medico_id, nombre
from (
select medico_id, nombre, ap_paterno, ap_materno, cedula, especialidad_id
from medico
where nombre like 'A%' or cedula like '15%'
union all
select medico_id, nombre, ap_paterno, ap_materno, cedula, especialidad_id
from medico_suplente
where nombre like 'A%' or cedula like '15%'
);


Prompt Eliminando índices
drop index receta_medicamento_id_ix;
drop index receta_cita_id_ix;
drop index medicamento_subclave;
drop index cita_consultorio;