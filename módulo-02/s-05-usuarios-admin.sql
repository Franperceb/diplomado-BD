conn sys/system as sysdba


create user user01 identified by user01

grant create session , create table to user01;


prompt 3.
grant sysdba, sysoper to user01;

prompt 4.
create user user02 identified by user02;
create user user03 identified by user03;

grant create session to user02;
grant create session to user03;

prompt 5.
conn user01/user01

prompt Mostrando esquema y usuario actuales
select sys_context('user_env','current_schema') esquema 
from dual;

show user;

create table prueba(id number);
insert into prueba values(1);


-- cualquiera puede consultar la tabla ahora
grant select on prueba to public;

prompt 6.
conn user01/user01 as sysdba

prompt Mostrando esquema y usuario actuales
select sys_context('user_env','current_schema') esquema 
from dual;
--valor esperado sys por sysdba
show user;

select * from user01.test;

-- no debe marcar error es publica y sys puede ver todos

prompt 7.
conn user01/user01 as sysoper
select sys_context('user_env','current_schema') esquema 
from dual;
--valor esperado public
show user;

select * from user01.test;

--funciona la siguiente? no porque no esta buscando en el schema que esta
select * from test;

prompt 8.
conn user02/user02
select * from user01.test;

conn user03/user03
select * from user01.test;

--se peude ver? si es publica


--Aplicar indempotencia


