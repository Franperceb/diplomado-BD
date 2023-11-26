--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 13/11/2023
--@Descripción: Tarea 01 -módulo 02 . Ejercicio de tarea respecto a admin privs, user profiles.
conn sys/system1 as sysdba

prompt 1. Creando usuario jfpc01
create user jfpc01 identified by jfpc01;

prompt Asignando quota
alter user jfpc01 quota 1G on users;

prompt Creando role app_rol
create role app_rol;


prompt Asignando privilegios a app_rol y asignando rol a jfpc01
grant create session, create table, create procedure, create sequence to app_rol;

grant app_rol to jfpc01;

prompt 1.2 reseteando pwd a jfpc01 cuando inicie sesión por primera vez
alter user jfpc01 password expire;

prompt 1.3 Entrando a sesión como jfpc01
conn jfpc01/jfpc01

prompt 1.4  Creando tabla amigo 
create table amigo(id number, nombre varchar2(40));

prompt Insertando registro en tabla amigo
insert into amigo values (1, 'Jorge');

commit;

prompt 2. Creando user jfpc_worker01
conn sys/system1 as sysdba
create user jfpc_worker01 identified by jfpc_worker01;

prompt 2.1 Asignando priv de crear sesiones.
grant create session to jfpc_worker01;

prompt Asignando privilegio de insert a jfpc_worker01
grant insert on jfpc01.amigo to jfpc_worker01;

prompt  4. Insertando 3 registros en tabla jfpc01.amigo como jfpc_worker01
connect jfpc_worker01/jfpc_worker01
insert into jfpc01.amigo values (2,'Jorge02');
insert into jfpc01.amigo values (3,'Jorge03');
insert into jfpc01.amigo values (4,'Jorge04');

prompt 5. esperando 70 segundos 
exec dbms_session.sleep(70);

prompt 5.1 Insertando registro nuevamente a tabla amigo por jfpc_worker01
conn jfpc_worker01/jfpc_worker01
insert into jfpc01.amigo values (4,'Jorge05');

accept v_resultado prompt '¿Se insertó el 4to registro a la tabla? '
prompt Respuesta: &v_resultado

prompt 6. Creando usuario jfpc_slave
conn sys/system1 as sysdba;
create user jfpc_slave identified by jfpc_slave;

prompt 6.1 Asignando privilegios necesarios a jfpc_slave
grant create session to jfpc_slave;
grant grant any object privilege to jfpc_slave;

grant select on jfpc01.amigo to jfpc_worker01;
grant delete on jfpc01.amigo to jfpc_worker01;

prompt 6.2 Iniciando sesion como jfpc_worker01
conn jfpc_worker01/jfpc_worker01

prompt Eliminando todos los registros en jfpc01.amigo
delete from jfpc01.amigo;
select count(*) total_registros  from  jfpc01.amigo;
accept v_resultado2 prompt '¿Se eliminaron los registros de la tabla? '
prompt Respuesta: &v_resultado2

pause 7. Actividades de limpieza [Enter] para continuar
conn sys/system1 as sysdba
drop user jfpc_slave cascade;
drop user jfpc01 cascade;
drop user jfpc_worker01 cascade;
drop role app_rol;

prompt Listo!

