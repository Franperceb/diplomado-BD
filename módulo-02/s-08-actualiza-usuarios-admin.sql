
prompt mostrando datos de privilegios de administración asignado a usuarios.
select username, sysdba, sysbackup, sysoper, account_status
from  v$pwfile_users;


prompt asignando privilegios de administración a usuarios creados.
grant sysdba, sysoper, sysbackup to user01;
grant sysdba, sysoper, sysbackup to user02;
grant sysdba, sysoper, sysbackup to user03;

prompt mostrando datos de privilegios de administración asignado a usuarios.
select username, sysdba, sysbackup, sysoper, account_status
from  v$pwfile_users;


alter user sys identified by system1;
