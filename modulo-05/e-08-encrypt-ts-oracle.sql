--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 19/01/2024
--@Descripción: Ejercicio 08 - Módulo 05. Encriptado de TS. 


Prompt Conectando como sys
connect sys/system2 as sysdba

Prompt 2: Crea y abre el wallet
alter system set encryption key identified by "wallet_password";


Prompt 3: Creando Tablespace
create tablespace m05_encrypted_ts
datafile '/u01/app/oracle/oradata/JPCDIP02/m05_encrypted_ts01.dbf' size 10M
autoextend on next 64k
encryption using 'aes256'
default storage(encrypt);


Prompt 4: Asignando quota de almacenamiento a jorge05
alter user jorge05 quota unlimited on m05_encrypted_ts;

Prompt 5: Verificar tablespace creado
select tablespace_name ,encrypted 
from dba_tablespaces;

Pause [Enter] para continuar

Prompt 6: Conectando con jorge05 para crear objetos cifrados

conn jorge05/jorge05

create table mensaje_seguro(
  id number,
  mensaje varchar2(20)
) tablespace m05_encrypted_ts;

create index mensaje_seguro_ix on mensaje_seguro(mensaje) 
tablespace m05_encrypted_ts;


Prompt Insertando registros en mensaje mensaje_seguro
insert into mensaje_seguro(id, mensaje) values (1,'mensaje_1');
insert into mensaje_seguro(id, mensaje) values (1,'mensaje_2');

commit;

Prompt Mostrando datos de mensaje_seguro
select * from mensaje_seguro;


Prompt 7: Creando tabla mensaje_inseguro e insertando tablespace_size

create table mensaje_inseguro(
  id number,
  mensaje varchar2(20)
);



Prompt Insertando registros en mensaje mensaje_inseguro
insert into mensaje_inseguro(id, mensaje) values (1,'mensaje_1');
insert into mensaje_inseguro(id, mensaje) values (1,'mensaje_2');

commit;


Prompt Mostrando datos de mensaje_inseguro
select * from mensaje_inseguro;

Prompt 8: Forzando sincronización a df, conectando como sys
conn sys/system2 as sysdba

alter system checkpoint;


Prompt 9: Busqueda de textos  en dbfs
!strings /u01/app/oracle/oradata/JPCDIP02/m05_encrypted_ts01.dbf | grep "mensaje"


Pause [Enter] para Verificar


 
Prompt 10: Busqueda de textos  en dbfs
!strings /u01/app/oracle/oradata/JPCDIP02/users01.dbf | grep "mensaje"


Pause [Enter] para Verificar

Prompt Reiniciando instancia y volviendo a consultar datos
shutdown immediate
startup

Prompt Consultando datos nuevamente
conn jorge05/jorge05


select * from mensaje_seguro;

Pause [Enter] para continuar y corregir el problema
conn sys/sytem2 as sysdba;

alter system set encryption  wallet open identified by "wallet_password";

Prompt 11: Mostrando datos nuevamente 
conn jorge05/jorge05

select * from mensaje_seguro;

Pause Prompt 12: Limpieza de datos [Enter] para continuar
conn sys/system2 as sysdba

drop index jorge05.mensaje_seguro_ix;
drop table jorge05.mensaje_seguro;
drop table jorge05.mensaje_inseguro;
drop tablespace m05_encrypted_ts including contents and datafiles;

Prompt Listo!

exit

