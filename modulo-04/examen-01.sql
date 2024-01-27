--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 08/01/2024
--@Descripción: Examen 01 - Módulo 04. Modos de conexión a una instancia.

--CONFIGURACION COMPARTIDO
prompt conectando como usuario sys
connect sys/system2 as sysdba

alter system register;

Prompt validando servicios
!lsnrctl services

Prompt cambiando a modo compartido
--configura 2 dispatchers para protocolo TCP
alter system set dispatchers='(dispatchers=2)(protocol=tcp)' scope=both;
alter system set max_dispatchers = 2  scope=both;

--configura 4 shared servers
alter system set shared_servers=4  scope=both;
alter system set max_shared_servers=4  scope=both;

Prompt mostrando cambio de parametros
show parameter shared_servers
show parameter dispatchers

alter system register;

Prompt mostrando servicios 
!lsnrctl services

--POOL DE CONEXIONES
Prompt iniciando connection pool
exec dbms_connection_pool.start_pool();

Prompt configurando el número mínimo de conexiones que serán creadas y almacenadas en el pool (30 y 50)
exec dbms_connection_pool.alter_param('','MAXSIZE','50');
exec dbms_connection_pool.alter_param('','MINSIZE','30');

Prompt cambiando valores de parametros en pool
exec dbms_connection_pool.alter_param('','INACTIVITY_TIMEOUT','1800');
exec dbms_connection_pool.alter_param('','MAX_THINK_TIME','1800');


alter system register;

Prompt validando servicios
!lsnrctl services