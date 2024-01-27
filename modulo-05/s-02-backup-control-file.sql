--JORGE FRANCISCO PEREDA CEBALLOS
--26-01-2024
--Módulo 05. Backup de un control file. Comandos a utilizar
-------------------------------------------



-- T1
define syslogon='sys/system2 as sysdba'

Prompt 0. Conectar como sys
conn &syslogon
conn sys/system2 as sysdba

Prompt 1. Realizar un backup 
alter database backup controlfile to trace 
  as '/home/oracle/backups/controlfile-ej11.bkp.sql';

-- T2 (se puede en 1) 
Prompt 2. Abrir y Analizar el archivo generado
! cat /home/oracle/backups/controlfile-ej11.bkp.sql ;
Pause Analizar el archivo [ENTER] para continuar

-- T1
prompt Validando status de la instancia
col name format a80
select status from v$instance;

set linesize window;
SELECT * FROM v$controlfile;
SELECT * FROM v$controlfile_record_section;

-- T2 
Prompt 1. Mover una de las 3 copias 
! mv /unam-diplomado-bd/disk-01/app/oracle/oradata/JPCDIP02/control01.ctl /home/oracle/backups/ ;
pause [ENTER] para continuar

-- T1
connect jorge05/jorge05
select table_name
from user_tables;

desc numeros
insert into numeros (id) values (10001);
commit;
select *
from numeros;
conn sys/system2 as sysdba

prompt creamos un checkpoint
alter system checkpoint;

prompt bajando la instancia , 
prompt se espera un error de no detectar 
prompt el control01.ctl y no da shutdown
shutdown immediate

-- T2 
cd /unam-diplomado-bd/disk-02/app/oracle/oradata/JPCDIP02
--aqui esta control02.ctl, checar la hora y ver 
--que estan desincronizados. Ya no sirve
ls -lt 
cd /home/oracle/backups/
ls -lt
cd /unam-diplomado-bd/disk-03/app/oracle/oradata/JPCDIP02/
ls -lt

-- T1
--SOLUCIÓN que el spfile no apunte a la 3er copia

!echo $ORACLE_SID
conn jorge05/jorge05
desc numeros
insert into numeros (id) values (10002);
commit;
--la instancia sigue arriba

prompt 3 Generamos un pfile
conn sys/system2 as sysdba

create pfile from spfile;
exit

prompt Con usuario oracle
su -l oracle  o whoami
-- T2
prompt Modificar el pfile "$ORACLE_HOME/dbs/initjpcdip02.ora"
-- con cd $ORACLE_HOME/dbs
prompt se modifica el parametro con 
prompt vi "*.control_files=" eliminando el controlfile que se movio
prompt el control01.ctl
pause [ENTER] para continuar

cd $ORACLE_HOME/dbs
export ORACLE_SID=jpcdip02
sqlplus sys/system2 as sysdba
prompt bajamos la instancia
shutdown abort

-- ora-00205 error en identifying control file
startup

-- aun mostrara el control01.ctl
show parameter control_files

-- No permite por ora-01033 oracle initialization or shutdown in progress
connect jorge05/jorge05
select *
from numeros;

insert into numeros (id) values (10003);
commit;


--Volver a los 3
conn sys/system2 as sysdba
shutdown immediate
-- msg ora-01507 db not mounted, pero si da shutdown a instancia
exit

su -l oracle
oracle
cd /unam-diplomado-bd/disk-02/app/oracle/oradata/JPCDIP02/
ls
cp control02.ctl /unam-diplomado-bd/disk-01/app/oracle/oradata/JPCDIP02/control01.ctl

cd $ORACLE_HOME/dbs

vi initjpcdip02.ora
--aumentamos archivo control01.dbf

--T1
echo $ORACLE_SID
prompt iniciamos la instancia con el pfile
sqlplus sys/system2 as sysdba
  startup pfile=/u01/app/oracle/product/19.3.0/dbhome_1/dbs/initjpcdip02.ora;

--Ya levanto y abrio

prompt creamos un spfile
create spfile from pfile;

prompt bajamos la instancia 
shutdown abort

prompt iniciamos sin pfile 
startup

SELECT * FROM v$controlfile;
show parameter control_files
