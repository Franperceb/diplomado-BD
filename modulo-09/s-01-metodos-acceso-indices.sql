--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 12/04/2024
--@Descripción: Ejercicio 09 - Módulo 09. Métodos de acceso indices.

define syslogon='sys/system1 as sysdba'
define t_user='control_medico'
define userlogon='&t_user/&t_user'
define autotrace_opt='trace only'


Prompt conectando como &t_user
connect &userlogon

set linesize window

--consulta 2
create index receta_cita_id_ix on receta(cita_id);
--consulta 3
create index medico_nombre_ix on medico(nombre);
--consulta 4
create index especialidad_nombre_ix on especialidad(nombre);
--consulta 5
create index medicamento_clabe_cbm_indicacion_secundaria_idx on medicamento(clave_cbcm,indicacion_secundaria);
--consulta 6
create index receta_id_dias_idx on receta(dias);

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


Prompt ====  Consulta 1  Index Unique Scan
select clave, nombre 
from diagnostico 
where diagnostico_id = 10;

Prompt ====  Consulta 2  Index Range Scan
select receta_id 
from receta
where cita_id in (1,5000);

Prompt ====  Consulta 3  Fast Full Index Scan
select nombre
from medico  
order by nombre;

Prompt ====  Consulta 4   full index Scan
select nombre
from especialidad;

Prompt ====  Consulta 5  Skip  index Scan
select * 
from medicamento 
where indicacion_secundaria = '%s';

Prompt ====  Consulta 6  Join  index Scan
create index paciente_ap_materno_idx on paciente(ap_materno);
create index paciente_ap_paterno_idx on paciente(ap_paterno);

select ap_materno,ap_paterno from paciente where ap_materno like 'B%';

prompt ELiminando índices

drop index receta_cita_id_ix;
drop index receta_id_cantidad_idx;
drop index medico_nombre_ix;
drop index especialidad_nombre_ix;
drop index medicamento_clabe_cbm_indicacion_secundaria_idx;
drop index receta_id_dias_idx;
drop index medicamento_nombre_generico_idx;
drop index paciente_ap_paterno_idx;
drop index paciente_ap_materno_idx;
