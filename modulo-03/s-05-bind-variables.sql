--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 27 /11/2023
--@Descripción: Ejercicio 05 -módulo 03 . Bind Variables.

connect sys/system2 as sysdba

prompt creando usuario user01
create user user01 identified by user01 quota unlimited on users;
grant create session, create table to user01;

Prompt creando tabla de prueba
create table user01.test(id number) segment creation immediate;

Prompt removiendo información del shared pool
alter system flush shared_pool;


prompt 2. Sentencias SQL sin bind variables

begin
  for i in 1..100000 loop
    execute immediate 'insert into user01.test (id) values ('||i||')';
  end loop;
end;
/

prompt 1. Sentencias SQL con bind variables
set timing on 

begin
  for i in 1..100000 loop
    execute immediate 'insert into user01.test (id) values (:ph1)' using i;
  end loop;
end;
/


Prompt mostrando datos de la sentencia SQL sin bind variables
select  count(*) t_rows, sum(executions) executions,sum(loads) loads,
  sum(parse_calls) parse_calls, sum(disk_reads) disk_reads,
  sum(buffer_gets) buffer_gets, sum(cpu_time)/1000 cpu_time_ms ,
  sum(elapsed_time)/1000 elapsed_time_ms
from v$sqlstats
where sql_text  like 'insert into user01.test (id) values (%)'
and sql_text  <> 'insert into user01.test (id) values (:ph1)';

Prompt mostrando datos de la sentencia SQL con bind variables
select  executions,loads,parse_calls,disk_reads,buffer_gets,
  cpu_time/1000 cpu_time_ms,elapsed_time/1000 elapsed_time_ms
from v$sqlstats
where sql_text  = 'insert into user01.test (id) values (:ph1)';

set timing off

Prompt limpieza
connect sys/system2 as sysdba
drop user user01 cascade;
