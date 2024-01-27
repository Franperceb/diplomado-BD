--JORGE FRANCISCO PEREDA CEBALLOS
--26-01-2024
--Módulo 05. E-013 Modo Archive. Respaldo de redologs
-------------------------------------------

set linesize window
define syslogon='sys/system2 as sysdba'

Prompt Habilitar archive mode 

Prompt 1 respaldando spfile  a través del pfile.
connect &syslogon
create pfile from spfile;

Prompt 2 configurando parámetros
--procesos ARC
alter system set log_archive_max_processes=5 scope=spfile;

--configuración de directorios
alter system set log_archive_dest_1='LOCATION=/unam-diplomado-bd/disk-041/archivelogs/jpcdip02/disk_a MANDATORY' scope=spfile;
alter system set log_archive_dest_2='LOCATION=/unam-diplomado-bd/disk-042/archivelogs/jpcdip02/disk_b' scope=spfile;

--formato del archivo
alter system set log_archive_format='arch_jpcdip02_%t_%s_%r.arc' scope=spfile;

--copias mínimas  para considerar el proceso como exitoso.
alter system set log_archive_min_succeed_dest=1 scope=spfile;

Prompt Mostrando parámetros antes de continuar.

show spparameter log_archive_max_processes
show spparameter log_archive_dest_1
show spparameter log_archive_dest_2
show spparameter log_archive_format
show spparameter log_archive_min_succeed_dest

Pause Revisar configuracion, [enter] para reiniciar instancia en modo mount

shutdown immediate

Prompt 3 iniciando en modo mount
startup mount

Prompt habilitar el modo archive
alter database archivelog;

Prompt 4 abrir la BD  para comprobar configuración
alter database open;

Prompt comprobando resultados
archive log list

Pause Revisar, [enter] para continuar

Prompt 5 respaldando nuevamente el spfile 
create pfile from spfile;

Prompt mostrando procesos ARCn
!ps -ef | grep ora_arc

Prompt Listo.
exit