--@Autor: Jorge Francisco Pereda Ceballos
--@Fecha creación: 12/04/2024
--@Descripción: Ejercicio 01 - Módulo 09. Configuración autotrace.

Prompt conectando como sys
conn sys/system1 as sysdba

Prompt otorgando rol plustrace al usuario &t_user
grant plustrace to &tuser;

Prompt Conectando con &t_user
connect &userlogon

Prompt Creando PLAN TABLE
declare
V count number;
begin
select count(*) into v count from user tables where table name='PLAN TABLE'
if v count > 0 then
execute immediate 'drop table plan table'
end if:
end;
/
@SORACLE _HOME/cdbms/admin/utlxplan.sql
Prompt ejemplo con set autotrace on
Prompt contando registros de la tabla cita
set autotrace on
select count (*) from cita;

