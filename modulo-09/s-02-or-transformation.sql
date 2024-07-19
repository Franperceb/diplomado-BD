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
Prompt Ejemplo Transformación OR

--consulta 1
create index paciente_num_seguro_ix on paciente(num_seguro);
create index cita_paciente_id_ix on cita(paciente_id);
create index cita_medico_id_ix on cita(medico_id);

--consulta 2
create index diagnostico_nombre_ix on diagnostico(nombre);
create index cita_diagnostico_id_ix on cita(diagnostico_id);



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

Prompt ====  Consulta 1 

--El optimizador genera automáticamente una transformación or -> costo menor
Prompt => Sin transformación or
select c.fecha_cita,cita_id,c.consultorio,p.nombre
from cita c, paciente p
where c.paciente_id = p.paciente_id
and (c.medico_id = 2999 or p.num_seguro like '33%');


--Obligando al optimizador a no realizar la transformación -> costo mayor
-- se puede emplear también el hint no_expand
Prompt => Evita transformación or 
select /*+ no_query_transformation */ c.fecha_cita,cita_id,consultorio,p.nombre
from cita c, paciente p
where c.paciente_id = p.paciente_id
and (c.medico_id = 2999 or p.num_seguro like '33%');


-- Sentencia con transformación or -> mismo plan que la primera sentencia.
select c.fecha_cita,cita_id,consultorio,p.nombre
from cita c, paciente p
where c.paciente_id = p.paciente_id
and c.medico_id = 2999
union all
select c.fecha_cita,cita_id,consultorio,p.nombre
from cita c, paciente p
where c.paciente_id = p.paciente_id
and p.num_seguro like '33%' ;

Pause  [Enter] para continuar con la sentencia 2

col nombre format a30

Prompt ====  Consulta 2 
Prompt =>Sentencia sin transformación 
-- El optimizador no realiza transformación or -> mayor costo
select p.paciente_id,p.nombre,d.nombre 
from paciente p, diagnostico d, cita c
where p.paciente_id = c.paciente_id
and c.diagnostico_id = d.diagnostico_id
and (p.num_seguro like '3%' or d.nombre like 'HIPER%' );


Prompt =>Sentencia con transformación  manual
-- El optimizador no realiza transformación or -> mayor costo
select p.paciente_id,p.nombre,d.nombre 
from paciente p, diagnostico d, cita c
where p.paciente_id = c.paciente_id
and c.diagnostico_id = d.diagnostico_id
and p.num_seguro like '3%'
union all
select p.paciente_id,p.nombre,d.nombre 
from paciente p, diagnostico d, cita c
where p.paciente_id = c.paciente_id
and c.diagnostico_id = d.diagnostico_id
and d.nombre like 'HIPER%';



Prompt === Consulta 3
--- El optimizador realizó una transformación -> costo menor
Prompt => Sentencia sin transformación
select p.paciente_id,p.nombre,d.nombre 
from paciente p, diagnostico d, cita c
where p.paciente_id = c.paciente_id
and c.diagnostico_id = d.diagnostico_id
and (p.num_seguro like '33%' or d.nombre like 'HIPER%' );


Prompt Eliminando índices
drop index paciente_num_seguro_ix;
drop index diagnostico_nombre_ix;
drop index cita_diagnostico_id_ix;
drop index cita_paciente_id_ix;
drop index cita_medico_id_ix;
