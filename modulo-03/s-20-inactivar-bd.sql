prompt conectando como sysdba
connect sys/system2 as sysdba

prompt creando usuarios
create user user03_a1 identified by user03_a1 quota unlimited on users;
grant create session, create table to user03_a1;

create user user03_a2 identified by user03_a2 quota unlimited on users;
grant create session, create table to user03_a2;

create user user03_a3 identified by user03_a3 quota unlimited on users;
grant create session, create table to user03_a3;

prompt otorgando privilegio sysbackup al usuario user03_a1
grant sysbackup to user03_a1;

prompt Abrir 2 terminales T1 y T2. en T1 Autenticar user03_a1,
prompt en T2 autenticar con el usuario user03_a2, crear una tabla y un registro.

prompt Inactivando la base de datos, ¿Qué sucederá? 
prompt En caso de ser necesario ejecutar s-21-terminar-sesione.sql 
pause [Enter] para continuar
--no se podrá inactivar debido a que user03_a2 está en sesión activa
--se deberá ejecutar el script s-21-terminar-sesiones.sql, se espera que
--solo se elimine la sesión activa del usuario user03_a2. La sesión del usuario
--user03_a1 está inactiva.

alter system quiesce restricted;

prompt BD inactiva. 
prompt Abrir  una terminal T3, intentar autenticar con user03_a3
prompt Abrir una terminal T4, intentar autenticar con user03_a1 como sysbackup
pause  ¿Qué sucederá? [Enter] para continuar
-- el usuario user03_a3 no podrá autenticar porque la bd está inactiva
--el usuario user03_a1 como sysbackup si podrá autenticar

prompt mostrando el status de la BD (active_state)
select active_state from v$instance;

pause reactivando la BD ¿Qué sucederá? [Enter] para continuar
-- la sesión de user03_a3 sale del modo de espera y autentica con éxito. 
alter system unquiesce;

prompt Cerrar las sesiones de los usuarios en todas las terminales
pause [Enter] para terminar y realiza limpieza
drop user user03_a1 cascade;
drop user user03_a2 cascade;
drop user user03_a3 cascade;