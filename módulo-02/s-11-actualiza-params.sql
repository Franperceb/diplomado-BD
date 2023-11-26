--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 24/11/2023
--@Descripción: Ejercicio 11 -módulo 02 . Actualización de parametros a nivel instancia, memoria 
-- y spfile.


prompt Conectando como sysdba
conn sys/system1 as sysdba

prompt Consultando valores de los parámetros: nls_date_format, db_domain, deferred_segment_creation
set linesize window
col name format a30
col value format a30

select name, value, isses_modifiable, issys_modifiable
from v$parameter
where name in (
    'nls_date_format',
    'db_domain',
    'deferred_segment_creation'
);

prompt Creación de respaldo de SPFILE a traves de PFILE
create pfile='/unam-diplomado-bd/diplomado-BD/respaldo-spfile.ora' from spfile;

-- si la instancia se inició con spfile -> default = both
-- si la instancia se inciió con pfile -> default = memory 

--*nls_date_format*
prompt Aplicando cambio a parametro: nls_date_format
pause nivel sesión. Valor esperado: OK. [Enter] para comprobar..
alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';

prompt Aplicando cambio a parametro: nls_date_format
pause nivel memoria. Valor esperado: ERROR. [Enter] para comprobar..
alter system set nls_date_format='dd/mm/yyyy hh24:mi:ss' scope=memory;


prompt Aplicando cambio a parametro: nls_date_format
pause nivel BOTH. Valor esperado: ERROR. [Enter] para comprobar..
alter system set nls_date_format='dd/mm/yyyy hh24:mi:ss' scope=both;


prompt Aplicando cambio a parametro: nls_date_format
pause nivel SPFILE. Valor esperado: OK. [Enter] para comprobar..
alter system set nls_date_format='dd/mm/yyyy hh24:mi:ss' scope=spfile;

--*db_domain
prompt Aplicando cambio a parametro: db_domain
pause nivel sesión. Valor esperado: ERROR. [Enter] para comprobar..
alter session set db_domain='fi.unam2';

prompt Aplicando cambio a parametro: db_domain
pause nivel memoria. Valor esperado: ERROR. [Enter] para comprobar..
alter system set db_domain='fi.unam2' scope=memory;


prompt Aplicando cambio a parametro: db_domain
pause nivel BOTH. Valor esperado: ERROR. [Enter] para comprobar..
alter system set  db_domain='fi.unam2' scope=both;


prompt Aplicando cambio a parametro: db_domain
pause nivel SPFILE. Valor esperado: OK. [Enter] para comprobar..
alter system set  db_domain='fi.unam2' scope=spfile;


--*deferred
prompt Aplicando cambio a parametro: deferred_segment_creation
pause nivel sesión. Valor esperado: OK. [Enter] para comprobar..
alter session set deferred_segment_creation = FALSE;

prompt Aplicando cambio a parametro: deferred_segment_creation
pause nivel memoria. Valor esperado: OK. [Enter] para comprobar..
alter system set deferred_segment_creation = FALSE scope=memory;


prompt Aplicando cambio a parametro: deferred_segment_creation
pause nivel BOTH. Valor esperado: OK. [Enter] para comprobar..
alter system set  deferred_segment_creation = FALSE scope=both;


prompt Aplicando cambio a parametro: deferred_segment_creation
pause nivel SPFILE. Valor esperado: OK. [Enter] para comprobar..
alter system set  deferred_segment_creation = FALSE scope=spfile;


--reset de párametros
prompt restaurando parametro: nls_date_format
alter system reset nls_date_format scope=spfile;

prompt restaurando parametro: db_domain
alter system reset db_domain scope=spfile;

prompt restaurando parametro: deferred_segment_creation
alter system reset deferred_segment_creation scope=both;



prompt Verificando valores de los 3 parametros confirmando resultados a nivel sesión
set linesize window
col name format a30
col value format a50

select name, value
from v$parameter
where name in (
    'nls_date_format',
    'db_domain',
    'deferred_segment_creation'
);


prompt Verificando valores de los 3 parametros confirmando resultados a nivel spfile
set linesize window
col name format a30
col value format a50

select name, value
from v$spparameter
where name in (
    'nls_date_format',
    'db_domain',
    'deferred_segment_creation'
);