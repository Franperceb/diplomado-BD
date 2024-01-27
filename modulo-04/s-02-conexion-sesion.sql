--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 11/01/2024
--@Descripción: Ejercicio 02 - Módulo 04. Sesiones y conexiones.

prompt Conectando comos ysdba 
conn sys/system2 as sysdba

prompt Creando user04
create user user04 identified by user04 quota unlimited on users;

prompt Otorgando permisos a user04
grant create table, create session to user04;


Pause Abrir una nueva terminal, crear una nueva sesión como user04, [Enter] al terminar.

prompt Mostrando datos de las sesiones de user04
col username format a30
set linesize window

select username, sid, serial# , server, paddr , status
from v$session
where username = 'USER04';

pause Analizando resultados,  [ Enter ] para continuar 

prompt configurando el rol plustrace
@?/sqlplus/admin/plustrce.sql

prompt Otorgando el rol plustrace a user04
grant plustrace to user04;

prompt en T2 reiniciar la sesión y habilitar el modo autotrace statistics 
pause [Enter] al terminar

/* En T2
    disconnnect
    connect user04/user04 
    set autotrace on statistics
*/

prompt Mostrando datos de las sesiones creadas para user04
select username, sid, serial# , server, paddr , status
from v$session
where username = 'USER04';

Pause ¿Qué diferencias se observan respecto a la primera consulta ? [Enter] para continuar

Pause en T2 deshabilitar la recolección automática de estadisticas [Enter] al terminar
/**
set autotrace off statistics 
*/

prompt Mostrando datos de las sesiones nuevamente
pause ¿Cuántos registros se esperan? [Enter] para continuar

select username, sid, serial# , server, paddr , status
from v$session
where username = 'USER04';

Pause Analizar resultados [Enter] para continuar 

--Para esta consulta, se debe de proporcionar el valor de PADDR
--obtenido de la última consulta donde la sesión aún existia, empleando para 
--ello la variable de sustitución p_addr
set linesize window
prompt Mostrando los datos de la conexión, proporcionar el valor de PADDR
select sosid , username, program
from v$process 
where addr = hextoraw('&p_addr');

Pause Analizar resultados [Enter] para continuar 

--De forma similar, se debe de proporcionar el valor de la columna sosid empleando la variable
-- de sustitución p_soid
prompt Mostrando los datos del server process a nivel S.O. Especificar sosid
!ps -ef | grep -e &p_sosid  | grep -v grep

pause Realizar limpieza [Enter] para continuar ,  cerrar seión primero en T2
drop user user04 cascade;