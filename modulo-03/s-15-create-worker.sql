prompt conectando como sys
connect sys/system2 as sysdba

set serveroutput on 
Prompt creando usuarios

declare
  v_num_users number := 5;
  v_usr_prefix varchar2(20) :='WORKER_M03_';
  v_username varchar2(30);
  cursor cur_users is
    select username from all_users where username like v_usr_prefix||'%';
begin
  for i in cur_users loop
    execute immediate 'drop user '||i.username||' cascade';
  end loop;

  for i in 1..v_num_users loop
    v_username := v_usr_prefix||i;
    dbms_output.put_line('Creando usuario '||v_username);
    execute immediate 
      'create user '
      ||v_username
      ||' identified by '
      ||v_username
      ||' quota unlimited on users';
    
    execute immediate 'grant create session, create table, create job,
      create procedure, create sequence to '||v_username; 
  end loop;
end;
/

Prompt invocando s-16-create-worker-objects.sql para cada worker
Pause [Enter para comenzar]

define p_user=WORKER_M03_1
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_2
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_3
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_4
@s-16-create-worker-objects.sql
define p_user=WORKER_M03_5
@s-16-create-worker-objects.sql

