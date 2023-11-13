--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 13/11/2023
--@Descripción: Ejercicio 04 -módulo 02 .Creación de User Profile.
conn sys/system1 as sysdba

prompt creando session limit profile con para limitar a dos sesiones por user
create profile session_limit_profile limit
  session_per_user 2;

--creando usuario
prompt  2. creando user01, su privilegio para sesion y asignando el profile session_limit_profile
create user user01 identified by user01
  profile session_limit_profile;

--otorgando create session
grant create session to user01;

prompt Abrir 3 terminales , intentar crear sesión con user01
accept v_resultado prompt '¿Que sucedió con la 3era sesion?'
prompt Respuesta: &v_resultado

prompt Mostrar datos de las sesiones de user01 
select sid, serial#,username , status , schemaname
from v$session
where username='USER01';

accept v_res prompt '¿Cuantas sesiones se obtuvieron?'
prompt &v_res

pause Limpieza , cerrar sesion en las terminales, despues presionar [Enter]...
drop user user01 cascade;
drop profile session_limit_profile;


