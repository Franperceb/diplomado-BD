--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 12/01/2024
--@Descripción: Ejercicio 04 - Módulo 05. Row chaining


whenever sqlerror exit rollback

connect sys/system2 as sysdba

Prompt mostrando el contenido del parámetro db_block_size
show parameter db_block_size

Prompt conectando como jorge05 para generar una tabla grande
connect jorge05/jorge05

declare
begin
  execute immediate 'drop table t03_row_chaining';
exception
  when others then
    null;
end;
/

create table t03_row_chaining(
  id number(10,0) constraint t03_row_chaining_pk primary key,
  c1 char(2000) default 'A',
  c2 char(2000) default 'B',
  c3 char(2000) default 'C',
  c4 char(2000) default 'D',
  c5 char(2000) default 'E'
);

Prompt insertando un primer registro
insert into t03_row_chaining(id) values (1);

commit;

Prompt mostrando el tamaño de la columna c1
select length(c1) from t03_row_chaining where id = 1;

Prompt actualizando estadísticas
analyze table t03_row_chaining compute statistics;


Prompt consultando metadatos
set linesize window
select tablespace_name, pct_free,pct_used,num_rows,blocks,empty_blocks,
  avg_space/1024 avg_space_kb, chain_cnt,avg_row_len/1024 avg_row_len_kb
from user_tables
where table_name= 'T03_ROW_CHAINING';

Pause Analizar, presionar [Enter] parar corregir problema

Prompt Creando un nuevo tablespace con bloques de 16K, conectando como SYS
connect sys/system2 as sysdba

--Tamanio de todo el pool
---se debe de cambiar de configuracion para poder alterar el parametro de db size
--alter system set sga_max_size=150m scope=spfile;

--shutdown immediate
--startup

alter system set sga_target = 400M scope = memory;
alter system set db_16k_cache_size = 1M scope = memory;
SELECT name, value FROM v$parameter WHERE name LIKE '%cache_size%'

begin
  execute immediate 'drop tablespace dip_m05_01 including contents and datafiles';
exception
  when others then
    null;
end;
/

create tablespace dip_m05_01
  blocksize 16K
  datafile '/u01/app/oracle/oradata/JPCDIP02/dip_m05_01_01.dbf' size 20m
  extent management local uniform size 1M;

Prompt otorgando quota de almacenamiento al usuario jorge05 en el nuevo TS
alter user jorge05 quota unlimited on dip_m05_01;


Prompt moviendo datos al nuevo TS, conectando como jorge05
connect jorge05/jorge05 
alter table t03_row_chaining move tablespace dip_m05_01;

Prompt reconstruyendo el índice (por efectos del cambio del TS)
alter index t03_row_chaining_pk rebuild;

Prompt  calculando estadísticas nuevamente
analyze table t03_row_chaining compute statistics;

Prompt Mostrando metadatos nuevamente
select tablespace_name, pct_free,pct_used,num_rows,blocks,empty_blocks,
  avg_space/1024 avg_space_kb, chain_cnt,avg_row_len/1024 avg_row_len_kb
from user_tables
where table_name= 'T03_ROW_CHAINING';

Pause Analizar y presionar [Enter] para continuar

Prompt  Mostrando el DDL de la tabla modificada

set heading off
set echo off
set pages 999
set long 90000
select dbms_metadata.get_ddl('TABLE','T03_ROW_CHAINING','JORGE05') from dual;

Pause Prueba terminada, presionar [Enter] para hacer limpieza

Prompt eliminando tabla t03_row_chaining
drop table t03_row_chaining;

Prompt  Eliminando TS 
connect sys/system2 as sysdba

drop tablespace dip_m05_01 including contents and datafiles;

exit
