--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 19/01/2024
--@Descripción: Ejercicio 09 - Módulo 05.  data files. 



define syslogon='sys/system2 as sysdba'

set pagesize 100
set linesize window

Prompt 2 Consultando data files empleando dba_data_files

connect &syslogon

select file_name, file_id, relative_fno, tablespace_name,
  bytes/(1024*1024) bytes_mb,
  status, autoextensible, increment_by, 
  user_bytes/(1024*1024) user_bytes_mb,
  (bytes-user_bytes)/1024 header_kb,
  online_status
from dba_data_files;

  -- status del data_file : online available, invalid
  -- status online : sysoff, system, offline, online, recover

Prompt 3 Consultando data_files de v$datafile
select name, file#, creation_change#,
  to_char(creation_time,'dd/mm/yyyy hh24:mi:ss') creation_time,
  checkpoint_change#, to_char(checkpoint_time,'dd/mm/yyyy hh24:mi:ss') checkpoint_time,
  last_change#, to_char(last_time, 'dd/mm/yyyy hh24:mi:ss') last_time
from v$datafile;

Pause 4 Analizar salida, [Enter] para continuar 

Prompt 5 Mostrando datos del header del data_file
select file#, name, error, recover, checkpoint_change#,
  to_char(checkpoint_time,'dd/mm/yyyy hh24:mi:ss') checkpoint_time
from v$datafile_header;

Pause Analizar salida, [Enter] para continuar 

Prompt Mostrando datos de archivos temporales

select file_id, file_name, tablespace_name, status,
  autoextensible, bytes/(1024*1024) bytes_mb
from dba_temp_files;

Pause Analizar salida, [Enter] para continuar 
