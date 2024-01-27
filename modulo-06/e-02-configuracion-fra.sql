--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 26/01/2024
--@Descripción: Ejercicio 01 -02 Módulo 06. Configuración de FRA.


set linesize window
set verify off

define syslogon='sys/system2 as sysdba'

Prompt Conectado como sys
conn &syslogon 

Prompt 1. Verificando que se cuente con la FRA.
show parameter db_recovery

Prompt 2. Validando que se encuentre habilitado  el modo archivelog
archive log list

Prompt 3. Especificando el tamaño de la FRA y ubicación
alter system set db_recovery_file_dest_size=20G scope=both;
alter system set db_recovery_file_dest='/unam-diplomado-bd/fast-recovery-area' scope=both;

Prompt 4. Moviendo el estado de la instancia a mount 
shutdown 
startup mount


Prompt 5. Configurando periodo de retención con el que la base de datos podrá hacer flashback
alter system set db_flashback_retention_target=1440 scope=both;

Prompt 6. Habilitando el modo flashback
alter database flashback on;

Prompt 7. Abriendo base de datos
alter database open;

Prompt 8. Verificando el modo flashback
show parameter db_recovery
select flashback_on from v$database;

Prompt 9. Mostrando el tiempo de retención de datos undo 
show parameter undo_retention

Prompt 9.1. Modificando parámetro undo_retention a 30 minutos
alter system set undo_retention=1800 scope=both;

Prompt Mostrando modificacion de undo_retencion
show parameter undo_retention;