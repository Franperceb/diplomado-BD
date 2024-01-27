--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 11/01/2024
--@Descripción: Ejercicio 04 - Módulo 04. Consultas - procesos.

/** Correr consultas en SQL Developer para mostrar todos los datos **/
set linesize window
prompt Conectando como sysdba
connect sys/system2 as sysdba 
-- Consulta 1: Mostrar el total de procesos de la instancia
SELECT COUNT(*) AS total_procesos
FROM v$process;

-- Consulta 2: Mostrar los datos de los procesos que no son procesos de background
SELECT * FROM v$process WHERE background is null;



-- Consulta 3: Mostrar los datos de todos los procesos que son de background
SELECT * FROM v$process WHERE background = '1';

-- Consulta 3
SELECT sid, username, status
FROM v$session
WHERE username = 'SYS'; 


--Consulta 4:  Obtener el ID de la sesión iniciada en SQL Developer
DEFINE user = 'sys'; 
COLUMN sid NEW_VALUE session_id

SELECT sid
FROM v$session
WHERE username = UPPER('&user')
and status ='ACTIVE';

-- Consulta 5: Mostrar los datos del proceso asociado a la sesión creada en SQL Developer
SELECT *
FROM v$process
WHERE addr = (SELECT paddr FROM v$session WHERE sid = &session_id);

-- Consulta 6: Mostrar datos de monitoreo ASH para la sesión creada en SQL Developer
SELECT *
FROM v$active_session_history
WHERE session_id = &session_id;

