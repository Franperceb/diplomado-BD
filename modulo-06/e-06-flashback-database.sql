--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 26/01/2024
--@Descripción: Ejercicio 06- Módulo 06. Flashback database.

set linesize window
set verify off

define syslogon='sys/system2 as sysdba'
define userlogon='user06/user06'
conn &syslogon

Prompt 1. Verificando el SCN actual
select dbms_flashback.get_system_change_number() scn_inicial 
from dual;

Prompt 2. Creando punto de restauración
create restore point punto_rest;

Prompt 3. Verificando el punto de restauración
col name format a15
select scn, name , time from v$restore_point;


Prompt 4. Con el usuario user06 creando tabla fb_database e insertando datos.
conn &userlogon

Prompt Creando tabla fb_database
create table fb_database(id number(2),dato varchar2(15));

Prompt Insertando datos
insert into fb_database values(1,'dato1');
insert into fb_database values(2,'dato2');
insert into fb_database values(3,'dato3');
insert into fb_database values(4,'dato4');

commit;

Prompt Mostrando contenido de la tabla
select * from fb_database;

Prompt 5.  Conectandose como sys , reiniciando instancia a modo mount y regresando la base por flashback
conn &syslogon

shutdown immediate
startup mount


Prompt 6. Regresando la base datos al punto de restauración
flashback database to restore point punto_rest;


Prompt 7. Abriendo la base de datos a open y reiniciando redologs
alter database open resetlogs;

Prompt 8. Verificando que se haya retornado al punto marcado
select * from user06.fb_database;


Prompt 9. Eliminando punto de restauración
drop restore point punto_rest;

exit