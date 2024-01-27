--JORGE FRANCISCO PEREDA CEBALLOS
--26-01-2024
--Módulo 05. E-014 Modo Archive. Respaldo de redologs. Datos.
-------------------------------------------


define syslogon='sys/system2 as sysdba'

Prompt Mostrando datos del modo archive 

set linesize window

Prompt 1.  Datos de v$database
select  name, log_mode,archivelog_compression 
from v$database;

Pause [enter] para continuar

Prompt 2. Configuración archive Redo logs.
col destination format a40
col dest_name format a30
select dest_id,dest_name,status,binding,destination
from v$archive_dest
where dest_name in ('LOG_ARCHIVE_DEST_1','LOG_ARCHIVE_DEST_2');

Pause [enter] para continuar

Prompt 3. Datos de los Redo Logs 
select group#,thread#,sequence#,bytes,blocksize,members,archived,status,
 first_change#,to_char(first_time,'dd/mm/yyyy hh24:mi:ss') first_time,
 next_change#,to_char(next_time,'dd/mm/yyyy hh24:mi:ss') next_time
from v$log;

Pause [enter] para continuar

Prompt 4.  Log switches
select recid,stamp,thread#,sequence#,first_change#,
  to_char(first_time,'dd/mm/yyyy hh24:mi:ss') first_time,
  next_change#,resetlogs_change#,
  to_char(resetlogs_time,'dd/mm/yyyy hh24:mi:ss') resetlogs_time
from v$log_history
where sequence#>=(select min(sequence#) from v$log)
order by first_time;

Pause [enter] para continuar

Prompt 5. Registro de Archive Redo logs.
col name format a70
select recid,name,dest_id,sequence#,
  to_char(first_time,'dd/mm/yyyy hh24:mi:ss') first_time,
  status,to_char(completion_time,'dd/mm/yyyy hh24:mi:ss') completion_time
from v$archived_log;

Pause [enter] para continuar

Prompt 6. Archive redo logs nivel S.O.
!ls -l "/unam-diplomado-bd/disk-04*/archivelogs/jpcdip02/disk_*/*.arc"

Prompt Listo
exit 