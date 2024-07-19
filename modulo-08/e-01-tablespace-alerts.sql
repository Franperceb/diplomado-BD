--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 05/04/2024
--@Descripción: Ejercicio 01 - Módulo 08. Alertas  de tablespaces.


define syslogon='sys/system1 as sysdba'
define t_user='jorge08'
define t_userlogon='&t_user/&t_user'

set linesize window

Prompt conectando como sys

connect &syslogon

Prompt creando usuario  &t_user en caso de no existir

declare
  v_count number;
begin
  select count(*) into v_count 
  from all_users
  where username=upper('&t_user');
  if v_count > 0 then
    execute immediate 'drop user &t_user cascade';
  end if;
end;
/

Prompt creando un nuevo TS
create tablespace m08_alerts_tbs
  datafile '/u01/app/oracle/oradata/JPCDIP01/m08_alerts_tbs01.dbf'
    size 30m
  extent management local autoallocate
  segment space management auto;

Prompt creando usuario &t_user
create  user &t_user identified by &t_user  quota unlimited on users;
alter user &t_user quota unlimited on m08_alerts_tbs;
grant create session, create table to &t_user;

Prompt configurando alertas 
begin
  --configurando con MBs
  dbms_server_alert.set_threshold(
    metrics_id            =>    dbms_server_alert.tablespace_byt_free,
    warning_operator      =>    dbms_server_alert.operator_le,
    warning_value         =>    '10240',
    critical_operator     =>    dbms_server_alert.operator_le,
    critical_value        =>    '5120',
    observation_period    =>    1,
    consecutive_occurrences =>  1,
    instance_name           => null,
    object_type           =>    dbms_server_alert.object_type_tablespace,
    object_name           =>     'M08_ALERTS_TBS'
  );

  --configurando con porcentajes
    dbms_server_alert.set_threshold(
    metrics_id            =>    dbms_server_alert.tablespace_pct_full,
    warning_operator      =>    dbms_server_alert.operator_ge,
    warning_value         =>    '80',
    critical_operator     =>     dbms_server_alert.operator_ge,
    critical_value        =>    '90',
    observation_period    =>    1,
    consecutive_occurrences =>  1,
    instance_name           => null,
    object_type           =>    dbms_server_alert.object_type_tablespace,
    object_name           =>     'M08_ALERTS_TBS'
  );

  dbms_server_alert.set_threshold(
    metrics_id            =>    dbms_server_alert.tablespace_space_usage,
    warning_operator      =>    dbms_server_alert.operator_ge,
    warning_value         =>    '80', -- Porcentaje de uso del tablespace
    critical_operator     =>    dbms_server_alert.operator_ge,
    critical_value        =>    '90', -- Porcentaje de uso crítico del tablespace
    observation_period    =>    60, -- Intervalo de observación en minutos
    consecutive_occurrences =>  1,
    instance_name           => null,
    object_type           =>    dbms_server_alert.object_type_tablespace,
    object_name           =>     'M08_ALERTS_TBS'
  );
end;
/


Pause Poblando tablespace, [Enter] para continuar

create table &t_user..mensaje(str char(1024)) nologging tablespace m08_alerts_tbs;

declare
  v_iter number:= 25*1000;
begin 
  for r in 1..v_iter loop
    insert /*+ append */ into &t_user..mensaje values('A');
  end loop;
end;
/
commit;

-- en algunos casos hay que esperar más tiempo para que aparezcan las métricas
Prompt esperando un minuto 130 seg
exec dbms_session.sleep(130);

col object_name format a20
col object_type format a15
col reason format a30
col suggested_action format a30  
col time_suggested format a25
Prompt mostrando alertas existentes
select object_name,object_type,reason,time_suggested,suggested_action,
  metric_value,message_type
from dba_outstanding_alerts;

Pause [Enter] para realizar limpieza

Prompt restableciendo métricas
begin
 
  dbms_server_alert.set_threshold(
    metrics_id            =>    dbms_server_alert.tablespace_byt_free,
    warning_operator      =>    null,
    warning_value         =>    null,
    critical_operator     =>    null,
    critical_value        =>    null,
    observation_period    =>    1,
    consecutive_occurrences =>  1,
    instance_name           => null,
    object_type           =>    dbms_server_alert.object_type_tablespace,
    object_name           =>     'M08_ALERTS_TBS'
  );
end;
/

Prompt eliminando tablespace
drop tablespace m08_alerts_tbs including contents and datafiles;



