Prompt 0. Conectando como sys 
define syslogon='sys/system2 as sysdba'
define p_user='m05_911_user'
define p_userlogon='&p_user/&p_user'

conn &syslogon

col SEGMENT_NAME format a35
col FILE_NAME format a65

Prompt 1. Mostrar el nombre del segmento, nombre del tablespace, número
Prompt de extensiones y el total de espacio reservado en MB hasta el momento. 
set linesize window 
select segment_name,  tablespace_name, extent_id as num_ext ,  
bytes/1024/1024 extent_size_mb, blocks , file_id, segment_type, block_id
from dba_extents
where segment_name='LLAMADA_911'
and owner = 'M05_911_USER';

Pause dba_extents [ENTER] para continuar

prompt 1 Consultando segmentos
select substr(rowid, 1, 6) segmento,
count(*) as total_reg
from &p_user..llamada_911
group by substr(rowid, 1, 6);

Pause rowid segmentos [ENTER] para continuar

prompt 2. Mostrar el nombre del tablespace, id y nombre(path) del data file, tamaño 
prompt en MB, total de bloques, online_status, bandera que indica crecimiento automático.

select tablespace_name, file_id, file_name, bytes/(1024*1024) bytes_mb, 
blocks, online_status, autoextensible
from dba_data_files
where tablespace_name in ('M05_911_IX_TS','M05_911_TS');

Pause dba_data_files [ENTER] para continuar

prompt 3. Mostrar el nombre del tablespace, nombre del segmento, nombre del data file(path)
prompt y el total de extensiones que se han reservado para cada data file hasta el momento.
select e.tablespace_name, e.segment_name, df.file_name
from dba_extents e
join dba_data_files df 
  on e.tablespace_name = df.tablespace_name and df.tablespace_name in ('M05_911_IX_TS','M05_911_TS');

Pause dba_extents, dba_data_files [ENTER] para continuar

Prompt 3 Total de extensiones reservadas 
select sum(bytes)/1024/1024 , count(*) 
from user_extents
where TABLESPACE_NAME in ('M05_911_IX_TS','M05_911_TS');

Pause extensiones reservadas [ENTER] para continuar



Prompt Validando tabla permanente 
select * from llamada_911 where rownum <=3;


select * from M05_911_USER.LLAMADA_911 where rownum <=3;