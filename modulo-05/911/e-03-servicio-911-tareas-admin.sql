-- Script que realiza tareas administrativas.
Prompt 0. Conectando como sys 
define syslogon='sys/system2 as sysdba'
define p_user='m05_911_user'
define p_userlogon='&p_user/&p_user'
connect sys/system2 as sysdba

--prompt 1. Poniendo Data file 1 en modo offline

--alter database datafile '/disk-mod5/u21/app/oracle/oradata/JPCDIP02/m05_911_ts_01.dbf' offline;

--prompt 2. Pasando tbs a modo offline.
--select FILE_NAME, FILE_ID  from dba_data_files df 
--where tablespace_name in ('M05_911_TS');

--NOTA: En estos momentos si tengo habilitado el modo archive por lo que la operacion anterior 
--me permite poner solo un data file offline, esto en el modo noarchive no lo permitiria y lanzaria un error.
--Para proseguir con el script se colocan las operaciones necesarias para poder pasar el datafile a modo online
--y poder pasar el tbs a modo offline.
--recover datafile 5;
--alter database datafile 5 online;
alter tablespace m05_911_ts offline normal;

--pause Consulta del usuario [Enter] para continuar
--connect &p_userlogon
--select count(*) from llamada_911;

--prompt 3. No procede la consulta lanza error.

col file_name format a70
prompt 4. Consulta que muestra nombre, id y online_status de los datafiles
select file_name, file_id, online_status
from dba_data_files
where tablespace_name = 'M05_911_TS';

prompt 5. Reasingacion de ubicaciones.

!mv /disk-mod5/u21/app/oracle/oradata/JPCDIP02/m05_911_ts_01.dbf /disk-mod5/u25/app/oracle/oradata/JPCDIP02/m05_911_ts_a.dbf
!mv /disk-mod5/u22/app/oracle/oradata/JPCDIP02/m05_911_ts_02.dbf /disk-mod5/u24/app/oracle/oradata/JPCDIP02/m05_911_ts_b.dbf
!mv /disk-mod5/u23/app/oracle/oradata/JPCDIP02/m05_911_ts_03.dbf /disk-mod5/u23/app/oracle/oradata/JPCDIP02/m05_911_ts_c.dbf
!mv /disk-mod5/u24/app/oracle/oradata/JPCDIP02/m05_911_ts_04.dbf /disk-mod5/u22/app/oracle/oradata/JPCDIP02/m05_911_ts_d.dbf
!mv /disk-mod5/u25/app/oracle/oradata/JPCDIP02/m05_911_ts_05.dbf /disk-mod5/u21/app/oracle/oradata/JPCDIP02/m05_911_ts_e.dbf


alter tablespace m05_911_ts rename datafile 
	'/disk-mod5/u21/app/oracle/oradata/JPCDIP02/m05_911_ts_01.dbf',
	'/disk-mod5/u22/app/oracle/oradata/JPCDIP02/m05_911_ts_02.dbf',
	'/disk-mod5/u23/app/oracle/oradata/JPCDIP02/m05_911_ts_03.dbf',
	'/disk-mod5/u24/app/oracle/oradata/JPCDIP02/m05_911_ts_04.dbf',
	'/disk-mod5/u25/app/oracle/oradata/JPCDIP02/m05_911_ts_05.dbf'
to 
	'/disk-mod5/u25/app/oracle/oradata/JPCDIP02/m05_911_ts_a.dbf',
	'/disk-mod5/u24/app/oracle/oradata/JPCDIP02/m05_911_ts_b.dbf',
	'/disk-mod5/u23/app/oracle/oradata/JPCDIP02/m05_911_ts_c.dbf',
	'/disk-mod5/u22/app/oracle/oradata/JPCDIP02/m05_911_ts_d.dbf',
	'/disk-mod5/u21/app/oracle/oradata/JPCDIP02/m05_911_ts_e.dbf';

prompt colocando en modo online el tbs m05_911_ts
alter tablespace m05_911_ts online;

pause [Enter para continuar]

prompt 7. Renombrando pero en modo online

alter database move datafile '/disk-mod5/u25/app/oracle/oradata/JPCDIP02/m05_911_ts_a.dbf' to '/disk-mod5/u21/app/oracle/oradata/JPCDIP02/m05_911_ts_01.dbf';
alter database move datafile '/disk-mod5/u24/app/oracle/oradata/JPCDIP02/m05_911_ts_b.dbf' to '/disk-mod5/u22/app/oracle/oradata/JPCDIP02/m05_911_ts_02.dbf';
alter database move datafile '/disk-mod5/u23/app/oracle/oradata/JPCDIP02/m05_911_ts_c.dbf' to '/disk-mod5/u23/app/oracle/oradata/JPCDIP02/m05_911_ts_03.dbf';
alter database move datafile '/disk-mod5/u22/app/oracle/oradata/JPCDIP02/m05_911_ts_d.dbf' to '/disk-mod5/u24/app/oracle/oradata/JPCDIP02/m05_911_ts_04.dbf';
alter database move datafile '/disk-mod5/u21/app/oracle/oradata/JPCDIP02/m05_911_ts_e.dbf' to '/disk-mod5/u25/app/oracle/oradata/JPCDIP02/m05_911_ts_05.dbf';

--prompt 8. Reconstruyendo indices.
--alter index m05_911_user.ix1_llamada_911_incident_number rebuild;
--alter index m05_911_user.ix1_llamada_911_address rebuild;

prompt 9. Consultando registros para verificar integridad de la base.

select count(*) from m05_911_user.llamada_911;
