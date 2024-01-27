--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 26/01/2024
--@Descripción: Ejercicio 05- Módulo 06. Flashback dropa.

set linesize window
set verify off

define syslogon='sys/system2 as sysdba'
define userlogon='user06/user06'

Prompt 1. Conectando como sys
conn &userlogon

Prompt Activando la papelera de reciclaje
alter session set recyclebin=on;


Prompt Verificando su contenido
col object_name format a30
col original_name format a15
select object_name, original_name, createtime
from recyclebin;


Prompt 2. Conectando con user06 y creando tabla fb_drop
conn &userlogon
create table fb_drop(id number(2), datos varchar2(20));


Prompt Ingresando registros a fb_drop
insert into fb_drop values(1,'dato1');
insert into fb_drop values(2,'dato2');
insert into fb_drop values(3,'dato3');
insert into fb_drop values(4,'dato4');

commit;

Prompt Mostrando contenido de la tabla fb_drop
select *  from fb_drop;

Prompt 3. Eliminando tabla fb_drop
drop table fb_drop;

Prompt Verificando que se haya eliminado
select * from fb_drop;


Prompt 4. Mostrando contenido de la papelera de reciclaje
select object_name ,original_name, createtime
from recyclebin;

Prompt 5. Consultando el contenido de object_name
select * from "&object_name";


Prompt 6. Recuperando la tabla eliminandola
flashback table fb_drop to before drop;

Prompt Mostrando tabla recuperada
select * fb_drop;

Prompt 7. Eliminando la tabla nuevamente y Verificando
drop table fb_drop;
select * from fb_drop;


Prompt 8. Creando nuevamente la tabla e insertando datos distintos.
create table fb_drop(id number(2), datos varchar2(20));

insert into fb_drop values(5,'dato5');
insert into fb_drop values(6,'dato6');
insert into fb_drop values(7,'dato7');
insert into fb_drop values(8,'dato8');

commit;

Prompt Consultando la tabla creada nuevamente
select * from fb_drop;

Prompt 9. Consultando la papelera de reciclaje
select object_name, original_name, createtime
from recyclebin;

Prompt 10. Eliminando nuevamente la tabla y Verificando
drop table fb_drop;
select * from fb_drop;

Prompt 11. Consultando el contenido de la papelera de reciclaje
select object_name,original_name,createtime
from recyclebin;

Prompt 12. Recuperando las tablas eliminadas y renombrandolas
Prompt fb_drop1
flashback table "&object_name" to before drop rename to fb_drop1;

Prompt Consultando fb_drop1 (Tabla recuperada)
select * from fb_drop1;

Prompt fb_drop2;
flashback table "&object_name" to before drop rename to fb_drop2;

Prompt Mostrando datos de fb_drop2(Tabla 2 recuperada)
select * from fb_drop2;


Prompt 13. Desactivando la papelera de reciclaje
alter session set recyclebin=off;

Prompt 14. Borrando las tablas creadas y Verificando
drop table fb_drop1;

Prompt Mostrando contenido de la papelera de reciclaje
select object_name ,original_name, createtime
from recyclebin;

drop table fb_drop2;

Prompt Mostrando contenido de la papelera de reciclaje
select object_name ,original_name, createtime
from recyclebin;

exit