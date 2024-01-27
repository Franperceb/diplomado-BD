--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 26/01/2024
--@Descripción: Ejercicio 04- Módulo 06. Flashback table.

set linesize window
set verify off

define syslogon='sys/system2 as sysdba'
define userlogon='user06/user06'

Prompt 1. Conectando con el usuario user06
conn &userlogon

Prompt Creando la tabla venta
create table venta(venta_id number(2),monto number(10,2));


exec dbms_lock.sleep(5);

Prompt 2. Configurando la tabla para poder regresarla en el tiempo 
alter table venta enable row movement;
exec dbms_lock.sleep(5);



Prompt 3. Tomando el scn actual y el tiempo
select current_scn scn1 , 
(select to_char(sysdate, 'dd-mm-yyyy hh24:mi:ss')  from dual) fecha_hora_1
from v$database; 


Prompt 4. Agregar el primer registro a la tabla y confirmar 
insert into venta values(1,1300.50);
commit;

Prompt Mostrando datos de tabla
select * from venta;
exec dbms_lock.sleep(5);


Prompt 5. Nuevamente tomar el scn y el tiempo
select current_scn scn2 , 
(select to_char(sysdate, 'dd-mm-yyyy hh24:mi:ss')  from dual) fecha_hora_2
from v$database; 



Prompt 6. Ingresando otro registro y confirmando
insert into venta values(2,1500.90);
commit;


Prompt Mostrando datos de tabla
select * from venta;
exec dbms_lock.sleep(5);


Prompt Tomando nuevamente el SCN y tiempo
select current_scn scn3 , 
(select to_char(sysdate, 'dd-mm-yyyy hh24:mi:ss')  from dual) fecha_hora_3
from v$database; 


Prompt Ingresando otro registro y confirmando
insert into venta values(3,500.90);
commit;


Prompt Mostrando datos de tabla
select * from venta;
exec dbms_lock.sleep(5);


Prompt Tomando nuevamente el SCN y tiempo
select current_scn scn4 , 
(select to_char(sysdate, 'dd-mm-yyyy hh24:mi:ss')  from dual) fecha_hora_4
from v$database; 

 
Prompt 7. Mostrando contenido de la tabla y eliminandola
Prompt Mostrando datos de tabla
select * from venta;

Prompt Eliminando tabla
delete from venta; 
commit;

exec dbms_lock.sleep(5);

Prompt Mostrando datos de tabla con registro eliminado
select * from venta;


Prompt 8 Tomando el SCN y el tiempo nuevamente
select current_scn scn5 , 
(select to_char(sysdate, 'dd-mm-yyyy hh24:mi:ss')  from dual) fecha_hora_5
from v$database; 



Prompt 9. Restaurando la tabla en algun punto del tiempo.

Prompt con el SCN
flashback table venta to scn &scn;
select * from venta;

Prompt con fecha_hora
flashback table venta to timestamp to_timestamp('&fecha_hora', 'dd-mm-yyyy hh24:mi:ss');

Prompt Mostrando datos de tabla
select * from venta;


Prompt 10. Mostrando el contenido final de la tabla
Prompt Mostrando datos de tabla
select * from venta;


exit










