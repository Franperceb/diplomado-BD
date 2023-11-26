
--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 24/11/2023
--@Descripción: Ejercicio 01 -módulo 03 . Iniciando una instancia de base de datos.

connect sys/system1 as sysdba

Prompt 1.Deteniendo instancia
shutdown immediate

define backup_dir='/home/oracle/backups/modulo-03'
Prompt 2.Creando directorio de respaldos
!mkdir -p &backup_dir

--verificar nombres de spfile y pfile
Prompt Moviendo spfile y pfile
!mv  $ORACLE_HOME/dbs/spfilejfpcdip02.ora &backup_dir
!mv  $ORACLE_HOME/dbs/initjfpcdip02.ora  &backup_dir

Prompt Moviendo un solo archivo de control
!mv /unam-diplomado-bd/disk-01/app/oracle/oradata/control01.ctl &backup_dir


Prompt Moviendo un archivo redo log de cada grupo
!mv /unam-diplomado-bd/disk-01/app/oracle/oradata/JFPCDIP02/redo01a.log &backup_dir
!mv /unam-diplomado-bd/disk-02/app/oracle/oradata/JFPCDIP02/redo01b.log &backup_dir
!mv /unam-diplomado-bd/disk-03/app/oracle/oradata/JFPCDIP02/redo01c.log &backup_dir

Prompt Moviendo  datafiles
!mv $ORACLE_BASE/oradata/JFPCDIP02/system01.dbf &backup_dir
!mv $ORACLE_BASE/oradata/JFPCDIP02/users01.dbf &backup_dir

Prompt mostrando archivos en el directorio de respaldos ( verificar 8 archivos)
!ls -lh &backup_dir

Pause [Archivos en directorio de respaldos, enter para continuar]

Prompt intentando iniciar instancia modo nomount
startup nomount

Pause [Enter para corregir y reintentar]
Prompt restaurando archivos de parámetros
!mv  &backup_dir/spfilejfpcdip02.ora  $ORACLE_HOME/dbs
!mv  &backup_dir/initjfpcdip02.ora  $ORACLE_HOME/dbs

Prompt iniciando instancia
startup nomount
pause [¿ Se corrigió el error? Enter para continuar]

Prompt Intentando pasar al modo mount
alter database mount;

pause [Enter para corregir y reintentar]
Prompt restaurando el archivo de control
!mv &backup_dir/control01.ctl /unam-diplomado-bd/disk-01/app/oracle/oradata/JFPCDIP02/

Prompt cambiando al modo mount
alter database mount;
Pause [¿ Se corrigió el error? Enter para continuar]

prompt intentar pasar al modo open
alter database open;

pause [Enter para restaurar datafile del tablespace system]
prompt restaurando datafile para el tablespace system 
!mv &backup_dir/system01.dbf  $ORACLE_BASE/oradata/JFPCDIP02/

prompt intentando abrir nuevamente 
alter database open;

pause [¿Se corrigió el error? Enter para restaurar datafile del TS users]
!mv &backup_dir/users01.dbf  $ORACLE_BASE/oradata/JFPCDIP02/

prompt intentando abrir nuevamente 
alter database open;

pause [¿Se corrigió el error?, Revisar alert Log!, Enter - Restaurar Redo Logs]
prompt restaurando redo logs 
!mv &backup_dir/redo01a.log  /unam-diplomado-bd/disk-01/app/oracle/oradata/JFPCDIP02/
!mv &backup_dir/redo01b.log  /unam-diplomado-bd/disk-02/app/oracle/oradata/JFPCDIP02/
!mv &backup_dir/redo01c.log  /unam-diplomado-bd/disk-03/app/oracle/oradata/JFPCDIP02/

prompt intentando iniciar nuevamente en modo OPEN, requiere autenticar y volver a iniciar
connect sys/system2 as sysdba
startup open; 

prompt Mostrando status
select status from v$instance;

Pause [¿La Base ha regresado a la normalidad ? Enter para terminar]

------------
connect sys/system2 as sysdba
Prompt deteniendo instancia
shutdown immediate

define backup_dir='/home/oracle/backups/modulo-03'
Prompt creando directorio de respaldos
!mkdir -p &backup_dir

Prompt Moviendo spfile y pfile
!mv  $ORACLE_HOME/dbs/ &backup_dir
!mv  $ORACLE_HOME/dbs/ &backup_dir

Prompt Moviendo un solo archivo de control
!mv /unam-diplomado-bd/disk-01/app/oracle/oradata/ &backup_dir

Prompt Moviendo un archivo redo log de cada grupo
!mv /unam-diplomado-bd/disk-01/app/oracle/oradata/ &backup_dir
!mv /unam-diplomado-bd/disk-02/app/oracle/oradata/ &backup_dir
!mv /unam-diplomado-bd/disk-03/app/oracle/oradata/ &backup_dir

Prompt Moviendo  datafiles
!mv $ORACLE_BASE/oradata/ &backup_dir
!mv $ORACLE_BASE/oradata/ &backup_dir
Prompt mostrando archivos en el directorio de respaldos ( verificar 8 archivos)
!ls -lh &backup_dir

Pause [Archivos en directorio de respaldos, enter para continuar]

Prompt intentando iniciar instancia modo nomount
startup nomount

Pause [Enter para corregir y reintentar]
Prompt restaurando archivos de parámetros
!mv  &backup_dir/  $ORACLE_HOME/dbs
!mv  &backup_dir/  $ORACLE_HOME/dbs

Prompt iniciando instancia
startup nomount
pause [¿ Se corrigió el error? Enter para continuar]

Prompt Intentando pasar al modo mount
alter database mount;

pause [Enter para corregir y reintentar]
Prompt restaurando el archivo de control
!mv &backup_dir/ /unam-diplomado-bd/disk-01/app/oracle/oradata/

Prompt cambiando al modo mount
alter database mount;
Pause [¿ Se corrigió el error? Enter para continuar]

prompt intentar pasar al modo open
alter database open;

pause [Enter para restaurar datafile del tablespace system]
prompt restaurando datafile para el tablespace system 
!mv &backup_dir/  $ORACLE_BASE/oradata/

prompt intentando abrir nuevamente 
alter database open;

pause [¿Se corrigió el error? Enter para restaurar datafile del TS users]
!mv &backup_dir/  $ORACLE_BASE/oradata/

prompt intentando abrir nuevamente 
alter database open;

pause [¿Se corrigió el error?, Revisar alert Log!, Enter - Restaurar Redo Logs]
prompt restaurando redo logs 
!mv &backup_dir/  /unam-diplomado-bd/disk-01/app/oracle/oradata/
!mv &backup_dir/  /unam-diplomado-bd/disk-02/app/oracle/oradata/
!mv &backup_dir/  /unam-diplomado-bd/disk-03/app/oracle/oradata/

prompt intentando iniciar nuevamente en modo OPEN, requiere autenticar y volver a iniciar
connect sys/system2 as sysdba
startup open; 

prompt Mostrando status
select status from v$instance;

Pause [¿La Base ha regresado a la normalidad ? Enter para terminar]