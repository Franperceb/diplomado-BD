prompt conectando como sys

--los jobs serán asignados a cada worker, el usario sys solo los genera.
connect sys/system2 as sysdba
define p_num_workers=5

Prompt registrando jobs para realizar la carga de datos
set timing on
set serveroutput on
declare
  v_num_workers number := &p_num_workers;
  v_usr_prefix varchar2(20) :='WORKER_M03_';
  v_start_date date;
begin
  --iniciar en los próximos 10 segundos
  v_start_date := sysdate + 10/24/60/60;
  for i in 1..v_num_workers loop
    dbms_output.put_line('creando job para '||v_usr_prefix||i);
    dbms_scheduler.create_job(
      job_name    => v_usr_prefix||i||'.job_generate_data',
      job_type    => 'STORED_PROCEDURE',
      job_action  => v_usr_prefix||i||'.sp_generate_data',
      start_date  => v_start_date,
      enabled     => true
    );
  end loop;  
end;
/

Prompt esperando a que los jobs terminen - carga de datos
declare
  v_count number;
begin 
  loop 
    select count(*) into v_count from dba_scheduler_jobs
    where owner like 'WORKER_M03%'
    and job_name ='JOB_GENERATE_DATA'
    and state in ('RUNNING','SCHEDULED');
    if v_count > 0 then 
      dbms_session.sleep(30);
    else
      dbms_output.put_line('0 jobs pendientes');
      exit;
    end if;
  end loop;
end;
/

Pause Carga de datos concluida [Enter] para comenzar etapa de análisis

declare
  v_num_workers number := &p_num_workers;
  v_usr_prefix varchar2(20) :='WORKER_M03_';
  v_start_date date;
begin
  --iniciar en los próximos 10 segundos
  v_start_date := sysdate + 10/24/60/60;
  for i in 1..v_num_workers loop
    dbms_output.put_line('creando job para '||v_usr_prefix||i);
    dbms_scheduler.create_job(
      job_name    => v_usr_prefix||i||'.job_process_data',
      job_type    => 'STORED_PROCEDURE',
      job_action  => v_usr_prefix||i||'.sp_process_data',
      start_date  => v_start_date,
      enabled     => true
    );
  end loop;  
end;
/

Prompt esperando a que los jobs terminen - procesamiento de datos
declare
  v_count number;
begin 
  loop 
    select count(*) into v_count from dba_scheduler_jobs
    where owner like 'WORKER_M03%'
    and job_name ='JOB_PROCESS_DATA'
    and state in ('RUNNING','SCHEDULED');
    if v_count > 0 then 
      dbms_session.sleep(30);
    else
      dbms_output.put_line('0 jobs pendientes');
      exit;
    end if;
  end loop;
end;
/


set timing off
Prompt analisis concluido, mostrando resultados

prompt worker_1
select * from worker_m03_1.total_results;
prompt worker_2
select * from worker_m03_2.total_results;
prompt worker_3
select * from worker_m03_3.total_results;
prompt worker_4
select * from worker_m03_4.total_results;
prompt worker_5
select * from worker_m03_5.total_results;

Prompt Invocando nuevamente al script s-14-monitor-mem.sql 
start s-14-monitor-mem.sql