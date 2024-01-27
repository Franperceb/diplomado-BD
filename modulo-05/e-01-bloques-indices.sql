--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 12/01/2024
--@Descripción: Ejercicio 01 - Módulo 05. Bloques en indices

whenever sqlerror exit rollback;

connect sys/system2 as sysdba

declare
  v_count number;
begin
  select count(*) into v_count
  from all_users
  where username = 'JORGE05';

-- ddl es con sql dinamico
  if v_count > 0 then
    execute immediate 'drop user JORGE05 cascade';
  end if;
end;
/

Prompt creando usuario
create user jorge05 identified by jorge05 quota unlimited on users;
grant create table, create session  to jorge05;

Prompt conectando como JORGE05
connect jorge05/jorge05

create table t01_id(
  id number(10,0) constraint t01_id_pk primary key
);

Prompt insertando registro 1
insert into t01_id(id) values(1);

Prompt mostrando datos del índice.
set linesize window
col table_name format a20
select  index_type,table_name,uniqueness,tablespace_name,status,
  blevel, distinct_keys
from user_indexes
where  index_name='T01_ID_PK';

Pause Analizar resultados, presionar [Enter] para continuar

Prompt Recolectando estadísticas
begin
  dbms_stats.gather_index_stats(
    ownname => 'JORGE05',
    indname => 'T01_ID_PK'
  );
end;
/

Prompt mostrando datos del índice despues de la recolección
set linesize window
col table_name format a20
select  index_type,table_name,uniqueness,tablespace_name,status,
  blevel, distinct_keys
from user_indexes
where  index_name='T01_ID_PK';

Pause Analizar resultados, presionar [Enter] para realizar la carga

begin
  for v_index in 2..1000000 loop
    --insert into t01_id values(v_index);
    execute immediate 'insert into t01_id(id) values (:ph1)' using v_index;
  end loop;
end;
/

Prompt recolectando estadisticas despues de la carga
begin
  dbms_stats.gather_index_stats(
    ownname => 'JORGE05',
    indname => 'T01_ID_PK'
  );
end;
/

Prompt mostrar los datos del índice despues de la carga
select  index_type,table_name,uniqueness,tablespace_name,status,
  blevel, distinct_keys, leaf_blocks
from user_indexes
where  index_name='T01_ID_PK';

exit
