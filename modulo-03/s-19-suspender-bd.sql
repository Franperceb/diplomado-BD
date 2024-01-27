prompt conectando como sysdba
connect sys/system2 as sysdba

prompt creando usuarios
create user user03_s1 identified by user03_s1 quota unlimited on users;
grant create session, create table to user03_s1;

pause Reiniciando instancia [Enter] para continuar
shutdown immediate
startup

prompt Abrir una nueva terminal T1 y entrar a sesión con user03_s1
Pause [Enter] para continuar

prompt suspendiendo la BD Considerado que el usuario user03_s1 esta en sesión, 
pause ¿Qué sucederá?, [Enter] para continuar
--R: la BD se puede suspender sin problema
alter system suspend;

prompt Salir de sesión en T1 , intentar autenticar nuevamente
Pause ¿Qué sucederá? Considerar que la BD está suspendida. [Enter para continuar]
--El usuario podrá autenticar ya que sus datos de autenticación están en cache

prompt En la terminal T1, intentar crear una tabla y un registro.
pause ¿Qué sucederá? [Enter] para continuar
-- El usuario no podrá crear su tabla porque la BD está suspendida

Prompt mostrando status de la BD 
select database_status from v$instance;

prompt ¿Qué sucederá si se termina la suspensión?
-- la sesión en T1 se reanuda y al tabla se crea.
pause [Enter] para continuar
alter system resume;

Prompt mostrando status de la BD 
select database_status from v$instance;

Prompt realizando limpieza. En T1 salir de sesión 
pause [Enter] para continuar
drop user user03_s1 cascade;
