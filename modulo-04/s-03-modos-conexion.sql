--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 11/01/2024
--@Descripción: Ejercicio 03 - Módulo 04. Configuracíón modo dedicado y compartido


--CONFIGURACION COMPARTIDO
prompt conectando como usuario sys
connect sys/system2 as sysdba

Prompt cambiando a modo compartido
--configura 2 dispatchers para protocolo TCP
alter system set dispatchers='(ADDRESS=(PROTOCOL=TCP)(PORT=5000))','(ADDRESS=(PROTOCOL=TCP)(PORT=5001))' scope=memory;

--configura 4 shared servers
prompt configurando shared servers
alter system set shared_servers=3  scope=memory;

Prompt mostrando cambio de parametros
show parameter shared_servers
show parameter dispatchers

--POOL DE CONEXIONES
Prompt iniciando connection pool
exec dbms_connection_pool.start_pool();

Prompt configurando el número mínimo de conexiones que serán creadas y almacenadas en el pool (5 y 10)
exec dbms_connection_pool.alter_param('','MAXSIZE','10');
exec dbms_connection_pool.alter_param('','MINSIZE','5');

Prompt cambiando valores de parametros en pool
exec dbms_connection_pool.alter_param('','INACTIVITY_TIMEOUT','3600');
exec dbms_connection_pool.alter_param('','MAX_THINK_TIME','300');


prompt mostrando parametro db_domain
show parameter db_domain

prompt Notificando al listener los servicios disponibles 
alter system register;

Prompt validando servicios
!lsnrctl services

pause Analizar resultados [Enter] para continuar

--como es en memoria no es necesario reiniciar la instancia si fuera a spfile si

pause Añadir service names en tnsnames.ora [Enter] para continuar

prompt Probando conexión en modo dedicado
connect sys/system2@jpcdip02_dedicated as sysdba
select sysdate from dual;
pause [Enter] para continuar

prompt Probando conexión en modo compartido
connect sys/system2@jpcdip02_shared as sysdba
select sysdate from dual;
pause [Enter] para continuar

prompt mostrando datos de v$circuit
select circuit, dispatcher, status, bytes/1024 kbs from v$circuit;

prompt Probando conexión en modo pooled
connect sys/system2@jpcdip02_pooled as sysdba
select sysdate from dual;
pause [Enter] para continuar


