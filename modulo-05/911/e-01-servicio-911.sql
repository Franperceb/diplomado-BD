--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 26/01/2024
--@Descripción: Módulo 05. Laboratorio 01 - Servicio 911.



Prompt Conectando como sys 
define syslogon='sys/system2 as sysdba'
define p_user='m05_911_user'
define p_userlogon='&p_user/&p_user'

conn &syslogon

declare
 v_count number;
begin
  select count(*) into v_count
    from dba_data_files
    where tablespace_name in ('M05_911_IX_TS');
  if v_count>=1 then 
    dbms_output.put_line('Eliminando TS M05_911_IX_TS');
    execute immediate 'drop tablespace m05_911_ix_ts including contents and datafiles';
  else
    dbms_output.put_line('Se creara el TS M05_911_IX_TS por primera vez');
  end if; 
end;
/

declare
 v_count number;
begin
  select count(*) into v_count
    from dba_data_files
    where tablespace_name in ('M05_911_TS');
  if v_count>=1 then 
    dbms_output.put_line('Eliminando TS M05_911_TS');
    execute immediate 'drop tablespace m05_911_ts including contents and datafiles';
  else
    dbms_output.put_line('Se creara el TS M05_911_TS por primera vez');
  end if; 
end;
/

pause [ENTER] para continuar

Prompt Creando tablespaces
create tablespace  m05_911_ts
datafile 
  '/disk-mod5/u21/app/oracle/oradata/JPCDIP02/m05_911_ts_01.dbf' size 15M,
  '/disk-mod5/u22/app/oracle/oradata/JPCDIP02/m05_911_ts_02.dbf' size 15M,
  '/disk-mod5/u23/app/oracle/oradata/JPCDIP02/m05_911_ts_03.dbf' size 15M,
  '/disk-mod5/u24/app/oracle/oradata/JPCDIP02/m05_911_ts_04.dbf' size 15M,
  '/disk-mod5/u25/app/oracle/oradata/JPCDIP02/m05_911_ts_05.dbf' size 15M
extent management local autoallocate
segment space management auto;

create tablespace m05_911_ix_ts
datafile '/disk-mod5/u31/app/oracle/oradata/JPCDIP02/m05_911_ix_ts_05.dbf' size 5M 
  autoextend on next 1M maxsize 30M
  extent management local autoallocate
  segment space management auto;

Prompt Creando directorio en el S.O. para la tabla externa
! mkdir /home/oracle/911 ;



declare
 v_count number;
begin
  select count(*) into v_count from  all_users where username='&p_user';
  if v_count =0 then 
    dbms_output.put_line('Creando al usuario &p_user');
  else
    dbms_output.put_line('El usuario &p_user ya existe, se eliminara');
    execute immediate 'drop user &p_user cascade';
  end if; 
end;
/


Prompt Creando directorio 'ext_tab_data' para tabla externa
create or replace directory ext_tab_data as '/home/oracle/911';

pause [ENTER] para continuar

create user &p_user identified by &p_user
quota unlimited on m05_911_ts 
default tablespace m05_911_ts;
grant create session, create table to &p_user;
alter user &p_user quota unlimited on m05_911_ix_ts;
grant all on directory ext_tab_data to &p_user;

conn &p_userlogon

declare v_count number;
begin
  select count(*) 
  into v_count
  from user_tables 
  where table_name = 'LLAMADA_911';
  if v_count > 0 then 
    execute immediate ('drop table llamada_911');
  end if;
end;
/

Prompt Creando tabla externa 

create table llamada_911_ext(
  address varchar2(50),
  type    varchar2(50),
  call_ts  date,
  latitude number(10,6),
  longitude number(10,6),
  report_location varchar2(40),
  incident_number varchar2(12)
)organization external (
  type oracle_loader
  default directory ext_tab_data
  access parameters (
    records delimited by newline
    badfile ext_tab_data: 'llamada_911_bad.log'
    logfile ext_tab_data: 'llamada_911_err.log'
    fields terminated by ',' 
    optionally enclosed by '"' 
    date_format date mask "mm/dd/yyyy hh:mi:ss am"
    lrtrim
    missing field values are null
    (
      address,type,call_ts,latitude,longitude,report_location,incident_number
    )
  )
  location ('calls-911-50m.csv') 
)
reject limit 100;

Prompt Validando tabla externa

select * from llamada_911_ext where rownum <=3;

Pause  Analizar, [enter] para continuar;

create table llamada_911(
  address varchar2(50),
  type    varchar2(50),
  call_ts  date,
  latitude number(10,6),
  longitude number(10,6),
  report_location varchar2(40),
  incident_number varchar2(12)
) nologging;

prompt Crando un indices
create index ix1_llamada_911_incident_number on llamada_911(incident_number) tablespace m05_911_ix_ts ;
create index ix1_llamada_911_address on llamada_911(address) tablespace m05_911_ix_ts ;

Prompt poblando tabla llamada_911 desde la tabla externa
insert /*+ append */ into llamada_911 select * from llamada_911_ext;

commit;