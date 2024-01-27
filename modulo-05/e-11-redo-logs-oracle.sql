
--JORGE FRANCISCO PEREDA CEBALLOS
--26-01-2024
--Módulo 05. E-012 RedoLogs Consultas , manejo y creación de grupos redo
-------------------------------------------


define syslogon='sys/system2 as sysdba'
define userlogon='jorge05/jorge05'

Prompt  1. mostrando Redo logs en S.O
--su -l oracle
--!find /unam-diplomado-bd/disk-*/app/oracle/oradata/JPCDIP02/redo*.log -name "*redo*.log" -type f -exec ls -l {} \;

connect &syslogon
prompt 2. Mostrando datos de los grupos de Redo Logs
select group#, sequence#, bytes/1024/1024 as tam_mb, blocksize, members, status,
  first_change#, to_char(first_time,'DD-MON-YYYY HH:MI:SS') as first_time, next_change# 
from v$log;

Prompt 3. Que grupo de Redo Log es el que se esta empleando
-- current   el 2

prompt 4. Mostrando datos de los miembros de cada grupo de Redo Logs
col member format a67
select group#, status, type, member
from v$logfile;

Prompt 5 . Agregar grupos nuevos.

connect &syslogon

Prompt creando grupo 4
alter database add logfile group 4 (
  '/unam-diplomado-bd/disk-01/app/oracle/oradata/JPCDIP02/redo04a_60.log',
  '/unam-diplomado-bd/disk-02/app/oracle/oradata/JPCDIP02/redo04b_60.log'
) size 60m blocksize 512;

Prompt creando grupo 5
alter database add logfile group 5 (
  '/unam-diplomado-bd/disk-01/app/oracle/oradata/JPCDIP02/redo05a_60.log',
  '/unam-diplomado-bd/disk-02/app/oracle/oradata/JPCDIP02/redo05b_60.log'
) size 60m blocksize 512;

Prompt creando grupo 6
alter database add logfile group 6 (
  '/unam-diplomado-bd/disk-01/app/oracle/oradata/JPCDIP02/redo06a_60.log',
  '/unam-diplomado-bd/disk-02/app/oracle/oradata/JPCDIP02/redo06b_60.log'
) size 60m blocksize 512;

Prompt 6. Agregar miembros

alter database add logfile member 
  '/unam-diplomado-bd/disk-03/app/oracle/oradata/JPCDIP02/redo04c_60.log' to group 4;

alter database add logfile member 
  '/unam-diplomado-bd/disk-03/app/oracle/oradata/JPCDIP02/redo05c_60.log' to group 5;

alter database add logfile member 
  '/unam-diplomado-bd/disk-03/app/oracle/oradata/JPCDIP02/redo06c_60.log' to group 6;


Prompt 7. consultar nuevamente  grupos.
set linesize window 

select * from v$log;
Pause  Analizar y [enter] para continuar

Prompt 8. consultar nuevamente  miembros
col member format  a50 
select * from v$logfile;

Prompt 9 Forzar log switch para liberar grupos 1,2 y 3

set serveroutput on 
declare
  v_group number;
begin
  loop
    select group# into v_group from v$log where status ='CURRENT';
    dbms_output.put_line('Grupo en uso: '||v_group);
    if v_group in (1,2,3) then
      execute immediate 'alter system switch logfile';
    else 
      exit;
    end if;
  end loop;
end;
/

Prompt 10. Confirmando grupo actual.
select * from v$log;
Pause Analizar y [enter] para continuar

Prompt 11.  Validando que los grupo 1 a 3 no tengan status active

declare
  v_count number;
begin
  select count(*) into v_count from v$log where status = 'ACTIVE';
  if v_count > 0 then
    dbms_output.put_line('Forzando checkpoint para sicronizar data files con db buffer');
    execute immediate 'alter system checkpoint';
  end if;
end;
/

Prompt 12. Confirmando que no existen grupos con status ACTIVE.
select * from v$log;
Pause Analizar y [enter] para continuar

Prompt 13. Eliminar grupos 1, 2, y 3

alter database drop logfile  group  1;
alter database drop logfile  group  2;
alter database drop logfile  group  3;

Prompt 14. Confirmando que se han eliminado grupos 1, 2 y 3.
select * from v$log;
Pause Analizar y [enter] para continuar OJO! validar que todo esta OK.

Prompt 15 y 16 Eliminar archivos via S.O.
--su -l oracle
Prompt eliminando redo logs grupo 1
!rm /unam-diplomado-bd/disk-01/app/oracle/oradata/JPCDIP02/redo01a.log
!rm /unam-diplomado-bd/disk-02/app/oracle/oradata/JPCDIP02/redo01b.log
!rm /unam-diplomado-bd/disk-03/app/oracle/oradata/JPCDIP02/redo01c.log

Prompt eliminando redo logs grupo 2
!rm /unam-diplomado-bd/disk-01/app/oracle/oradata/JPCDIP02/redo02a.log
!rm /unam-diplomado-bd/disk-02/app/oracle/oradata/JPCDIP02/redo02b.log
!rm /unam-diplomado-bd/disk-03/app/oracle/oradata/JPCDIP02/redo02c.log

Prompt eliminando redo logs grupo 3
!rm /unam-diplomado-bd/disk-01/app/oracle/oradata/JPCDIP02/redo03a.log
!rm /unam-diplomado-bd/disk-02/app/oracle/oradata/JPCDIP02/redo03b.log
!rm /unam-diplomado-bd/disk-03/app/oracle/oradata/JPCDIP02/redo03c.log

Prompt 17. revisar archivos esperados a nivel s.o.
!find /unam-diplomado-bd/disk-*/app/oracle/oradata/JPCDIP02/redo* -name "*redo*.log" -type f -exec ls -l {} \;

exit
