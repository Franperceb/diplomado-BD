--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 12/04/2024
--@Descripción: Ejercicio 08 - Módulo 09. Star Transformation.


define syslogon='sys/system1 as sysdba'
define t_user='control_medico'
define userlogon='&t_user/&t_user'
define autotrace_opt='trace only'


Prompt conectando como &t_user
connect &userlogon

create bitmap index cita_paciente_id_bix on cita(paciente_id);
create bitmap index cita_diagnostico_id_bix on cita(diagnostico_id);
create bitmap index cita_medico_id_bix on cita(medico_id);
create index diagnostico_clave_ix on diagnostico(clave);
create index medico_cedula_ix on medico(cedula);
create index paciente_curp_ix on paciente(curp);


Prompt Configurando autotrace 'set autotrace '
set autotrace &autotrace_opt

set linesize window

select /*+ STAR_TRANSFORMATION */d.clave,m.cedula
from diagnostico d, paciente p, medico m, cita c
where c.diagnostico_id = d.diagnostico_id
and  c.paciente_id = p.paciente_id
and c.medico_id = m.medico_id
and d.clave like 'Z%'
and m.cedula like '9%'
and p.curp like 'Z%';

--- EL uso de star transformation también se controla con el parámetro
--  parametro star_transformation_enabled

Prompt haciendo limpieza

drop index cita_paciente_id_bix;
drop index cita_diagnostico_id_bix;
drop index cita_medico_id_bix;
drop index diagnostico_clave_ix;
drop index medico_cedula_ix;
drop index paciente_curp_ix;
