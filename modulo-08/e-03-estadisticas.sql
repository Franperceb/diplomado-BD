--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 05/04/2024
--@Descripción: Ejercicio 08 - MD06E02. Estadisticas de las columnas de una tabla.
Prompt Conectando como jorge
conn jorge/jorge

set linesize window

Prompt Creando tabla prueba
create table prueba(id number);

Prompt Total de registros en tabla creada
select count(*) from prueba;

declare
  num pls_integer;
begin 
  for i in 1..50000 loop 
    num := dbms_random.value(1,20);
    execute immediate 'insert into prueba values (:1)' using num;
  end loop;
end;
/

Prompt Mostrando los registros INSERTADOS 
 select count(*) from prueba;

Prompt Conectando como sysdba
connect sys/system1 as sysdba

Prompt Recolectando Estadisticas 
begin
  dbms_stats.gather_table_stats (
      ownname => 'JORGE',
      tabname => 'PRUEBA',
      degree  => 2,
      method_opt => 'for columns id size AUTO'
  );
end;
/

select count(*) 
from jorge.prueba 
where id = 15;


begin
  dbms_stats.gather_table_stats (
      ownname => 'JORGE',
      tabname => 'PRUEBA',
      degree  => 2,
      method_opt => 'for columns id size AUTO'
  );
end;
/


Prompt Obteniendo datos de estadistica

col  table_name format a20
col  column_name format a25
col  low_value format a20
col  high_value format a20

select c.table_name,c.column_name,c.histogram
from dba_tab_statistics t, dba_tab_col_statistics c
where c.table_name=t.table_name
and t.owner='JORGE' and c.table_name='PRUEBA'
and c.column_name in('ID');


Prompt Conectando como Jorge 
conn jorge/jorge


Prompt Mostrando datos de estadistica
col  table_name format a20
col  column_name format a25
col  endpoint_actual_value format a25

select table_name,column_name,endpoint_number,endpoint_actual_value
from user_histograms where table_name='PRUEBA'
and column_name='ID';



Prompt Realizando limpieza
drop table jorge.prueba;

