--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 26/01/2024
--@Descripción: Ejercicio 03 - Módulo 06. Flashback version query.

set linesize window
set verify off

define syslogon='sys/system2 as sysdba'
define userlogon='user06/user06'

Prompt 1. Conectado como usuario user06
conn &userlogon

Prompt Creando la tabla fb_version
create table fb_version(id number(2), dato varchar2(15), fecha_hora varchar2(30));
exec dbms_lock.sleep(5);

Prompt Insertando tres registros a fb_version
insert into fb_version values(1,'valor1', to_char(sysdate,'dd-mm-yyyy hh24:mi:ss'));
insert into fb_version values(2,'valor2', to_char(sysdate,'dd-mm-yyyy hh24:mi:ss'));
insert into fb_version values(3,'valor3', to_char(sysdate,'dd-mm-yyyy hh24:mi:ss'));

commit;

Prompt Mostrando datos insertados en fb_version
select * from fb_version;
exec dbms_lock.sleep(5);


Prompt 2. Consultando el scn actual
select current_scn scn1 from v$database;
exec dbms_lock.sleep(5);


Prompt 3. Realizando actualizacion a fb_version
update fb_version set dato='cambio1' , 
fecha_hora= to_char(sysdate, 'dd-mm-yyyy hh24:mi:ss')
where id=1;
commit;

Prompt Mostrando datos de la tabla
select * from fb_version;
exec dbms_lock.sleep(5);

Prompt 4. Realizando nuevamente actualización
update fb_version set dato='cambio2' , 
fecha_hora= to_char(sysdate, 'dd-mm-yyyy hh24:mi:ss')
where id=1;
commit;

Prompt Mostrando datos de la tabla
select * from fb_version;
exec dbms_lock.sleep(5);

Prompt 5. Eliminando registro modificado
delete from fb_version where id=1;
commit;

Prompt Mostrando datos de la tabla
select * from fb_version;
exec dbms_lock.sleep(5);

Prompt 6. Obteniendo el SCN actual
select current_scn scn2 from v$database;
exec dbms_lock.sleep(5);


Prompt 7. Obteniendo el historico de eventos ocurridos a través de select versions
Prompt Consulta 1 con fecha_hora
select * from fb_version
versions between timestamp minvalue and maxvalue
where id=1;

Prompt Consulta 1 con fecha_hora
select * from fb_version
versions between scn &scn1 and &scn2
where id=1;

exit
