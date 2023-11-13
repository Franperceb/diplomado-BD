--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 13/11/2023
--@Descripción: Ejercicio 02 -módulo 02 .Creación de object privileges a usuarios y validación.
prompt conectando como sysdba
conn sys/system1 as sysdba

prompt creando usuarios 
create user user01 identified by user01 quota unlimited on users;
create user guest01 identified by guest01 quota unlimited on users;

prompt 2 privilegios de sistema para user01
grant create session, create table to user01;

prompt 4  privilegios de sistema para guest01
grant create session to guest01;

prompt 5 creando al usuario guest02 a partir de la instruccion grant
grant create session to guest02 identified by guest02;
alter user guest02 quota 10M on users;

prompt 6 asignando a guest02 permiso de otorgar object privilieges a cualquier otro usuario
grant grant any object privilege to guest02;

prompt 7 conectando como user01
conn user01/user01 

prompt 8 creando tabla test
create table test01(id number);

prompt  isertando registro en test
insert into test01 values(1);

prompt 9 verificando que guest01 no pueda acceder datos en test01
connect guest01/guest01
select * from user01.test01;

pause ¿Que sucedió? No pudo acceder guest01 a la tabla user01.test01

prompt 10 otorgando permisos a guest01 para poder consultar datos en user01.test01
connect user01/user01
grant select on test01 to guest01;

prompt 11 verificando que guest01 pueda acceder datos en test01
connect guest01/guest01
select * from user01.test01;

prompt 12 conectando como guest02
conn guest02/guest02

prompt 13 asignando privilegio de inserciones desde guest02 en user01.test01 a guest01
grant insert on user01.test01 to guest01;

prompt 14 comprobando inserciones a test01
conn guest01/guest01
insert into user01.test01(2);


pause  Actividades de limpieza [Enter] para continuar
conn sys/system1 as sysdba
drop user user01 cascade;
drop user guest01 cascade;
drop user guest02 cascade;

prompt Listo!


