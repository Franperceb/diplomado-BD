prompt conectando como sysdba
connect sys/system2 as sysdba

prompt eliminando sesiones que impiden inactivar una BD
pause ¿Cuántas sesiones deberán eliminarse? [Enter] para comenzar
set serveroutput on
declare
  cursor cur_sesiones is
    select s.sid, s.serial#, s.username
    from  v$blocking_quiesce b , v$session s
    where b.sid = s.sid; 
begin
  for r in cur_sesiones loop 
    dbms_output.put_line('Cerrando sesión para el usuario  '||r.username);
    execute immediate 'alter system kill session '''||r.sid||','||r.serial#||'''';     
  end loop;
end;
/
