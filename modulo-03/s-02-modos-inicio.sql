--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 24/11/2023
--@Descripción: Ejercicio 02 -módulo 03 . Modos de inicio de una instancia.
prompt autenticando como sysdba
connect sys/system2 as sysdba

prompt Iniciando en modo restringido
alter system enable restricted session;

Prompt creando al usuario  user01
create user user01 identified by user01 quota unlimited on users;
grant create session, create table to user01;

Prompt intentando abrir sesión con user01 
connect user01/user01
pause [¿Qué sucedió?, Enter para continuar]

Prompt asignando el privilegio restricted session a user01
connect system/system2 as sysdba
grant restricted session to user01;

Prompt intentando crear sesión con user01
connect user01/user01
pause [¿Qué sucedió ?, Enter para continuar]

Prompt regresando al modo no restringido
connect sys/system2 as sysdba
alter system disable restricted session;

pause [Enter para continuar]
Prompt Abrir en modo read only, primero la bd debe detenerse.
-- ESta es una desventaja del modo read only. La BD tiene que detenerse
-- antes de pasarla a este modo. Activar y/o suspender evita tener que
-- cerrarla, los usuarios no tienen que desconectarse.
shutdown immediate 
Prompt Abriendo la BD en modo read only.
startup open read only;

Prompt Conectando como user01, intentando crear una tabla
connect user01/user01
create table test(id number);
pause [¿Qué sucedió ? Enter para continuar]

Prompt Regresar al modo de escritura y lectura
connect sys/system2 as sysdba
shutdown immediate 
startup open read write;

Prompt Haciendo limpieza (borrar a user01)
drop user user01 cascade;

Prompt Listo!


