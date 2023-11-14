--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 13/11/2023
--@Descripción: Ejercicio 05  -módulo 02 . Privilegios de administración.


set linesize window 

prompt Conectando como usuario sysdba
conn sys/system1 as sysdba

prompt 2. Creando user01
create user user01 identified by user01
grant create session , create table to user01;

prompt 3. Asignando privilegios de administración a user01
grant sysdba, sysoper to user01;

prompt 4. Creando usuarios user02 y user03
create user user02 identified by user02;
create user user03 identified by user03;

grant create session to user02;
grant create session to user03;

prompt 5. Creando sesión con user01 
conn user01/user01

prompt Mostrando esquema y usuario actuales
select sys_context('user_env','current_schema') esquema 
from dual;

show user;

create table prueba(id number);
insert into prueba values(1);

commit;
-- cualquiera puede consultar la tabla ahora
grant select on prueba to public;

prompt 6. Autenticando como sysdba desde user01
conn user01/user01 as sysdba

prompt Mostrando esquema y usuario actuales
select sys_context('user_env','current_schema') esquema 
from dual;
--valor esperado sys por sysdba
show user;

prompt Consultado tabla user01.test
select * from user01.test;
-- no debe marcar error es publica y sys puede ver todos

prompt 7. Autenticando como sysoper desde user01
conn user01/user01 as sysoper

prompt Mostrando esquema y usuarios actuales
select sys_context('user_env','current_schema') esquema 
from dual;
--valor esperado public
show user;

--funciona la siguiente? no porque no esta buscando en el schema que esta
prompt Consultando datos en tabla user01.test pero como alias test
select * from test;

prompt 8. Comprobando consulta de datos por estar en esquema public con user02 y user03 
prompt en tabla user01.test
conn user02/user02
select * from user01.test;

conn user03/user03
select * from user01.test;

pause 9. Actividades de limpieza [Enter] para continuar
conn sys/system1 as sysdba
drop user user01 cascade;
drop user user02 cascade;
drop user user03 cascade;

prompt Listo!
