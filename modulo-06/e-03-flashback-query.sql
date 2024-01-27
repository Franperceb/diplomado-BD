--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 26/01/2024
--@Descripción: Ejercicio 02 - Módulo 06. Flashback query.

set linesize window
set verify off

define syslogon='sys/system2 as sysdba'
define userlogon='user06/user06'

Prompt Conectado como sys
conn &syslogon 

Prompt 1. Creando el usuario user06
create user user06 identified by user06
default tablespace users
quota unlimited on users;

grant dba to user06;

Prompt 2. Conectandose con el user06
conn &userlogon

Prompt 2.1 Creando tabla fb_query
create table fb_query(id number(2), name varchar2(10));

Prompt 3 Insertando 3 registros a la tabla fb_query
insert into fb_query values(1,'dato1');
insert into fb_query values(2,'dato2');
insert into fb_query values(3,'dato3');

commit; 

Prompt mostrando datos de la tabla fb_query
select * from fb_query;

exec dbms_lock.sleep(5);

Prompt 4. Obteniendo el SCN actual y marca de tiempo.

select current_scn scn1 , 
(select to_char(sysdate, 'dd-mm-yyyy hh24:mi:ss')  from dual) fecha_hora_1
from v$database; 

Prompt 5. Modificando un dato en la tabla
update fb_query set name='cambio1' where id=1;
commit;

select * from fb_query;

exec dbms_lock.sleep(5);

Prompt 6. Obeniendo nuevamente el SCN actual y marca de tiempo
select current_scn scn2 , 
(select to_char(sysdate, 'dd-mm-yyyy hh24:mi:ss')  from dual) fecha_hora_2
from v$database; 

Prompt 7. Eliminando un registro de la tabla
delete from fb_query where id = 1;
commit;


Prompt Mostrando cambios
select * from fb_query;

exec dbms_lock.sleep(5);

Prompt 8. Obeniendo nuevamente el SCN actual y marca de tiempo
select current_scn scn3 , 
(select to_char(sysdate, 'dd-mm-yyyy hh24:mi:ss')  from dual) fecha_hora_3
from v$database; 

Prompt 9. Mostrando información de fb_query en diferentes momentos del tiempo.
select * from fb_query as of
timestamp to_timestamp('&fecha_hora_1','dd-mm-yyyy hh24:mi:ss');

select * from fb_query as of scn &scn3;


Prompt 10. Ingresando el valor eliminado de nuevo y verificando.
insert into fb_query 
select * from fb_query as of scn &scn2 where id=1;


Prompt Mostrando información recuperada
select * from fb_query;

--Pause Actividades de limpieza [Enter] para continuar

--conn &syslogon
--drop user user06 cascade;

exit

