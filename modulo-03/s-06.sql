prompt conectando como sys
connect sys/system2 as sysdba

Prompt instalando Oracle JVM

alter system set "_system_trig_enabled" = false scope=memory;
@?/javavm/install/initjvm.sql
@?/rdbms/admin/catjava.sql

Prompt comprobando la instalaci�n, El status debe ser  VALID

col comp_name format a30
col status format a15
select comp_name, version, status from dba_registry where comp_name like '%JAVA%' ;

Prompt mostrando objetos de la instalaci�n
select count(*), object_type from all_objects
   where object_type like '%JAVA%' group by object_type;

Pause Listo! Reiniciando instancia, [enter] para continuar
shutdown immediate
startup

