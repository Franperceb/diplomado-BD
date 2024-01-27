--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 12/01/2024
--@Descripción: Ejercicio 06 - Módulo 05. Segmentos.

Prompt Explorando segmentos
connect jorge05/jorge05

begin
  execute immediate 'drop table jorge05.empleado';
exception
  when others then
    null;
end;
/

create table empleado(
  empleado_id number(10,0) constraint empleado_pk primary key,
    curp  varchar2(18) constraint empleado_curp_uk unique,
    email varchar2(100),
    foto  blob,
    cv    clob,
    perfil  varchar2(4000)
) segment creation immediate;

Prompt creando un índice explícito
create index empleado_email_ix on empleado(email);

Prompt mostrando los segmentos asociados con esta tabla.
set linesize window
col segment_name format a30
select tablespace_name,segment_name, segment_type, blocks,extents
from user_segments
where segment_name like'%EMPLEADO%';

Prompt mostrando datos de user_lobs
col index_name format a30
col column_name format a30
select tablespace_name,segment_name,index_name,column_name
from user_lobs 
where table_name='EMPLEADO';