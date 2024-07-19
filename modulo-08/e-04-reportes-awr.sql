--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 05/04/2024
--@Descripción: Ejercicio 08 - MD07E02. E01 Snapshots del AWR,

set linesize window
spool /unam-diplomado-bd/diplomado-BD/modulo-08/reporte-awr.txt 

Prompt Conectando como sysdba
connect sys/system1 as sysdba 

Prompt Reiniciando BD
shutdown 
startup 

Prompt Generando primer snapshot
begin
  dbms_workload_repository.create_snapshot();
end;
/

Prompt Conectando como  control_medico
connect control_medico/control_medico

create table merge_r_especialidad as
select m.nombre,m.cedula,e.nombre,e.requisito
from especialidad e, medico m
where e.especialidad_id = m.especialidad_id
and m.nombre like 'A%' ;



Prompt Creando segundo Snapshot
connect sys/system1 as sysdba 
begin
  dbms_workload_repository.create_snapshot();
end;
/

connect control_medico/control_medico
select m.medicamento_id, r.dias
from receta r
join medicamento m
on m.medicamento_id = r.medicamento_id 
where r.cantidad < 3
and m.nombre_generico like '%A';  

select p.nombre,c.fecha_cita
from paciente p
join cita c
on p.paciente_id = c.paciente_id;

Prompt Creando tercer Snapshot
connect sys/system1 as sysdba 
begin
  dbms_workload_repository.create_snapshot();
end;
/

connect control_medico/control_medico
select c.fecha_cita,cita_id,consultorio,p.nombre
from cita c, paciente p
where c.paciente_id = p.paciente_id
and c.medico_id = 2999
union all
select c.fecha_cita,cita_id,consultorio,p.nombre
from cita c, paciente p
where c.paciente_id = p.paciente_id
and p.num_seguro like '33%' ;

select /*+ STAR_TRANSFORMATION */d.clave,m.cedula
from diagnostico d, paciente p, medico m, cita c
where c.diagnostico_id = d.diagnostico_id
and  c.paciente_id = p.paciente_id
and c.medico_id = m.medico_id
and d.clave like 'Z%'
and m.cedula like '9%'
and p.curp like 'Z%';



Prompt Creando cuarto Snapshot
connect sys/system1 as sysdba 
begin
  dbms_workload_repository.create_snapshot();
end;
/

Prompt listo!