--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 08/01/2024
--@Descripción: Examen 04 - Módulo 04. Modos de conexión a una instancia:  consultas.

-- A. Mostrar el nombre y el valor de los principales parámetros en modo compartido
prompt Mostrando valores de los principales parámetros en modo compartido
col name format a30
col value format a30

SELECT name, value
FROM v$spparameter
WHERE NAME = 'dispatchers' 
OR NAME = 'shared_servers' 
OR NAME = 'max_dispatchers' 
OR NAME = 'max_shared_servers';

-- B. Mostrar el nombre y el valor de los principales parámetros en modo POOLED
prompt Mostrando valores de los principales parámetros en modo pooled
SELECT pool_name, num_open_servers, num_requests , num_authentications, historic_max
FROM v$cpool_stats;

-- C. Mostrar todos los procesos de tipo "Server processes"
prompt Mostrando todos los procesos de tipo server processes
!ps -ef | grep -e jpcdip02 | grep -v grep;

-- D. Mostrar todos los procesos de tipo "Background processes"
prompt Mostrando todos los procesos de tipo background
!ps -ef | grep ora_| grep -v grep;

-- E. Consulta para mostrar user processes conectados a la BD
prompt Mostrnado todos los user processes conectados a la BD
SELECT
    s.sid,
    s.serial#,
    p.spid,
    s.status,
    CASE
        WHEN s.server = 'DEDICATED' THEN 'Dedicado'
        WHEN s.server = 'SHARED' THEN 'Compartido'
        WHEN s.server = 'POOLED' THEN 'Pooled'
        ELSE 'Desconocido'
    END AS tipo_conexion,
    p.addr AS direccion_proceso,
    p.pga_max_mem
FROM v$session s
JOIN v$process p ON s.paddr = p.addr;
